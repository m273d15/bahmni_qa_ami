#!/bin/bash -ex

# OPENMRS_PWD is set by packer
# shellcheck disable=SC2153
openmrs_pwd="$OPENMRS_PWD"
# Prerequisite Click 7.0 for fresh installation of Bahmni
function install_click {
  local install_dir=/home/centos
  local current_dir
  current_dir="$(pwd)"

  cd "$install_dir"

  yum upgrade -y python-setuptools
   
  curl -O https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz
  tar -xvf Click-7.0.tar.gz
  cd Click-7.0
  python setup.py install
  cd "$current_dir"
}

function install_zlib {
  yum install -y https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-1.2.11-19.fc30.x86_64.rpm
  # Installing the zlib-devel package is not required for installing bahmni, but
  # the AWS CodeDeploy agent also requires zlib and zlib-devel. During the agent installation
  # the yum default package is used. This leads to a version conflict and the installation will
  # fail. Therefore, we install the devel package to fulfill the requirements of the agent.
  yum install -y https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-devel-1.2.11-19.fc30.x86_64.rpm
}

function install_bahmni_installer_dependencies {
  install_zlib
  install_click
}

function setup_bahmni_installer_config {
  curl -L -o /etc/bahmni-installer/setup.yml https://tinyurl.com/yyoj98df
}

function install_bahmni_installer {
  yum install -y https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.92-155.noarch.rpm
}

function configure_superman_user_roles {
  openmrs_pwd="$1"

  # Add roles to superman
  mysql -uopenmrs-user -p"$openmrs_pwd" openmrs << EOF
INSERT INTO user_role (user_id, role)
SELECT user_id, role
FROM (
  SELECT "Appointments:FullAccess" AS role
  UNION ALL
  SELECT "Appointments:ManageAppointments"
) a
NATURAL LEFT JOIN (
  SELECT user_id
  FROM users
  WHERE username="superman"
) b;
EOF
}



install_bahmni_installer_dependencies
install_bahmni_installer
setup_bahmni_installer_config

bahmni -ilocal install
configure_superman_user_roles "$openmrs_pwd"

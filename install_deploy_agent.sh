#!/bin/bash -ex

# Install the AWS CodeDeploy agent
# https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent.html

region="$AWS_REGION"

yum -y update

# Install ruby prerequisites
yum -y install curl gpg gcc gcc-c++ make

# Install RVM
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable

# shellcheck disable=SC1091
source /etc/profile.d/rvm.sh
rvm reload

# Install Ruby
ruby_version=2.7
rvm install "$ruby_version"
rvm use "$ruby_version" --default

# Install codedeploy agent
cd /home/centos
curl -O "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install"
chmod +x ./install
# Install latest agent (auto)
./install auto

service codedeploy-agent start
# Bahmni QA AMI
![Validate](https://github.com/m273d15/bahmni_qa_ami/workflows/Validate/badge.svg)

The repository provides a packer template `centos_bahmni_ami.json` and corresponding
scripts to create a bahmni QA instance that can be used in
combination with AWS CodeDeploy.

## Setup

The AMI contains the following software:
* A [Bahmni installation](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/33128505/Install+Bahmni+on+CentOS)
* A [Deploy Agent installation](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent.html)

## Usage

### Prerequisites

* Install [Packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install)
* Set the environment var `OPENMR_PWD` to the password of the mysql user `openmrs-user`.
* Set the environment var `AWS_DEFAULT_REGION` to the desired region. Use
  `AWS_DEFAULT_REGION=ap-south-1` if you want to build the AMI in Mumbai.
* Set your (temporary) AWS credentials and assume a role that has the [required permissions](https://www.packer.io/docs/builders/amazon#iam-task-or-instance-role).

### Build
* Call `packer build centos_bahmni_ami.json` to build the AMI in AWS

#! /usr/bin/env bash

set -e

# Helps clear issues of not finding Ansible package,
# perhaps due to updates running when server is first spun up
sleep 10

# Install Ansible
echo ">>>>>>>>>>> INSTALLING ANSIBLE"
sudo yum update –y
sudo amazon-linux-extras install ansible2 -y
ansible --version

#!/usr/bin/env bash

function usage {
    echo "usage: ./build.sh <jenkins_user_aws_access_key_id> <jenkins_user_aws_secret_access_key>"
    exit 1
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 
# Always run from the location of this script
cd $DIR

if [ "$#" -ne 2 ]; then
    usage
fi

packer fmt .

packer validate -var jenkins_user_aws_access_key_id=$1 -var jenkins_user_aws_secret_access_key=$2 .

packer build -var jenkins_user_aws_access_key_id=$1 -var jenkins_user_aws_secret_access_key=$2 .

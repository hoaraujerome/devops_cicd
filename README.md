# DEVOPS Project: Jenkins As Code with CI/CD pipeline from scratch
## Goal
Deploy a containerized API into a staging environment in a public cloud **automatically** whenever new commits are integrated into the main branch.

Stack:
* Cloud Platform: AWS
* Code Hosting Platform: GitHub
* CI/CD Tool: Jenkins with Jenkins Pipeline
* Infrastructure Management Tool: Terraform
* Configuration Management Tool: Ansible
* Image Management Tool: Packer 
* Container Build Tool: Docker
* API: Express.js
* Staging Environment for Jenkins: EC2 instance
* Staging Environment for API: ECS Fargate with ALB and application auto-scaling

Overview:
![Overview](/misc/devops_cicd-Overview.jpg)

## Part 1: Jenkins server on AWS EC2 instance

### a) Create a Jenkins machine image With Packer and Ansible

![Packer](/misc/devops_cicd-Packer.jpg)

#### Image Content
* Amazon Linux 2 AMI (HVM)
* Ansible
* Terraform
* Jenkins with plugins ("GIT", "Pipeline", and "Pipeline: AWS Steps") + AWS Credentials + 1 Jenkins Job for the [API](https://github.com/thecloudprofessional/devops_demoapp)
* Docker
* AWS CLI

#### Prerequisites
* AWS CLI profile named **devops_cicd** (see "profile" in the [packer configuration](/packer/jenkins-amazonlinux.pkr.hcl)). Permission needed: EC2.
* If the user **devops_cicd** has no default vpc, set a VPC and subnet IDs manually in the [packer configuration](/packer/jenkins-amazonlinux.pkr.hcl). 

#### Usage
```
./packer/build.sh <jenkins_user_aws_access_key_id> <jenkins_user_aws_secret_access_key>
```
Note: the access key will be replaced by an IAM role [soon](https://github.com/thecloudprofessional/devops_cicd/issues/1)

### b) Deploy a Jenkins server on AWS with Terraform
![Terraform](/misc/devops_cicd-Terraform.jpg)

#### Prerequisites
* S3 bucket to store the Terraform state (see "bucket" in the [staging configuration](/terraform/backend-staging.tf)).
* AWS CLI profile named **devops_cicd** (see "profile" in the [terraform configuration](/terraform/staging/main.tf)). Permissions needed: S3, VPC, and EC2.

#### Usage
```
./terraform/run.sh staging init
./terraform/run.sh staging deploy
```

## Part 2: Containerized API deployment with Jenkins Pipeline
See the repository [devops_demoapp](https://github.com/thecloudprofessional/devops_demoapp).

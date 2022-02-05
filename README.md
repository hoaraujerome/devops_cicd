# DEVOPS Project
## Goal
Deploy a containerized API into a staging environment in a public cloud **automatically** whenever new commits are integrated into the main branch.

Overview:
![Overview](/misc/devops_cicd-Deployment.jpg)

Stack:
* Cloud Platform: AWS
* Code Hosting Platform: GitHub
* CI/CD Tool: Jenkins with Jenkins Pipeline
* Infrastructure Management Tool: Terraform
* Configuration Management Tool: Ansible
* Image Management Tool: Packer 
* Container Build Tool: Docker
* API: Express.js
* Staging Environment: ECS Fargate with ALB and application auto-scaling

## Module #1: Jenkins server on AWS EC2 instance with Packer and Ansible provisioned by Terraform

## Packer
![Packer](/misc/devops_cicd-Packer.jpg)

## Terraform
![Terraform](/misc/devops_cicd-Terraform.jpg)

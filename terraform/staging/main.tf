terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  backend "s3" {
    region = "ca-central-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

data "aws_ami" "jenkins" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Component"
    values = ["jenkins"]
  }

  filter {
    name   = "tag:Project"
    values = [var.project]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  owners = ["self"]
}

module "vpc" {
  source = "../modules/vpc"

  iac_tool    = var.iac_tool
  project     = var.project
  environment = var.environment
}

module "ec2_jenkins_server" {
  source = "../modules/ec2"

  iac_tool           = var.iac_tool
  project            = var.project
  environment        = var.environment
  instance_ami       = data.aws_ami.jenkins.id
  subnet_id          = module.vpc.vpc_public_subnet_id
  security_group_ids = [module.vpc.security_group_jenkins_server]
  role               = "jenkins_server"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  backend "s3" {
    bucket = "thecloudprofessional-devops-cicd"
    key    = "iac/terraform.tfstate"
    region = "ca-central-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  name_regex  = "amzn2-ami-kernel-5.10*"

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  owners = ["amazon"]
}

module "vpc" {
  source = "./modules/vpc"

  iac_tool    = var.iac_tool
  project     = var.project
  environment = var.environment
}

module "ec2_jenkins_server" {
  source = "./modules/ec2"

  iac_tool           = var.iac_tool
  project            = var.project
  environment        = var.environment
  instance_ami       = data.aws_ami.amazon_linux.id
  subnet_id          = module.vpc.vpc_public_subnet_id
  security_group_ids = [module.vpc.security_group_jenkins_server]
  role               = "jenkins_server"
}

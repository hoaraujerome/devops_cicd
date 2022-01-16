terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

resource "aws_vpc" "devops_cicd" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops_cicd"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.devops_cicd.id
  cidr_block = cidrsubnet(aws_vpc.devops_cicd.cidr_block, 4, 1)

  tags = {
    Name = "devops_cicd-public-subnet"
  }
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0ab6282fde6b605a3"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "JenkinsServerInstance"
  }
}

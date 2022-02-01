packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "project" {
  type    = string
  default = "devops_cicd"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "jenkins_user_aws_access_key_id" {
  sensitive = true
  type      = string
}

variable "jenkins_user_aws_secret_access_key" {
  sensitive = true
  type      = string
}

variable "component" {
  type    = string
  default = "jenkins"
}

source "amazon-ebs" "amazonlinux" {
  ami_name      = "${var.project}-${var.environment}-${var.component}-{{timestamp}}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  ssh_username  = "ec2-user"
  profile       = "devops_cicd"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10*x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  tags = {
    Component   = "${var.component}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  # No default VPC for the user. Workaround: specify manually temporary vpc & subnet.
  vpc_id    = "vpc-0f400b1e1a169d826"
  subnet_id = "subnet-0045bfdc2e51ccf02"
}

build {
  sources = [
    "source.amazon-ebs.amazonlinux"
  ]

  provisioner "shell" {
    script = "${path.root}/scripts/base.sh"
  }

  provisioner "ansible-local" {
    playbook_file   = "${path.root}/ansible/playbook.yml"
    extra_arguments = ["--extra-vars", "\"jenkins_user_aws_access_key_id=${var.jenkins_user_aws_access_key_id} jenkins_user_aws_secret_access_key=${var.jenkins_user_aws_secret_access_key}\""]
    # extra_arguments = ["-vvv"]
    role_paths = [
      "ansible/roles/terraform",
      "ansible/roles/jenkins",
      "ansible/roles/docker",
      "ansible/roles/awscli",
    ]
  }
}
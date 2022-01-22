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

variable "component" {
  type    = string
  default = "jenkins"
}

source "amazon-ebs" "amazonlinux" {
  ami_name      = "${var.project}-${var.environment}-${var.component}-{{timestamp}}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  ssh_username  = "ec2-user"

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

  # No default VPC for the user. Workaround: specify manually temporary vpc & subnet .
  vpc_id    = "vpc-01f5359e01814325f"
  subnet_id = "subnet-0c5f933ebdc65635a"
}

build {
  sources = [
    "source.amazon-ebs.amazonlinux"
  ]

  provisioner "shell" {
    script = "${path.root}/scripts/base.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "${path.root}/ansible/playbook.yml"
    # extra_arguments = ["--extra-vars", "\"pizza_toppings=${var.topping}\""]
    role_paths = [
      "ansible/roles/jenkins"
    ]
  }
}
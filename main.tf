terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

resource "aws_vpc" "devops_cicd" {
  cidr_block = var.vpc_cidr
  tags = {
    Name      = "${var.project}-${var.environment}"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_cicd.id

  tags = {
    Name      = "${var.project}-${var.environment}-igw"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops_cicd.id

  tags = {
    Name      = "${var.project}-${var.environment}-public-rt"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops_cicd.id
  cidr_block              = cidrsubnet(aws_vpc.devops_cicd.cidr_block, 4, 1)
  availability_zone       = var.default_az
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project}-${var.environment}-public-subnet"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security
resource "aws_security_group" "jenkins_server" {
  name        = "${var.project}-jenkins_server-sg"
  description = "Security Group For Jenkins Server"
  vpc_id      = aws_vpc.devops_cicd.id

  tags = {
    Name      = "${var.project}-${var.environment}-jenkins_server-sg"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

resource "aws_security_group_rule" "ca-central-1-ec2-instance-connect_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["35.183.92.176/29"]
  description       = "Allow SSH for EC2InstanceConnect from Canada central region"
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_in_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_out_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

# Compute
resource "aws_instance" "jenkins_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.jenkins_server.id]

  tags = {
    Name      = "${var.project}-${var.environment}-jenkins_server"
    ManagedBy = "${var.infra_as_code_tool}"
  }
}

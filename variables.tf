variable "project" {
  type        = string
  description = "The name of the project"
  default     = "devops_cicd"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment"
  default     = "staging"
}

variable "default_az" {
  type        = string
  description = "the AZ this infrastructure is in"
  default     = "ca-central-1a"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "ami" {
  type        = string
  description = "EC2 AMI"
  default     = "ami-0ab6282fde6b605a3"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "infra_as_code_tool" {
  type        = string
  description = "Name of the IAC tool used to provision the infra"
  default     = "terraform"
}
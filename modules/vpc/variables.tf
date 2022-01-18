variable "iac_tool" {
  type        = string
  description = "Name of the IAC tool used to provision the infra"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "192.168.0.0/27"
}

variable "az" {
  type        = string
  description = "The AZ the subnets are in"
  default     = "ca-central-1a"
}
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

variable "instance_ami" {
  type        = string
  description = "Server image to use"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to assign to server"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups to assign to server"
  default     = []
}

variable "role" {
  type        = string
  description = "Server purpose"
}
variable "iac_tool" {
  type        = string
  description = "Name of the IAC tool used to provision the infra"
  default     = "terraform"
}
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
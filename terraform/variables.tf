variable "aws_region" {
  description = "AWS region for the main project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "lab-04-aws-auditor"
}

variable "my_ip" {
  description = "Current public IP address for SSH access"
  type        = string
}
variable "aws_region" {
  description = "AWS region where bootstrap resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of this Terraform project"
  type        = string
  default     = "lab-04-aws-auditor"
}

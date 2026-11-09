terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "lab-04-aws-auditor-tfstate-476c87e6"
    key            = "lab-04-aws-auditor/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
    dynamodb_table = "lab-04-aws-auditor-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}
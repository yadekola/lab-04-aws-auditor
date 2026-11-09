terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate a random suffix to make the S3 bucket name unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create the S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-tfstate"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

# Enable versioning to preserve previous state versions
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption for the state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the state bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "${var.project_name}-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-state-lock"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

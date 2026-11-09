output "s3_bucket_name" {
  description = "Name of the S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB state locking table"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "aws_region" {
  description = "AWS region used for bootstrap resources"
  value       = var.aws_region
}

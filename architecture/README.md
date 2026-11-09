# Project Architecture

## Overview

This project combines Terraform infrastructure provisioning with Python/Boto3 automation to manage and audit AWS EC2 resources.

## Architecture Workflow

### 1. Terraform Bootstrap

The bootstrap configuration provisions the resources required for remote Terraform state management:

- Amazon S3 bucket for Terraform state storage.
- S3 versioning.
- AES256 server-side encryption.
- S3 public access block.
- DynamoDB state-locking table.

### 2. Terraform Infrastructure

The main Terraform configuration provisions:

- Amazon EC2 instance.
- EC2 security group.
- SSH access restricted to the configured public IP.
- Nginx web server installation and configuration.

### 3. Website Deployment

Terraform connects to the EC2 instance using SSH and configures Nginx.

The deployed website is made accessible through HTTP.

### 4. Python/Boto3 Auditing

The Python auditing script connects to AWS using configured credentials.

It retrieves EC2 instance information and checks:

- Instance IDs and types.
- Instance states.
- Name and Owner tags.
- Missing Owner tags.
- Estimated monthly EC2 compute costs.

### 5. Report Generation

The auditor generates two report formats:

- CSV: `reports/ec2_audit_report.csv`
- JSON: `reports/ec2_audit_report.json`

Generated reports are excluded from Git.

## Architecture Diagram

```text
                  AWS CLOUD
                      |
          +-----------+-----------+
          |                       |
    Terraform Bootstrap     Main Terraform
          |                       |
     +----+----+             +----+----+
     |         |             |         |
    S3      DynamoDB        EC2    Security Group
  Backend   Lock Table       |
                             |
                           Nginx
                             |
                       Public Website
                             |
                         HTTP Access

                  Python / Boto3
                         |
                    AWS EC2 API
                         |
                   Instance Audit
                         |
                  +------+------+
                  |             |
                 CSV           JSON
                  |             |
                  +------+------+
                         |
                      reports/
```

## Infrastructure Cleanup

The main Terraform-managed EC2 infrastructure was successfully destroyed after testing.

The S3 remote state bucket and DynamoDB locking table were intentionally retained.

The architecture documentation describes the complete deployment workflow, including resources that are no longer running.
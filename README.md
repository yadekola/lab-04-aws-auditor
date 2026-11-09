# Terraform AWS EC2 Infrastructure and Boto3 Auditor

## 1. Project Overview

This project demonstrates how to provision AWS infrastructure using Terraform and automate EC2 instance auditing using Python and Boto3.

Terraform is used to provision an EC2 web server, configure its security group and deploy Nginx. Python and Boto3 are used to inspect EC2 instances, identify missing tags, estimate monthly compute costs and generate audit reports.

## 2. Technologies Used

- **Terraform:** Infrastructure as Code.
- **Amazon Web Services (AWS):** Cloud infrastructure.
- **Amazon EC2:** Virtual server hosting the website.
- **Amazon S3:** Terraform remote state storage.
- **Terraform state locking:** Configured through the S3 backend.
- **Nginx:** Web server.
- **Python:** Automation and auditing.
- **Boto3:** AWS SDK for Python.
- **CSV and JSON:** Audit report formats.

## 3. Project Architecture

The project follows this workflow:

1. Terraform provisions AWS infrastructure.
2. Terraform creates an EC2 instance and security group.
3. Terraform connects to the instance using SSH.
4. Nginx is installed and enabled.
5. The website becomes publicly accessible over HTTP.
6. Python connects to AWS using Boto3.
7. Boto3 retrieves EC2 instance information.
8. The auditor checks instance states, tags and estimated costs.
9. Audit records are exported to CSV and JSON.

## 4. Infrastructure Details

| Component | Configuration |
|---|---|
| AWS Region | us-east-1 |
| EC2 instance type | t3.micro |
| Operating system | Amazon Linux 2023 |
| Web server | Nginx 1.30.6 |
| Website protocol | HTTP |
| SSH access | Restricted to the configured public IP |
| Terraform backend | Amazon S3 |

## 5. Boto3 Auditor Features

The Python auditing script performs the following tasks:

- Connects to AWS EC2.
- Retrieves running and stopped instances.
- Collects instance IDs and instance types.
- Checks instance states.
- Retrieves Name and Owner tags.
- Identifies missing Owner tags.
- Records audit timestamps.
- Retrieves instance launch times.
- Estimates monthly EC2 compute costs.
- Generates CSV and JSON reports.

## 6. Audit Report Fields

The reports contain:

- Instance ID
- Instance Type
- State
- Name
- Owner
- Audit Time
- Launch Time
- Estimated Monthly Cost

## 7. Verified Project Results

The latest audit successfully detected two EC2 instances.

| Metric | Result |
|---|---:|
| Total instances | 2 |
| Running instances | 1 |
| Stopped instances | 1 |
| Missing Owner tags | 1 |
| Missing prices | 0 |
| Estimated monthly compute cost | $7.59 |

The replacement web server was successfully detected:

- Instance ID: `i-073605aa92f80606d`
- Instance type: `t3.micro`
- State: running
- Name: `lab-04-web-server`
- Owner: `DevOps-Student`

The website was tested using `curl -I` and returned `HTTP/1.1 200 OK`.

Both CSV and JSON audit reports were successfully generated and inspected.

## 8. Cost Estimation Note

The monthly cost estimates use predefined hourly rates multiplied by 730 hours.

These are approximate EC2 compute estimates, not actual AWS billing figures. They do not include other possible charges such as EBS storage, data transfer or additional AWS services.

## 9. Running the Project

### Terraform

From the Terraform configuration directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the Terraform plan before approving infrastructure changes.

### Python Auditor

Activate the Python virtual environment and install the required dependency if necessary:

```bash
pip install boto3
```

Run the auditor:

```bash
python aws_audit.py
```

The script generates CSV and JSON audit reports.

## 10. Security Considerations

- AWS credentials should be managed securely.
- Never upload private SSH keys.
- Never commit AWS credentials or secrets.
- Restrict SSH access to trusted IP addresses.
- Avoid exposing SSH port 22 to the entire internet.
- Exclude Terraform state files and sensitive variable files from Git.

## 11. Project Status

The following milestones have been verified:

- Terraform EC2 provisioning.
- Nginx installation.
- Public website HTTP verification.
- Boto3 EC2 discovery.
- Missing Owner tag detection.
- Monthly compute cost estimation.
- CSV report generation.
- JSON report generation.
- Before-and-after EC2 audit comparison.

Final documentation review, repository preparation and Terraform infrastructure cleanup remain to be completed.
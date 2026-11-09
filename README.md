# Terraform AWS EC2 Infrastructure and Boto3 Auditor

## 1. Project Overview

This project demonstrates how to provision AWS infrastructure using Terraform and automate EC2 instance auditing using Python and Boto3.

Terraform is used to provision an EC2 web server, configure its security group, and deploy Nginx. Python and Boto3 are used to inspect EC2 instances, identify missing tags, estimate monthly compute costs, and generate audit reports.

The project also demonstrates Terraform remote state management using Amazon S3 and state locking.

## 2. Technologies Used

- **Terraform:** Infrastructure as Code (IaC).
- **Amazon Web Services (AWS):** Cloud infrastructure.
- **Amazon EC2:** Virtual server hosting the website.
- **Amazon S3:** Terraform remote state storage.
- **Amazon DynamoDB:** State locking table configured by the bootstrap infrastructure.
- **Python:** Automation and auditing.
- **Boto3:** AWS SDK for Python.
- **Nginx:** Web server.
- **CSV and JSON:** Audit report formats.
- **Git and GitHub:** Version control and project hosting.

## 3. Project Architecture

The project follows this workflow:

1. Terraform bootstrap provisions the S3 bucket and DynamoDB state-locking table.
2. S3 versioning and server-side encryption are enabled.
3. Public access to the S3 bucket is blocked.
4. The main Terraform configuration uses the S3 remote backend.
5. Terraform provisions the EC2 instance and security group.
6. Terraform connects to the EC2 instance using SSH.
7. Nginx is installed and enabled.
8. The website becomes publicly accessible over HTTP.
9. Python connects to AWS using Boto3.
10. Boto3 retrieves EC2 instance information.
11. The auditor checks instance states, tags, and estimated compute costs.
12. Audit records are exported to CSV and JSON reports.

## 4. Infrastructure Details

| Component | Configuration |
|---|---|
| AWS Region | us-east-1 |
| EC2 Instance Type | t3.micro |
| Operating System | Amazon Linux 2023 |
| Web Server | Nginx 1.30.6 |
| Website Protocol | HTTP |
| SSH Access | Restricted to the configured public IP |
| Terraform Backend | Amazon S3 |
| State Locking | S3 lockfile and configured DynamoDB table |

### Terraform Backend Bootstrap

The `bootstrap/` directory contains the Terraform configuration responsible for preparing the remote backend infrastructure.

It performs the following tasks:

- Creates a uniquely named S3 bucket for Terraform state storage.
- Enables S3 bucket versioning.
- Enables AES256 server-side encryption.
- Blocks public access to the bucket.
- Creates a DynamoDB table for Terraform state locking.

The `terraform/` directory contains the main infrastructure configuration, which uses the remote S3 backend.

**Important:** The bootstrap infrastructure must be created before initializing the main Terraform configuration with the remote backend.

The main configuration currently includes both S3 native lockfile support (`use_lockfile = true`) and a DynamoDB backend table reference. Terraform has deprecated the DynamoDB backend locking argument in favour of S3 native lockfiles. Review this configuration before making future changes.

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
- Produces a summary of discovered instances.

## 6. Audit Report Fields

The generated reports contain:

- Instance ID
- Instance Type
- State
- Name
- Owner
- Audit Time
- Launch Time
- Estimated Monthly Cost

## 7. Verified Project Results

The latest successful audit detected two EC2 instances.

| Metric | Result |
|---|---:|
| Total Instances | 2 |
| Running Instances | 1 |
| Stopped Instances | 1 |
| Missing Owner Tags | 1 |
| Missing Prices | 0 |
| Estimated Monthly Compute Cost | $7.59 |

### Verified Web Server

- **Instance ID:** `i-073605aa92f80606d`
- **Instance Type:** `t3.micro`
- **State:** Running
- **Name:** `lab-04-web-server`
- **Owner:** `DevOps-Student`

### Website Verification

The website was tested using the following command:

```bash
curl -I http://54.242.72.225
```

The server returned:

```text
HTTP/1.1 200 OK
Server: nginx/1.30.6
Content-Type: text/html
```

This confirmed that the Nginx web server was responding successfully over HTTP at the time of testing.

Both CSV and JSON audit reports were successfully generated and inspected.

## 8. Cost Estimation Note

The monthly cost estimates use predefined hourly rates multiplied by 730 hours.

These are approximate EC2 compute estimates, not actual AWS billing figures.

The estimates do not include additional possible charges such as:

- EBS storage.
- Data transfer.
- Elastic IP addresses, where chargeable.
- Other AWS services.

Stopped instances are assigned an estimated EC2 compute cost of $0 by the script. However, associated storage and other resources may still incur charges.

## 9. Running the Project

### Prerequisites

Before running the project, ensure you have:

- An AWS account.
- AWS CLI installed and configured.
- Terraform installed.
- Python installed.
- Git installed.
- Appropriate AWS IAM permissions.
- An SSH key pair for EC2 access.

### A. Terraform Backend Bootstrap

From the project root:

```bash
cd bootstrap
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the plan before approving the creation of AWS resources.

After successful bootstrap creation, note the S3 bucket name and DynamoDB table name from the Terraform outputs.

### B. Main Terraform Infrastructure

Move into the main Terraform directory:

```bash
cd ../terraform
```

Create your local `terraform.tfvars` file with the required variables. For example:

```hcl
aws_region = "us-east-1"
my_ip      = "YOUR_PUBLIC_IP"
```

Replace `YOUR_PUBLIC_IP` with your current public IP address without adding `/32`; the Terraform security group configuration adds that suffix.

Initialize Terraform:

```bash
terraform init
```

Format and validate the configuration:

```bash
terraform fmt
terraform validate
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

Deploy the infrastructure only after reviewing and approving the plan:

```bash
terraform apply
```

### C. Python Boto3 Auditor

Return to the project root:

```bash
cd ..
```

Create and activate a Python virtual environment if one does not already exist:

```bash
python -m venv .venv
```

On Git Bash:

```bash
source .venv/Scripts/activate
```

Install Boto3:

```bash
pip install boto3
```

Run the auditor from the project root:

```bash
python scripts/aws_audit.py
```

The script generates CSV and JSON audit reports in the project root.

### D. Verify Generated Reports

Check the generated report files:

```bash
ls ec2_audit_report.*
```

The generated reports are excluded from Git using `.gitignore`.

## 10. Security Considerations

- AWS credentials should be managed securely.
- Never upload private SSH keys.
- Never commit AWS credentials or secrets.
- Restrict SSH access to trusted IP addresses.
- Avoid exposing SSH port 22 to the entire internet.
- Exclude Terraform state files and sensitive variable files from Git.
- Keep the S3 state bucket private and encrypted.
- Use appropriate IAM permissions and follow the principle of least privilege.
- Review Terraform plans before applying or destroying infrastructure.

## 11. Project Directory Structure

```text
lab-04-aws-auditor/
│
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
│
├── terraform/
│   ├── main.tf
│   ├── ec2.tf
│   ├── Keypair.tf
│   ├── security_group.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
│
├── scripts/
│   ├── aws_audit.py
│   └── deploy_website.sh
│
├── .gitignore
└── README.md
```

## 12. Project Status

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
- Independent Git repository creation.
- Initial Git commit.
- Public GitHub repository publication.

Final documentation review and AWS infrastructure cleanup remain pending.

**Note:** AWS infrastructure should only be destroyed after reviewing the destruction plan and confirming that the project no longer needs the deployed resources.
resource "aws_key_pair" "lab_key" {
  key_name   = "lab-04-aws-auditor-key"
  public_key = file(pathexpand("~/.ssh/lab-04-aws-auditor.pub"))

  tags = {
    Name      = "lab-04-aws-auditor-key"
    ManagedBy = "Terraform"
  }
}
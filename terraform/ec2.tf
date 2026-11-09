
# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = aws_key_pair.lab_key.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  associate_public_ip_address = true

  tags = {
    Name      = "lab-04-web-server"
    Owner     = "DevOps-Student"
    ManagedBy = "Terraform"
  }

  # Copy website deployment script to EC2
  provisioner "file" {
    source      = "${path.module}/../scripts/deploy_website.sh"
    destination = "/tmp/deploy_website.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand("~/.ssh/lab-04-aws-auditor"))
      host        = self.public_ip
      timeout     = "5m"
    }
  }

  # Execute website deployment script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/deploy_website.sh",
      "sudo bash /tmp/deploy_website.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand("~/.ssh/lab-04-aws-auditor"))
      host        = self.public_ip
      timeout     = "5m"
    }
  }
}

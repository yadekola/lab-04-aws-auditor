output "ec2_instance_id" {
  description = "ID of the web server"
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "ec2_instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.web_server.instance_type
}

output "website_url" {
  description = "Public URL of the website"
  value       = "http://${aws_instance.web_server.public_ip}"
}
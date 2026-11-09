#!/bin/bash

set -e

sudo dnf update -y
sudo dnf install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

sudo tee /usr/share/nginx/html/index.html > /dev/null <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>My DevOps Project</title>
</head>
<body>
    <h1>Welcome to My AWS Website!</h1>
    <p>Deployed using Terraform, EC2 and Nginx.</p>
</body>
</html>
HTML

sudo systemctl restart nginx
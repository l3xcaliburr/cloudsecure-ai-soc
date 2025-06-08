#!/bin/bash
# User data script for EC2 instances

# Update system
yum update -y

# Install useful packages
yum install -y htop nmap netcat-openbsd tcpdump wireshark-cli

# Install web server
yum install -y httpd
systemctl enable httpd
systemctl start httpd

# Create a simple web page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>CloudSecure Demo Target</title>
</head>
<body>
    <h1>CloudSecure AI SOC Demo - ${hostname}</h1>
    <p>This server is intentionally configured for security demonstration purposes.</p>
    <p>Hostname: ${hostname}</p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
    <p>Time: $(date)</p>
</body>
</html>
EOF

# Install MySQL for demo purposes (intentionally insecure)
yum install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

# Set hostname
hostnamectl set-hostname ${hostname}

# Configure SSH (allow password auth for demo)
sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Create demo user
useradd demouser
echo "demouser:password123" | chpasswd

# Log setup completion
echo "$(date): User data script completed" >> /var/log/setup.log
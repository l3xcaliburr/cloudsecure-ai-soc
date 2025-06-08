terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# EC2 instances for attack simulation and demonstration

# Key pair for SSH access
resource "aws_key_pair" "demo" {
  key_name   = "${var.name_prefix}-demo-key"
  public_key = var.ssh_public_key
  
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-demo-key"
  })
}

# Target EC2 instance in public subnet (intentionally vulnerable for demo)
resource "aws_instance" "target" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.demo.key_name
  
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.target.id]
  associate_public_ip_address = true
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    hostname = "demo-target"
  }))
  
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-target-server"
    Role = "AttackTarget"
  })
}

# Optional: Attacker EC2 instance in different AZ
resource "aws_instance" "attacker" {
  count = var.create_attacker_instance ? 1 : 0
  
  ami           = var.instance_ami
  instance_type = "t3.micro"
  key_name      = aws_key_pair.demo.key_name
  
  subnet_id                   = var.public_subnet_ids[1]
  vpc_security_group_ids      = [aws_security_group.attacker[0].id]
  associate_public_ip_address = true
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    hostname = "demo-attacker"
  }))
  
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-attacker-server"
    Role = "AttackSource"
  })
}

# Security group for target server (intentionally permissive for demo)
resource "aws_security_group" "target" {
  name        = "${var.name_prefix}-target-sg"
  description = "Security group for attack target demonstration"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # MySQL (intentionally exposed for demo)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # RDP (intentionally exposed for demo)
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-target-sg"
  })
}

# Security group for attacker instance
resource "aws_security_group" "attacker" {
  count = var.create_attacker_instance ? 1 : 0
  
  name        = "${var.name_prefix}-attacker-sg"
  description = "Security group for attack source demonstration"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-attacker-sg"
  })
}

# CloudWatch monitoring for the target instance
resource "aws_cloudwatch_metric_alarm" "target_cpu" {
  alarm_name          = "${var.name_prefix}-target-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  
  dimensions = {
    InstanceId = aws_instance.target.id
  }
  
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-target-cpu-alarm"
  })
}
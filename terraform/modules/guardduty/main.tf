terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# GuardDuty AI threat detection service

# Enable GuardDuty detector
resource "aws_guardduty_detector" "main" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-detector"
  })
}



# GuardDuty threat intel set (optional - adds known malicious IPs)
resource "aws_guardduty_threatintelset" "malicious_ips" {
  count = var.enable_threat_intel ? 1 : 0

  activate    = true
  detector_id = aws_guardduty_detector.main.id
  format      = "TXT"
  location    = "https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt"
  name        = "${var.name_prefix}-malicious-ips"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-threat-intel"
  })
}


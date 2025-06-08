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

# CloudWatch Event Rule for GuardDuty findings
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "${var.name_prefix}-guardduty-findings"
  description = "Capture GuardDuty findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-findings-rule"
  })
}

# CloudWatch Log Group for GuardDuty findings
resource "aws_cloudwatch_log_group" "guardduty_findings" {
  name              = "/aws/events/guardduty-findings"
  retention_in_days = 14

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-findings-logs"
  })
}

# CloudWatch Event Target - Send findings to CloudWatch Logs
resource "aws_cloudwatch_event_target" "guardduty_logs" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "GuardDutyToCloudWatchLogs"
  arn       = aws_cloudwatch_log_group.guardduty_findings.arn
}

# IAM role for CloudWatch Events to write to logs
resource "aws_iam_role" "guardduty_events_role" {
  name = "${var.name_prefix}-guardduty-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-events-role"
  })
}

# IAM policy for GuardDuty events to write to CloudWatch Logs
resource "aws_iam_role_policy" "guardduty_events_policy" {
  name = "${var.name_prefix}-guardduty-events-policy"
  role = aws_iam_role.guardduty_events_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.guardduty_findings.arn}:*"
      }
    ]
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

# Custom CloudWatch metric for GuardDuty findings count
resource "aws_cloudwatch_log_metric_filter" "guardduty_findings_count" {
  name           = "${var.name_prefix}-guardduty-findings-count"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  pattern        = "[timestamp, request_id, event_type=\"GuardDuty Finding\"]"

  metric_transformation {
    name      = "GuardDutyFindingsCount"
    namespace = "CloudSecure/Security"
    value     = "1"
  }
}

# CloudWatch metric filter for high severity findings
resource "aws_cloudwatch_log_metric_filter" "guardduty_high_severity" {
  name           = "${var.name_prefix}-guardduty-high-severity"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  pattern        = "[timestamp, request_id, event_type=\"GuardDuty Finding\", ..., severity >= 7.0]"

  metric_transformation {
    name      = "GuardDutyHighSeverityFindings"
    namespace = "CloudSecure/Security"
    value     = "1"
  }
}
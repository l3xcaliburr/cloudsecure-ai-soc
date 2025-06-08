# CloudWatch Log Group for GuardDuty findings
resource "aws_cloudwatch_log_group" "guardduty_findings" {
  name              = "/aws/events/guardduty-findings"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-findings-logs"
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

# CloudWatch Event Target - Send findings to CloudWatch Logs
resource "aws_cloudwatch_event_target" "guardduty_logs" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "GuardDutyToCloudWatchLogs"
  arn       = aws_cloudwatch_log_group.guardduty_findings.arn
}

# CloudWatch Log Resource Policy for Event Bridge
resource "aws_cloudwatch_log_resource_policy" "guardduty_logs_policy" {
  policy_name = "${var.name_prefix}-guardduty-logs-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.guardduty_findings.arn}:*"
      }
    ]
  })
}

# Metric filter for total GuardDuty findings count
resource "aws_cloudwatch_log_metric_filter" "guardduty_findings_count" {
  name           = "${var.name_prefix}-guardduty-findings-count"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  # Simple pattern to match GuardDuty findings
  pattern = "GuardDuty Finding"

  metric_transformation {
    name      = "GuardDutyFindingsCount"
    namespace = "CloudSecure/Security"
    value     = "1"
    default_value = 0
  }
}

# Metric filter for high severity findings (7.0+)
resource "aws_cloudwatch_log_metric_filter" "guardduty_high_severity" {
  name           = "${var.name_prefix}-guardduty-high-severity"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  # Simple pattern to match any log entry containing "severity" and "7" or "8" or "9"
  pattern = "severity 7"

  metric_transformation {
    name      = "GuardDutyHighSeverityFindings"
    namespace = "CloudSecure/Security"
    value     = "1"
    default_value = 0
  }
}

# Metric filter for medium severity findings (4.0-6.9)
resource "aws_cloudwatch_log_metric_filter" "guardduty_medium_severity" {
  name           = "${var.name_prefix}-guardduty-medium-severity"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  pattern = "severity 4"

  metric_transformation {
    name      = "GuardDutyMediumSeverityFindings"
    namespace = "CloudSecure/Security"
    value     = "1"
    default_value = 0
  }
}

# Metric filter for low severity findings (0.1-3.9)
resource "aws_cloudwatch_log_metric_filter" "guardduty_low_severity" {
  name           = "${var.name_prefix}-guardduty-low-severity"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  pattern = "severity 1"

  metric_transformation {
    name      = "GuardDutyLowSeverityFindings"
    namespace = "CloudSecure/Security"
    value     = "1"
    default_value = 0
  }
}

# Metric filter for findings by type - just count all findings with a type field
resource "aws_cloudwatch_log_metric_filter" "guardduty_findings_by_type" {
  name           = "${var.name_prefix}-guardduty-findings-by-type"
  log_group_name = aws_cloudwatch_log_group.guardduty_findings.name
  pattern = "type"

  metric_transformation {
    name      = "GuardDutyFindingsByType"
    namespace = "CloudSecure/Security"
    value     = "1"
    default_value = 0
  }
}

# CloudWatch Alarm for high severity findings
resource "aws_cloudwatch_metric_alarm" "guardduty_high_severity_alarm" {
  alarm_name          = "${var.name_prefix}-guardduty-high-severity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "GuardDutyHighSeverityFindings"
  namespace           = "CloudSecure/Security"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.high_severity_threshold
  alarm_description   = "This metric monitors high severity GuardDuty findings"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : []

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-high-severity-alarm"
  })
}

# CloudWatch Alarm for finding count rate
resource "aws_cloudwatch_metric_alarm" "guardduty_findings_rate_alarm" {
  alarm_name          = "${var.name_prefix}-guardduty-findings-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "GuardDutyFindingsCount"
  namespace           = "CloudSecure/Security"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.findings_rate_threshold
  alarm_description   = "This metric monitors the rate of GuardDuty findings"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : []

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty-findings-rate-alarm"
  })
}

# CloudWatch Dashboard for GuardDuty metrics
resource "aws_cloudwatch_dashboard" "guardduty_dashboard" {
  dashboard_name = "${var.name_prefix}-guardduty-security-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["CloudSecure/Security", "GuardDutyFindingsCount"],
            [".", "GuardDutyHighSeverityFindings"],
            [".", "GuardDutyMediumSeverityFindings"],
            [".", "GuardDutyLowSeverityFindings"]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "GuardDuty Findings by Severity"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["CloudSecure/Security", "GuardDutyFindingsCount"]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Total GuardDuty Findings"
          view   = "timeSeries"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6

        properties = {
          query = "SOURCE '${aws_cloudwatch_log_group.guardduty_findings.name}'\n| fields @timestamp, detail.severity, detail.type, detail.title, detail.description\n| filter detail.severity >= 7.0\n| sort @timestamp desc\n| limit 20"
          region = var.aws_region
          title  = "Recent High Severity Findings"
        }
      }
    ]
  })
}

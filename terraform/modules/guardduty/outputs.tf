output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = aws_guardduty_detector.main.id
}

output "guardduty_detector_arn" {
  description = "GuardDuty detector ARN"
  value       = aws_guardduty_detector.main.arn
}

output "findings_log_group" {
  description = "CloudWatch log group for GuardDuty findings"
  value       = aws_cloudwatch_log_group.guardduty_findings.name
}

output "findings_event_rule" {
  description = "CloudWatch event rule for GuardDuty findings"
  value       = aws_cloudwatch_event_rule.guardduty_findings.name
}

output "custom_metrics_namespace" {
  description = "CloudWatch custom metrics namespace"
  value       = "CloudSecure/Security"
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name for GuardDuty metrics"
  value       = aws_cloudwatch_dashboard.guardduty_dashboard.dashboard_name
}

output "high_severity_alarm_name" {
  description = "CloudWatch alarm name for high severity findings"
  value       = aws_cloudwatch_metric_alarm.guardduty_high_severity_alarm.alarm_name
}

output "findings_rate_alarm_name" {
  description = "CloudWatch alarm name for findings rate"
  value       = aws_cloudwatch_metric_alarm.guardduty_findings_rate_alarm.alarm_name
}
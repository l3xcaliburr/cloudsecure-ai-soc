output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

output "security_group_ids" {
  description = "IDs of the security groups"
  value = {
    web     = module.security.web_security_group_id
    ec2     = module.security.ec2_security_group_id
    grafana = module.security.grafana_security_group_id
    rds     = module.security.rds_security_group_id
    lambda  = module.security.lambda_security_group_id
  }
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.security.web_acl_arn
}

# Add these outputs
output "grafana_url" {
  description = "URL to access Grafana dashboard"
  value       = "http://${module.networking.alb_dns_name}"
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.networking.alb_dns_name
}

output "grafana_target_group_arn" {
  description = "Grafana target group ARN"
  value       = module.networking.grafana_target_group_arn
}

# =============================================================================
# GUARDDUTY OUTPUTS - AI-POWERED THREAT DETECTION
# =============================================================================
# GuardDuty deployed and active - AI-powered threat detection analyzing the environment

output "guardduty_detector_id" {
  description = "GuardDuty detector ID - AI-powered threat detection service identifier"
  value       = module.guardduty.guardduty_detector_id
}

output "guardduty_detector_arn" {
  description = "GuardDuty detector ARN - Full Amazon Resource Name for the detector"
  value       = module.guardduty.guardduty_detector_arn
}

output "guardduty_findings_log_group" {
  description = "CloudWatch log group for GuardDuty findings - Central logging for security events"
  value       = module.guardduty.findings_log_group
}

output "guardduty_dashboard_url" {
  description = "CloudWatch Dashboard URL for GuardDuty metrics visualization"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.guardduty.cloudwatch_dashboard_name}"
}

output "security_monitoring_summary" {
  description = "Security monitoring deployment summary"
  value = {
    status                    = "✅ GuardDuty deployed and active - AI-powered threat detection analyzing the environment"
    detector_id              = module.guardduty.guardduty_detector_id
    findings_log_group       = module.guardduty.findings_log_group
    metrics_namespace        = module.guardduty.custom_metrics_namespace
    high_severity_alarm      = module.guardduty.high_severity_alarm_name
    findings_rate_alarm      = module.guardduty.findings_rate_alarm_name
    dashboard_name           = module.guardduty.cloudwatch_dashboard_name
  }
}

output "security_metrics_namespace" {
  description = "Custom security metrics namespace for CloudWatch"
  value       = module.guardduty.custom_metrics_namespace
}

output "target_server_ip" {
  description = "Target server public IP for attack testing"
  value       = module.compute.target_public_ip
}

output "attacker_server_ip" {
  description = "Attacker server public IP"
  value       = module.compute.attacker_public_ip
}

output "ssh_connection_command" {
  description = "SSH command to connect to target server"
  value       = "ssh -i ~/.ssh/cloudsecure-demo ec2-user@${module.compute.target_public_ip}"
}
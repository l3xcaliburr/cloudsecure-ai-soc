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

output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = module.guardduty.guardduty_detector_id
}

output "guardduty_findings_log_group" {
  description = "GuardDuty findings log group"
  value       = module.guardduty.findings_log_group
}

output "security_metrics_namespace" {
  description = "Custom security metrics namespace"
  value       = module.guardduty.custom_metrics_namespace
}

# TODO: Add these outputs when modules are created
# output "grafana_url" {
#   description = "URL of the Grafana instance"
#   value       = module.grafana.grafana_url
# }

# output "monitoring_dashboard_url" {
#   description = "URL of the monitoring dashboard"
#   value       = module.monitoring.dashboard_url
# } 
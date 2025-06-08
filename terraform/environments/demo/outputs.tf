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

# TODO: Add these outputs when modules are created
# output "grafana_url" {
#   description = "URL of the Grafana instance"
#   value       = module.grafana.grafana_url
# }

# output "monitoring_dashboard_url" {
#   description = "URL of the monitoring dashboard"
#   value       = module.monitoring.dashboard_url
# } 
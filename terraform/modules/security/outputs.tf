output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "grafana_security_group_id" {
  description = "ID of the Grafana security group"
  value       = aws_security_group.grafana.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  value       = aws_security_group.lambda.id
}

output "network_acl_id" {
  description = "ID of the network ACL"
  value       = aws_network_acl.main.id
}

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    web     = aws_security_group.web.id
    ec2     = aws_security_group.ec2.id
    grafana = aws_security_group.grafana.id
    rds     = aws_security_group.rds.id
    lambda  = aws_security_group.lambda.id
  }
} 
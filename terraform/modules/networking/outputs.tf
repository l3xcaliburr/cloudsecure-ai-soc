output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

# TODO: ALB outputs will be added when ALB module is created

output "vpc_flow_log_group" {
  description = "CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_log.name
}

# Add these outputs to your existing outputs.tf
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.grafana.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.grafana.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.grafana.zone_id
}

output "grafana_target_group_arn" {
  description = "ARN of the Grafana target group"
  value       = aws_lb_target_group.grafana.arn
}
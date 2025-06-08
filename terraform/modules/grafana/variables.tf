variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Map of security group IDs"
  type = object({
    grafana = string
  })
}

variable "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
} 
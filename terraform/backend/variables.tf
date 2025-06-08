variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cloudsecure-ai-soc"
}

variable "owner_email" {
  description = "Email of the project owner"
  type        = string
  default     = "your-email@example.com"
}
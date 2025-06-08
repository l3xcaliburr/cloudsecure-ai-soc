variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "enable_threat_intel" {
  description = "Enable threat intelligence feeds"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
}

variable "high_severity_threshold" {
  description = "Threshold for high severity GuardDuty findings alarm"
  type        = number
  default     = 0
}

variable "findings_rate_threshold" {
  description = "Threshold for GuardDuty findings rate alarm"
  type        = number
  default     = 10
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarms (optional)"
  type        = string
  default     = null
}
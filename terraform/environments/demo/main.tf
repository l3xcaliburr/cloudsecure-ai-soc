terraform {
  required_version = ">= 1.0"
  
    backend "s3" {
        bucket         = "cloudsecure-ai-soc-terraform-state-21a9fbd7"
        key            = "demo/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "cloudsecure-ai-soc-terraform-lock"
        encrypt        = true
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "CloudSecure-AI-SOC"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.owner_email
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

# Local values
locals {
  name_prefix = "cs-soc-${var.environment}"  # Shortened to fit AWS ALB name limits
  
  common_tags = {
    Project     = "CloudSecure-AI-SOC"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner_email
  }
}

# Module calls (we'll create these modules next)
module "networking" {
  source = "../../modules/networking"
  
  name_prefix         = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  
  tags = local.common_tags
}

module "security" {
  source = "../../modules/security"
  
  name_prefix         = local.name_prefix
  vpc_id              = module.networking.vpc_id
  allowed_cidr_blocks = var.allowed_cidr_blocks
  
  tags = local.common_tags
}

# Additional modules will be added as we build them
# module "grafana" { ... }
# module "compute" { ... }
# module "monitoring" { ... }
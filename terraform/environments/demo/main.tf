terraform {
  required_version = ">= 1.0"
  
    backend "s3" {
        bucket         = "your-terraform-state-bucket"
        key            = "demo/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "your-terraform-lock-table"
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

module "grafana" {
  source = "../../modules/grafana"
  
  name_prefix            = local.name_prefix
  aws_region            = var.aws_region
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  security_group_ids    = module.security.security_group_ids
  target_group_arn      = module.networking.grafana_target_group_arn
  alb_dns_name          = module.networking.alb_dns_name
  grafana_admin_password = var.grafana_admin_password
  
  tags = local.common_tags
}

module "guardduty" {
  source = "../../modules/guardduty"
  
  name_prefix         = local.name_prefix
  aws_region         = var.aws_region
  enable_threat_intel = false
  
  tags = local.common_tags
}

module "compute" {
  source = "../../modules/compute"
  
  name_prefix        = local.name_prefix
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  ssh_public_key    = var.ssh_public_key
  
  tags = local.common_tags
}
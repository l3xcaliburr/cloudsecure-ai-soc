#!/bin/bash

# CloudSecure AI SOC Destruction Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-demo}
BACKEND_DIR="terraform/backend"
ENV_DIR="terraform/environments/$ENVIRONMENT"

echo -e "${RED}🔥 CloudSecure AI SOC Destruction Script${NC}"
echo "Environment: $ENVIRONMENT"

# Confirmation prompt
echo -e "${YELLOW}⚠️  WARNING: This will destroy all resources in the $ENVIRONMENT environment!${NC}"
read -p "Are you sure you want to continue? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Destruction cancelled."
    exit 0
fi

# Step 1: Destroy main infrastructure
echo -e "${RED}🏗️  Step 1: Destroying $ENVIRONMENT environment...${NC}"
if [ -d "$ENV_DIR" ]; then
    cd "$ENV_DIR"
    if [ -f "terraform.tfstate" ] || [ -f ".terraform/terraform.tfstate" ]; then
        terraform destroy -auto-approve
    else
        echo "No Terraform state found, skipping main infrastructure destruction"
    fi
    cd - > /dev/null
fi

# Step 2: Stop Grafana containers
echo -e "${RED}📊 Step 2: Stopping Grafana containers...${NC}"
if [ -f "grafana/docker/docker-compose.yml" ]; then
    cd grafana/docker
    docker-compose down -v
    cd - > /dev/null
fi

# Step 3: Destroy backend infrastructure (optional)
echo -e "${YELLOW}🤔 Do you want to destroy the backend infrastructure (S3 bucket and DynamoDB table)?${NC}"
echo -e "${YELLOW}⚠️  This will delete the Terraform state storage!${NC}"
read -p "Destroy backend? (yes/no): " -r
if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${RED}📦 Step 3: Destroying backend infrastructure...${NC}"
    cd "$BACKEND_DIR"
    if [ -f "terraform.tfstate" ]; then
        terraform destroy -auto-approve
    else
        echo "No backend state found, skipping backend destruction"
    fi
    cd - > /dev/null
fi

# Step 4: Cleanup
echo -e "${GREEN}🧹 Step 4: Cleaning up...${NC}"
find . -name "*.tfstate*" -type f -delete 2>/dev/null || true
find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true

echo -e "${GREEN}✅ Destruction completed successfully!${NC}"
echo -e "${YELLOW}📋 Summary:${NC}"
echo "- $ENVIRONMENT environment destroyed"
echo "- Grafana containers stopped"
echo "- Local Terraform state files cleaned up" 
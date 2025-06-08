#!/bin/bash

# CloudSecure AI SOC Deployment Script
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

echo -e "${GREEN}🚀 CloudSecure AI SOC Deployment Script${NC}"
echo "Environment: $ENVIRONMENT"

# Check if required files exist
if [ ! -f "$ENV_DIR/terraform.tfvars" ]; then
    echo -e "${RED}❌ Error: terraform.tfvars file not found in $ENV_DIR${NC}"
    echo -e "${YELLOW}💡 Copy terraform.tfvars.example to terraform.tfvars and customize the values${NC}"
    exit 1
fi

# Step 1: Deploy backend infrastructure
echo -e "${GREEN}📦 Step 1: Deploying backend infrastructure...${NC}"
cd "$BACKEND_DIR"
terraform init
terraform plan
terraform apply -auto-approve

# Get backend outputs
STATE_BUCKET=$(terraform output -raw state_bucket_name)
LOCK_TABLE=$(terraform output -raw lock_table_name)

cd - > /dev/null

# Step 2: Initialize main environment
echo -e "${GREEN}🏗️  Step 2: Initializing $ENVIRONMENT environment...${NC}"
cd "$ENV_DIR"

# Configure backend
terraform init \
    -backend-config="bucket=$STATE_BUCKET" \
    -backend-config="key=$ENVIRONMENT/terraform.tfstate" \
    -backend-config="region=us-east-1" \
    -backend-config="dynamodb_table=$LOCK_TABLE"

# Step 3: Deploy main infrastructure
echo -e "${GREEN}🔧 Step 3: Deploying main infrastructure...${NC}"
terraform plan
terraform apply -auto-approve

# Step 4: Configure Grafana dashboards
echo -e "${GREEN}📊 Step 4: Configuring Grafana dashboards...${NC}"
cd - > /dev/null

if [ -f "grafana/docker/docker-compose.yml" ]; then
    cd grafana/docker
    docker-compose up -d
    cd - > /dev/null
fi

# Step 5: Deploy Lambda functions
echo -e "${GREEN}⚡ Step 5: Deploying Lambda functions...${NC}"
for lambda_dir in lambda/*/; do
    if [ -d "$lambda_dir" ]; then
        echo "Deploying $(basename "$lambda_dir")..."
        # Add Lambda deployment logic here
    fi
done

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Access Grafana dashboard at the provided URL"
echo "2. Configure data sources and dashboards"
echo "3. Run demo scenarios with: ./scripts/demo-scenarios.sh" 
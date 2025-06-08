# CloudSecure AI SOC Setup Guide

This guide provides detailed instructions for setting up the CloudSecure AI SOC environment.

## Prerequisites

### Required Software

1. **AWS CLI** (v2.0+)

   ```bash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install

   # Configure AWS credentials
   aws configure
   ```

2. **Terraform** (v1.0+)

   ```bash
   # Download and install Terraform
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   unzip terraform_1.5.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

3. **Docker** (for Grafana)
   ```bash
   # Install Docker
   sudo apt-get update
   sudo apt-get install docker.io docker-compose
   sudo usermod -aG docker $USER
   ```

### AWS Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS Key Pair** for EC2 instances
3. **IAM User** with the following policies:
   - EC2FullAccess
   - VPCFullAccess
   - S3FullAccess
   - DynamoDBFullAccess
   - LambdaFullAccess
   - CloudWatchFullAccess
   - IAMFullAccess

## Step-by-Step Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd cloudsecure-ai-soc
```

### 2. Configure Environment

Copy and customize the example configuration:

```bash
cp terraform/environments/demo/terraform.tfvars.example terraform/environments/demo/terraform.tfvars
```

Edit `terraform/environments/demo/terraform.tfvars`:

```hcl
# Basic Configuration
environment = "demo"
aws_region  = "us-east-1"  # Change to your preferred region

# Network Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]  # Update for your region

# Compute Configuration
instance_type = "t3.medium"  # Adjust based on your needs
key_pair_name = "your-aws-key-pair"  # Replace with your key pair

# Security Configuration
allowed_cidr_blocks = ["YOUR.PUBLIC.IP.ADDRESS/32"]  # Replace with your IP
```

### 3. Set up AWS Key Pair

If you don't have an AWS key pair:

```bash
# Create a new key pair
aws ec2 create-key-pair --key-name cloudsecure-demo --query 'KeyMaterial' --output text > ~/.ssh/cloudsecure-demo.pem
chmod 400 ~/.ssh/cloudsecure-demo.pem

# Update terraform.tfvars with the key pair name
key_pair_name = "cloudsecure-demo"
```

### 4. Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### 5. Deploy Infrastructure

```bash
./scripts/deploy.sh demo
```

The deployment script will:

1. Create S3 bucket and DynamoDB table for Terraform state
2. Deploy the main infrastructure
3. Configure Grafana dashboards
4. Deploy Lambda functions

### 6. Verify Deployment

Check that all resources are created:

```bash
# List running EC2 instances
aws ec2 describe-instances --filters "Name=tag:Project,Values=CloudSecure-AI-SOC" --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType}'

# Check S3 buckets
aws s3 ls | grep terraform

# Verify DynamoDB table
aws dynamodb list-tables | grep terraform
```

## Configuration Details

### Backend Configuration

The Terraform backend uses:

- **S3 Bucket**: For storing Terraform state
- **DynamoDB Table**: For state locking
- **Encryption**: State files are encrypted at rest

### Network Architecture

- **VPC**: Isolated virtual network
- **Public Subnets**: For load balancers and NAT gateways
- **Private Subnets**: For compute resources
- **Security Groups**: Firewall rules for different tiers

### Security Configuration

1. **IAM Roles**: Least privilege access for resources
2. **Security Groups**: Restrictive network access
3. **VPC Flow Logs**: Network traffic monitoring
4. **CloudTrail**: API call auditing

## Troubleshooting

### Common Issues

1. **AWS Credentials Not Configured**

   ```bash
   aws configure list
   aws sts get-caller-identity
   ```

2. **Terraform State Lock Issues**

   ```bash
   # Force unlock if needed (use carefully)
   terraform force-unlock LOCK_ID
   ```

3. **Permission Denied Errors**

   - Ensure your AWS user has the required policies
   - Check IAM role trust relationships

4. **Key Pair Not Found**
   ```bash
   # List available key pairs
   aws ec2 describe-key-pairs
   ```

### Validation Commands

```bash
# Check Terraform configuration
cd terraform/environments/demo
terraform validate
terraform plan

# Verify AWS connectivity
aws sts get-caller-identity

# Test security group rules
aws ec2 describe-security-groups --filters "Name=tag:Project,Values=CloudSecure-AI-SOC"
```

## Environment Management

### Multiple Environments

To create additional environments:

1. Copy the demo environment:

   ```bash
   cp -r terraform/environments/demo terraform/environments/staging
   ```

2. Update configuration files:

   ```bash
   # Edit terraform.tfvars for the new environment
   vim terraform/environments/staging/terraform.tfvars
   ```

3. Deploy the new environment:
   ```bash
   ./scripts/deploy.sh staging
   ```

### Environment Isolation

Each environment gets:

- Separate Terraform state
- Isolated AWS resources
- Environment-specific tags
- Independent configuration

## Monitoring Setup

### Grafana Configuration

1. Access Grafana at the provided URL
2. Default credentials: admin/admin (change immediately)
3. Import dashboards from `grafana/dashboards/`
4. Configure data sources from `grafana/datasources/`

### CloudWatch Integration

- VPC Flow Logs → CloudWatch Logs
- Application Logs → CloudWatch Logs
- Custom Metrics → CloudWatch Metrics
- Alarms → SNS notifications

## Security Hardening

### Post-Deployment Security

1. **Change Default Passwords**

   - Grafana admin password
   - Database passwords (if applicable)

2. **Review Security Groups**

   ```bash
   aws ec2 describe-security-groups --query 'SecurityGroups[].{GroupId:GroupId,GroupName:GroupName,IpPermissions:IpPermissions}'
   ```

3. **Enable Additional Logging**

   - S3 access logging
   - Load balancer access logs
   - Application-level logging

4. **Configure Monitoring Alerts**
   - Failed login attempts
   - Unusual network traffic
   - Resource utilization thresholds

## Backup and Recovery

### State File Backup

Terraform state is automatically backed up in S3 with versioning enabled.

### Resource Backup

- EC2 snapshots (if using EBS volumes)
- Database backups (if applicable)
- Configuration backups

## Next Steps

After successful deployment:

1. [Run Demo Scenarios](DEMO.md)
2. Customize dashboards and alerts
3. Integrate with existing security tools
4. Configure automated responses
5. Set up monitoring and alerting

## Support

For deployment issues:

1. Check AWS CloudFormation events (if applicable)
2. Review Terraform logs
3. Verify AWS service limits
4. Check the troubleshooting section above

---

**Note**: This setup creates AWS resources that may incur charges. Monitor your AWS billing and destroy resources when not needed using `./scripts/destroy.sh`.

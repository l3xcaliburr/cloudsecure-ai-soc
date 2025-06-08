# CloudSecure AI SOC

> **⚠️ Important Security Notice**: This project is designed for educational and demonstration purposes. Always follow your organization's security policies and conduct proper security reviews before deploying in production environments.

An AI-powered Security Operations Center (SOC) built on AWS with Terraform, featuring automated threat detection, incident response, and comprehensive security monitoring.

## 🚀 Features

- **Infrastructure as Code**: Complete AWS infrastructure managed with Terraform
- **AI-Powered Threat Detection**: Lambda functions for intelligent security analysis using AWS GuardDuty
- **Real-time Monitoring**: Grafana dashboards with custom security metrics
- **Automated Response**: Incident response automation with AWS Lambda
- **Attack Simulation**: Built-in demo scenarios for testing and training
- **Scalable Architecture**: Modular design supporting multiple environments

## 🏗️ Architecture

The CloudSecure AI SOC consists of several key components:

- **AWS GuardDuty**: AI-powered threat detection service
- **AWS VPC**: Secure network infrastructure with public/private subnets
- **Application Load Balancer**: Traffic distribution and SSL termination
- **Amazon ECS Fargate**: Containerized Grafana deployment
- **AWS Lambda**: Serverless security automation functions
- **Amazon CloudWatch**: Metrics, logs, and alerting
- **AWS WAF**: Web application firewall protection

## 📋 Prerequisites

Before you begin, ensure you have the following installed and configured:

- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [Terraform](https://terraform.io) >= 1.0
- [Docker](https://docker.com) (for local development)
- Bash shell environment
- An AWS account with appropriate permissions

### Required AWS Permissions

Your AWS credentials need the following permissions:

- EC2 (VPC, instances, security groups)
- ECS (clusters, services, tasks)
- Application Load Balancer
- GuardDuty
- CloudWatch (logs, metrics, dashboards)
- IAM (roles and policies)
- S3 (for Terraform state)
- DynamoDB (for Terraform locking)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/cloudsecure-ai-soc.git
cd cloudsecure-ai-soc
```

### 2. Set Up Terraform Backend

First, create the S3 bucket and DynamoDB table for remote state:

```bash
cd terraform/backend
terraform init
terraform plan
terraform apply
```

Note the bucket name and DynamoDB table name from the output, then update `terraform/environments/demo/main.tf` with these values.

### 3. Configure Environment Variables

Copy the example variables file:

```bash
cd terraform/environments/demo
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:

```hcl
environment = "demo"
aws_region  = "us-east-1"
vpc_cidr    = "10.0.0.0/16"
owner_email = "your-email@example.com"
allowed_cidr_blocks = ["your.ip.address/32"]
grafana_admin_password = "your-secure-password"
ssh_public_key = "ssh-rsa AAAA... your-public-key"
```

### 4. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### 5. Access Grafana Dashboard

After deployment, get the Grafana URL:

```bash
terraform output grafana_url
```

Login with:

- Username: `admin`
- Password: (the password you set in terraform.tfvars)

### 6. Run Attack Simulations

Configure the demo script with your infrastructure IPs:

```bash
# Get the required IPs from terraform output
export GRAFANA_ALB=$(terraform output -raw alb_dns_name)
export TARGET_SERVER=$(terraform output -raw target_server_ip)
export ATTACKER_SERVER=$(terraform output -raw attacker_server_ip)

# Run the attack simulation
./demo-attacks.sh
```

## 📁 Project Structure

```
cloudsecure-ai-soc/
├── terraform/                  # Infrastructure as Code
│   ├── backend/               # Backend state management
│   ├── modules/               # Reusable Terraform modules
│   │   ├── networking/        # VPC, subnets, security groups
│   │   ├── security/          # Security-specific resources
│   │   ├── compute/           # EC2 instances and clusters
│   │   ├── monitoring/        # CloudWatch and monitoring
│   │   ├── guardduty/         # GuardDuty AI threat detection
│   │   └── grafana/           # Grafana deployment
│   └── environments/          # Environment-specific configs
│       └── demo/              # Demo environment
├── docs/                      # Detailed documentation
│   ├── README.md             # Architecture overview
│   ├── SETUP.md              # Detailed setup guide
│   └── DEMO.md               # Demo scenarios guide
├── demo-attacks.sh           # Attack simulation script
├── .gitignore                # Git ignore rules
└── README.md                 # This file
```

## 🔧 Configuration

### Environment Variables

Key configuration variables in `terraform.tfvars`:

| Variable                 | Description                   | Required |
| ------------------------ | ----------------------------- | -------- |
| `environment`            | Environment name              | Yes      |
| `aws_region`             | AWS region                    | Yes      |
| `vpc_cidr`               | VPC CIDR block                | Yes      |
| `owner_email`            | Email for resource tagging    | Yes      |
| `allowed_cidr_blocks`    | IP ranges for access control  | Yes      |
| `grafana_admin_password` | Grafana admin password        | Yes      |
| `ssh_public_key`         | SSH public key for EC2 access | Yes      |

### Security Configuration

- All resources are deployed within a VPC with private subnets
- Security groups restrict access based on `allowed_cidr_blocks`
- VPC Flow Logs enabled for network monitoring
- CloudTrail logging for API call auditing
- AWS WAF protection for web applications

## 📊 Monitoring & Dashboards

The Grafana dashboards provide:

- **Security Overview**: High-level security metrics
- **AI Threat Detection**: GuardDuty findings and analysis
- **Network Monitoring**: Traffic patterns and anomalies
- **Infrastructure Health**: System performance metrics

## 🎭 Demo Scenarios

The included attack simulation demonstrates:

1. **SOC Platform Reconnaissance**: Probing monitoring infrastructure
2. **Infrastructure Port Scanning**: Network reconnaissance
3. **Web Application Attacks**: Common web vulnerabilities
4. **Brute Force Simulation**: Credential attacks
5. **DoS Simulation**: High-volume request patterns
6. **Cryptocurrency Mining Detection**: Malicious domain queries
7. **Vulnerability Scanning**: Aggressive security scans
8. **Backdoor Communication**: Suspicious port activity
9. **Data Exfiltration**: Large data transfer patterns

## 🔒 Security Features

- **Real-time Threat Detection**: AWS GuardDuty AI-powered analysis
- **Network Segmentation**: Private subnets and security groups
- **Web Application Firewall**: AWS WAF protection
- **Logging & Auditing**: Comprehensive logging with CloudTrail
- **Anomaly Detection**: ML-based behavioral analysis
- **Automated Alerting**: CloudWatch alarms and notifications

## 🛠️ Customization

### Adding New Modules

1. Create module directory under `terraform/modules/`
2. Define `variables.tf`, `main.tf`, and `outputs.tf`
3. Reference module in environment configuration

### Customizing Detection Rules

1. Modify GuardDuty settings in `terraform/modules/guardduty/`
2. Update Grafana dashboards
3. Configure alert thresholds in monitoring module

## 📚 Documentation

For detailed information, see the `docs/` directory:

- [Setup Guide](docs/SETUP.md) - Step-by-step setup instructions
- [Demo Guide](docs/DEMO.md) - Demo scenarios and usage
- [Architecture](docs/README.md) - Technical architecture details

## 🧹 Cleanup

To destroy all resources:

```bash
cd terraform/environments/demo
terraform destroy
```

Then cleanup the backend resources:

```bash
cd terraform/backend
terraform destroy
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test with demo environment
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

For issues and questions:

1. Check the documentation in the `docs/` directory
2. Review existing GitHub issues
3. Create a new issue with detailed information

## ⚠️ Security Considerations

- **Demo Environment**: This is designed for demonstration and learning
- **Production Use**: Requires additional hardening and security reviews
- **Credentials**: Never commit credentials to version control
- **Access Control**: Implement proper IAM roles and policies
- **Monitoring**: Enable comprehensive logging and monitoring
- **Updates**: Regularly update dependencies and security patches

---

**Built with ❤️ for cybersecurity education and training**

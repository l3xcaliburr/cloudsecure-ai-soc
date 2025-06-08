# CloudSecure AI SOC

An AI-powered Security Operations Center (SOC) built on AWS with Terraform, featuring automated threat detection, incident response, and comprehensive security monitoring.

## 🚀 Features

- **Infrastructure as Code**: Complete AWS infrastructure managed with Terraform
- **AI-Powered Threat Detection**: Lambda functions for intelligent security analysis
- **Real-time Monitoring**: Grafana dashboards with custom security metrics
- **Automated Response**: Incident response automation with AWS Lambda
- **Attack Simulation**: Built-in demo scenarios for testing and training
- **Scalable Architecture**: Modular design supporting multiple environments

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Threat Intel  │    │   Log Sources   │    │   Monitoring    │
│   & Detection   │    │   (CloudTrail,  │    │   (Grafana,     │
│   (Lambda)      │    │   VPC Logs)     │    │   CloudWatch)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   AI SOC Core   │
                    │   (AWS VPC)     │
                    └─────────────────┘
```

## 📁 Project Structure

```
cloudsecure-ai-soc/
├── terraform/              # Infrastructure as Code
│   ├── backend/            # Backend state management
│   ├── modules/            # Reusable Terraform modules
│   │   ├── networking/     # VPC, subnets, security groups
│   │   ├── security/       # Security-specific resources
│   │   ├── compute/        # EC2 instances and clusters
│   │   ├── monitoring/     # CloudWatch and monitoring
│   │   └── grafana/        # Grafana deployment
│   └── environments/       # Environment-specific configs
├── ansible/                # Configuration management
├── grafana/                # Dashboard definitions
├── lambda/                 # Serverless functions
│   ├── attack-simulator/   # Attack simulation
│   ├── threat-detection/   # AI threat detection
│   └── response-automation/# Automated incident response
├── scripts/                # Deployment and utility scripts
└── docs/                   # Documentation
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- Docker (for Grafana)
- Bash shell

### 1. Clone and Setup

```bash
git clone <repository-url>
cd cloudsecure-ai-soc
cp terraform/environments/demo/terraform.tfvars.example terraform/environments/demo/terraform.tfvars
```

### 2. Configure Variables

Edit `terraform/environments/demo/terraform.tfvars`:

```hcl
environment = "demo"
aws_region  = "us-east-1"
vpc_cidr    = "10.0.0.0/16"
key_pair_name = "your-key-pair-name"
allowed_cidr_blocks = ["your.ip.address/32"]
```

### 3. Deploy

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh demo
```

### 4. Run Demo Scenarios

```bash
./scripts/demo-scenarios.sh
```

## 🔧 Configuration

### Environment Variables

| Variable        | Description       | Default       |
| --------------- | ----------------- | ------------- |
| `environment`   | Environment name  | `demo`        |
| `aws_region`    | AWS region        | `us-east-1`   |
| `vpc_cidr`      | VPC CIDR block    | `10.0.0.0/16` |
| `instance_type` | EC2 instance type | `t3.medium`   |

### Security Configuration

- All resources are deployed within a VPC with private subnets
- Security groups restrict access based on `allowed_cidr_blocks`
- VPC Flow Logs enabled for network monitoring
- CloudTrail logging for API call auditing

## 📊 Monitoring & Dashboards

Access Grafana dashboards at the URL provided after deployment:

- **Security Overview**: High-level security metrics
- **Threat Detection**: AI-powered threat analysis
- **Network Monitoring**: Traffic patterns and anomalies
- **Incident Response**: Response automation status

## 🎭 Demo Scenarios

The project includes pre-built attack scenarios:

1. **Brute Force Attack**: Failed login simulation
2. **Port Scanning**: Network reconnaissance
3. **File Access**: Suspicious file system activity
4. **Network Anomaly**: Unusual traffic patterns
5. **SQL Injection**: Database attack attempts
6. **DDoS Simulation**: High-volume request flooding

## 🔒 Security Features

- **Real-time Threat Detection**: AI-powered analysis of logs and metrics
- **Automated Incident Response**: Lambda-based response automation
- **Network Segmentation**: Private subnets and security groups
- **Logging & Auditing**: Comprehensive logging with CloudTrail
- **Anomaly Detection**: ML-based behavioral analysis

## 🛠️ Development

### Adding New Modules

1. Create module directory under `terraform/modules/`
2. Define variables, resources, and outputs
3. Reference module in environment configuration

### Customizing Detection Rules

1. Modify Lambda functions in `lambda/threat-detection/`
2. Update Grafana dashboards in `grafana/dashboards/`
3. Configure alert thresholds in monitoring module

## 📚 Documentation

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Demo Guide](DEMO.md) - Demo scenarios and usage
- [Architecture Guide](ARCHITECTURE.md) - Technical architecture details

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with demo environment
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋‍♂️ Support

For issues and questions:

1. Check the documentation in the `docs/` directory
2. Review existing GitHub issues
3. Create a new issue with detailed information

## 🔄 Updates

Stay updated with the latest security patches and features by regularly pulling from the main branch and reviewing the changelog.

---

**⚠️ Security Notice**: This project is for educational and demonstration purposes. Always follow your organization's security policies and conduct proper security reviews before deploying in production environments.

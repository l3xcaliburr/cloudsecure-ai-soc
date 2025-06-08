# Contributing to CloudSecure AI SOC

Thank you for your interest in contributing to CloudSecure AI SOC! This project is designed to help cybersecurity professionals learn about security monitoring, AI-powered threat detection, and cloud security best practices.

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- AWS account with appropriate permissions
- Terraform >= 1.0 installed
- Basic understanding of AWS services (VPC, EC2, ECS, GuardDuty)
- Familiarity with Infrastructure as Code (IaC) principles

### Setting Up Development Environment

1. Fork and clone the repository
2. Set up the backend infrastructure (S3 bucket and DynamoDB table)
3. Create your own `terraform.tfvars` file
4. Test the deployment in your own AWS account

## 🛠️ How to Contribute

### Types of Contributions

We welcome contributions in several areas:

- **Infrastructure Improvements**: Terraform module enhancements
- **Security Enhancements**: Better security configurations
- **Documentation**: README updates, guides, tutorials
- **Monitoring**: New Grafana dashboards, alerts
- **Attack Simulations**: Additional demo scenarios
- **Bug Fixes**: Issues with deployment or functionality

### Development Workflow

1. **Fork the Repository**

   ```bash
   git fork https://github.com/original-owner/cloudsecure-ai-soc.git
   cd cloudsecure-ai-soc
   ```

2. **Create a Feature Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**

   - Follow existing code style and patterns
   - Test changes in your own AWS environment
   - Update documentation as needed

4. **Test Your Changes**

   ```bash
   cd terraform/environments/demo
   terraform plan
   terraform apply
   # Run tests and verification
   terraform destroy
   ```

5. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "feat: add descriptive commit message"
   ```

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub.

## 📋 Contribution Guidelines

### Code Standards

- **Terraform**: Follow HashiCorp's style guide
- **Documentation**: Use clear, concise language
- **Security**: Always consider security implications
- **Testing**: Test all changes in your own environment

### Terraform Best Practices

- Use meaningful resource names with consistent prefixes
- Include proper tagging for all resources
- Use variables instead of hard-coded values
- Include outputs for important resource information
- Add comments for complex configurations

### Security Considerations

⚠️ **Important**: This project contains intentionally vulnerable configurations for educational purposes.

- **Never** commit real credentials or sensitive information
- **Always** use placeholder values in example files
- **Document** any intentional vulnerabilities clearly
- **Test** security configurations thoroughly

### Documentation Requirements

- Update README.md if adding new features
- Include inline comments for complex code
- Provide examples for new configurations
- Update architecture diagrams if needed

## 🐛 Reporting Issues

When reporting issues, please include:

- **Environment**: AWS region, Terraform version, OS
- **Steps to Reproduce**: Clear steps to replicate the issue
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Error Messages**: Full error logs if applicable
- **Configuration**: Relevant terraform.tfvars (sanitized)

### Issue Templates

- **Bug Report**: For deployment or functionality issues
- **Feature Request**: For new capabilities or improvements
- **Security Issue**: For security-related concerns (use private disclosure)

## 🔒 Security Disclosure

If you discover security vulnerabilities, please:

1. **DO NOT** open a public issue
2. Send details to the maintainers privately
3. Allow time for assessment and fixes
4. Follow responsible disclosure practices

## 📝 Pull Request Process

### Before Submitting

- [ ] Code follows project standards
- [ ] All tests pass in your environment
- [ ] Documentation updated as needed
- [ ] No hard-coded credentials or sensitive data
- [ ] Commit messages are descriptive

### PR Requirements

- **Title**: Clear, descriptive title
- **Description**: Explain what changes and why
- **Testing**: Describe how you tested the changes
- **Screenshots**: Include relevant screenshots if applicable
- **Breaking Changes**: Document any breaking changes

### Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Your contribution will be acknowledged

## 🎯 Priority Areas

We're particularly interested in contributions for:

- **Multi-cloud Support**: Azure, GCP integrations
- **Advanced Monitoring**: Custom CloudWatch metrics
- **AI/ML Enhancements**: Improved threat detection
- **Compliance**: SOC 2, PCI DSS configurations
- **Performance**: Optimization and cost reduction
- **Automation**: CI/CD pipeline improvements

## 📚 Resources

### Learning Resources

- [AWS GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Grafana Documentation](https://grafana.com/docs/)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-resources/)

### Community

- GitHub Discussions for questions and ideas
- Issues for bug reports and feature requests
- Pull Requests for contributions

## 📄 License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers the project.

## 🙏 Recognition

Contributors will be acknowledged in:

- Project README
- Release notes for significant contributions
- Hall of Fame for major contributors

---

**Thank you for helping make cybersecurity education more accessible!** 🛡️

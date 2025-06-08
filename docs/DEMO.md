# CloudSecure AI SOC Demo Guide

This guide walks you through the demo scenarios and features of the CloudSecure AI SOC platform.

## Overview

The demo environment includes pre-built attack scenarios that demonstrate the SOC's detection and response capabilities. These scenarios simulate real-world security threats and show how the AI-powered system responds.

## 🚀 Getting Started

### Prerequisites

1. Completed infrastructure deployment (`./scripts/deploy.sh demo`)
2. Grafana dashboards accessible
3. Demo scenarios script ready (`./scripts/demo-scenarios.sh`)

### Quick Demo Run

```bash
# Make script executable (if not already done)
chmod +x scripts/demo-scenarios.sh

# Run interactive demo menu
./scripts/demo-scenarios.sh

# Or run all scenarios at once
./scripts/demo-scenarios.sh --all
```

## 🎭 Demo Scenarios

### 1. Brute Force Attack Simulation

**Scenario**: Simulates multiple failed login attempts from a single IP address.

**What it demonstrates**:

- Login attempt monitoring
- Failed authentication detection
- IP-based attack pattern recognition
- Alert generation and escalation

**Expected Alerts**:

- High number of failed login attempts
- Suspicious source IP identification
- Automated blocking recommendations

```bash
# Manual execution
./scripts/demo-scenarios.sh
# Select option 1
```

**Grafana Dashboard**: Check "Security Overview" → "Authentication Failures"

---

### 2. Port Scanning Detection

**Scenario**: Simulates network reconnaissance activities typical of attackers mapping network services.

**What it demonstrates**:

- Network traffic monitoring
- Port scanning pattern detection
- Reconnaissance activity identification
- Network anomaly alerts

**Expected Alerts**:

- Unusual port access patterns
- Multiple port probes from single source
- Network reconnaissance warnings

```bash
# View network monitoring dashboard while running
./scripts/demo-scenarios.sh
# Select option 2
```

**Grafana Dashboard**: Check "Network Monitoring" → "Port Scan Detection"

---

### 3. Suspicious File Access

**Scenario**: Attempts to access sensitive system files and directories.

**What it demonstrates**:

- File system monitoring
- Unauthorized access detection
- Privilege escalation attempts
- Data exfiltration prevention

**Expected Alerts**:

- Access to sensitive files
- Unusual file system activity
- Potential data breach warnings

**Grafana Dashboard**: Check "Security Overview" → "File System Activity"

---

### 4. Network Anomaly Detection

**Scenario**: Generates unusual network traffic patterns that deviate from normal behavior.

**What it demonstrates**:

- AI-powered anomaly detection
- Behavioral analysis capabilities
- Traffic pattern recognition
- Automated threat scoring

**Expected Alerts**:

- Abnormal network traffic volumes
- Unusual destination patterns
- Anomaly confidence scores

**Grafana Dashboard**: Check "Threat Detection" → "Anomaly Analysis"

---

### 5. SQL Injection Simulation

**Scenario**: Simulates database attack attempts through malicious SQL queries.

**What it demonstrates**:

- Application security monitoring
- Database attack detection
- Input validation bypass attempts
- Web application firewall effectiveness

**Expected Alerts**:

- SQL injection attempt detection
- Database security violations
- Application vulnerability warnings

**Grafana Dashboard**: Check "Security Overview" → "Application Security"

---

### 6. DDoS Attack Simulation

**Scenario**: Generates high-volume requests simulating a distributed denial of service attack.

**What it demonstrates**:

- Traffic volume monitoring
- DDoS pattern recognition
- Rate limiting effectiveness
- Service availability protection

**Expected Alerts**:

- High request volume alerts
- Service degradation warnings
- DDoS mitigation activation

**Grafana Dashboard**: Check "Network Monitoring" → "Traffic Analysis"

## 📊 Monitoring the Demo

### Grafana Dashboards

Access your Grafana instance to monitor the demo scenarios in real-time:

1. **Security Overview Dashboard**

   - High-level security metrics
   - Alert summaries
   - Threat landscape visualization

2. **Threat Detection Dashboard**

   - AI-powered threat analysis
   - Anomaly detection results
   - Risk scoring and prioritization

3. **Network Monitoring Dashboard**

   - Traffic flow analysis
   - Network anomaly detection
   - Connection pattern monitoring

4. **Incident Response Dashboard**
   - Response automation status
   - Incident timelines
   - Remediation tracking

### Real-time Monitoring

While running scenarios, observe:

1. **Alert Generation**: Watch alerts appear in real-time
2. **Metric Changes**: Monitor security metrics and graphs
3. **Automated Responses**: See system responses to threats
4. **Correlation**: Notice how different events correlate

## 🤖 AI Features Demonstration

### Machine Learning Components

The demo showcases several AI capabilities:

1. **Behavioral Analysis**

   - User behavior profiling
   - Deviation detection
   - Risk scoring

2. **Pattern Recognition**

   - Attack pattern identification
   - Signature matching
   - Trend analysis

3. **Automated Response**
   - Threat classification
   - Response recommendation
   - Auto-remediation triggers

### AI Model Performance

During the demo, observe:

- Detection accuracy rates
- False positive management
- Response time metrics
- Learning and adaptation

## 📈 Metrics and KPIs

### Security Metrics

Track these key performance indicators during the demo:

| Metric              | Description            | Expected Range |
| ------------------- | ---------------------- | -------------- |
| MTTD                | Mean Time to Detection | < 5 minutes    |
| MTTR                | Mean Time to Response  | < 15 minutes   |
| Alert Accuracy      | True Positive Rate     | > 85%          |
| False Positive Rate | Incorrect Alerts       | < 10%          |

### System Performance

Monitor system health during scenarios:

- CPU utilization
- Memory usage
- Network throughput
- Storage performance

## 🔧 Customizing Demo Scenarios

### Adding Custom Scenarios

1. **Create New Scenario Function**:

   ```bash
   # Edit scripts/demo-scenarios.sh
   run_custom_scenario() {
       echo "Running custom scenario..."
       # Add your simulation logic here
   }
   ```

2. **Add to Menu**:

   ```bash
   # Update show_menu() function
   echo "9. Custom Scenario"
   ```

3. **Update Case Statement**:
   ```bash
   9)
       run_custom_scenario
       ;;
   ```

### Scenario Configuration

Modify scenario parameters:

```bash
# In demo-scenarios.sh
BRUTE_FORCE_ATTEMPTS=20    # Increase failed login attempts
PORT_SCAN_TARGETS=100      # More port scan targets
DDOS_REQUEST_COUNT=1000    # Higher DDoS volume
```

## 🚨 Understanding Alerts

### Alert Severity Levels

| Level    | Color  | Description      | Action Required            |
| -------- | ------ | ---------------- | -------------------------- |
| Critical | Red    | Immediate threat | Immediate response         |
| High     | Orange | Significant risk | Respond within 1 hour      |
| Medium   | Yellow | Moderate concern | Investigate within 4 hours |
| Low      | Blue   | Informational    | Monitor and log            |

### Alert Components

Each alert includes:

- **Timestamp**: When the event occurred
- **Source**: Origin of the security event
- **Type**: Category of security threat
- **Severity**: Risk level assessment
- **Description**: Details of the event
- **Recommendations**: Suggested actions

## 🔍 Troubleshooting Demo Issues

### Common Issues

1. **No Alerts Generated**

   - Check Grafana data source connections
   - Verify CloudWatch log streams
   - Confirm Lambda function execution

2. **Dashboard Not Loading**

   - Refresh browser cache
   - Check Grafana service status
   - Verify network connectivity

3. **Scenarios Running Too Fast**
   - Adjust sleep intervals in demo script
   - Increase scenario duration
   - Add more detailed logging

### Debug Commands

```bash
# Check Lambda function logs
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/cloudsecure"

# Verify CloudWatch metrics
aws cloudwatch list-metrics --namespace "CloudSecure/SOC"

# Test Grafana API
curl -H "Authorization: Bearer <token>" http://<grafana-url>/api/health
```

## 📚 Demo Scenarios Explained

### Technical Implementation

Each scenario triggers different monitoring systems:

1. **Log Generation**: Creates entries in CloudWatch Logs
2. **Metric Updates**: Updates custom CloudWatch metrics
3. **Lambda Triggers**: Activates threat detection functions
4. **Alert Generation**: Creates alerts in monitoring systems
5. **Dashboard Updates**: Refreshes Grafana visualizations

### Learning Opportunities

Use the demo to understand:

- How security events are correlated
- The role of AI in threat detection
- Automated response capabilities
- Security monitoring best practices

## 🎯 Demo Objectives

By completing the demo scenarios, you will:

1. **Understand SOC Operations**: See how a modern SOC functions
2. **Experience AI Detection**: Witness AI-powered threat detection
3. **Learn Response Procedures**: Understand incident response workflows
4. **Evaluate Effectiveness**: Assess the system's capabilities
5. **Identify Improvements**: Spot areas for customization

## 📝 Demo Report

After running scenarios, document:

- Alert response times
- Detection accuracy
- False positive rates
- System performance
- Areas for improvement

## 🔄 Continuous Demo Environment

### Automated Demo Mode

Set up continuous demo scenarios:

```bash
# Create a cron job for regular demo runs
echo "0 */4 * * * /path/to/scripts/demo-scenarios.sh --automated" | crontab -
```

### Demo Environment Maintenance

Regular tasks:

- Clear old log entries
- Reset demo data
- Update scenario parameters
- Refresh dashboard data

---

**Pro Tip**: Run the demo scenarios while presenting to stakeholders to show real-time SOC capabilities and AI-powered threat detection in action!

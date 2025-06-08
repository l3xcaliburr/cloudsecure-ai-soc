#!/bin/bash

# =============================================================================
# CloudSecure AI SOC - Attack Simulation Script
# =============================================================================
# 
# ⚠️  SECURITY NOTICE:
# This script is designed for EDUCATIONAL and DEMONSTRATION purposes only.
# It performs simulated attacks against your own infrastructure to test
# security monitoring capabilities.
# 
# DO NOT use this script against systems you do not own or have explicit
# permission to test. Unauthorized testing may be illegal and unethical.
# 
# By using this script, you acknowledge that:
# - You own or have permission to test the target systems
# - You understand the potential impact of these simulated attacks
# - You will use this responsibly for educational purposes only
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Update these with your actual IPs or set as environment variables
GRAFANA_ALB="${GRAFANA_ALB:-your-grafana-alb-url.elb.amazonaws.com}"
TARGET_SERVER="${TARGET_SERVER:-your.target.server.ip}"
ATTACKER_SERVER="${ATTACKER_SERVER:-your.attacker.server.ip}"

# Verify configuration
if [[ "$GRAFANA_ALB" == "your-grafana-alb-url.elb.amazonaws.com" ]] || 
   [[ "$TARGET_SERVER" == "your.target.server.ip" ]] || 
   [[ "$ATTACKER_SERVER" == "your.attacker.server.ip" ]]; then
    echo -e "${RED}❌ Configuration Error:${NC}"
    echo "Please set the following environment variables or edit this script:"
    echo "  export GRAFANA_ALB='your-actual-grafana-alb-url'"
    echo "  export TARGET_SERVER='your-actual-target-ip'"
    echo "  export ATTACKER_SERVER='your-actual-attacker-ip'"
    echo ""
    echo "Or get these values from terraform output:"
    echo "  cd terraform/environments/demo"
    echo "  terraform output grafana_url"
    echo "  terraform output target_server_ip"
    echo "  terraform output attacker_server_ip"
    exit 1
fi

echo -e "${BLUE}🎯 CloudSecure AI SOC Attack Simulation${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""
echo -e "${YELLOW}Target Infrastructure:${NC}"
echo -e "  Grafana SOC Platform: ${GRAFANA_ALB}"
echo -e "  Target Server: ${TARGET_SERVER}"
echo -e "  Attacker Server: ${ATTACKER_SERVER}"
echo ""

# Function to print attack status
print_attack() {
    echo -e "${RED}🚨 ATTACK: $1${NC}"
}

# Function to print dashboard impact
print_dashboard() {
    echo -e "${GREEN}📊 Dashboard Impact: $1${NC}"
}

# Attack 1: Reconnaissance against SOC Platform (ALB)
print_attack "SOC Platform Reconnaissance"
echo "Scanning security monitoring platform for vulnerabilities..."

for path in admin config backup database .env wp-admin phpmyadmin login api; do
    curl -s -o /dev/null "http://${GRAFANA_ALB}/${path}" || true
    echo "  → Probing /${path}"
    sleep 1
done

print_dashboard "ALB 3XX Redirects will spike (Panel 2: SOC Platform Security)"
echo ""

# Attack 2: Port Scanning Target Infrastructure
print_attack "Infrastructure Port Scanning"
echo "Scanning target server for open services..."

# Basic port scan
if command -v nmap &> /dev/null; then
    echo "  → Running nmap port scan"
    nmap -sS -p 22,25,53,80,110,143,443,993,995,3306,3389,5432 "${TARGET_SERVER}" 2>/dev/null || true
else
    echo "  → Running manual port probes (nmap not available)"
    for port in 22 25 53 80 110 143 443 993 995 3306 3389 5432; do
        timeout 2 nc -zv "${TARGET_SERVER}" $port 2>/dev/null || true
        echo "    Scanning port $port"
    done
fi

print_dashboard "GuardDuty AI will detect reconnaissance (Panel 1: AI Threat Detection)"
echo ""

# Attack 3: Web Application Attacks
print_attack "Web Application Enumeration"
echo "Probing web services for vulnerabilities..."

web_paths=("admin" "administrator" "wp-admin" "phpmyadmin" "config" "backup" "database" "test" "dev" "staging")

for path in "${web_paths[@]}"; do
    curl -s -o /dev/null "http://${TARGET_SERVER}/${path}" || true
    echo "  → Testing /${path}"
    sleep 0.5
done

print_dashboard "EC2 NetworkPacketsIn will increase (Panel 3: Target Infrastructure)"
echo ""

# Attack 4: Brute Force Simulation
print_attack "SSH Brute Force Simulation"
echo "Attempting credential attacks..."

usernames=("admin" "root" "user" "test" "guest" "oracle" "postgres" "mysql")

for user in "${usernames[@]}"; do
    timeout 3 ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no "${user}@${TARGET_SERVER}" 2>/dev/null &
    echo "  → Testing credentials for ${user}"
    sleep 1
done

# Wait for background processes
wait

print_dashboard "GuardDuty may detect brute force patterns (Panel 1)"
echo ""

# Attack 5: Rapid Request Generation
print_attack "DoS Simulation - Rapid Requests"
echo "Generating high-volume traffic..."

echo "  → Sending rapid requests to SOC platform"
for i in {1..50}; do
    curl -s -o /dev/null "http://${GRAFANA_ALB}/api/health" &
    if [ $((i % 10)) -eq 0 ]; then
        echo "    Sent $i requests..."
    fi
done

echo "  → Sending rapid requests to target server"
for i in {1..30}; do
    curl -s -o /dev/null "http://${TARGET_SERVER}/" &
done

# Wait for requests to complete
wait

print_dashboard "Request Count will spike across all panels"
echo ""

# Attack 6: Cryptocurrency Mining Simulation (HIGH SEVERITY)
print_attack "Cryptocurrency Mining Detection"
echo "Simulating crypto mining DNS queries..."

crypto_domains=("pool.minergate.com" "xmr-usa-east1.nanopool.org" "stratum.antpool.com" "mining.pool.bitcoin.com" "eth-us-east1.nanopool.org")

for domain in "${crypto_domains[@]}"; do
    dig @8.8.8.8 "$domain" >/dev/null 2>&1 || true
    echo "  → Querying ${domain}"
    sleep 2
done

print_dashboard "GuardDuty will likely generate HIGH severity crypto mining findings"
echo ""

# Attack 7: Malicious Domain Queries (CRITICAL SEVERITY)
print_attack "Malicious Domain Reconnaissance"
echo "Querying known malicious domains..."

malicious_domains=("027.ru" "3322.org" "no-ip.org" "dyndns.org" "botnets.com")

for domain in "${malicious_domains[@]}"; do
    dig @8.8.8.8 "$domain" >/dev/null 2>&1 || true
    echo "  → Probing ${domain}"
    sleep 2
done

print_dashboard "GuardDuty may generate CRITICAL malicious domain findings"
echo ""

# Attack 8: Aggressive Vulnerability Scanning (HIGH SEVERITY)
print_attack "Aggressive Vulnerability Scanning"
echo "Running comprehensive security scans..."

if command -v nmap &> /dev/null; then
    echo "  → Running aggressive nmap scan"
    timeout 60 nmap -sS -O -A --script vuln "${TARGET_SERVER}" >/dev/null 2>&1 &
    
    echo "  → Running UDP scan"
    timeout 30 nmap -sU -p 53,67,68,161,162 "${TARGET_SERVER}" >/dev/null 2>&1 &
    
    echo "  → Running OS detection"
    timeout 30 nmap -O "${TARGET_SERVER}" >/dev/null 2>&1 &
else
    echo "  → Manual aggressive port probing"
    for port in {1..100}; do
        timeout 1 nc -zv "${TARGET_SERVER}" $port >/dev/null 2>&1 &
    done
fi

print_dashboard "GuardDuty should detect aggressive scanning patterns"
echo ""

# Attack 9: Multiple SSH Brute Force Sources (HIGH SEVERITY)
print_attack "Multi-Source SSH Brute Force"
echo "Coordinated credential attacks..."

# Simulate attacks from multiple "sources" with different user agents and timing
for round in {1..3}; do
    echo "  → Attack round ${round}"
    
    usernames=("admin" "root" "user" "test" "guest" "oracle" "postgres" "mysql" "administrator" "sa")
    
    for user in "${usernames[@]}"; do
        # Vary the timing to look like different attackers
        sleep_time=$(echo "scale=1; $RANDOM/32767*3" | bc 2>/dev/null || echo "1")
        timeout 2 ssh -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${user}@${TARGET_SERVER}" >/dev/null 2>&1 &
        
        # Also try telnet brute force
        timeout 2 telnet "${TARGET_SERVER}" 23 >/dev/null 2>&1 &
        
        sleep 0.5
    done
    
    sleep 5  # Pause between rounds
done

print_dashboard "Multiple failed login attempts should trigger HIGH severity findings"
echo ""

# Attack 10: Backdoor Communication Simulation (CRITICAL SEVERITY)
print_attack "Backdoor Communication Patterns"
echo "Simulating C&C server communication..."

# Common backdoor ports
backdoor_ports=(4444 6666 8080 9999 1337 31337 12345 54321)

for port in "${backdoor_ports[@]}"; do
    echo "  → Testing backdoor port ${port}"
    timeout 3 nc -zv "${TARGET_SERVER}" $port >/dev/null 2>&1 &
    
    # Also try reverse connection simulation
    timeout 3 nc -l -p $port >/dev/null 2>&1 &
    
    sleep 1
done

print_dashboard "Unusual port activity may trigger CRITICAL backdoor findings"
echo ""

# Attack 11: Data Exfiltration Simulation (HIGH SEVERITY)
print_attack "Data Exfiltration Simulation"
echo "Simulating large data transfers..."

echo "  → Rapid large file downloads"
for i in {1..20}; do
    curl -s --max-time 5 "http://${TARGET_SERVER}/" >/dev/null 2>&1 &
    curl -s --max-time 5 "http://${TARGET_SERVER}/large-file-$i" >/dev/null 2>&1 &
done

# Simulate DNS tunneling (data exfiltration technique)
echo "  → DNS tunneling simulation"
for i in {1..10}; do
    dig @8.8.8.8 "data-exfil-${i}-${RANDOM}.example.com" >/dev/null 2>&1 || true
    sleep 1
done

print_dashboard "High volume transfers may trigger data exfiltration alerts"
echo ""

# Attack Summary
echo -e "${BLUE}🎯 Advanced Attack Simulation Complete${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "${GREEN}✅ Dashboard Panels Should Show:${NC}"
echo "  Panel 1 (AI Threat Detection): Multiple GuardDuty findings with HIGH/CRITICAL severity"
echo "  Panel 2 (SOC Platform Security): 3XX redirect spikes from ALB reconnaissance"
echo "  Panel 3 (Target Infrastructure): Heavy network packet increases on EC2"
echo "  Panel 4 (Traffic Analysis): Significant request count spikes during attacks"
echo ""
echo -e "${YELLOW}⏱️  Advanced Timing Expectations:${NC}"
echo "  Immediate (0-2 min): ALB metrics, EC2 network metrics"
echo "  Short term (5-15 min): Medium severity findings (port scans)"
echo "  Medium term (10-20 min): HIGH severity findings (crypto mining, brute force)"
echo "  Longer term (15-30 min): CRITICAL findings (malicious domains, backdoors)"
echo "  Dashboard refresh: 30 seconds"
echo ""
echo -e "${RED}🚨 Expected GuardDuty Finding Types:${NC}"
echo "  • Recon:EC2/Portscan (Medium) - Port scanning activity"
echo "  • CryptoCurrency:EC2/BitcoinTool.B (High) - Crypto mining detection"
echo "  • Trojan:EC2/DNSDataExfiltration (High) - DNS tunneling"
echo "  • Backdoor:EC2/C&CActivity.B (Critical) - Command & control communication"
echo "  • UnauthorizedAPICall:EC2/MaliciousIPCaller.Custom (Critical) - Malicious domains"
echo ""
echo -e "${BLUE}📊 Monitor your Grafana dashboard: http://${GRAFANA_ALB}${NC}"
echo ""
echo -e "${YELLOW}🔄 Wait 10-20 minutes then check GuardDuty console for HIGH/CRITICAL findings!${NC}"
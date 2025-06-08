#!/bin/bash

# CloudSecure AI SOC Demo Scenarios Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎭 CloudSecure AI SOC Demo Scenarios${NC}"
echo ""

# Menu function
show_menu() {
    echo -e "${BLUE}Available Demo Scenarios:${NC}"
    echo "1. Brute Force Attack Simulation"
    echo "2. Port Scanning Detection"
    echo "3. Suspicious File Access"
    echo "4. Network Anomaly Detection"
    echo "5. SQL Injection Attempt"
    echo "6. DDoS Attack Simulation"
    echo "7. Run All Scenarios"
    echo "8. Exit"
    echo ""
}

# Scenario 1: Brute Force Attack
run_brute_force_demo() {
    echo -e "${YELLOW}🔐 Running Brute Force Attack Simulation...${NC}"
    echo "Simulating multiple failed login attempts..."
    
    # Simulate failed SSH attempts
    for i in {1..10}; do
        echo "Failed login attempt #$i from IP 192.168.1.100"
        sleep 1
    done
    
    echo -e "${GREEN}✅ Brute force attack simulation completed${NC}"
    echo "Check Grafana dashboard for security alerts"
    echo ""
}

# Scenario 2: Port Scanning
run_port_scan_demo() {
    echo -e "${YELLOW}🔍 Running Port Scanning Detection...${NC}"
    echo "Simulating port scanning activity..."
    
    # Simulate nmap-like port scanning
    ports=(22 80 443 3389 8080 8443)
    for port in "${ports[@]}"; do
        echo "Scanning port $port on target 10.0.1.50"
        sleep 0.5
    done
    
    echo -e "${GREEN}✅ Port scanning simulation completed${NC}"
    echo "Network monitoring should detect suspicious port scanning"
    echo ""
}

# Scenario 3: Suspicious File Access
run_file_access_demo() {
    echo -e "${YELLOW}📁 Running Suspicious File Access Simulation...${NC}"
    echo "Simulating unauthorized file access attempts..."
    
    suspicious_files=(
        "/etc/passwd"
        "/etc/shadow"
        "/var/log/auth.log"
        "/home/admin/.ssh/id_rsa"
    )
    
    for file in "${suspicious_files[@]}"; do
        echo "Attempting to access: $file"
        sleep 1
    done
    
    echo -e "${GREEN}✅ Suspicious file access simulation completed${NC}"
    echo "File integrity monitoring should trigger alerts"
    echo ""
}

# Scenario 4: Network Anomaly
run_network_anomaly_demo() {
    echo -e "${YELLOW}🌐 Running Network Anomaly Detection...${NC}"
    echo "Simulating unusual network traffic patterns..."
    
    echo "Generating high-volume traffic to unusual destinations..."
    echo "Simulating DNS tunneling attempts..."
    echo "Creating abnormal connection patterns..."
    
    sleep 3
    
    echo -e "${GREEN}✅ Network anomaly simulation completed${NC}"
    echo "Network monitoring should detect anomalous behavior"
    echo ""
}

# Scenario 5: SQL Injection
run_sql_injection_demo() {
    echo -e "${YELLOW}💉 Running SQL Injection Simulation...${NC}"
    echo "Simulating SQL injection attempts..."
    
    payloads=(
        "' OR '1'='1"
        "'; DROP TABLE users; --"
        "' UNION SELECT * FROM passwords"
    )
    
    for payload in "${payloads[@]}"; do
        echo "Testing payload: $payload"
        sleep 1
    done
    
    echo -e "${GREEN}✅ SQL injection simulation completed${NC}"
    echo "Web application firewall should detect injection attempts"
    echo ""
}

# Scenario 6: DDoS Attack
run_ddos_demo() {
    echo -e "${YELLOW}🌊 Running DDoS Attack Simulation...${NC}"
    echo "Simulating distributed denial of service attack..."
    
    echo "Generating high-volume requests from multiple sources..."
    for i in {1..50}; do
        echo "Request #$i from 192.168.100.$((RANDOM % 254 + 1))"
        sleep 0.1
    done
    
    echo -e "${GREEN}✅ DDoS attack simulation completed${NC}"
    echo "Rate limiting and DDoS protection should activate"
    echo ""
}

# Run all scenarios
run_all_scenarios() {
    echo -e "${BLUE}🚀 Running All Demo Scenarios...${NC}"
    echo ""
    
    run_brute_force_demo
    run_port_scan_demo
    run_file_access_demo
    run_network_anomaly_demo
    run_sql_injection_demo
    run_ddos_demo
    
    echo -e "${GREEN}🎉 All demo scenarios completed!${NC}"
    echo -e "${YELLOW}📊 Check your Grafana dashboards for:${NC}"
    echo "- Security alerts and incidents"
    echo "- Network traffic anomalies"
    echo "- System performance metrics"
    echo "- Threat detection results"
}

# Main loop
while true; do
    show_menu
    read -p "Select a scenario (1-8): " choice
    
    case $choice in
        1)
            run_brute_force_demo
            ;;
        2)
            run_port_scan_demo
            ;;
        3)
            run_file_access_demo
            ;;
        4)
            run_network_anomaly_demo
            ;;
        5)
            run_sql_injection_demo
            ;;
        6)
            run_ddos_demo
            ;;
        7)
            run_all_scenarios
            ;;
        8)
            echo -e "${GREEN}👋 Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Please try again.${NC}"
            ;;
    esac
    
    read -p "Press Enter to continue..."
done 
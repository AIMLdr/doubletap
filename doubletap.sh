# doubletap (c) 2025 Gregory L. Magnusson
# find and kill llama with custom port kill
# ollama shepherd boot y/N control

#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# list known LLM process names
llm_process_names=("ollama" "llama" "llamacpp" "text-generation-server" "python" "pytorch" "tensorflow")

# Function to handle Ollama daemon first
handle_ollama_daemon() {
    echo -e "${YELLOW}=== Checking Ollama Service ===${NC}"
    if systemctl list-unit-files | grep -q ollama; then
        if systemctl is-active --quiet ollama; then
            echo -e "${YELLOW}stopping Ollama service...${NC}"
            sudo systemctl stop ollama
            sleep 2
        fi
    fi
}

# you have 3 seconds to enter a port number or default
default_port=11434
echo "you have 3 seconds to enter a port to scan (Enter use default: $default_port)..."
read -t 3 -p "enter port number: " user_port
port=${user_port:-$default_port}

# Diagnostic: Show processes using selected port
echo "checking for process on port $port..."
lsof_output=$(sudo lsof -i :$port)
netstat_output=$(sudo netstat -tulnp | grep $port)

# is LLM running
llm_found=false
is_llm_process=false

# check if process name matches known LLM processes
check_llm_process() {
    local process_name=$1
    for llm in "${llm_process_names[@]}"; do
        if [[ $process_name =~ $llm ]]; then
            return 0  # true
        fi
    done
    return 1  # false
}

# Handle daemon before checking processes
handle_ollama_daemon

if [[ -n "$lsof_output" ]]; then
    echo "process found via lsof on port $port:"
    echo "$lsof_output"
    
    # Extract process name from lsof output and check if it's an LLM
    process_name=$(echo "$lsof_output" | awk 'NR>1 {print $1}')
    if check_llm_process "$process_name"; then
        is_llm_process=true
        echo -e "${GREEN}confirmed LLM process: $process_name${NC}"
    else
        echo -e "${YELLOW}warning: unknown LLM service${NC}"
    fi
    llm_found=true
else
    echo "no process found via lsof on port $port."
fi

if [[ -n "$netstat_output" ]]; then
    echo "network activity found via netstat on port $port:"
    echo "$netstat_output"
    
    # Extract process name from netstat output and check if it's an LLM
    process_name=$(echo "$netstat_output" | awk '{print $7}' | cut -d'/' -f2)
    if check_llm_process "$process_name"; then
        is_llm_process=true
        echo -e "${GREEN}confirmed LLM process: $process_name${NC}"
    else
        echo -e "${YELLOW}warning: unknown LLM service${NC}"
    fi
    llm_found=true
else
    echo "netstat no network activity on port $port."
fi

# Proceed with process checks and termination
if [[ "$llm_found" == true ]]; then
    if [[ "$is_llm_process" == false ]]; then
        read -p "Process doesn't appear to be an LLM. Are you sure you want to proceed? (y/N) " proceed
        proceed=$(echo "$proceed" | tr '[:upper:]' '[:lower:]')
        if [[ "$proceed" != "y" ]]; then
            echo "Process check cancelled. Continuing with shepherd controls..."
        fi
    fi

    read -p "kill the llama on port $port? (y/N) " confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    if [[ "$confirm" == "y" ]]; then
        pids=$(sudo lsof -i :$port | awk 'NR>1 {print $2}')
        if [[ ! -z "$pids" ]]; then
            echo "hunting llama process(es) on port $port: $pids"
            sudo kill -9 $pids
            
            # Verify if process was actually killed
            sleep 1  # Give system time to update process list
            if ! sudo lsof -i :$port >/dev/null 2>&1; then
                echo -e "${GREEN}✓ llama Process(es) kill confirmed${NC}"
                echo -e "${GREEN}Port $port is now free${NC}"
            else
                echo -e "${RED}! warning: llama process(es) may still be running${NC}"
                echo -e "${RED}check port $port manually${NC}"
            fi
        else
            echo "no llama process running on port $port via lsof."
        fi
    fi
fi

# Continue with shepherd controls regardless of previous operations
echo -e "${YELLOW}=== Checking System for Ollama Processes ===${NC}"

# Check for any ollama processes
if pgrep -x "ollama" > /dev/null; then
    echo -e "${YELLOW}Found running Ollama processes${NC}"
    read -p "Terminate all Ollama processes? (y/N) " kill_all
    if [[ "${kill_all,,}" == "y" ]]; then
        echo -e "${YELLOW}Terminating all Ollama processes...${NC}"
        sudo pkill -9 ollama
        sleep 1
        if ! pgrep -x "ollama" > /dev/null; then
            echo -e "${GREEN}✓ All Ollama processes terminated${NC}"
        else
            echo -e "${RED}! Some Ollama processes may still be running${NC}"
        fi
    fi
fi

# Check systemd service status
if systemctl list-unit-files | grep -q ollama; then
    echo -e "${YELLOW}Checking Ollama service status...${NC}"
    if systemctl is-active --quiet ollama; then
        read -p "Ollama service is active. Stop it? (y/N) " stop_service
        if [[ "${stop_service,,}" == "y" ]]; then
            sudo systemctl stop ollama
            echo -e "${GREEN}✓ Ollama service stopped${NC}"
        fi
    else
        echo -e "${GREEN}Ollama service is inactive${NC}"
    fi
    
    # Ask about boot behavior
    read -p "Disable Ollama at boot? (y/N) " disable_boot
    if [[ "${disable_boot,,}" == "y" ]]; then
        sudo systemctl disable ollama
        echo -e "${GREEN}✓ Ollama disabled at boot${NC}"
    else
        sudo systemctl enable ollama
        echo -e "${YELLOW}! warning: Ollama running at boot${NC}"
        echo -e "${YELLOW}! use 'sudo systemctl disable ollama' to disable manually${NC}"
    fi
fi

# Final verification
echo -e "${YELLOW}=== Final System Check ===${NC}"
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${GREEN}✓ no Ollama processes running${NC}"
else
    echo -e "${RED}! warning: ollama processes detected${NC}"
fi

if ! sudo lsof -i :$port >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Port $port is clear${NC}"
else
    echo -e "${RED}! port $port is in use${NC}"
fi

# Additional check for default Ollama port if custom port was used
if [[ "$port" != "11434" ]]; then
    if ! sudo lsof -i :11434 >/dev/null 2>&1; then
        echo -e "${GREEN}✓ default Ollama port 11434 is clear${NC}"
    else
        echo -e "${RED}! warning: Default Ollama port 11434 still in use${NC}"
    fi
fi

echo -e "${YELLOW}=== UFW Ollama Security Configuration ===${NC}"

# Check if UFW is installed
if ! command -v ufw >/dev/null 2>&1; then
    echo -e "${RED}Error: UFW is not installed${NC}"
    echo -e "${YELLOW}Install with: sudo apt install ufw${NC}"
    exit 1
fi

# Check current UFW status
echo -e "${YELLOW}Checking UFW status...${NC}"
if ! sudo ufw status | grep -q "Status: active"; then
    echo -e "${YELLOW}Enabling UFW...${NC}"
    sudo ufw enable
    sleep 2
fi

echo -e "${YELLOW}Configuring Ollama UFW rules...${NC}"

# Allow localhost access
echo -e "${GREEN}Allowing localhost access to port 11434...${NC}"
sudo ufw allow in from 127.0.0.1 to any port 11434
sudo ufw allow out from any to 127.0.0.1 port 11434

# Block external access
echo -e "${GREEN}Blocking external access to port 11434...${NC}"
sudo ufw deny in to any port 11434
sudo ufw deny out to any port 11434

# Verify rules
echo -e "${YELLOW}=== UFW Rules Verification ===${NC}"
sudo ufw status verbose

echo -e "${GREEN}=== Configuration Complete ===${NC}"
echo -e "${YELLOW}! Ollama now restricted to localhost only${NC}"
echo -e "${GREEN}=== Operation Complete ===${NC}"


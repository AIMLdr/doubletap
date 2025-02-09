# DoubleTap

DoubleTap is designed to locate, monitor, and manage large language model (LLM) processes on my Linux x64 system running from a bash shell. It will detect running LLM instance from port default 11434 and name to hunt and kill llama including ollama. Following termination Shepherd Daemon boot option y/N 

# doubletap - Local LLM Process Management and Network Tool
```txt
Purpose: Emergency termination of resource-hungry LLM processes and associated services
Use Case: When local LLMs consume excessive RAM or maintain unwanted network connections
Kill the llama before it eats all your grass
hint: Always monitor htop for resource usage and netstat for open ports
Maintain proper firewall rules for all AI/ML service ports
```
default <a href="http://127.0.0.1:11434/">Ollama port 11434</a> firewall restricted to localhost from uncompicated firewall
```bash
# Allow localhost access
echo -e "${GREEN}Allowing localhost access to port 11434...${NC}"
sudo ufw allow in from 127.0.0.1 to any port 11434
sudo ufw allow out from any to 127.0.0.1 port 11434

# Block external access
echo -e "${GREEN}Blocking external access to port 11434...${NC}"
sudo ufw deny in to any port 11434
sudo ufw deny out to any port 11434
```
# Scans for known LLM processes including:
```txt
ollama
llama
llamacpp
text-generation-server
python
pytorch
tensorflow
```

stops Ollama daemon service if running
provides custom network port for scanning
color-coded terminal output
```sh
 git clone https://github.com/aimldr/doubletap.git
```
```sh
cd doubletap && chmod +x doubletap.sh && ./doubletap.sh
```
enter a port number within 3 seconds or default :11434<br/>
requires root privileges for stopping and killing llama<br />

takes liberty with ufw and blocks external llama interaction while maintaining localhost. edit to your specifications





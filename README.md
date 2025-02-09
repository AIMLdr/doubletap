# DoubleTap

DoubleTap is designed to locate, monitor, and manage large language model (LLM) processes on my Linux x64 system running from a bash shell. It will detect running LLM instance from port default 11434 and name to hunt and kill llama including ollama. Following kill option y/N Shepherd Daemon boot option y/N and uncomplicated fire wall settings with sanity audit to use llama as localhost while preventing outside access as default to keep your local llama for local access. Fencing in your llama for personal use. 

# doubletap - Local LLM Process Management and Network Tool
```txt
Purpose: Emergency termination of resource-hungry LLM processes and associated services
Use Case: When local LLMs consume excessive RAM or maintain unwanted network connections
Kill the llama before it eats all your grass
hint: Always monitor htop for resource usage and netstat for open ports
Maintain proper firewall rules for all AI/ML service ports
```
default <a href="http://127.0.0.1:11434/">Ollama port 11434</a> firewall restricted to <a href="http://localhost:11434/">localhost</a> from uncompicated fire wall 
```bash
sudo apt install ufw
```
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

# Check for any rules allowing external access
```bash
sudo ufw status verbose | grep 11434
```
# Check what address Ollama is bound to
```bash
sudo netstat -tulpn | grep 11434
```
d
# Verify socket binding
```bash
sudo lsof -i :11434
```

stops Ollama daemon service if running
provides custom network port for scanning
```sh
 git clone https://github.com/aimldr/doubletap.git
```
```sh
cd doubletap && chmod +x doubletap.sh && ./doubletap.sh
```
enter a port number within 3 seconds or default :11434<br/>
requires root privileges for stopping and killing llama<br />

y/N option for liberty with ufw and blocks external llama interaction while maintaining localhost as default<br />
performs audit<br />
edit to your specifications





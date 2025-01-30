# DoubleTap

DoubleTap is designed to locate, monitor, and manage large language model (LLM) processes on my Linux x64 system running from a bash shell. It will detect running LLM instance from port default 11434 and name to hunt and kill llama including ollama. Following termination Shepherd Daemon boot option y/N and ufw localhost:11434 allow

# doubletap - Local LLM Process Management and Security Tool
```txt
Purpose: Emergency termination of resource-hungry LLM processes and associated services
Use Case: When local LLMs consume excessive RAM or maintain unwanted network connections
Security Note: Always monitor htop for resource usage and netstat for open ports
Maintain proper firewall rules for all AI/ML service ports
default Ollama port 11434 firewall restricted to localhost from uncompicated firewall
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
cd doubletap && chmod +x doubletap.sh && sudo ./doubletap.sh
```
enter a port number within 3 seconds or default :11434
requires root privileges for stopping and killing llama





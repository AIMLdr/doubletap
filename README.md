# DoubleTap

DoubleTap is designed to locate, monitor, and manage large language model (LLM) processes on a system. It will detect running LLM instance from port default 11434 and name to hunt and kill llama. Following termination Shepherd Daemon boot option y/N

# Features
Scans for known LLM processes including:
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

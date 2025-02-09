```txt
chmod +x doubletap.sh
hacker@llamahost:~$ ./doubletap.sh
you have 3 seconds to enter a port to scan (Enter use default: 11434)...
enter port number: checking for process on port 11434...
=== Checking Ollama Service ===
no process found via lsof on port 11434.
netstat no network activity on port 11434.
=== Shephard checking system for Ollama process ===
Checking Ollama service status...
Ollama service is inactive
Disable Ollama at boot? (y/N) N
! warning: Ollama runs at boot
! use 'sudo systemctl disable ollama' to disable manually
=== Final System Check ===
✓ no Ollama process running
✓ Port 11434 is clear
=== UFW Ollama Security Configuration ===
Checking UFW status...
Configuring Ollama UFW rules...
Configure Ollama for localhost-only access? (y/N) y
Configuring localhost access rules...
Existing Ollama port rules found:
11434                      ALLOW       127.0.0.1                 
11434                      DENY        Anywhere                  
11434 (v6)                 DENY        Anywhere (v6)             
127.0.0.1 11434            ALLOW OUT   Anywhere                  
11434                      DENY OUT    Anywhere                  
11434 (v6)                 DENY OUT    Anywhere (v6)             
Remove existing rules before continuing? (y/N) N
Allowing localhost access to port 11434...
Skipping adding existing rule
Skipping adding existing rule
Blocking external access to port 11434...
Skipping adding existing rule
Skipping adding existing rule (v6)
Skipping adding existing rule
Skipping adding existing rule (v6)
✓ Localhost-only configuration complete
=== UFW Rules Verification ===
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
80/tcp                     ALLOW IN    Anywhere
80/tcp (v6)                ALLOW IN    Anywhere (v6)             
11434                      ALLOW IN    127.0.0.1                 
11434                      DENY IN     Anywhere                  
11434 (v6)                 DENY IN     Anywhere (v6)             

127.0.0.1 11434            ALLOW OUT   Anywhere                  
11434                      DENY OUT    Anywhere                  
11434 (v6)                 DENY OUT    Anywhere (v6)             

✓ UFW is active and configured
✓ Ollama is restricted to localhost only
=== UFW Configuration Complete ===
```

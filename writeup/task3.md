🔍 Why Investigate Unusual Port Traffic?
In cybersecurity, most legitimate network traffic occurs over well-known ports—HTTP (80), HTTPS (443), SSH (22), and RDP (3389). When a system starts communicating over uncommon ports, it often signals:

Stealthy backdoor access

Malware attempting to evade detection

Data exfiltration

Port scanning & reconnaissance activities

Attackers and defenders both pay close attention to traffic on unusual ports to uncover hidden threats.

👨‍💻 How Attackers Exploit Unusual Ports
1️⃣ Reverse Shells Over High-Numbered Ports
A skilled hacker rarely uses default ports for persistence. Instead, they configure reverse shells to communicate on random, high-numbered ports (49152–65535). This avoids detection from firewalls restricting default ports.

2️⃣ Covert Channels for Data Exfiltration
Sensitive data can be exfiltrated using non-standard ports. For example:

plaintext
- DNS tunneling (port `53` used improperly)
- Custom encrypted channels (`54321`)
- HTTP traffic disguised over an obscure port (`8088`)
Network admins typically ignore traffic over unknown ports, making this an ideal method for attackers to siphon data unnoticed.

3️⃣ Beaconing Malware & C2 Traffic
Advanced malware and Command-and-Control (C2) servers communicate on unusual ports to stay under the radar. Threat actors modify their botnet’s connection settings:

plaintext
Malware -> Victim Machine -> Port 4444 (Custom C2 Channel)
🔧 How Hackers & Defenders Detect Unusual Ports
Using tools like Splunk, attackers AND defenders analyze network traffic patterns to catch strange connections. A typical search might look like this:

splunk
index=* | stats count by src_ip, dest_ip, dest_port
| where NOT (dest_port=80 OR dest_port=443 OR dest_port=22 OR dest_port=3389)
| where NOT (cidrmatch("224.0.0.0/4", src_ip) OR cidrmatch("ff00::/8", src_ip) OR cidrmatch("224.0.0.0/4", dest_ip) OR cidrmatch("ff00::/8", dest_ip))
| table _time, src_ip, dest_ip, dest_port, count
✅ Excludes common ports ✅ Filters multicast IPs ✅ Detects traffic on suspicious ports


![image](https://github.com/user-attachments/assets/adcdfa7c-45d8-47c3-bf21-6fb3841593fa)

🔧 Step 1: Set Up the Netcat Server
On the listening machine, run:

bash
nc -lvp 12345
✅ -l → Listen mode ✅ -v → Verbose output ✅ -p → Specify port (12345 in this case)

🖥️ Step 2: Connect from the Netcat Client
On the attacking/test machine, connect to the server using:

bash
nc <server_ip> 12345
Replace <server_ip> with your actual server’s IP.

✅ Once connected, you can send test data between the systems.

📌 Why This Helps in Port & Connection Testing?
1️⃣ Simulates real network traffic, helping detect unusual port activity. 2️⃣ Allows testing unexpected open ports that might be used in attacks. 3️⃣ Helps verify Splunk logging and detection for unusual connections.

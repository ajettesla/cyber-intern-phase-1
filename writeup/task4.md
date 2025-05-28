
Understanding OS Detection via Nmap Scan
From the analysis of the image, the attacker utilized Nmap, a powerful network scanning tool, to perform OS detection. This type of scan systematically probes all open ports on the target machine to infer the operating system in use.

Wireshark Analysis of the Scan
Upon examining the Wireshark output, it is evident that the scan targeted critical ports, gathering insights into the system. This allows the attacker to identify vulnerabilities specific to the OS, which can then be exploited further.

Defense Mechanisms Against OS Detection
To mitigate the risks associated with OS fingerprinting:

Firewalls play a crucial role in filtering out unwanted scan attempts.

iptables with conntrack (cstate) can effectively control connection states and restrict unauthorized access.

Port filtering techniques can obscure open and closed ports, making it difficult for attackers to determine the system's configuration.

By applying these defensive measures, the visibility of ports to attackers can be reduced, thereby preventing precise OS identification and reinforcing system security.

![image](https://github.com/user-attachments/assets/e8f301ec-e509-42ec-8b6c-e1fed79d7756)



![image](https://github.com/user-attachments/assets/ccad7283-fb63-4f6d-b817-c1f8534ce60a)


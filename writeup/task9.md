Lateral Movement Detection with Sysmon and Windows Event Logs
Lateral movement refers to an attacker’s ability to move within an internal network after gaining initial access. Common techniques include SMB, WMI, RDP, and PsExec, which are often used for remote command execution or credential harvesting. To effectively detect lateral movement, we can monitor specific Sysmon Event IDs and Windows Event Logs.

Detection Approach
To trace lateral movement, we need to focus on two key event types:

1. Sysmon Event ID 3: Network Connections
Captures when a process initiates a network connection.

Useful for tracking remote executions like wmiexec.py, CrackMapExec, or PsExec.

Shows source and destination IPs, giving visibility into potential lateral movement.

2. Windows Security Log Event ID 4624: Successful Logons
Logs user authentication events, indicating when a session is established.

Tracks logon types:

Type 3 (Network Logon): Remote logon via SMB or PsExec.

Type 10 (Remote Interactive Logon): RDP logon.

Other types (e.g., Type 9): Unusual logins worth investigating.

Sysmon Rule Configuration for Lateral Movement Detection
To detect SMB, WMI, RDP, and PsExec activity effectively, we need to modify the Sysmon configuration file (sysmonconfig.xml) to ensure all relevant ports and processes are logged.

Updated Sysmon Configuration
xml
<Sysmon schemaversion="4.50">
  <HashAlgorithms>SHA256</HashAlgorithms>

  <EventFiltering>
   ``` <!-- Log all process creations (important for PsExec and WMI execution tracking) -->```
    <ProcessCreate onmatch="include">
      <Image condition="contains">powershell.exe</Image>
      <Image condition="contains">cmd.exe</Image>
      <Image condition="contains">wmic.exe</Image> <!-- WMI execution tracking -->
      <Image condition="contains">psexec.exe</Image> <!-- PsExec execution tracking -->
    </ProcessCreate>

   ``` <!-- Log all network connections -->
    <NetworkConnect onmatch="include">
      <DestinationPort condition="contains">445</DestinationPort> <!-- SMB traffic -->
      <DestinationPort condition="contains">135</DestinationPort> <!-- WMI execution -->
      <DestinationPort condition="contains">5985</DestinationPort> <!-- WinRM usage -->
      <DestinationPort condition="contains">3389</DestinationPort> <!-- RDP connections -->
      <DestinationPort condition="contains">22</DestinationPort> <!-- SSH remote execution -->
      <DestinationPort condition="contains">139</DestinationPort> <!-- NetBIOS session service -->
    </NetworkConnect>

    <!-- Log registry modifications (useful for persistence techniques) -->
    <RegistryEvent onmatch="include">
      <TargetObject condition="contains">*</TargetObject> <!-- Capture all registry changes -->
    </RegistryEvent>

    <!-- Log file creations (attackers may drop scripts for execution) -->
    <FileCreate onmatch="include">
      <TargetFilename condition="contains">*.ps1</TargetFilename>
      <TargetFilename condition="contains">*.bat</TargetFilename>
      <TargetFilename condition="contains">*.exe</TargetFilename>
    </FileCreate>
  </EventFiltering>
</Sysmon>

```

What This Configuration Captures
✔ Tracking SMB connections for file sharing and lateral movement (port 445). ✔ Detecting remote WMI execution (wmic.exe + port 135). ✔ Monitoring RDP logins (port 3389). ✔ Logging PsExec executions (psexec.exe). ✔ Capturing registry modifications, useful for detecting persistence mechanisms. ✔ Detecting script and executable file drops (*.ps1, *.bat, *.exe).

Windows Event Log Queries for Lateral Movement Detection
Alongside Sysmon logs, Windows logs can provide further details on authentication events:

Splunk Query for Sysmon Network Connections (Event ID 3)
spl
index=sysmon EventCode=3
| table _time, SourceHostname, DestinationHostname, DestinationIp, Image, CommandLine
Displays source and destination hosts for network activity.

Identifies whether PsExec, WMI, or SMB was used for lateral movement.

Splunk Query for Windows Logon Events (Event ID 4624)
spl
index=wineventlog EventCode=4624
| table _time, User, LogonType, SourceIp, ComputerName
Helps identify successful logins, including remote authentications.

Focuses on Logon Types 3 (network logon) and 10 (remote desktop logon).

Example Attack & Detection
Scenario: Lateral Movement Using wmiexec.py
Attacker runs:

bash
wmiexec.py 'User':'Password'@192.168.10.10
Windows logs capture Event ID 4624 with Logon Type 3 (indicating network authentication).

Sysmon logs Event ID 3, recording SMB or WMI traffic from the attacker's IP.

Analyst investigates SourceHostname → DestinationHostname → Image (wmic.exe execution).

Conclusion
By implementing the above Sysmon configuration rules and Windows log analysis, security teams can effectively detect lateral movement in an enterprise network. Attack techniques like SMB, PsExec, WMI, and RDP can be tracked using Event IDs 3 and 4624.

I will attach the screenshots below to provide practical examples of detected activity

![image](https://github.com/user-attachments/assets/f29a13fd-3646-4c6c-93a6-6ec41ca0fdf6)

![image](https://github.com/user-attachments/assets/65f06f77-4a31-4a39-a534-8078c061ad69)

![image](https://github.com/user-attachments/assets/a88988e5-d99c-4ef1-920f-ec09d01397e3)




Certainly! Here’s an updated version of the note with the part about verifying PowerShell logging using Event Viewer included:

---

# Enabling PowerShell Command Logging and Configuring Splunk for Detection

### 1. Enabling PowerShell Command Logging

PowerShell logging is essential for detecting suspicious or malicious scripts executed on Windows systems. It provides detailed insight into the commands run, helping to identify attacks such as downloading malware or executing obfuscated scripts.

**Key PowerShell logging features to enable:**

* **Module Logging (Event ID 4103):** Logs details about PowerShell modules loaded.
* **Script Block Logging (Event ID 4104):** Logs the full content of PowerShell script blocks, including dynamically generated or obfuscated code.
* **PowerShell Transcription (optional):** Records full input/output of PowerShell sessions to log files.

These logs are recorded in the **`Microsoft-Windows-PowerShell/Operational`** event log.

---

### How to Enable PowerShell Logging

**Using Group Policy:**

* Open `gpedit.msc`
* Navigate to:
  `Computer Configuration > Administrative Templates > Windows Components > Windows PowerShell`
* Enable:

  * **Turn on Module Logging** (set to log all modules, e.g., `*`)
  * **Turn on Script Block Logging**

**Using Registry (PowerShell commands):**

```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name EnableScriptBlockLogging -Value 1 -Force

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name EnableModuleLogging -Value 1 -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Name "*" -Value "*" -Force
```

Restart the system or PowerShell to apply changes.

---

### 2. Verify PowerShell Logging Is Enabled Using Event Viewer

To confirm that PowerShell logging is active, use **Event Viewer**:

1. Open **Event Viewer** (`eventvwr.msc`).
2. Navigate to:
   `Applications and Services Logs > Microsoft > Windows > PowerShell > Operational`
3. Ensure the **Operational** log is enabled (it should say “Enable Log” if disabled; if it says “Disable Log,” it is already enabled).
4. Check for recent events with Event ID **4104** (Script Block Logging) or **4103** (Module Logging). These events contain logged PowerShell commands.

This visual confirmation helps validate that detailed PowerShell command logging is working before relying on Splunk ingestion.

---

### 3. Configuring Splunk Inputs (`inputs.conf`)

To ingest these logs into Splunk, configure Splunk Universal Forwarder or Splunk Enterprise to collect this Windows event log:

```ini
[WinEventLog://Microsoft-Windows-PowerShell/Operational]
disabled = 0
index = powershell
renderXml = true
```

* `disabled = 0` enables collection.
* `index = powershell` stores logs in a dedicated index.
* `renderXml = true` ensures full event details are parsed correctly.

---

### 4. Importance of PowerShell Logging

Attackers commonly abuse PowerShell for stealthy operations. Without script block logging, many malicious commands go undetected. Enabling detailed PowerShell logging allows:

* Early detection of suspicious commands (e.g., `Invoke-WebRequest` downloading malicious payloads).
* Context on which user/process executed the command.
* Correlation with other system events for a full attack timeline.

When combined with Sysmon’s process and network monitoring, it provides a comprehensive defense against PowerShell-based attacks.

---

### 5. Detecting Malicious PowerShell Commands in Splunk

Once ingested, search for suspicious commands. Example to detect `Invoke-WebRequest`:

```spl
index=powershell source="WinEventLog:Microsoft-Windows-PowerShell/Operational" EventCode=4104
| search Message="*Invoke-WebRequest*"
| table _time, host, User, Message
| sort -_time
```


### 6. Attached Image

I have attached an image showing an example Splunk search result detecting the use of `Invoke-WebRequest` in PowerShell logs. This illustrates how PowerShell command activity can be identified and investigated.


![Screenshot (23)](https://github.com/user-attachments/assets/200223bd-ccc0-4472-97b6-defd4eeaaa94)


![image](https://github.com/user-attachments/assets/a60a77f8-390b-4b2f-b6c0-fc11cfb5fce1)




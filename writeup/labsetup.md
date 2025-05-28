Here's a well-structured `README.md` section that documents your lab setup, installation steps, configurations, and essential Splunk commands. You can copy-paste and edit according to your specific IPs, file paths, or preferences:

---

# 🧪 Splunk Lab Setup

This document outlines the steps I followed to set up a Splunk lab environment using VirtualBox, including a Windows host, Windows VM, and Ubuntu VM, with all systems forwarding logs to a Splunk Enterprise server.

## 🔧 Lab Topology

* **Host Machine**: Windows with **Splunk Enterprise** installed.
* **Virtual Machines**:

  * **Windows 10 Pro** VM with **Sysmon** and **Splunk Universal Forwarder**
  * **Ubuntu Linux** VM with **Auditd** and **Splunk Universal Forwarder**
* **Network Mode**: All machines are connected using **Host-Only Adapter** in VirtualBox.

---

## 🧱 Splunk Server Setup (Host Machine)

1. Download and install **Splunk Enterprise** from [Splunk Downloads](https://www.splunk.com/en_us/download.html).
2. Start the Splunk service and log in via `http://localhost:8000`.
3. Create a new index (e.g., `lab_index`) for log segregation.

---

## 🪟 Windows VM Setup

### 1. Install Splunk Universal Forwarder

Download from [Splunk Universal Forwarder](https://www.splunk.com/en_us/download/universal-forwarder.html).

```powershell
# Example install command (PowerShell)
Start-Process -Wait -FilePath "splunkforwarder-<version>-x64-release.msi"
```

### 2. Install and Configure Sysmon

1. Download Sysinternals Sysmon: [https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)

```cmd
sysmon.exe -accepteula -i sysmonconfig.xml
```

> `sysmonconfig.xml` can be a custom configuration file or use [SwiftOnSecurity's Sysmon config](https://github.com/SwiftOnSecurity/sysmon-config)

### 3. Configure Splunk Forwarder

Edit `inputs.conf` and `outputs.conf` in:
`C:\Program Files\SplunkUniversalForwarder\etc\system\local\`

#### `inputs.conf`

```conf
[default]
host = windows-vm

[WinEventLog:Security]
disabled = 0

[WinEventLog:System]
disabled = 0

[WinEventLog:Application]
disabled = 0

[monitor://C:\Windows\System32\winevt\Logs]
disabled = false
index = lab_index
```

#### `outputs.conf`

```conf
[tcpout]
defaultGroup = default-autolb-group

[tcpout:default-autolb-group]
server = <SPLUNK_SERVER_IP>:9997

[tcpout-server://<SPLUNK_SERVER_IP>:9997]
```

---

## 🐧 Ubuntu VM Setup

### 1. Install Splunk Universal Forwarder

```bash
wget -O splunkforwarder.tgz 'https://download.splunk.com/products/universalforwarder/releases/X.X.X/linux/splunkforwarder-X.X.X-Linux-x86_64.tgz'
tar -xvzf splunkforwarder.tgz
cd splunkforwarder
./bin/splunk start --accept-license
```

### 2. Enable Audit Logs (Auditd)

```bash
sudo apt install auditd audispd-plugins
sudo systemctl enable auditd
sudo systemctl start auditd
```

### 3. Configure `inputs.conf` and `outputs.conf`

Edit the files under:
`/opt/splunkforwarder/etc/system/local/`

#### `inputs.conf`

```conf
[default]
host = ubuntu-vm

[monitor:///var/log]
disabled = false
index = lab_index
```

To forward Audit logs specifically:

```conf
[monitor:///var/log/audit/audit.log]
disabled = false
index = lab_index
sourcetype = linux_audit
```

#### `outputs.conf`

```conf
[tcpout]
defaultGroup = default-autolb-group

[tcpout:default-autolb-group]
server = <SPLUNK_SERVER_IP>:9997

[tcpout-server://<SPLUNK_SERVER_IP>:9997]
```

---

## 🛠 Useful Splunk Forwarder Commands

```bash
# Check monitored files
./splunk list monitor

# Add new monitor
./splunk add monitor /var/log/syslog

# Restart the forwarder
./splunk restart
```

---

## 🧼 Clean Events (on Splunk Server)

```bash
# Remove all events from index (use cautiously)
$SPLUNK_HOME/bin/splunk clean eventdata -index lab_index

# Restart Splunk
$SPLUNK_HOME/bin/splunk restart
```

---

🛠 Install and Start Sysmon on Windows

    Download Sysmon from:
    https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

    Download Sysmon config (recommended):
    https://github.com/SwiftOnSecurity/sysmon-config

    Install command (in Command Prompt as Administrator):

## ✅ Verification

* Login to Splunk Enterprise.
* Go to **Search & Reporting** app.
* Run:

```spl
index=lab_index | stats count by host, sourcetype
```

* You should see logs from both Windows and Ubuntu VMs.

---


Let me know if you want this in `.md` file format directly or want to include screenshots, diagrams, or architecture illustrations.

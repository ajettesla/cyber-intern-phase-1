🔍 How VirusTotal Scans Files
1️⃣ File Upload & Hash Check

When you upload a file (like eicar.txt), VirusTotal first checks its hash (SHA-256, MD5, etc.).

If the file has been scanned before, VirusTotal retrieves the previous results instead of rescanning.

2️⃣ Multi-Engine Analysis

VirusTotal runs the file through 97+ antivirus engines (such as Microsoft Defender, Kaspersky, McAfee, etc.).

Each engine applies its own signature-based detection, heuristic analysis, and behavioral analysis.

3️⃣ Behavioral & Static Analysis

Static Analysis: Examines the file’s structure, metadata, and embedded code.

Behavioral Analysis: Runs the file in a sandbox environment to observe its actions (e.g., modifying registry keys, network activity).

4️⃣ Threat Intelligence & Community Feedback

VirusTotal integrates threat intelligence from cybersecurity researchers.

Users can comment on scan results, providing additional insights.

🔎 Understanding Your Score (8/97)
8/97 means 8 antivirus engines flagged the file as malicious, while 89 engines did not.

Since eicar.txt is a test file, some engines detect it as a false positive.

You can check which engines flagged it and their reasoning.

![Screenshot (10)](https://github.com/user-attachments/assets/92ee024e-3339-4322-9d9b-2d740a35ec13)


🔍 Registry-Related Event Codes in Windows
1️⃣ Event ID 4656 – A Handle to an Object Was Requested
This logs when a process requests access to a registry key.

It records who (user), what process, and which registry key was accessed.

Commonly used for tracking unauthorized registry access.

2️⃣ Event ID 4657 – A Registry Value Was Modified
This occurs when a registry value is changed.

It records before-and-after values, showing exactly what changed.

Useful for detecting malicious persistence mechanisms (e.g., malware adding itself to startup).

3️⃣ Event ID 4663 – An Attempt Was Made to Access an Object
This logs actual registry accesses (read, write, delete).

It confirms whether access was granted or denied.

Often useful for monitoring registry permissions.

4️⃣ Event ID 4660 – An Object Was Deleted
Triggers when a registry key or value is deleted.

Critical for detecting unwanted configuration removals.

![image](https://github.com/user-attachments/assets/f6209369-c76c-41da-abaa-a576e5d03e58)

Windows Registry Auditing Guide
🔍 Overview
This guide explains how to enable auditing for Windows registry changes using different methods. Registry auditing helps detect unauthorized modifications and security threats.

📌 Methods to Enable Registry Auditing
1️⃣ Enable Auditing via Command Line (auditpol)
If you don’t have access to secpol.msc, use PowerShell or Command Prompt:

powershell
auditpol /set /subcategory:"Registry" /success:enable /failure:enable
✅ Verify if auditing is enabled:

powershell
auditpol /get /subcategory:"Registry"
🔹 If Success and Failure appear, auditing is enabled.

2️⃣ Enable Auditing via Local Security Policy (secpol.msc)
If you have access to Local Security Policy, follow these steps:

Open Run (Win + R), type secpol.msc, and press Enter.

Navigate to:

Security Settings > Local Policies > Audit Policy
Find "Audit Object Access", double-click it.

Enable Success & Failure.

Click OK and restart your computer.

3️⃣ Enable Auditing via Group Policy (gpedit.msc)
If your system supports Group Policy Editor, use this method:

Open Run (Win + R), type gpedit.msc, and press Enter.

Navigate to:

Computer Configuration > Windows Settings > Security Settings > Advanced Audit Policy Configuration > Object Access
Click Audit Registry and enable Success & Failure.

Click Apply & OK, then restart your system.

4️⃣ Enable Auditing via Registry (regedit)
If you cannot access secpol.msc, modify the registry directly:

Open Registry Editor (regedit).

Navigate to:

`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa`
Right-click on AuditBaseObjects, select Modify, and set the value to 1.

Restart your system.

🔎 How to Verify Registry Events
Once auditing is enabled:

Open Event Viewer `(eventvwr.msc)`.

`Navigate to Windows Logs > Security`.

Look for Event ID 4657 (Registry Modification).

If needed, filter for other registry-related events:

`EventCode=4656 (Registry access request)`

`EventCode=4663 (Registry key accessed)`

`EventCode=4657 (Registry value modified)`








# **DETECTING NEW ADMIN USER CREATION AND PRIVILEGE ESCALATION IN WINDOWS**

---

## **OVERVIEW**

**Privilege escalation** is a common tactic used by attackers to gain higher-level permissions on a compromised system. Detecting attempts to escalate privileges is critical for early threat detection and preventing further damage.

One key indicator of privilege escalation is the **creation of new administrative users** or modification of existing user privileges.

---

## **WHY IS PRIVILEGE ESCALATION IMPORTANT?**

- **Attackers leverage privilege escalation** to gain access to sensitive data, execute malware with high privileges, and maintain persistence.
- Without detection, attackers can operate stealthily with elevated rights, bypassing security controls.
- Early identification of privilege escalation attempts helps security teams respond before attackers can cause significant harm.

---

## **WHAT TO MONITOR**

### **New Admin User Creation**

- Creation of new user accounts with administrative rights.
- Adding existing users to privileged groups such as **Administrators**.
- Changes in group memberships that elevate privileges.

### **Modifications Indicative of Privilege Escalation**

- Changes to **registry keys** controlling user rights and service permissions.
- Creation or modification of **Windows services** running with elevated permissions.
- **Token impersonation** or manipulation events.

---

## **KEY WINDOWS EVENT CODES TO DETECT PRIVILEGE ESCALATION**

| Event Code | Description                                   | Details |
|------------|-----------------------------------------------|---------|
| **4720**   | A user account was created                     | Indicates a new user creation. Look for new accounts being added to privileged groups. |
| **4732**   | A member was added to a security-enabled local group | Detects when a user is added to groups like Administrators. |
| **4733**   | A member was removed from a security-enabled local group | Useful to monitor privilege changes. |
| **4697**   | A service was installed                        | Services can be configured to run with elevated privileges. |
| **4657**   | A registry value was modified                  | Track changes to registry keys related to security and privileges. |
| **4672**   | Special privileges assigned to new logon      | Indicates a user has logged on with administrative privileges. |
| **4673**   | A privileged service was called                | Indicates privileged operations were performed. |

---

## **DETECTING NEW ADMIN USER CREATION IN SPLUNK**

To detect new admin user creation or privilege escalation, you can use Splunk queries like:

### **Detect New User Creation**

```spl
index=security EventCode=4720
| table _time, ComputerName, Subject_User_Name, Target_User_Name
| sort -_time




![image](https://github.com/user-attachments/assets/a1219919-473a-4396-84b9-28e0c0f55fb8)



![image](https://github.com/user-attachments/assets/1a1d7133-d8a2-48b6-935c-b39381f810f5)


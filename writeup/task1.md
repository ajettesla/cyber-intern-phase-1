
Here's a refined version incorporating your update:

---

**1. Introduction**  
Brute-force attacks involve systematically guessing large numbers of credential combinations until an attacker gains access. In the context of RDP (Remote Desktop Protocol), these attacks generate a high volume of failed login attempts over a short period, typically followed by successful logins. Detecting this pattern in real time is essential for preventing unauthorized access.

---

**2. Query Update**  
I've refined the brute-force attack detection query to use a `(src_ip, dest_ip OR host)` tuple-based approach. This new query filters brute-force attempts based on time intervals and these tuple combinations, ensuring more accurate detection.  
This enhancement is crucial because multiple addresses can be assigned to the same computer. In such cases, attackers often use proxy setups to mask their brute-force attempts. The updated query helps generalize detection across multiple scenarios, making it more effective.

---

**3. Core Logic of the Detection Query**  
The SPL query applies a time-based brute-force detection method with tuple analysis:  

- **Time-based filtering**: Groups RDP login events into 10-minute intervals to tally failed (EventCode 4625) and successful (EventCode 4624) logins.  
- **Tuple tracking**: Aggregates data based on `(src_ip, dest_ip OR host)`, improving detection accuracy when attackers use multiple IP addresses.  
- **Lookahead mechanism**: Checks the next bucket for successful logins to confirm a brute-force pattern.  
- **Attack flagging**: Marks an event as a brute-force attack when failed attempts exceed **six**, followed by one or more successful logins (either in the current or next bucket).  

This refined detection method helps security teams monitor and respond to brute-force attempts with greater precision.

---

**4. Updated Query**  
```spl
index=* host=* ((EventCode=4624 AND EventType=0) OR (EventCode=4625 AND EventType=0))
| bin _time span=10m 
| stats count(eval(EventCode=4625)) as failed_attempts, count(eval(EventCode=4624)) as success_attempts by _time, host, src_ip
| sort _time
| streamstats window=2 current=f last(success_attempts) as next_success_attempts by host, src_ip
| eval brute_force=if(failed_attempts>6 AND (success_attempts>0 OR next_success_attempts>0), "Possible Brute Force Attack", "Normal Activity")
| table _time, host, src_ip, failed_attempts, success_attempts, next_success_attempts, brute_force
```

---

**5. Conclusion**  
By incorporating a tuple-based approach and time-based filtering, this updated SPL query enhances brute-force attack detection. It effectively identifies attacks involving proxy setups and multiple IP addresses, making it a critical addition to security monitoring strategies.

Does this version meet your requirements? Let me know if you'd like further refinements!




![image](https://github.com/user-attachments/assets/46e7a3e3-9027-4030-b6ef-7ca1e192b85c)



![image](https://github.com/user-attachments/assets/8b651a2f-20fd-45e8-8682-228020a59ad3)



![image](https://github.com/user-attachments/assets/e014d61b-2c10-491d-bcf6-45d35de8b132)


The image below shows a brute-force attack using a source IP address's. Since this is generated test data and not based on real-world activity, there were no successful login attempts within the following 10 minutes.

You can find the `logGen` repository in my [GitHub repository](https://github.com/ajettesla/logGen).

![image](https://github.com/user-attachments/assets/c1238ef2-67fd-48ce-81c8-540548801e80)




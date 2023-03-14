---
title: "SPNEGO in Brave"
date: 2023-03-13T21:20:37-07:00
draft: false
author: "Caleb Callaway"
tags: ["tech", "linux", "security", "kerberos"]
---

## 1. Create config directory

```bash
sudo mkdir -p /etc/brave/policies/managed/
```

## 2. Create policy file

Create `/etc/brave/policies/managed/spnego.json` with the following contents, editing domain names as needed:

```bash
{
  "AuthServerAllowlist" : "*.brainvitamins.net",
  "AuthNegotiateDelegateAllowlist" : "*.brainvitamins.net",
  "EnableAuthNegotiatePort" : true
}

```

## 3. Restart

Restart the browser. Verify the policy is active by visiting [brave://policy](brave://policy)

## References

* https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy
* https://docs.spring.io/spring-security-kerberos/docs/current/reference/html/browserspnegoconfig.html

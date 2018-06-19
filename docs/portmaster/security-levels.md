---
title: Security Levels
section: portmaster
order: 2
layout: base
source-docs:
---

Security Levels were created to give the user an easy and quick way to adapt to different environments and better handle the under/overblocking problem.

They are the main way to interact with the Portmaster and react to user-perceived threats.

### Dynamic

This is the standard operating mode - the user is in a trusted environment and no threats have been detected. Privacy protections are activated, but may slightly tend to underblocking.

### Secure

This mode is the standard mode for untrusted environments. It is automatically activated when entering an unknown network, like a café's Wi-Fi, or if an attack is detected. This mode is meant for situations where more privacy is needed and may slightly tend to overblocking.

### Fortress  

This is the emergency mode and should be used in highly untrusted environments, and if an attack is imminent or in progress ("You clicked on that link, didn't you..."). This mode will activate all available mechanisms to keep you safe and will undoubtedly overblock and break applications. It is meant as a small bandage until an expert can verify that everything is ok (And that the link really just showed you cat pictures).

## Configuration

How these modes behave and what features are activated can be configured to some extent in the Portmaster settings. Please note, that certain features cannot be turned off in the Fortress mode in order to prevent misconfiguration and provide the same _Fortress_ experience across installations - ie. you know what the Fortress mode does, even if it's not your computer you are using.

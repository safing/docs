---
title: Advanced Inspection
section: portmaster
order: 4
layout: base
source-docs:
  - firewall/inspection
---

In order to better secure you from attacks and ensure that connections are genuine, the Portmaster supports packet inspection. The Portmaster will never break any encryption or weaken it - on the contrary - this system is designed to ensure and enforce good, valid and secure connections.

This framework allows to easily plug in new modules that check for various kinds of network attacks or verify connections.
Here we are the modules that come with the Portmaster:

## TLS Verification {% include code_ref.html godoc-portmaster="firewall/inspection/tls" github-portmaster="firewall/inspection/tls" %}

<div class="alert alert-info" role="alert">
  Status: not currently part of Portmaster, PoC exists, integration planned.
</div>

This module fully verifies TLS connections to ensure that all programs use the best available versions, ciphers and options. Will block outdated and vulnerable TLS connections.

## Planned

These modules are planned and will be implemented at some point in time.

- ARP Attack Detection: detect and mititage ARP-based MITM attacks.
- Portscan Detection: detect portscans and block the attacking host.

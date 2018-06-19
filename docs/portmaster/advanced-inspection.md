---
title: Advanced Inspection
section: portmaster
order: 4
layout: base
source-docs:
  - firewall/inspection
---

In order to better secure you from attacks and ensure that connections are genuine, the Portmaster supports packet inspection.

This framework allows to easily plug in new modules that check for various kinds of network attacks or verify connections.

## TLS Verification {% include source-docs.html a="firewall/inspection/tls" %}

This module fully verifies TLS connections to ensure that all programs use the best available versions, ciphers and options. Will block outdated and vulnerable TLS connections.

## Planned

These modules are planned and will be implement at some point in time.

- ARP Attack Detection: detect and mititage ARP-based MITM attacks.
- Portscan Detection: detect portscans to block attacking host.
- Network mapper: provide a network map to users.

---
title: OS Integration
section: port17
order: 10
layout: base
---

## Windows

_coming soon_

## macOS

_coming soon_

## Linux

On Linux we aim to provide two ways of OS integration:

##### iptables

If DNS is resolved for a connection, Portmaster replies with `127.0.0.17` if the connection should be routed through the Port17 network.
If connecting to an IP address directly, the Portmaster marks the connection with `1717` and the iptables rules below will redirect the connection.

Three additonal rules are added to the iptables main chains:
```
nat OUTPUT -m mark --mark 1717 -p {tcp|udp} -j DNAT --to-destination 127.0.0.17:17
nat OUTPUT -m mark --mark 1717 -j DNAT --to-destination 127.0.0.17
```

##### kernel module

We will provide an alternative to `iptables` by writing a kernel module to handle the needed packet interception in the future. Depending on the performance and stability of the `iptables` integration this might come sooner or later.

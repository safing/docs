---
title: OS Integration
section: portmaster
order: 10
layout: base
updated: 19.02.2019
code_ref:
  github-portmaster-1: firewall/interception
  github-portmaster-2: process
---

## General

##### TCP/UDP Ports

The Portmaster (with Gate17) uses the following ports:
- ` 17` Gate17 port for connecting to Gate17 nodes
- ` 53` DNS server (local only)
- `717` Gate17 entrypoint as the local endpoint for tunneled connections (local only)
- `817` Portmaster API for integration with UI elements and other helpers (local only)

Gate17 additionally uses other common ports like `80` and `443` to provide access in restricted network environments.

All these ports are in the System Ports range (0-1023) for additional security. These ports require administrator privileges to be used. This adds another layer of protection against processes that try to trick the User Interface components into thinking that everything is OK, while it is not.

Some of you will note that these port numbers are not registered by us. That is true:
- Port `17` is assigned to the (historic) `Quote of the Day` protocol. This was primarily used for debugging network problems, and Gate17 is backward compatible!
- Ports `717` and `817` are currently unassigned by the IANA.
See the full list [here](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml).

The [IANA](https://www.iana.org/) [states](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml) that "both System and User ports `SHOULD NOT` be used without or prior to IANA registration.". `SHOULD NOT` is defined as "NOT RECOMMENDED", but acknowledges that there may exist valid reasons in particular circumstances when the particular behavior is acceptable or even useful, but should be carefully weighed. While we are planning to start the registration process soon, we believe that we are RFC compliant nevertheless, because the ports `717` and `718`:
- will only be used locally,
- will not be exposed to the Internet and
- are important for security reasons.

## Windows

##### Kernel Extension

We are currently developing a kernel extension for integration with the Windows kernel. _(update coming soon)_

## macOS

_coming soon_

## Linux

On Linux we aim to provide two ways of OS integration:

##### iptables with nfqueue {% include code_ref.html github-portmaster="firewall/interception/nfqueue" %}

Portmaster uses iptables and nfqueue to inspect and control network traffic. The nfqueue allows packets to be handed over to user space and return a verdict and set a mark on that connection.

Portmaster accepts all packets, but marks the whole connection to be accepted/dropped afterwards. This relieves Portmaster of heavy network traffic because once the fate of connection is decided, it is handed back to the kernel, never to be handed to userspace again, which is quite costly.

Here are the rules that Portmaster injects for both IPv4 and IPv6:

Chains:
```
mangle: C170
mangle: C171
filter: C17
```

Rules in own chains:
```
mangle C170 -j CONNMARK --restore-mark
mangle C170 -m mark --mark 0 -j NFQUEUE --queue-num {17040|17060} --queue-bypass

mangle C171 -j CONNMARK --restore-mark
mangle C171 -m mark --mark 0 -j NFQUEUE --queue-num {17140|17160} --queue-bypass

filter C17 -m mark --mark 0 -j DROP
filter C17 -m mark --mark 1700 -j ACCEPT
filter C17 -m mark --mark 1701 -j REJECT --reject-with {icmp-host-prohibited|icmp6-adm-prohibited}
filter C17 -m mark --mark 1702 -j DROP
filter C17 -j CONNMARK --save-mark
filter C17 -m mark --mark 1710 -j ACCEPT
filter C17 -m mark --mark 1711 -j REJECT --reject-with {icmp-host-prohibited|icmp6-adm-prohibited}
filter C17 -m mark --mark 1712 -j DROP
filter C17 -m mark --mark 1717 -j ACCEPT
```

Rules in main chains:
```
mangle OUTPUT -j C170
mangle INPUT -j C171
filter OUTPUT -j C17
filter INPUT -j C17
nat OUTPUT -p udp --dport 53 -m mark --mark 1799 -j DNAT --to {127.0.0.1:53|[::1]:53}
nat OUTPUT -m mark --mark 1717 -p {tcp|udp} -j DNAT --to-destination 127.0.0.17:1117 # for Gate17
nat OUTPUT -m mark --mark 1717 -j DNAT --to-destination 127.0.0.17 # for Gate17
```

Explanation of Nfqueue Numbers:

`17040` breaks up into:
- `17` is an identifier, so that you can easily spot what belongs to Portmaster/Gate17
- `0` for output, `1` for input
- `4` for IPv4, `6` for IPv6
- `0` id for multi-threaded nfqueue (currently only one thread is used)

Explanation of Connmark Numbers:

```
1700 Accept
1701 Block
1702 Drop
1710 Permanent Accept
1711 Permanent Block
1712 Permanent Drop
1717 Reroute to Gate17
1799 Reroute to nameserver (for astray DNS queries)
```

##### kernel module

We will provide an alternative to the `iptables` integration by writing a kernel module to handle the needed packet interception in the future. Depending on the performance and stability of the `iptables` integration this might come sooner or later.

##### proc/net {% include code_ref.html godoc-portmaster="process/proc" %}

In order to find out which process a packet belongs to, the proc filesystem is first parsed to find the socket id of the intercepted packet, then the process directory is searched for the matching PID.

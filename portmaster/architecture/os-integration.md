---
title: OS Integration
layout: base
code_ref:
  github-portmaster-1: firewall/interception
  github-portmaster-2: process
updated: 19.02.2019
---

## General

This page covers all the OS integration, including the SPN.

## Windows

##### Kernel Extension

The Windows kernel-mode driver provides the Portmaster with a high performance OS integration.
It provides an internal caching for best performance and lets the Portmaster do all the decision making.

The basic architecture is as follows:

```
                          +----------------+
                          |                |
                  +------>|   Portmaster   |------>+
                  |       |                |       |
                  |       +----------------+       |
                  |                                |
                  | (2a) verdict request           | (3) set verdict
[user mode]       |                                |
..................|................................|........................
[kernel mode]     |                                |
                  |                                |
             +-------------------------------------|---+
             |                                     +-> | (2b/4) handle packet
 (1) packet  |   Driver                    if in cache | according to verdict
------------>|   (2) check verdict cache   +---------> |-------------------->
             |                                         |
             +-----------------------------------------+
```

This architecture allows for high performance, as most packages are handled directly in kernel space.
Only new connections need to be pushed into userland so that the Portmaster can set a verdict for them.

The Driver is installed into the Windows network stack - between OSI layer 2 and 3 - and sees the IP layer and everything above.

This is how packets are handled:

1.  Windows Kernel processes a packet in the TCP/IP stack (netbuffer).
2.  Windows Kernel presents the packet to Portmaster Kernel Extension via a callout.
3.  The Portmaster Kernel Extension check its cache for a verdict for the given packet, using network (IP) and transport (TCP/UDP/...) layer data.
4.  If not found, the Portmaster Kernel Extension presents the packet to the Portmaster via the blocking API call `PortmasterRecvVerdictRequest`.
5.  The Portmaster inspects the packet information (`packetInfo`) and sets verdict via `PortmasterSetVerdict`.
6.  If necessary, the Portmaster may also inspect the payload of packet via `PortmasterGetPayload`, using the packet ID previously received by `PortmasterRecvVerdictRequest`.
7.  The Portmaster Kernel Extension holds intercepted packet in a packet cache until the verdict is set.
8.  If the packet cache is full, the oldest packet will be dropped, so that the newest packet can be stored.

##### The Windows DNS Client

Windows uses a system service called `DNS Client`, sometimes referred to as `dnscache` to resolve queries for applications.
Queries that are made through this service cannot be linked to the original application that started the request. This is why the Portmaster tries to stop the service when starting.

This service cannot be easily disabled directly, but must be disabled using the registry.
The installer disables the service during install and the uninstaller enables it again during uninstall.
This is also one of the reasons a restart is strongly recommended after both installing and uninstalling.

Please note that disabling this service is safe, as its primary function is a DNS cache. It does, however, handle some other DNS related functionality as well. Especially software that uses this service, for example via a call to `netsh`, may experience errors due to the unavailability of said service.

## Linux

On Linux we aim to provide two ways of OS integration:

##### iptables with nfqueue {% include code_ref.html github-portmaster="firewall/interception/nfqueue" %}

Portmaster uses iptables and nfqueue to inspect and control network traffic. The nfqueue allows packets to be handed over to user space and return a verdict and set a mark on that connection.

Portmaster accepts all packets, but marks the whole connection to be accepted/dropped afterwards. This relieves Portmaster of heavy network traffic because once the fate of connection is decided, it is handed back to the kernel, never to be handed to userspace again, which is quite costly.

Here are the rules that Portmaster injects for both IPv4 and IPv6:

__Chains__
```
mangle: C170
mangle: C171
filter: C17
```

__Rules in own chains__
```
mangle C170 -j CONNMARK --restore-mark
mangle C170 -m mark --mark 0 -j NFQUEUE --queue-num {17040|17060} --queue-bypass

mangle C171 -j CONNMARK --restore-mark
mangle C171 -m mark --mark 0 -j NFQUEUE --queue-num {17140|17160} --queue-bypass

filter C17 -m mark --mark 0 -j DROP
filter C17 -m mark --mark 1700 -j ACCEPT
filter C17 -m mark --mark 1701 -p icmp -j RETURN
filter C17 -m mark --mark 1701 -j REJECT --reject-with {icmp-host-prohibited|icmp6-adm-prohibited}
filter C17 -m mark --mark 1702 -j DROP
filter C17 -j CONNMARK --save-mark
filter C17 -m mark --mark 1710 -j ACCEPT
filter C17 -m mark --mark 1711 -p icmp -j RETURN
filter C17 -m mark --mark 1711 -j REJECT --reject-with {icmp-host-prohibited|icmp6-adm-prohibited}
filter C17 -m mark --mark 1712 -j DROP
filter C17 -m mark --mark 1717 -j ACCEPT
```

__Rules in main chains__
```
mangle OUTPUT -j C170
mangle INPUT -j C171
filter OUTPUT -j C17
filter INPUT -j C17
nat OUTPUT -p udp --dport 53 -m mark --mark 1799 -j DNAT --to {127.0.0.17:53|[::1]:53}
nat OUTPUT -m mark --mark 1717 -p {tcp|udp} -j DNAT --to-destination 127.0.0.17:1117 # for Gate17
```

__Explanation of Nfqueue Numbers__  
`17040` breaks up into:
- `17` is an identifier, so that you can easily spot what belongs to Portmaster/Gate17
- `0` for output, `1` for input
- `4` for IPv4, `6` for IPv6
- `0` id for multi-threaded nfqueue (currently only one thread is used)

__Explanation of Connmark Numbers__  
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

##### Kernel Module

We plan to provide an alternative to the `iptables` integration by writing a kernel module to handle the needed packet interception in the future.
Depending on the performance and stability of the `iptables` integration, this will be tackled sooner or later.

##### proc/net {% include code_ref.html godoc-portmaster="process/proc" %}

In order to find out which process a packet belongs to, the `proc` filesystem is first parsed to find the socket ID of the intercepted packet, then the process directory is search for the matching PID.
This is a bit cumbersome, but unfortunately, no better way of acquiring this information is available.

## Used TCP/UDP Ports

The Portmaster uses the following ports:
- ` 17` SPN connection port
- ` 53` Local nameserver (localhost only)
- `717` SPN entrypoint for tunneling connections (localhost only)
- `817` Portmaster API for integration with UI elements and other helpers (localhost only)

SPN nodes additionally use other common ports like `80` and `443` to provide access for restricted network environments.

All these ports are in the System Ports range (0-1023) for additional security. These ports require administrator privileges to be used. This adds another layer of protection against processes that try to trick the User Interface components into thinking that everything is OK, while it is not.

Some of you will note that these port numbers are not registered by us. That is true:
- Port `17` is assigned to the (historic) `Quote of the Day` protocol. This was primarily used for debugging network problems and is not actively in use anymore. But in any case: SPN is backwards compatible!
- Ports `717` and `817` are currently unassigned by the IANA.
See the full list [here](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml).

The [IANA](https://www.iana.org/) [states](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml) that "both System and User ports `SHOULD NOT` be used without or prior to IANA registration.". `SHOULD NOT` is defined as "NOT RECOMMENDED", but acknowledges that there may exist valid reasons in particular circumstances when the particular behavior is acceptable or even useful, but should be carefully weighed. While we are planning to start a registration process in the future, we believe that we are RFC compliant nevertheless, because the ports `717` and `718` (1) will only be used locally, (2) will not be exposed to the Internet and (2) are important for security reasons.

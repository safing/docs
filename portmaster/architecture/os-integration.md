---
title: OS Integration
layout: base
code_ref:
  github-portmaster-1: firewall/interception
  github-portmaster-2: process
---

This page covers all the OS integration, including the SPN.

## Windows

### Kernel Extension

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

### The Windows DNS Client

Windows uses a system service called `DNS Client`, sometimes referred to as `dnscache`, to resolve queries for applications.
Queries that are made through this service cannot be directly linked to the original application that started the request.

As a result, the Portmaster can not identify the actual applications behind a query and thus will not directly make a decision on queries coming from the Windows DNS Client (except for {% include setting/ref.html key="filter/preventBypassing" %}), but will remember the resulting IPs and use them to match domains to connections when the actual connection is initialized.

This approach can sometimes lead the Portmaster to a wrong attribution of a domain to a connection.

For example, if two processes use two different domains but both of them point to the same IP address, it could happen that the Portmaster thinks that the first process is connecting to the domain of the second process and vice-versa. Especially if requests are done in parallel or connections are re-established without querying for the domain again.

As a remediation to this, we will start looking at HTTP headers and TLS handshakes in the future. With information gathered directly from the connection, the attribution will be more accurate.

In versions up to v0.6.6, the Portmaster disabled the Windows DNS Client in order to directly see all DNS requests.
As this lead to many unexpected problems, this was reverted with a workaround in v0.6.7. You can [read the in-depth development log](https://safing.io/blog/2021/03/23/attributing-dns-requests-on-windows/) to find out all about this change and the reasoning behind it.

## Linux

On Linux we aim to provide two ways of OS integration:

### iptables with nfqueue

{% include code_ref.html github-portmaster="firewall/interception/nfqueue" %}

Portmaster uses iptables and nfqueue to inspect and control network traffic. The nfqueue allows packets to be handed over to user space and return a verdict and set a mark on that connection.

Portmaster accepts all packets, but marks the whole connection to be accepted/dropped afterwards. This relieves Portmaster of heavy network traffic because once the fate of connection is decided, it is handed back to the kernel, never to be handed to userspace again, which is quite costly.

Here are the rules that Portmaster injects for both IPv4 and IPv6:

###### Chains
```
mangle: C170
mangle: C171
filter: C17
```

###### Rules in own chains
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

###### Rules in main chains
```
mangle OUTPUT -j C170
mangle INPUT -j C171
filter OUTPUT -j C17
filter INPUT -j C17
nat OUTPUT -p udp --dport 53 -m mark --mark 1799 -j DNAT --to {127.0.0.17:53|[::1]:53}
nat OUTPUT -m mark --mark 1717 -p {tcp|udp} -j DNAT --to-destination 127.0.0.17:1117 # for Gate17
```

###### Explanation of Nfqueue Numbers  
`17040` breaks up into:
- `17` is an identifier, so that you can easily spot what belongs to Portmaster/Gate17
- `0` for output, `1` for input
- `4` for IPv4, `6` for IPv6
- `0` id for multi-threaded nfqueue (currently only one thread is used)

###### Explanation of Connmark Numbers  
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

### Kernel Module

We plan to provide an alternative to the `iptables` integration by writing a kernel module to handle the needed packet interception in the future.
Depending on the performance and stability of the `iptables` integration, this will be tackled sooner or later.

### proc/net

{% include code_ref.html godoc-portmaster="process/proc" %}

In order to find out which process a packet belongs to, the `proc` filesystem is first parsed to find the socket ID of the intercepted packet, then the process directory is searched for the matching PID.
This is a bit cumbersome, but unfortunately, no better way of acquiring this information is available.

##### Systemd Resolved

With `systemd-resolved`, Linux Distributions are slowly rolling out a system resolver with similar capabilites as the Windows `DNS Client`.

The important detail for the Portmaster is that queries may be sent to `systemd-resolved` using the [D-Bus interface](https://www.freedesktop.org/software/systemd/man/org.freedesktop.resolve1.html) instead of packets on the wire.
As a result, the Portmaster can not identify the actual process behind a query and thus will not directly make a decision on queries coming from `systemd-resolved` (except for {% include setting/ref.html key="filter/preventBypassing" %}), but will remember the resulting IPs and use them to match domains to connections when the actual connection is initialized.

This approach can sometimes lead the Portmaster to a wrong attribution of a domain to a connection.

For example, if two processes use two different domains but both of them point to the same IP address, it could happen that the Portmaster thinks that the first process is connecting to the domain of the second process and vice-versa. Especially if requests are done in parallel or connections are re-established without querying for the domain again.

As a remediation to this, we will start looking at HTTP headers and TLS handshakes in the future. With information gathered directly from the connection, the attribution will be more accurate.

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

## Integration Interfaces

There are two primary OS integration intefaces that the Portmaster uses to plug OS specific logic into the cross-platform structure:

- [Packet Interception](https://github.com/safing/portmaster/blob/develop/firewall/interception/interception_default.go)
  - The `Packet` channel is for ingesting all seen packets.
  - Packets need to be wrapped in order to conform to the [Packet interface](https://github.com/safing/portmaster/blob/a3b495f6c921d4189a57edda10c55cb71ef37f86/network/packet/packet.go#L221).
  - The OS side of the integration should persist decisions when one of the `Permanent*` action functions is called.
  - Currently, this uses `nfqueue` on Linux and and a custom kernel-mode driver on Windows.
- [Packet to Process Attribution](https://github.com/safing/portmaster/blob/a3b495f6c921d4189a57edda10c55cb71ef37f86/network/state/system_default.go)
  - This interface provides network state tables to the Portmaster.
  - Currently, this uses `/proc` on Linux and the `iphlpapi.dll` on Windows.

Additionally, there are some non-essential interfaces that provide things like names and icons of programs.

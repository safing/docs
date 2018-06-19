---
title: OS Integration
section: portmaster
order: 10
layout: base
source-docs:
  - firewall/interception
  - process
---

## Windows

##### WinDivert {% include source-docs.html a="firewall/interception/windivert" %}

The WinDivert API and kernel driver offer a similar interface to packet interception on Windows as divert socket.

While this works well, it's rather slow, so we are planning drastic performance improvements in the near future.

##### IP Helper API {% include source-docs.html a="process/iphelper" %}

The Windows API `IpHlpApi.dll` is used to fetch the table of current connections and get PID that belongs to the intercepted packet.

## macOS

_coming soon_

## Linux

On Linux we aim to provide two ways of OS integration:

##### iptables with nfqueue {% include source-docs.html a="firewall/interception/nfqueue" %}

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
nat OUTPUT -m mark --mark 1717 -p {tcp|udp} -j DNAT --to-destination 127.0.0.17:1117 # for Port17
nat OUTPUT -m mark --mark 1717 -j DNAT --to-destination 127.0.0.17 # for Port17
```

Explanation of Nfqueue Numbers:

`17040` breaks up into:
- `17` is an identifier, so that you can easily spot what belongs to Portmaster/Port17
- `0` for ouput, `1` for input
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
1717 Reroute to Port17
1799 Reroute to nameserver (for astray DNS queries)
```

##### kernel module

We will provide an alternative to `iptables` by writing a kernel module to handle the needed packet interception in the future. Depending on the performance and stability of the `iptables` integration this might come sooner or later.

##### proc/net {% include source-docs.html a="process/proc" %}

In order to find out which process a packet belongs to, the proc filesystem is first parsed to find the socket id of the intercepted packet, then the process directory is search for the matching PID.

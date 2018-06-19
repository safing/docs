---
title: Firewall
section: portmaster
order: 1
layout: base
source-docs:
  - firewall
  - firewall/interception
  - portmaster
  - network
  - network/packet
---

<div class="alert alert-info" role="alert">
  If you not have read the <a href="/main/tech-overview.html">Tech Overview</a>, please start there.
</div>

The Application Firewall is responsible for interception network connections and analyzing them to only the ones that are in the interest of the user - while not bugging the user about it.

## Packet Interception {% include source-docs.html a="firewall/interception" b="network/packet" %}

The interception package (a seperate one for each OS) provides the firewall a stream of packet objects, which the firewall can inspect and then issue a verdict through these packet objects.

Verdicts may be:

- __Accept__: Packet is allowed to pass.
- __Block__: Packet is dropped, a TCP-Reset or ICMP `host unreachable` message is sent to the sender.
- __Drop__: Packet is dropped silently.
- __PermanentAccept__: This packet is allowed to pass, also tell the interception package to accept all future packets of this `Link`.
- __PermanentBlock__: This packet is blocked, as well as all future packets of this `Link`.
- __PermanentDrop__: This packet is dropped, as well as all future packets of this `Link`.
- __RerouteToNameserver__: Reroute this packet to the local nameserver for handling.
- __RerouteToTunnel__: Reroute this packet (and its `Link`) to the local Port17 entry point for further handling.

The _permanent_ editions of verdicts were created to drastically improve performance of the portmaster, as such `Links` will be "handed over" back to the OS and will not be intercepted by the Portmaster anymore. The trade-off here is that connections cannot be killed, should the user or software change it's mind about it later on - but this is usually not the case.

## Links {% include source-docs.html a="network#Link" %}

`Links` represent a physical connection between a local application and a remote server. It is defined and identified through the IP/Port pair.

## Connections {% include source-docs.html a="network#Connection" %}

`Connections` represent a logical connection between a local application and a Internet entity, identified by a domain. `Connections` will usually have multiple `Links` belonging to it.

## The Portmaster {% include source-docs.html a="portmaster" %}

The Portmaster is the component that is handed received `Connections` and `Links` as well as any intelligence data gathered to make a decision.

It always tries to make a decision on the `Connection`, which `Links` will automatically inherit. All these decisions and why they were made can easily be monitored in the UI.

---
title: Firewall
section: portmaster
order: 1
layout: base
updated: 19.02.2019
code_ref:
  godoc-portmaster-1:  firewall
  godoc-portmaster-2:  network
  github-portmaster-1: firewall
  github-portmaster-2: firewall/interception
  github-portmaster-3: network
  github-portmaster-4: network/packet
---

<div class="alert alert-info" role="alert">
  This is a very technical document, if this not what you are looking for, maybe start out with our <a href="/guides/portmaster.html">Guides</a>.
  <br>
  Also, if you not have read the <a href="/main/tech-overview.html">Tech Overview</a>, please start there.
</div>

The Application Firewall is responsible for intercepting network connections and analyzing them to only permit the ones that are in your interest - while not bugging you about it.

## Connection Handling {% include code_ref.html godoc-portmaster="network" %}

The Portmaster uses a two tiered view of connections:

- `Communication` describes a logical connection between a local application and an Internet entity, identified by a domain. A `Communication` may have multiple `Links`.
- `Link` represents a physical connection between a local application and a remote server. It is defined and identified through the IP/Port pair.

Packets are intercepted and then handled by the Portmaster.

## Decision Making {% include code_ref.html godoc-portmaster="firewall" github-portmaster="firewall/master.go" %}

The Portmaster makes decisions about a connection at multiple stages:

- Before resolving DNS / fetching Stamp data
  - `Communication` level: function `DecideOnCommunicationBeforeIntel`
- After resolving DNS / fetching Stamp data
  - `Communication` level: function `DecideOnCommunicationAfterIntel`
- With the interception of the first packet
  - `Communication` level: function `DecideOnCommunication`
  - `Link` level: function `DecideOnLink`
- On every packet until all inspection subsystems are finished (`Link` level)

## Decision Flow

In order to help you understand the complete decision process, we have developed the flow graph below. You can also find a PDF version [here](/assets/diagrams/portmaster_firewall_decision_flow.pdf).

<img src="/assets/diagrams/portmaster_firewall_decision_flow_cropped.svg" style="padding: 40px 0;">

## Packet Interception {% include code_ref.html godoc-portmaster-1="firewall/interception" godoc-portmaster-2="network/packet" %}

The interception module (a seperate one for each OS) provides the firewall with a stream of packet objects, which the firewall can inspect and then issue a verdict through these packet objects.

Verdicts may be:

- __Accept__: Packet is allowed to pass.
- __Block__: Packet is dropped, a TCP-Reset or ICMP `host unreachable` message is sent to the sender.
- __Drop__: Packet is dropped silently.
- __PermanentAccept__: This packet is allowed to pass, also tell the interception package to accept all future packets of this `Link`.
- __PermanentBlock__: This packet is blocked, as well as all future packets of this `Link`.
- __PermanentDrop__: This packet is dropped, as well as all future packets of this `Link`.
- __RerouteToNameserver__: Reroute this packet to the local nameserver for handling.
- __RerouteToTunnel__: Reroute this packet (and its `Link`) to the local Gate17 entry point for further handling.

The _permanent_ editions of verdicts were created to drastically improve performance of the portmaster, as such `Links` will be "handed over" back to the OS and will not be intercepted by the Portmaster anymore. The trade-off here is that connections cannot be killed, should you change your mind about it later on - but this is usually not the case.

## An Example: The Story of a Connection

This little story of a packet aims to illustrate how the Portmaster works. Please note that this story may be fundamentally different depending on your settings.

You fire up Firefox to access a web page on the Internet. After clicking on the bookmark you want, Firefox sends a DNS request to resolve the website/domain you are accessing: `example.com.`.

_Before resolving DNS_  
The Portmaster takes over this request and first checks if Firefox is allowed to talk to `example.com.`. After verifying that this is the case, the Portmaster concurrently resolves the query and requests any intelligence data from Stamp.  
_After resolving DNS_  
With these, the permission to access `example.com.` is checked again - with the newly gained data. When all this goes well, the Portmaster returns the DNS answer to Firefox.

_interception of the first packet_  
Firefox then opens a connection to the server behind `example.com.`. The Portmaster intercepts the packet and checks if it already knows what to with it. The packet is put "on hold", while the Portmaster decides what to do. The Portmaster then finally marks the connection as permitted and the packet can continue.

But it's not quite over yet. The Portmaster may still further inspect packets to ensure your privacy or detect attacks. One of these things is to check if connections are encrypted (with TLS) and block them if they are not, but you require that.

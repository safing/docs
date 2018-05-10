---
title: Security
section: port17
order: 2
layout: base
---

## Our Promise

We know that every complex system can be broken, Port17 is no different. We do the best we can and we think we're doing quite good. Nevertheless we have to set limits to what extent we can and to which lengths we will go to protect you. Here we want to clearly communicate these limits:

__Money__  
If you throw enough money at something long enough, it will eventually crumble. In our case we estimate how much an attack on Port17 costs and set a limit to what extent we promise to intervene. For now this limit is set at one million EUR (Q3 2018) - we will periodically review and update this value.  Be assured that if there is a feasible solution, we will always react to a threat as fast as we can.
Let's look at an example of how attack costs are estimated: If an attack requires 100 server to be run for 3 months and requires a month worth of work, we can estimate that this attack would cost about 19000€ (100 * 3 * 30€ + 10000€).

__Legal__  
We will not break any laws. Our systems are designed to collect as little personal information as possible and we continually evaluate concepts to further decentralize our control over the Port17 network. Should we ever be forced to break the system or collect data on you, Safing (the company) will _hara-kiri_.

## Confidentiality and Integrity

[DRAFT]

## Anonymity

In order to anonymize connections, they are routed through

There are three possible attacks to break this anonymity:

__Rogue Nodes__

The obvious threat to anonymity are nodes that are compromised or silently collude. These nodes then extract session data and if a route is chosen that consists _entirely_ of such nodes, the attacker can link the source to the destination.

[DRAFT]

__Traffic Analysis__

One major concern with all anonymity networks is traffic analysis. With enough network visibility, one can easily find out where a connection really goes to and comes from, without even interacting with the network itself.

To provide the best possible anonymity, we studied the principles of _anti traffic analysis_ described by _Gordon Welchman_ in his book _The Hut Six Story_.

Here we compare these principles with Port17.

| # | Principle | Port17 |
|:--|---|---|
| 1 | All nodes are full nodes of the network with multiple connections (no leaf nodes). | With the exception of clients, all nodes in the network are full nodes. |
| 2 | Connections have link layer encryption. | True. |
| 3 | Communication is end-to-end encrypted. | True. |
| 4 | All nodes _store and forward_ (the longer stored the better) | Not really, as it'd be a pain to use. Will implement if there is demand. |
| 5 | Connections have a fixed bandwidth, which is padded to full utilization at all times. | Kind of: Network packets are fixed, but bandwidth is not. Will implement if there is demand. |

In our current state, we fulfill three out of these five principles on average. The last two put a heavy load on the network and make it a lot slower. We think that Port17 is designed to withstand traffic analysis to a great amount. Should things change or the need arise, we will further adopt these principles.

If there is enough demand, we will also implement the last two principles in a hybrid form, so you can opt-in if you need the extra protection.

The traffic analysis method is feared because it can be executed passively, which makes it really hard to detect.

__Data Leaks__

Not so obvious, but very dangerous attacks on the anonymity in the network are data leaks. As these happened so often with other networks in the past, we made sure we could address these optimally.

1. Because Port17 does not forward layer 4 network data, no data can leak from that layer into the Port17 network and beyond.
2. bla
3. Let's take a tour of what other data may leak and how Port17 (together with Portmaster) protects you:
  - WebRTC: WebRTC is a communication framework used within browsers. Portmaster blocks WebRTC.
  - Interface addresses: When using a domain to connect to a server (which is almost always), the local connection only uses local addresses, so the application only binds to a local address instead of a site-local or global one. This prevents applications from sharing their network location by reading the address of their bound interface.
  - Portmaster/Port17 crashes: In the event of a crash, connections are not automatically routed over the open Internet, but will be cut off. Connectivity will be lost until Portmaster/Port17 restarts.

> Please note that this is about data leaks of networking (meta)data. Port17 cannot protect you from sharing your data or using applications that make you easily identifiable, like your browser, if not configured correctly.

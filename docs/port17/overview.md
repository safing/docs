---
title: Overview
section: port17
order: 1
layout: base
---

## Network

Port17 uses static routes between all nodes. Clients may only use these routes. The network will automatically optimize these routes to get anywhere in at most 3-4 hops.

Clients

## Gossip

Every node knows all other nodes in the network. This information is propagated via `Bottles`. Whenever a node updates its information (including advertised routes) it sends out a new version of its `Bottle` to all connected nodes and broadcasts it on the local network.

Clients connect to a single Port17 node and download the current list from there. This node then is used as an entrance to the Port17 network.

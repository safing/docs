---
title: Bootstrapping
section: port17
order: 2
layout: base
---

When a Port17 Node comes online for the first time, it needs to bootstrap itself to the network.

Before doing this the node initializes itself:
- it generates its identity (a private/public key pair)
- it configures its [Bottle]({% link docs/port17/bottles.md %})

To join the network, the node then downloads a couple of `Bottles` from `https://bootstrap.safing.io/bootstrap-nodes.json`.

> Note: until the internal Port17 update system is in place, bootstrap.safing.io will also be used for updates.

These Bottles are then used for an initial connection to the network.

When a node (or client) has been offline for over a day, the `Bottle` of the node they want to connect to may not have any valid ephemeral keys left, so they will have to send a `Seagull` to fetch a new `Bottle` before connecting.

When finally connected to the first node, the system will request that the nodes sends all `Bottles` in store to get the internal network map up to date. These new `Bottles` are all handled as explained in the [Bottle]({% link docs/port17/bottles.md %}) section.

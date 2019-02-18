---
title: Architecture
pagetitle: Gate17 Architecture
section: gate17
order: 3
layout: base
---

## The Mesh Network

Gate17 employs a static - but dynamically created - mesh network. Clients may only move within existing connections and will never trigger a new layer 4 connection to be established.

## Bootstrapping <!-- {% include code_ref.html a="gate17/manager" %} -->

When a Gate17 Node comes online for the first time, it needs to bootstrap itself to the network.

Before doing this the node initializes itself:
- it generates its identity (a private/public key pair)
- it configures its `Bottle`

To join the network, the node then downloads a couple of `Bottles` from `https://bootstrap.safing.io/bootstrap-nodes.json`.

> Note: until the internal Gate17 update system is in place, bootstrap.safing.io will also be used for updates.

These Bottles are then used for an initial connection to the network.

When a node (or client) has been offline for over a day, the `Bottle` of the node they want to connect to may not have any valid ephemeral keys left, so they will have to send a `Seagull` to fetch a new `Bottle` before connecting.

When finally connected to the first node, the system will request that the nodes sends all `Bottles` in store to get the internal network map up to date. These new `Bottles` are all handled as explained in the `Bottle` section.

## Tunneling

Gate17 tunneling is done on layer 5 in the network layer model. This means that layer 4 (eg. TCP, UDP, ...) is terminated locally and _cannot_ leak any information, such as your IP address. Everything above, including TLS, is routed through the Gate17 network without mangling.

New connections are always first reviewed by Portmaster to determine if and how it should be handled by Gate17. Connections are then redirected to a local port, where Gate17 awaits new connections. This redirection is done either by DNS or - if connecting to an IP address directly - diverted Portmaster.

Upon accepting a new connection, Gate17 matches it to the information received by Portmaster and sets possible custom options. The `gate17/navigator` is then asked to calculate a route which is then built and the connection is then forwarded.

## Bottles (Gossip) <!-- {% include code_ref.html a="gate17/bottle" %} -->

Nodes exchange information about themselves by passing `Bottles` around. These `Bottles` are both sent to all connected nodes and are multicasted to the local network.

`Bottles` appear in two flavours: `public` and `local`.

`public` `Bottles` represent nodes on the public backbone. Most of them advertise a public IPv4 and/or IPv6 address. There are also nodes, which do not propagate an IP address. Clients only use these as intermediary nodes.

If a `public` `Bottle` is received it is handled like this:

- `gate17/manager` Bottle is received
- `gate17/bottle` Bottle is parsed, signature and validity is checked
- `gate17/bottlerack` Bottle is compared to stored version, continue if new or changed.
- `gate17/manager` verify new/changed advertised IP addresses
  - if verification failed, forward bottle as distrusted.
- `gate17/manager` forward bottle to all connected nodes and clients, as well as locally

`local` `Bottles` represent nodes in the local network.

If a `local` `Bottle` is received it is handled like this:

- `gate17/manager` The bottle is parsed.
- `gate17/bottle` Signature is checked. If invalid, abort.
- `gate17/manager` If the bottle does not advertise any IP addresses,
- `gate17/bottlerack` Bottle is compared to stored version, continue if new or changed.
- `gate17/manager` verify new/changed advertised IP addresses
  - if verification failed, forward bottle as distrusted.
- `gate17/manager` if PortName changed, verify if name is unique, otherwise, abort.
- `gate17/manager` forward bottle to all connected nodes and clients, as well as locally

## Routing <!-- {% include code_ref.html a="gate17/navigator" b="gate17/manager" %} -->

Routes are entirely chosen by the clients:

- Exit nodes are chosen in proximity to the destination in order to protect the connection as long as possible.
- Node ownership is diversified.
- The fastest route with at least 3 hops is chosen.

In the future, users will have multiple options to influence how routes through the network are calculated:

- Exclude nodes by name or group
- Exclude areas by AS-Number, Country or IP range

    This product includes GeoLite2 data created by MaxMind, available from [http://www.maxmind.com](http://www.maxmind.com).

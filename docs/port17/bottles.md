---
title: Bottles
section: port17
order: 5
layout: base
source-code:
  - port17/bottle
  - port17/bottlerack
  - port17/manager
---

Nodes exchange information about themselves by passing `Bottles` around. These `Bottles` are both sent to all connected nodes and are multicasted to the local network.

`Bottles` appear in two flavours: `public` and `local`.

`public` `Bottles` represent nodes on the public backbone. Most of them advertise a public IPv4 and/or IPv6 address. There are also nodes, which do not propagate an IP address. Clients only use these as intermediary nodes.

If a `public` `Bottle` is received it is handled like this:

- `port17/manager` The bottle is parsed.
- `port17/bottle` Signature is checked. If invalid, abort.
- `port17/bottlerack` Bottle is compared to stored version, continue if new or changed.
- `port17/manager` verify new/changed advertised IP addresses
  - if verification failed, forward bottle as distrusted.
- `port17/manager` if PortName changed, verify if name is unique, otherwise, abort.
- `port17/manager` forward bottle to all connected nodes and clients, as well as locally

`local` `Bottles` represent nodes in the local network.

If a `local` `Bottle` is received it is handled like this:

- `port17/manager` The bottle is parsed.
- `port17/bottle` Signature is checked. If invalid, abort.
- `port17/manager` If the bottle does not advertise any IP addresses,
- `port17/bottlerack` Bottle is compared to stored version, continue if new or changed.
- `port17/manager` verify new/changed advertised IP addresses
  - if verification failed, forward bottle as distrusted.
- `port17/manager` if PortName changed, verify if name is unique, otherwise, abort.
- `port17/manager` forward bottle to all connected nodes and clients, as well as locally

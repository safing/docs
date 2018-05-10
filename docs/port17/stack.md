---
title: Stack
pagetitle: Port17 Network Stack
section: port17
order: 4
layout: base
source-docs:
  - port17
  - port17/ships
  - port17/manager
---



## Overview

```
                A Port17 Node

             +-----------+   Conveyors
             |           <--Belt--Belt--->API
     Ship    |           <--Belt--...---->API
<------------>   Crane   <--------------->API
             |           <--------------->API
             |           <-----------------v
             +-----------+            +----+----+
                                      |   API   |
             +-----------+   Conv.    +----+----+
             |           <-----------------^
     Ship    |           <---...
<------------>   Crane   |
             |           |
             |           |
             +-----------+
```


## Ships

A `Ship` in Port17 represents an IP based connection between two nodes. There are several `Ship` types ie. protocols. A node listens on multiple ports, every port can handle any ship (ie. protocol) of its type (packet or stream based). The first packet received must somehow hint at what protocol should be used.

This layer is only responsible for ordered and reliable transportation.

List of `Ship` types:

- `TCP`: regular TCP connection. Uses Go standard library.
- `KCP`: a fast, ordered and error-checked delivery of streams over UDP packets. Uses [KCPGO](https://github.com/xtaci/kcp-go/).

Planned `Ship` types:

- HTTP
- HTTP/websocket: HTTP with upgrade to websockets
- DNS tunneling: data encapsulated in DNS queries and replies
- TLS (faked): simulated TLS
- TLS: normal TLS
- SMTPS (faked): SMTP init with STARTTLS, then simulated TLS
- SMTPS: SMTP init with STARTTLS, then use real TLS

## Cranes

A `Crane` in Port17 handles the loading and unloading of a single docked `Ship`.

It is responsible for:
- Network related security and privacy
- Multiplexing

`Cranes` encrypt all data they dispatch and only send fixed-sized messages to protect against traffic analysis attacks. A `Crane` can theoretically handle unlimited sub-connections: `Conveyors`.

## Conveyors

`Conveyors` transport containers from and to ships and normally have an API handler at the end. In between they may have any number and combination of `Conveyor Belts`.

`Conveyors` are normally represented by a `ConveyorLine`, which is also responsible for flow-control: Check that data is only forwarded as fast as it can be handled by the next node/component.

## Conveyor Belts

`Conveyor Belts` perform various actions on the containers.
Currently, the only available `Conveyor Belt` is the `Tinker`, which is responsible for encryption, verification and session key management.
Others - like compression - are planned.

## API

The Port17 API interacts with the client and has a couple of Endpoints:

- Informational
  - `Info`: returns generic info about node
  - `Load`: returns current load of node
  - `Stats`: returns statistics about node

- Tunneling
  - `Hop`: extend connection to another node
  - `Tunnel`: start a data tunnel
  - `Ping`: ping an IP address

- Diagnostics
  - `Echo`: return the transmitted string
  - `Speedtest`: send a bunch of data to test the connection

- Mgmt
  - `EstablishRoute`: advise node to establish a route
  - `Shutdown`: inform client that node is going down (mainly node -> client)

Each call made to the API creates a new asynchronous and concurrent request.

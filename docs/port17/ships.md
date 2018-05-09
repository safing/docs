---
title: Ships (Network)
section: port17
order: 5
layout: base
source-code:
  - port17/ships
  - port17/manager
---

A `Ship` in Port17 represents an IP based connection between two nodes. There are several `Ship` types ie. protocols. A node listens on multiple ports, every port can handle any ship (ie. protocol) of its type (packet or stream based).

The first packet received must somehow hint at what protocol should be used.

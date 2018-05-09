---
title: Tunneling
section: port17
order: 5
layout: base
---

Port17 tunneling is done on layer 5 in the network layer model. This means that layer 4 (eg. TCP, UDP, ...) is terminated locally and _cannot_ leak any information, such as your IP address. Everything above, including TLS, is routed through the Port17 network without mangling.

New connections are always first reviewed by Portmaster to determine if and how it should be handled by Port17. Connections are then redirected to a local port, where Port17 awaits new connections. This redirection is done either by DNS or - if connecting to an IP address directly - diverted Portmaster.

Upon accepting a new connection, Port17 matches it to the information received by Portmaster and sets possible custom options. The `port17/navigator` is then asked to calculate a route which is then built and the connection is then forwarded.

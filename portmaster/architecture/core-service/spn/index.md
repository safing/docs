---
title: SPN
layout: base
---

The SPN is a secure overlay network similar to Tor, but as easy to use as a VPN. Network connections that should be tunneled are redirected to a local endpoint and their Session Layer data is then intelligently routed through a network of servers on the Internet, employing onion encryption for a solid privacy protection.

Depending on your threat model, the SPN can be configured with different routing profiles, priotizing different things, such as speed, throughput and traffic analysis resistance. Clients cannot choose their routes freely, but need use routes that the network advertises. This leads to better bundling of connections on the network for improved privacy.

The SPN supports both TCP and UDP connections, albeit currently only with a single endpoint. Applications can be individually configured for the SPN and even be excluded if needed. Similar to the Resolver module, the SPN uses a split-view and does not route connections for local network via the SPN.

_Until this page is expanded to hold all the details, you can [read through our Whitepaper]({{ site.whitepaper_url }})._

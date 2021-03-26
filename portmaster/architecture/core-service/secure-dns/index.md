---
title: Secure DNS
layout: base
---

##### Secure DNS Resolver

{% include code_ref.html godoc_portmaster="resolver" %}

This module provides secure domain resolving. Most prominently, it uses the DNS-over-TLS protocol by default in order to protect your precious DNS queries from prying eyes.

It also splits its horizon between your local network and the Internet. If you employ local domains for either an enterprise network or development, it will direct queries for these domains to the correct local nameservers, if they announce them.

Responses from servers are cached intelligently, invalidating any cached responses that do not conform to updated configuration.

If you want to know how we choose our default providers, read [How Safing Selects its Default DNS Providers](https://safing.io/blog/2020/07/07/how-safing-selects-its-default-dns-providers/).


{% comment %} perma-anchor {% endcomment%}
<span id="querying-deep-dive"></span>

##### Deep Dive into Split Horizon Querying

{% include code_ref.html godoc_portmaster="resolver#GetResolversInScope" %}

Here is how the Portmaster decides where to send dns queries in order to achieve maximum privacy and interoperability:

__Environmental Domains__

Queries within the environmental special domain scopes are directly handled by the Portmaster in order to expose network environment information. For example, your router can always be reached at `router.local.17.home.arpa`.

This horizon affects the following domain scopes:
{% include setting/annotation-domainlist.html key="self:detail:internalSpecialUseDomains" scope=true %}

__Connectivity Domains__

Operating Systems and other software such as browsers use special domains to determine whether they are online and to check whether they are being kept captive by a portal, such as a welcome page on a public WiFi network.

In order to guarantee that these work properly, the Portmaster always sends them to the DNS Servers of the System or Network. Queries for these special domains also ignore {% include setting/ref.html key="dns/noAssignedNameservers" %} and {% include setting/ref.html key="dns/noInsecureProtocols" %}.

The connectivity domains the Portmaster knows about are:
{% include setting/annotation-domainlist.html key="self:detail:connectivityDomains" %}

__Search Scopes__

Some networks use an internal domain name for addressing devices in them. These search domains are configured per DNS Server. If the Portmaster detects a query for a domain that is part of such a search domain, it will prioritize DNS Servers that advertise a matching search domain. The Portmaster will not respect search domains that go higher than the public suffix - eg. a `.com` search scope will not be taken into account.

The domain scopes affected by this horizon are dependent on the current network environment. Also, DNS Server selection by this horizon is not final, the selection continues.

__Multicast Domains__

There are certain domain names that by definition should be resolved not by a DNS Server, but all devices on the network should be queried at once by using a multicast request. If that does not result in an answer, the Portmaster will also try DNS Servers on the LAN and System/Network assigned ones.

This horizon affects the following domain scopes:
{% include setting/annotation-domainlist.html key="self:detail:multicastDomains" scope=true %}

__Private and Special Use Domains__

Another set of domains are set aside to be used in private networks. The Portmaster queries DNS Servers on the LAN and System/Network assigned ones for these.

This horizon affects the following domain scopes:
{% include setting/annotation-domainlist.html key="self:detail:specialUseDomains" scope=true %}

__Special Services Domains__

There are special services on the Internet that use a top level domain without actually using the DNS system. Rather, the domains are resolved using special mechanisms or servers. They usually cannot be resolved via public DNS Servers.

Some organizations have set up special resolving for these domains in their network. This is why the Portmaster forwards queries to these domains to DNS Servers on the LAN and System/Network assigned ones - if they are not blocked by {% include setting/ref.html key="dns/dontResolveSpecialDomains" %}.

Please be aware that accessing these domains comes with a higher security risk simply because they do not receive as much attention from security researchers as regular domains.

This horizon affects the following domain scopes:
{% include setting/annotation-domainlist.html key="self:detail:specialServiceDomains" scope=true %}

__Global Domains__

Everything else will be resolved by the resolvers configured in the Portmaster, while using the System/Network assigned ones as a final fallback.


##### Relevant settings

{% include setting/brief.html key="dns/nameservers" %}
{% include setting/brief.html key="dns/nameserverRetryRate" %}
{% include setting/brief.html key="dns/noAssignedNameservers" %}
{% include setting/brief.html key="dns/noMulticastDNS" %}
{% include setting/brief.html key="dns/noInsecureProtocols" %}
{% include setting/brief.html key="dns/dontResolveSpecialDomains" %}

##### Nameserver

{% include code_ref.html godoc_portmaster="nameserver" %}

This module is kind of the other end of the resolver. It listens locally for DNS requests from processes and lets the resolver come up with an answer.

Similarly to the firewall module, it first attributes the request to a process and fetches custom settings and then lets the Privacy Filter make a decision about the query. Only then is the resolver tasked with finding a response to the query. After receiving the response, it is again checked with the Privacy Filter in case something in the response needs to be blocked.

{% comment %}

### Components

##### Nameserver

{not shown in UI, because it's the "main" of Secure DNS}
-> local DNS server (recursive stub)  
-> every DNS query goes through the same as the firewall  
-> first "network module" for connection  
-> then gets process via "processes"  
-> then the fitting "profiles"  
-> then it can decide what to do  
-> if yes, then use resolver  

##### resolver
-> resolve DNS query via DNS over TLS  
-> caching  
-> DNS config  

{% endcomment %}

<p></p> <!-- TODO: Fix spacing in CSS instead -->

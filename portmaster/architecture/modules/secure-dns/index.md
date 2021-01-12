---
title: Secure DNS
layout: base
---

##### Secure DNS Resolver {% include code_ref.html godoc_portmaster="resolver" %}

This module provides secure domain resolving. Most prominently, it uses the DNS-over-TLS protocol by default in order to protect your precious DNS queries from prying eyes. 

It also splits its horizon between your local network and the Internet. If you employ local domains for either an enterprise network or development, it will direct queries for these domains to the correct local nameservers, if they announce them.

Responses from servers are cached intelligently, invalidating any cached responses that do not conform to updated configuration.

If you want to know how we choose our default providers, read [How Safing Selects its Default DNS Providers](https://safing.io/blog/2020/07/07/how-safing-selects-its-default-dns-providers/).

Relevant settings:

{% include setting/brief.html key="dns/nameservers" %}
{% include setting/brief.html key="dns/noAssignedNameservers" %}
{% include setting/brief.html key="dns/nameserverRetryRate" %}
{% include setting/brief.html key="dns/noMulticastDNS" %}
{% include setting/brief.html key="dns/noInsecureProtocols" %}
{% include setting/brief.html key="dns/dontResolveSpecialDomains" %}

##### Nameserver {% include code_ref.html godoc_portmaster="nameserver" %}

This module is kind of the other end of the resolver. It listens locally for DNS requests from processes and lets the resolver come up with an answer.

Similarly to the firewall module, it first attributes the request to a process and fetches custom settings and then lets the Privacy Filter make a decision about the query. Only then is resolver tasked with finding a response to the query, which is check with the Privacy afterwards again, in case something in the response needs to be blocked.

{% comment %}

### Compontents

##### Nameserver {not shown in UI, because it's the "main" of Secure DNS}
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

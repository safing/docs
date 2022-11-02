---
title: Privacy Filter
layout: base
---

### Privacy Filter

{% include code_ref.html godoc_portmaster="firewall" github_portmaster="firewall/master.go" %}

The Privacy Filter is one of the most important parts of the Portmaster: It protects your privacy by blocking connections that are deemed a privacy intrusion deemed by you or the Portmaster itself.

It evaluates all connections leaving or entering your system. Filters are applied to both DNS queries as well as network connections. Every request or connection is run through a long list of checks and settings in order to protect your privacy as best possible.

In addition to rule lists and block lists, the Privacy Filter provides a big set of advanced and dynamic filtering options. It also blocks attempts to circumvent the filtering and enforces it everywhere, all the time.

### Supported Protocols

The Portmaster operates on the [Network Layer (Layer 3)](https://en.wikipedia.org/wiki/OSI_model) and focuses on the [Internet Protocol](https://en.wikipedia.org/wiki/Internet_Protocol), both IPv4 and IPv6. It can monitor and block the following protocols:

- `TCP`
- `UDP`
- `ICMP/v6 echo requests and replies` (no process attribution)
- Any other IP based protocol (no process attribution)

There is a small portion of protocols that are absolutely critical for operating systems to correctly bootstrap and interact with the network itself. In order to guarantee network interoperability, the Portmaster always allows `DHCP/v6` and `ICMP/v6 control and error messages`.

Because the Portmaster operates on the [Network Layer (Layer 3)](https://en.wikipedia.org/wiki/OSI_model), it does not see [Data Link Layer (Layer 2)](https://en.wikipedia.org/wiki/OSI_model) data or packets. As these can only live within the [local network's broadcast domain](https://en.wikipedia.org/wiki/Broadcast_domain), they do not pose a privacy threat. Regarding other Network Layer protocols, alternatives to IP existed, but they can be safely viewed as extinct.

---

### Connection Evaluation Stages

These are the stages which every connection goes through when being evaluated - from top to bottom:

###### Special and Edge Cases

Before any further processing takes places, Portmaster checks if the connections is one of a few special cases that are always allowed in order to keep everything operational. These are:

- __Network Management Connections__
  - Automatic network configuration via DHCP and DHCPv6
  - Network error messages via ICMP and ICMPv6
- __Portmaster Itself__
  - Outgoing connections from Portmaster (Corresponding features can be disabled)
  - Device-Local incoming connections to Portmaster
- __Internal App Connections__
  - Connections that come from and go to the same app/binary, even if they are different processes.

If you are using the Simple User Interface, then connections matching these criteria will not show up in order to not confuse you. The Advanced and Developer Interface will show some of these connections.

###### Connection Type

Incoming or direct connections (P2P) are blocked, if enabled by {% include setting/ref.html key="filter/blockInbound" %} or {% include setting/ref.html key="filter/blockP2P" %}.

###### Connection Scope

Connections are blocked according to their scope if enabled by {% include setting/ref.html key="filter/blockInternet" %}, {% include setting/ref.html key="filter/blockLAN" %} or {% include setting/ref.html key="filter/blockLocal" %}. This applies to both incoming and outgoing connections.

###### Rules

Connections are matched against the rule list:

1. {% include setting/ref.html key="filter/endpoints" %}: Rules that apply to outgoing network connections. Cannot overrule the above mentioned Connection Scopes and Connection Types.
2. {% include setting/ref.html key="filter/serviceEndpoints" %}: Rules that apply to incoming network connections. Cannot overrule the above mentioned Connection Scopes and Connection Types.

###### Connectivity Domains

Numerous systems and softare use a special domain in order to determine if they are online or not. The Portmaster grants special access to these domains _only while_ Portmaster has not yet detected that the device is online. This improves network bootstrapping.

###### Bypass Prevention

Processes are prevented from bypassing Portmaster if enabled by {% include setting/ref.html key="filter/preventBypassing" %}. This includes:

- Notifying Firefox that it should not use its own DNS-over-HTTPS resolver, but fall back to plain DNS, which the Portmaster then handles securely for you.
- Blocking known domains and IPs of DoH and DoT nameservers.

###### Filter Lists

Blocks connection if the domain or IP address is listed in one of the activated {% include setting/ref.html key="filter/lists" %}.

###### Domain Heuristics

The Portmaster applies some basic heuristics to detect malicious behaviour in the DNS system if enabled by {% include setting/ref.html key="filter/domainHeuristics" %}. This currently is rather primitive, but should be able to block the most obvious domains generated by malware, but also DNS tunnels.

###### Default Network Action

If nothing up to this point wanted to have a say in the decision, the {% include setting/ref.html key="filter/defaultAction" %} is applied.

### Filter Lists

{% include code_ref.html godoc_portmaster="intel/filterlists" %}

The Filter Lists module is responsible for fetching the filter lists, managing them and providing lightning fast access to them.

All the lists we include, as well as our own, are managed in this [Github repo](https://github.com/safing/intel-data). The collection of sources can be found [here](https://github.com/safing/intel-data/blob/master/lists/sources.yml).

All these sources are fetched regularly and repackaged into incremental updates, which are distributed via the update system. High frequency lists are updated every hour to give you the best possible protection.

These incremental updates are then "stitched back together" in the Portmaster, as well as fed into a bloom filter in order to provide lightning fast inclusion checks.

The filter lists can be configured in the settings and can be selected by category or indiviually.

### IP Metadata

{% include code_ref.html godoc_portmaster="intel/geoip" %}

This modules provides IP address metadata. This is usually referred to as "GeoIP", but in reality there is much more important information in there than just location.

We currently build our own IP metadata database, which includes:
- Continent
- Country
- Coordinates
- ASN (Autonomous System Number)
- Owner (Organization)

The data comes from [DB-IP](https://db-ip.com/), [IPtoASN](https://iptoasn.com/) and [IPFire Location](https://location.ipfire.org/), which we merge into a new database in the `mmdb` format created by [MaxMind](https://www.maxmind.com/).

We will also add more detailed logical Internet location information from our own gathering system in the future.

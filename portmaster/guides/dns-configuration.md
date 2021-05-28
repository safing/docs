---
title: DNS Configuration
layout: base
---


You can set the {% include setting/ref.html key="dns/nameservers" %} setting to a list of servers that you would like to use.
By default, only the first server in the list will be used, unless it fails or does not meet other configured requirements.

### DNS Configuration URL Scheme

DNS servers are configured using an URL scheme, the format is:

```plain
protocol://ip:port?parameter=value&parameter=value
```

These are the possible values:

###### Protocols

  - `dot`: DNS-over-TLS (recommended)
  - `dns`: plain DNS
  - `tcp`: plain DNS over TCP

###### IP

DNS Server configurations **must** use the server IP address instead of its hostname. Using a domain is not possible because there is no guarantee that there is another DNS Server available to resolve that domain.

###### Port

You must specify the server port if non-standard.

The standard ports are:

  - `dot`: 853
  - `dns`: 53
  - `tcp`: 53

###### Parameters

A DNS server configuration URL might have one or more the the following parameters configured.

- `name`: Give your DNS server a name that is used for messages and logs.
- `verify`: Domain name to verify for `dot` servers, required and only valid for `dot` servers.
- `blockedif`: How to detect if the name server blocks a query. Different name servers handle blocked responses differently.
  - `empty`: Server replies with NXDomain status, but without any other record in any section.
  - `refused`: Server replies with Refused status.
  - `zeroip`: Server replies with an IP address, but it is zero (ie. `0.0.0.0` for IPv4).

### Common Server Settings

Here are some common DNS Servers and their Portmaster configuration. Please note that we _do not_ recommend using IPv6 as the vast address space leads to increased trackability.

#### Quad9

[Quad9](https://quad9.org/) is a public DNS service that provides malware protection and is run a non-profit.

```
# Malware Protection:
dot://9.9.9.9:853?verify=dns.quad9.net&name=Quad9&blockedif=empty
dot://149.112.112.112:853?verify=dns.quad9.net&name=Quad9&blockedif=empty

# Malware Protection, IPv6:
dot://[2620:fe::fe]:853?verify=dns.quad9.net&name=Quad9&blockedif=empty
dot://[2620:fe::9]:853?verify=dns.quad9.net&name=Quad9&blockedif=empty
```

#### AdGuard

[AdGuard](https://adguard.com/) offers a freemium [public DNS service](https://adguard.com/en/adguard-dns/overview.html) that also blocks ads.  
Note: The Portmaster uses the publicly available ads blocklist from AdGuard in the Portmaster's Filter Lists by default.

```
# Ad Blocking:
dot://94.140.14.14:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip
dot://94.140.15.15:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip

# Ad Blocking, IPv6:
dot://[2a10:50c0::ad1:ff]:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip
dot://[2a10:50c0::ad2:ff]?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip

# Ad Blocking, Family Protection:
dot://94.140.14.15:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip
dot://94.140.15.16:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip

# Ad Blocking, Familty Protection, IPv6:
dot://[2a10:50c0::bad1:ff]:853?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip
dot://[2a10:50c0::bad2:ff]?verify=dns.adguard.com&name=AdGuard&blockedif=zeroip
```

#### Foundation for Applied Privacy (encrypted DNS)

The [Foundation for Applied Privacy](https://applied-privacy.net/) is a small non-profit that also runs a [public DNS service](https://applied-privacy.net/services/dns/).

```
# No Filtering:
dot://146.255.56.98:853?verify=dot1.applied-privacy.net&name=AppliedPrivacy

# No Filtering, IPv6:
dot://[2a02:1b8:10:234::2]:853?verify=dot1.applied-privacy.net&name=AppliedPrivacy
```

#### Cloudflare

Cloudflare is a behemoth of the Internet. Next to its commercial offerings, it also provices a [public DNS service](https://1.1.1.1/dns/).

```
# Malware Protection:
dot://1.1.1.2:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip
dot://1.0.0.2:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip

# Malware Protection, IPv6:
dot://[2606:4700:4700::1112]:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip
dot://[2606:4700:4700::1002]:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip

# Malware and Family Protection:
dot://1.1.1.3:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip
dot://1.0.0.3:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip

# Malware and Family Protection, IPv6:
dot://[2606:4700:4700::1113]:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip
dot://[2606:4700:4700::1003]:853?verify=cloudflare-dns.com&name=Cloudflare&blockedif=zeroip
```

### Community Suggested Server Settings

Needs are different, that is why we list settings suggested by the community down below. Is something missing or out of date? [Make a report](https://github.com/safing/docs/issues/new?assignees=&labels=suggestion&template=suggest-feature.md) or [create a pull request](https://github.com/safing/docs)

#### BlahDNS [](https://blahdns.com/)

```
# Malware Protection, Ad Blocking
🇨🇭 dot://45.91.92.121:853?verify=dot-ch.blahdns.com&name=BlahDNSch&blockedif=empty
🇯🇵 dot://139.162.112.47:853?verify=dot-jp.blahdns.com&name=BlahDNSjp&blockedif=empty
🇸🇬 dot://192.53.175.149:853?verify=dot-sg.blahdns.com&name=BlahDNSsg&blockedif=empty
🇩🇪 dot://78.46.244.143:853?verify=dot-de.blahdns.com&name=BlahDNSde&blockedif=empty
🇫🇮 dot://95.216.212.177:853?verify=dot-fi.blahdns.com&name=BlahDNSfi&blockedif=empty
```

#### LibreDNS [](https://libredns.gr/)

```
# Malware Protection
dot://116.202.176.26:853?verify=dot.libredns.gr&name=LibreDNS&blockedif=empty

# Malware Protection, Ad & Tracker Blocking
dot://116.202.176.26:854?verify=dot.libredns.gr&name=LibreDNS&blockedif=zeroip
```

#### NextDNS [](https://www.nextdns.io/)

```
# Malware Protection, Ad Blocking
dot://45.90.28.108:853?verify=b4ba5f.dns.nextdns.io&name=NextDNS&blockedif=empty
dot://45.90.30.108:853?verify=b4ba5f.dns.nextdns.io&name=NextDNS&blockedif=empty
```

#### Snopyta [](https://snopyta.org/service/dns/index.html)

```
# No Filtering:
dot://95.216.24.230:853?verify=fi.dot.dns.snopyta.org&name=SnopytaDNS

# No Filtering, IPv6:
dot://[2a01:4f9:2a:1919::9301]:853?verify=fi.dot.dns.snopyta.org&name=SnopytaDNS
```

### Disabling DNS

Unfortunately, you cannot disable the Secure DNS module directly.
This is because it is a crucial component:
Through this the Portmaster can see which domains are being resolved by which application.
This is vital information for the Portmaster to provide you with the promised privacy protection.

However, if you would just rather use the plain DNS servers configured in your Operating System,
you can just remove all configured {% include setting/ref.html key="dns/nameservers" %} from the settings in the Portmaster.
This will leave the list of configured DNS Servers within Portmaster empty.

In this case, the DNS queries will still go through the Portmaster, but will end up at the same DNS server as before.
The Portmaster is then only somewhat transparently inserted in the chain of servers.

While some systems are starting to offer DNS-over-TLS and DNS-over-HTTPS natively,
these settings are usually not as integrated into the programming interfaces as the plain DNS servers.
This means that the Portmaster will only pick up configured _plain DNS servers_ from the Operating System.

You can of course always configure the same DNS-over-TLS server directly in the Portmaster.

### Further Readings

- [How Safing Selects its Default DNS Providers](https://safing.io/blog/2020/07/07/how-safing-selects-its-default-dns-providers/)
- [We Are Updating Portmaster's Default DNS Servers](https://safing.io/blog/2020/07/07/we-are-updating-portmasters-default-dns-servers/)

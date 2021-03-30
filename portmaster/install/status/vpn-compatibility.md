---
title: VPN Compatibility
layout: base
---
1. Numbered
{:toc}

<br/>

Overall, the Portmaster is compatible with VPNs. Here we describe what to look out for and known issues with special VPN software.

You can look through the [main GitHub VPN Compatibility issue](https://github.com/safing/portmaster/issues/160) for more information.

### Setup

Under normal circumstances, VPNs should work right out of the box. If there are problems, [please raise an issue on GitHub](https://github.com/safing/portmaster/issues/new?template=bug-report.md) and we will try to help you get it going!

### DNS Leak Detection

Please note that pretty much all the DNS leak detection tests by the VPN providers will be a false positive, as the only thing they check is if you are using _their_ DNS servers. Rest assured that your DNS queries are well protected by the Portmaster and there is no need to be concerned.

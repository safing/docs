---
title: VPN Compatibility
layout: base
---

Overall, the Portmaster is compatible with VPNs. Here we describe what to look out for and known issues with special VPN software.

You can look through the [main GitHub VPN Compatibility issue](https://github.com/safing/portmaster/issues/160) for more information.

### Setup

Under normal circumstances, VPNs should work right out of the box. If there are problems, [please raise an issue on GitHub](https://github.com/safing/portmaster/issues/new?template=bug-report.md) and we will try to help you get it going!

### DNS Leak Detection

Please note that pretty much all the DNS leak detection tests by the VPN providers will be a false positive, as the only thing they check is if you are using _their_ DNS servers. Rest assured that your DNS queries are well protected by the Portmaster and there is no need to be concerned.

### VPN Providers that need special care

#### Mullvad

The Mullvad VPN App does not allow to turn off forcing their own DNS Servers. This in itself is not a problem, as the Portmaster would hijack the queries anyway and put them where you have configured them to go. What breaks their app, is that it requires the Windows DNS Client (the `dnscache` service) to be running - it simply fails if it's not. The Portmaster has disabled this service to gain the required system integration in order to be able to find out which process sent which DNS query - we don't like that either, but unfortunately this is the only way to gain that integration on Windows.

The workaround is to use OpenVPN directly and [use their configuration tool and guide](https://mullvad.net/en/account/#/openvpn-config/).

Full compatibility might be available in the future when [this feature request for Mullvad](https://github.com/mullvad/mullvadvpn-app/issues/473) is implemented.

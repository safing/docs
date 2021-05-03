---
title: VPN Compatibility
layout: base
---

Overall, the Portmaster is compatible with VPNs. Here we describe what to look out for and known issues with special VPN software.

### Setup

Under normal circumstances, VPNs should work right out of the box. Please [report your experience]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) to help others know whether the Portmaster works with a certain VPN client or not. Naturally, when encountering problems we will try to help you get it going.

### Community Reports

<!--

## Status Guideline

- 🟢 confirmed compatible                  (confirmed by the Safing team)
- 🟢 reported compatible                   (reported by the community)
- 🟡 issue reported                        (reported by the community)
- 🟡 issue confirmed, workaround available (confirmed by the Safing team)
- 🚫 issue confirmed                       (confirmed by the Safing team)

-->

| | OS | Status | Link |
|:---|:---|:---|:---:|
| NordVPN (NordLynx) | <i class="fab fa-linux"></i> | 🟢 reported compatible | [#297]({{ site.github_pm_url }}/issues/297) |
| NordVPN (OpenDNS) | <i class="fab fa-linux"></i> | 🟢 reported compatible | [#297]({{ site.github_pm_url }}/issues/297) |
| ProtonVPN | <i class="fab fa-windows"></i> | 🟢 confirmed compatible | [#160]({{ site.github_pm_url }}/issues/160#issuecomment-700528272) |
| RiseupVPN | <i class="fab fa-linux"></i>| 🟡 issue reported | [#284]({{ site.github_pm_url }}/issues/284) |
| WireGuard | <i class="fab fa-linux"></i>| 🟡 issue confirmed, workaround available | [#292]({{ site.github_pm_url }}/issues/292) |

#### Workaround: OpenVPN

If a VPN Client does not work, you can always work around this by [using OpenVPN instead](https://openvpn.net/community-resources/how-to/). This is a bit more technical but worth a shot if the normal client does not yet work.

### DNS Leak Detection

Please note that pretty much all the DNS leak detection tests by the VPN providers will be a false positive, as the only thing they check is if you are using _their_ DNS servers. Rest assured that your DNS queries are well protected by the Portmaster and there is no need to be concerned.

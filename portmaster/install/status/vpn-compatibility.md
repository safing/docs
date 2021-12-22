---
title: VPN Compatibility
layout: base
---

Overall, the Portmaster is compatible with VPNs. Here we describe what to look out for and known issues with special VPN software.

### Setup

Under normal circumstances, VPNs should work right out of the box. If not, you can always [use OpenVPN as a workaround](#workaround-openvpn).

Please [report your experience]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) to help others know whether the Portmaster works with a certain VPN client or not. Naturally, when encountering problems we will try to help you get it going.

### Community Reports

<table>
  <thead>
    <tr>
      <th style="text-align: left">Native Client</th>
      <th style="text-align: center">OS</th>
      <th style="text-align: center">Mode</th>
      <th style="text-align: left">Status</th>
      <th style="text-align: center">Link</th>
    </tr>
  </thead>
  <tbody>
		{% assign providers = site.data.compatibility.vpns | sort_natural: "name" %}
		{% for provider in providers %}
			{% for report in provider.reports %}
				<tr>
		      <td style="text-align: left">{% if forloop.index == 1 %}{{ provider.name }}{% endif %}</td>
		      <td style="text-align: center"><i class="fab fa-{{ report.os }}"></i></td>
		      <td style="text-align: center">{{ report.mode }}</td>
		      <td style="text-align: left">
						{{ report.state }}
					</td>
		      <td style="text-align: center"><a href="https://github.com/safing/portmaster/issues/{{ report.issue_number }}{% if report.issue_comment %}#issuecomment-{{ report.issue_comment }}{% endif %}">#{{ report.issue_number }}</a></td>
		    </tr>
			{% endfor %}
		{% endfor %}
  </tbody>
</table>

#### Workaround: OpenVPN

If a VPN Client does not work, you can always work around this by [using OpenVPN instead](https://openvpn.net/community-resources/how-to/). This is a bit more technical but worth a shot if the normal client does not yet work.

### DNS Leak Detection

Please note that pretty much all the DNS leak detection tests by the VPN providers will be a false positive, as the only thing they check is if you are using _their_ DNS servers. Rest assured that your DNS queries are well protected by the Portmaster and there is no need to be concerned.

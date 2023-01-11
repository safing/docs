---
title: VPN Compatibility
layout: base
---

Overall, the Portmaster is compatible with VPNs. Here we describe what to look out for and known issues with special VPN software.

### Setup

Under normal circumstances, VPNs should work right out of the box. If not, you can always [use OpenVPN as a workaround](#workaround-openvpn).

### Where Incompatibility Comes From

Incompatibility is created when both Portmaster and a VPN client hook into DNS. Check your VPN app if you can somewhere disable DNS redirection.

Portmaster _needs_ to hook into DNS in order to understand which connection goes where and to which app it belongs. Without it, users would have to start filtering by IP address, making Portmaster basically useless.

Portmaster automatically [secures DNS](portmaster/architecture/core-service/secure-dns/) requests by encrypting them to a secured DNS resolver - which you can configure if you do not like the defaults. You can even set your VPN provider as the resolver if you want. We are all about empowering users.

VPNs do sometimes hook into DNS too - creating the compatibility conflict. Their idea is that since you redirect all your normal traffic through them, you might as well redirect all your DNS to them too. Now that comes from good intentions - but if they do not provide a way to disable this behavior, then this goes against user choice.

The same can apply when VPNs enforce traffic re-routing with kill switches.

There sadly is not much we can do than to ask VPN providers to empower users and allow them to disable their various integrations.

### Workaround: OpenVPN

If a VPN Client does not work, you can try restoring compatibility with [this FAQ guide](https://github.com/safing/portmaster/issues/708). Or alternatively, you can always work around this by [using OpenVPN instead](https://openvpn.net/community-resources/how-to/). This is a bit more technical but worth a shot if the normal VPN client does not work out.

### DNS Leak Detection

Please note that pretty much all the DNS leak detection tests by the VPN providers will be a false positive, as the only thing they check is if you are using _their_ DNS servers. Rest assured that your DNS queries are well protected by the Portmaster and there is no need to be concerned.

### Community Reports

Please [report your experience]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) to help others know whether Portmaster works with a certain VPN client or not.

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
			{% assign reports = provider.reports | sort_natural: "os" %}
			{% for report in reports %}
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

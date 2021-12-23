---
title: Software Compatibility
layout: base
skip_toc: true
---

The Portmaster tries to stay out of your way so you can focus on your work or play. Since the Portmaster is in alpha, this is not always going to work out. We are collecting all reports of in/compatible software here.

### Community Reports

Help make the Portmaster better for everyone by [reporting your experience]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}).

<table>
  <thead>
    <tr>
      <th style="text-align: left"></th>
      <th style="text-align: left">OS</th>
      <th style="text-align: left">Status</th>
      <th style="text-align: center">Link</th>
    </tr>
  </thead>
  <tbody>
		{% assign apps = site.data.compatibility.software | sort_natural: "name" %}
		{% for app in apps %}
			{% assign reports = app.reports | sort_natural: "os" %}
			{% for report in reports %}
				<tr>
		      <td style="text-align: left">{% if forloop.index == 1 %}{{ app.name }}{% endif %}</td>
		      <td style="text-align: left"><i class="fab fa-{{ report.os }}"></i></td>
		      <td style="text-align: left">
						{{ report.state }}
					</td>
		      <td style="text-align: center"><a href="https://github.com/safing/portmaster/issues/{{ report.issue_number }}{% if report.issue_comment %}#issuecomment-{{ report.issue_comment }}{% endif %}">#{{ report.issue_number }}</a></td>
		    </tr>
			{% endfor %}
		{% endfor %}
  </tbody>
</table>

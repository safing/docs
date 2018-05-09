---
title: FAQ
section: misc
order: 2
layout: base
---

{% for entry in site.data.faq %}
<h4 style="padding-top: 20px;">{{ entry.question }}</h4>

{{ entry.answer }}

{% endfor %}

---
title: Frequently Asked Questions
layout: base
skip_toc: true
---

The FAQ section is work in progress.  
You can your browser search on this page or [search through all entries on GitHub](https://github.com/issues?q=archived%3Afalse+user%3Asafing+sort%3Aupdated-desc+label%3Afaq).

{%- for category in site.data.faq.config.categories %}

### {{ category }}

{%- for faq in site.data.faq.all -%}
{%- assign title = faq.title | remove_first: "FAQ: " -%}
{%- capture url -%}#{{ faq.title | remove_first: "FAQ: " | slugify }}{%- endcapture -%}
{%- if faq.categories contains category %}
- [{{ title }}]({{ url }})
{%- endif -%}
{%- endfor %}

{%- endfor %}

{%- for category in site.data.faq.config.categories -%}
{%- for faq in site.data.faq.all -%}
{%- if faq.categories contains category %}

<br><br><br><br><br>

# {{ faq.title | remove_first: "FAQ: " }}

<div class="text-right">
  <a href="{{ faq.html_url }}">View on GitHub</a>
</div>

<!-- TODO: Using hidden keywords for now, so entries can be found better. The UX is bit weird though. -->
<div class="hidden-keywords">
  <span>
    Keywords: {{ faq.keywords | join: ", " }}
  </span>
</div>

{{ faq.body | split: "---" | first }}

{%- endif -%}
{%- endfor -%}
{%- endfor %}


<style>
/* Fix some styling. TODO: Cleanup. */
.content p img {
  margin-top: 1rem !important;
  margin-bottom: 1rem !important;
  transform: none !important;
  --transform-scale-x: 0 !important;
  --transform-scale-y: 0 !important;
}
</style>

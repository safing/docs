{%- for faq in site.data.faq.all -%}
  {%- assign title = faq.title | remove_first: "FAQ: " -%}
  {%- capture url -%}{{ site.url }}{{ site.faq_url }}#{{ faq.title | remove_first: "FAQ: " | slugify }}{%- endcapture -%}
  {%- if include.textformat %}
{{ title }} - {{ url }}
  {%- else %}
- [{{ title }}]({{ url }})
  {%- endif -%}
{%- endfor -%}

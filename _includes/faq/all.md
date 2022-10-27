{%- for faq in site.data.faq.all -%}
  {%- if include.textformat %}
{{ faq.title | remove_first: "FAQ: " }} - {{ faq.url }}
  {%- else %}
- [{{ faq.title | remove_first: "FAQ: " }}]({{ faq.url }})
  {%- endif -%}
{%- endfor -%}

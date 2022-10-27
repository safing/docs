{% for category in site.data.faq.config.categories %}

{% if include.textformat %}
{{ category }}
{% else %}
#### {{ category }}
{% endif -%}

  {%- for faq in site.data.faq.all -%}

    {%- if faq.categories contains category -%}
      {%- if include.textformat %}
{{ faq.title | remove_first: "FAQ: " }} - {{ faq.url }}
      {%- else %}
- [{{ faq.title | remove_first: "FAQ: " }}]({{ faq.url }})
      {%- endif -%}
    {%- endif -%}

  {%- endfor -%}

{%- endfor %}

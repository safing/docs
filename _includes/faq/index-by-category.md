{% for category in site.data.faq.config.categories %}

{% if include.textformat %}
{{ category }}
{% else %}
#### {{ category }}
{% endif -%}

  {%- for faq in site.data.faq.all -%}

    {%- if faq.categories contains category -%}
      {%- assign title = faq.title | remove_first: "FAQ: " -%}
      {%- capture url -%}{{ site.url }}{{ site.faq_url }}#{{ faq.title | remove_first: "FAQ: " | slugify }}{%- endcapture -%}
      {%- if include.textformat %}
{{ title }} - {{ url }}
      {%- else %}
- [{{ title }}]({{ url }})
      {%- endif -%}
    {%- endif -%}

  {%- endfor -%}

{%- endfor %}

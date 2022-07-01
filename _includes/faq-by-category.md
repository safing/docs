{% for category in site.data.faq-config.categories %}

{% if include.textformat %}
{{ category }}
{% else %}
#### {{ category }}
{% endif -%}

  {%- for faq in site.data.faq-data -%}

    {%- assign entryCategories = "" -%}
    {%- assign splittedBody = faq.body | split: "---" -%}
    {%- if splittedBody.size >= 2 -%}
      {%- assign splittedMetaSection = splittedBody | last | split: "Categories: " -%}
      {%- if splittedMetaSection.size >= 2 -%}
        {%- assign entryCategories = splittedMetaSection | last -%}
      {%- endif -%}
    {%- endif -%}

    {%- if entryCategories != "" and entryCategories contains category -%}
      {%- if include.textformat %}
{{ faq.title | remove_first: "FAQ: " }} - {{ faq.url }}
      {%- else %}
- [{{ faq.title | remove_first: "FAQ: " }}]({{ faq.url }})
      {%- endif -%}
    {%- endif -%}

  {%- endfor -%}
{%- endfor %}

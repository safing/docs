---
title: Portmaster Developer API
layout: base
skip_toc: true
---

This page lists all API endpoints of the Portmaster.

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
      This page is very much in progress and may not be fully accurate and up to date.  
      If you plan to develop something that interacts with the Portmaster, we'd love to hear from you and talk about it!
    </p>
</div>

Some endpoints require authentication, which is handled with {% include setting/ref.html key="core/apiKeys" %}. You can use an API key in a `Basic` or `Bearer` HTTP `Authorization` Header. [](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)

For development, you may also enable the {% include setting/ref.html key="core/devMode" %}, which disables authentication and gives you full access. Cross-origin requests are not allowed.

{:.tag-explainers}
|Badge|Meaning|
|:--|:--|
|<span class="setting-badge key"><i class="fa fa-key"></i> User</span>|Endpoint requires User privileges.|
|<span class="setting-badge key"><i class="fa fa-key"></i> Admin</span>|Endpoint requires Admin privileges.|
|<span class="setting-badge key"><i class="fa fa-key"></i> Internal</span>|Endpoint can only be used by the Portmaster itself.|
|<span class="header-anchor-style"><i class="fab fa-lg fa-markdown"></i></span>|When hovering over a setting name - copy its name and URL formatted in markdown. This requires JavaScript.|

<div class="settingslist">

  <!-- Static entry for the database API. -->  
  <div class="setting">
    <h5 id="database/v1" class="header">
      <span class="second header-anchor hide-no-js"
        onclick="navigator.clipboard.writeText('[Database Websocket API]({{ site.url }}{{ site.portmaster_api_url }}#database/v1)')">
        <i class="fab fa-markdown hide-no-js"></i>
      </span>
      Database Websocket API
      <small>
        <span class="setting-badge key"><i class="fa fa-key"></i> Admin</span>
      </small>
    </h5>

    <p style="background: #eee; padding: 7px; border-radius: 2px;">
      <code>[WEBSOCKET] /api/database/v1</code>
      <br>
    </p>

    <p>
      The websocket interface is not yet documented in a processable format. Please refer to the Portmaster Console App for more information and testing:<br>
      <a href="http://127.0.0.1:817/ui/modules/console/">http://127.0.0.1:817/ui/modules/console/</a> (Requires {% include setting/ref.html key="core/devMode" %})
    </p>
  </div>

{% for endpoint in site.data.portmaster-api %}
  <div class="setting">
    <h5 id="v1/{{ endpoint.Path }}" class="header">
      <span class="second header-anchor hide-no-js"
        onclick="navigator.clipboard.writeText('[{{ endpoint.Name }}]({{ site.url }}{{ site.portmaster_api_url }}#v1/{{ endpoint.Path }})')">
        <i class="fab fa-markdown hide-no-js"></i>
      </span>
      {{ endpoint.Name }}
      {% if endpoint.Read > 1 %}
      <small>
        {% if endpoint.Read == 2 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> User</span>
        {% elsif endpoint.Read == 3 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> Admin</span>
        {% elsif endpoint.Read == 4 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> Internal</span>
        {% endif %}
      </small>
      {% endif %}
      {% if endpoint.Write > 1 %}
      <small>
        {% if endpoint.Write == 2 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> User</span>
        {% elsif endpoint.Write == 3 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> Admin</span>
        {% elsif endpoint.Write == 4 %}
          <span class="setting-badge key"><i class="fa fa-key"></i> Internal</span>
        {% endif %}
      </small>
      {% endif %}
    </h5>

    <p style="background: #eee; padding: 7px; border-radius: 2px;">
      {% if endpoint.Read and endpoint.Read != 0 %}
        <code>{{ endpoint.ReadMethod | default: "GET" }} /api/v1/{{ endpoint.Path }}</code>
        <br>
      {% endif %}

      {% if endpoint.Write and endpoint.Write != 0 %}
        <code>{{ endpoint.WriteMethod | default: "POST" }} /api/v1/{{ endpoint.Path }}</code>
        <br>
      {% endif %}

      {% if endpoint.MimeType %}
        returns <code>{{ endpoint.MimeType }}</code> data
        <br>
      {% endif %}
    </p>

    {{ endpoint.Description | markdownify }}

    {% if endpoint.Parameters %}
      <h6>Parameters:</h6>
      <ul>
      {% for parameter in endpoint.Parameters %}
        <li>
          <code>{{ parameter.Field }}</code>
          <ul>
            <li>Method: {{ parameter.Method }}</li>
            <li>Value: <code>{{ parameter.Value | escape }}</code></li>
            <li>Description: {{ parameter.Description | escape }}</li>
          </ul>
        </li>
      {% endfor %}
      </ul>
    {% endif %}

  </div>
{% endfor %}
</div>

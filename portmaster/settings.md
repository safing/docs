---
title: Settings Handbook
layout: base
skip_toc: true
---

This page lists all settings of the Portmaster.

{:.tag-explainers}
|Badge|Meaning|
|--:|:--|
|<span class="setting-badge global"><i class="fa fa-globe"></i> Global</span>|Setting is configured globally.|
|<span class="setting-badge per-app"><i class="far fa-dot-circle"></i> Per App</span>|Setting is configurable per app, but also has a configurable global default.|
|<span class="setting-badge restart"><i class="fa fa-sync-alt"></i> Requires Restart</span>|Setting requires a restart of the Portmaster to take effect.|
|<span class="setting-badge stackable"><i class="fa fa-layer-group"></i> Stackable</span>|Per-app setting that does not replace the global default, but adds to it.|
|<span class="setting-badge advanced">Advanced</span>|Setting is only visible in the Portmaster if the [UI Mode](#core/expertiseLevel) is set to Advanced.|
|<span class="setting-badge developer">Developer</span>|Setting is only visible in the Portmaster if the [UI Mode](#core/expertiseLevel) is set to Developer. Be careful, you could break things!|
|<span class="setting-badge beta">Beta</span>|Setting is not deemed to be stable yet.|
|<span class="setting-badge experimental">Experimental</span>|Setting is meant for experiments and debugging. Be careful, you could break things!|
|<span class="setting-badge key">setting/key</span>|Internal identifier of the setting. These are also used as anchors in order to directly link to a setting on this page.|

{% include setting/list.html prefix="" expertise=2 release=2 manual=true dev=true %}

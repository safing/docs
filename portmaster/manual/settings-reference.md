---
title: Settings Reference
layout: base
---

This page lists all settings of the Portmaster.

|Badge|Meaning|
|--:|:--|
|<span class="setting-badge"><i class="fa fa-globe"></i> Global</span>|Setting is configured globally.|
|<span class="setting-badge"><i class="fa fa-user-circle"></i> Per App</span>|Setting is configurable per app, but also has a global default.|
|<span class="setting-badge info"><i class="fa fa-refresh"></i> Requires Restart</span>|Setting requires a restart of the Portmaster to take effect.|
|<span class="setting-badge info"><i class="fa fa-bars"></i> Stackable</span>|Per-app setting that does not replace the global default, but adds to it.|
|<span class="setting-badge warn"><i class="fa fa-wrench"></i> Advanced</span>|Setting is only visible in the Portmaster if the UI Mode is set to Advanced.|
|<span class="setting-badge dev"><i class="fa fa-flask"></i> Developer</span>|Setting is only visible in the Portmaster if the UI Mode is set to Developer. Be careful, you could break things!|
|<span class="setting-badge warn"><i class="fa fa-wrench"></i> Beta</span>|Setting is not deemed to be stable yet.|
|<span class="setting-badge dev"><i class="fa fa-flask"></i> Experimental</span>|Setting is meant for experiments and debugging. Be careful, you could break things!|
|<span class="setting-badge key"><i class="fa fa-code"></i> setting/key</span>|Internal identifier of the setting. These are also used as anchors in order to directly link to a setting on this page.|

{% include setting/list.html prefix="" expertise=2 release=2 manual=true dev=true %}

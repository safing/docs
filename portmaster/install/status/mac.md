---
title: Status of Mac
layout: base
---

<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
    The Portmaster is currently not available for macOS.
  </p>
</div>

A release on all three major desktop platforms, including macOS, was planned from the beginning.
We started out with Linux support mainly because it was so easy and quick to do and then had to prioritize as we are a small team with limited capacity.
We opted for Windows as it is the dominant platform - and arguably the one with more privacy issues.
Now, let us look at where things currently stand with macOS:

### In 2018 Apple Deprecated Classic Kernel Extensions

Initially, we wanted to support macOS very soon after launch.
In 2018, during development of the Linux and Windows versions, Apple started hinting that they will start phasing out "classic" kernel extensions and started to replace them with specialized frameworks with a much narrower interface called "System Extensions".
Our dear fellow Austrians from [objective development](https://obdev.at/) - the makers of the Little Snitch firewall -  voiced their concerns about these new extensions very early in the Apple developer forums, as the new "Network Extension" framework initially did non even support firewalls.

With these changes in sight, we decided that it was not a good idea to jump into macOS at the time, as building a kernel extension would have been a short-lived success. A good amount of time later, Apple did respond to the raised concerns and added the needed functionality for implementing firewalls with the Network Extension framework.

### Apple Circumvented Network Extensions for Certain Apps and Only Stopped After An Uproar

When the dust settled over that issue, something very curious happened.
In October 2020, macOS started bypassing 3rd party firewall apps, which have all switched to the new framework.
This was [first noticed by Twitter user @mxswd](https://twitter.com/mxswd/status/1318305284524183552) and then [investigated by macOS security researcher Patrick Wardle](https://twitter.com/patrickwardle/status/1318437929497235457).
Patrick is the creator of the macOS application firewall [LuLu](https://github.com/objective-see/LuLu/), which was also affected by this.
There was quite an uproar and Apple did not seem to care a lot at first.

Later, in January 2021, Apple intervened by removing the bypass mechanism.
It is unclear if the whole thing was just an oversight when merging their iOS and macOS platform codebases or if it was an intentional step all along.

No matter which way, these two examples show the power that Apple executes over its platform. It also shows the uncertainties and challenges that developers face who want to put you back in control of your own device.

### Still We Will Invest Into MacOS Once We Have the Resources

No matter the difficulties we expect, we know that there are many people using macOS for various reasons.
And our vision to bring privacy to everyone naturally also includes macOS users.

We will continue to monitor the situation and as soon as we have the resources, we will start investing into this direction more actively.

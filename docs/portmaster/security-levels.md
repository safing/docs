---
title: Security Levels
section: portmaster
order: 2
layout: base
---

Security Levels give you an easy and quick way to adapt to different environments and quickly react to threats.

<h3>
  <img src="/assets/icons/level_dynamic.svg" style="height: 2rem; margin-top: -5px;">
  Dynamic
</h3>

The usual operating mode - for trusted environments. Privacy protections are activated, but may tend to underblock.

<h3>
  <img src="/assets/icons/level_secure.svg" style="height: 2rem; margin-top: -5px;">
  Secure
</h3>

This mode is for untrusted environments, like a café's Wi-Fi. This mode is meant for situations where more privacy is needed and may tend to overblock.

<h3>
  <img src="/assets/icons/level_fortress.svg" style="height: 2rem; margin-top: -5px;">
  Fortress
</h3>

This is the emergency mode and should be used in highly untrusted environments, or if an attack is imminent or in progress (_You clicked on that link, didn't you..._). This mode will activate all available mechanisms to keep you safe and will undoubtedly overblock and break applications. It is meant as a small band-aid until an expert can verify that everything is ok (_...and that the link you clicked didn't do anything nasty_).

## Autopilot

To assist you in choosing the correct mode for different situations, the Portmaster will detect threats and set the Security Level accordingly, as well as notify the user about what is happening. If you do not agree with what the Portmaster is doing, you can simply override the Security Level. To learn more about attack detection, refer to [Advanced Inspection](/docs/portmaster/advanced-inspection.html).

## Configuration

How the Security Levels behave and what features are activated can be configured in the Portmaster settings. Please note that certain features cannot be turned off in the Fortress mode in order to prevent misconfiguration and provide the same _Fortress_ experience across installations for when you are using another's computer or assisting with tech support.

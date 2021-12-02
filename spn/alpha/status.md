---
title: Broader Testing Phase - Status
layout: base
---

<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
    <b>
      Please be aware that there are not enough users and servers during this testing phase in order to protect you from trivial VPN traffic analysis. Treat the SPN as a VPN in your threat model for now.
    </b>
  </p>
</div>

<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
    <b>Last Updated on 11th October, 2021</b>
  </p>
</div>

### How Can I Activate the SPN "Broader Testing" Phase?

- [read the blog post](https://safing.io/blog/2021/10/01/spn-enters-broader-testing-phase/) to see if you are eligible
- [log in](https://account.safing.io) to your Safing account to receive your access code
- in the Portmaster App
  - switch to the "Advanced" [UI Mode](https://docs.safing.io/portmaster/settings#core/expertiseLevel) in the top right corner
  - in the global settings, switch your [Release Channel](https://docs.safing.io/portmaster/settings#core/releaseChannel) to "Beta"
    - Restart the Portmaster and Reload the UI
    - You should now see a yellow "BETA" at the top of your global settings, next to the restart button
  - [Enable](https://docs.safing.io/portmaster/settings#spn/enable) the SPN
  - enter your [Special Access Code](https://docs.safing.io/portmaster/settings#spn/specialAccessCode)
  - configure the [Use SPN](https://docs.safing.io/portmaster/settings#spn/useSPN) setting globally and for different apps, depending on your needs

### How Can I Test that the SPN Is Running?

- Go to <https://duckduckgo.com/?q=what+is+my+ip> to see your current IP address before activating the SPN
- Enable the SPN
- [Reload DuckDuckGo](https://duckduckgo.com/?q=what+is+my+ip) and check if the IP address has changed
- Bonus Step: Visit some of the "what is my IP" websites, your IP address should change frequently (based on the destination server location)

### Normally Works Well - Report if Broken [](https://github.com/safing/spn/issues)

- Portmaster Client successfully connects to the SPN
- Normal browsing of websites
- Big file downloads
- Video streaming
- Low Bandwidth: up to 5MBit/s

### Under Investigation - Please Test and Report [](https://github.com/safing/spn/issues)

- Video Conferencing
- Protected Video Streams
- UDP based applications
- Medium Bandwidth: targeting 30MBit/s as next step

### Under Construction

- Connecting to the SPN via Portmaster is currently very basic, new views _showing_ what the SPN is currently doing are being designed and developed
- we will add instructions for how to test that the SPN is working on your device to the docs before October 12th

### Known Issues

- The SPN re-uses connections to nodes. Due to missing route evaluation during routing calculation we currently cannot guarantee the minimum three hops.
- Speeds might vary greatly as we do not know the resource profile of the SPN yet.
- The SPN seems to be failing after sleep/suspend. Investigating. Disable/Enable SPN as a workaround.
- For stability, the client is artificially more sequential in order to provide more stability. This might lead to lag when lots of connections are initiated at the same time. Eg. when browsing to "big" websites.

### How To Report Bugs

Bugs can be reported on the [SPN repository on GitHub](https://github.com/safing/spn/issues)

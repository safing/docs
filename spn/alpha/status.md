---
title: SPN Alpha - Status
layout: base
redirect_from:
  - /spn/broader-testing/status
---

<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
    <b>
      Treat the SPN as a VPN in your threat model for now. Please be aware that there are not enough users and servers during the alpha phase in order to protect you from VPN traffic analysis.
    </b>
  </p>
</div>

<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
    <b>Last Updated on 2nd December, 2021</b>
  </p>
</div>

### Normally Works Well - Report if Broken [](https://github.com/safing/spn/issues)

- Login on Portmaster Client successfully connects to the SPN
- Normal browsing of websites
- Big file downloads
- Video streaming
- Low Bandwidth: up to 5MBit/s

### Under Investigation - Please Test and Report [](https://github.com/safing/spn/issues)

- Video Conferencing
- Protected Video Streams
- UDP based applications
- Medium Bandwidth: targeting 30MBit/s as next step

### Known Issues

- The SPN re-uses connections to nodes. Due to missing route evaluation during routing calculation we currently cannot guarantee the minimum three hops.
- Speeds might vary greatly as we do not know the resource profile of the SPN yet.
- The SPN seems to be failing after sleep/suspend. Investigating. Reconnect to the SPN as a workaround.
- For stability, the client is artificially more sequential in order to provide more stability. This might lead to lag when lots of connections are initiated at the same time. Eg. when browsing to "big" websites.

### How To Report Bugs

Bugs can be reported on the [SPN repository on GitHub](https://github.com/safing/spn/issues)

---
title: Broader Testing Phase - Status
layout: base
---


<div class="notification-warning">
  <img src="/assets/img/icons/info.svg">
  <p>
		<b>Last Updated on 1st October, 2021</b>
  </p>
</div>

<!-- Missing: ### How Can I Test that the SPN Is Running?

- browse pages that show current IP / what is my IP, etc.
-->

### Normally Works Well
- Portmaster Client successfully connects to the SPN
- Normal browsing of websites

### Under Investigation

#### Linux Works Better Than Windows

We know that Windows is less stable than Linux. Reasons for this likely come from the Windows Kernel Extension. Investigations have already started and upgrades are scheduled.

#### Other

- Big file downloads
- Video streaming
- UDP based applications

### Under Construction

- Connecting to the SPN via Portmaster is currently very basic, new views _showing_ what the SPN is currently doing are being designed and developed
- we will add instructions for how to test that the SPN is working on your device to the docs before October 12th

### Known Issues

- The SPN re-uses connections to nodes. Due to missing route evaluation during routing calculation we currently cannot guarantee the minimum three hops.
- Speeds might vary greatly as we do not know the resource profile of the SPN yet.
- The SPN seems to be failing after sleep/suspend. Investigating. Disable/Enable SPN as a workaround.
- We're leaking open file descriptors somewhere, which also affects Portmaster after some time. Restart Portmaster as a workaround.
- For stability, the client is artificially more sequential in order to provide more stability. This might lead to lag when lots of connections are initiated at the same time. Eg. when browsing to "big" websites.

### How To Report Bugs

Bugs can be reported on the [SPN repository on GitHub](https://github.com/safing/spn/issues)

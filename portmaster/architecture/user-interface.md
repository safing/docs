---
title: User Interface
layout: base
skip_toc: true
---

The Portmaster UI is the main way you interact with the Portmaster Application. It connects to the Portmaster Core Service, which is running in the background. Through the Portmaster UI you can easily monitor network activity on your device, block domains and connections as well as configure settings and rules.

The Portmaster UI has no background activity. Instead, background interaction is being take care of the Notifier.

_Extended documentation of the Portmaster UI are yet to be written. You can [check out its source code](https://github.com/safing/portmaster-ui/) in the mean time._

##### FAQ

###### Why do you use Electron for the User Interface?

The Portmaster UI was previously built with Go, acting as a base layer which then loaded a OS-provided webview for the UI.
Unfortunately, the OS-provided webview had many issues which forced us to rethink and re-write the UI.

While planning this re-write, we did invest a lot of time to research different approaches.
Sadly, at that point, our evaluation concluded that using anything but Electron would require us to invest a lot of time and effort:
We would either have to build a viable solution from scratch or bend over enough to fit into existing ones.

Spending these resources on the UI would have slowed us down massively elsewhere, so we chose to go with Electron.

We are not happy about Electron and only see it as a mid-term solution.
We plan to migrate to a better solution in the long run, as [mentioned in our Backlog](https://safing.io/backlog/#portmaster) on the card "Ditch Electron".

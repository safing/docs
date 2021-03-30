---
title: User Interface
layout: base
---

The Portmaster UI is the main way you interact with the Portmaster Application. It connects to the Portmaster Core Service, which is running in the background. Through the Portmaster UI you can easily monitor network activity on your device, block domains and connections as well as configure settings and rules.

The Portmaster UI has no background activity in order to save your precious computing resources. Background interaction is being take care of the Notifier.

_Extended documentation of the Portmaster UI are yet to be written. You can [check out its source code](https://github.com/safing/portmaster-ui/) in the mean time._

### Technologies

For the Notifier we use a small and light Go program, that interacts with both the Core Service and the OS where needed.

The Portmaster UI was previously also build with Go, acting as a base layer that then loads a OS-provided webview that then loads and runs the actual UI, which is served from the Core Service.

Unfortunately, the OS-provided webview had many problems and we were somewhat forced to mitigate the issues by switching to electron - the desktop app platform that everyone hates, including us.
The sad part is that there is no viable alternative to it - and yes, we took a lot our time to be certain of that.
At the point of the switch we were not able to invest the needed resources in order to build a viable solution or bend over enough to fit existing ones.
Rest assured that we want the Portmaster UI to move away from electron as much as you do and we will do it once we have the resources and the way.

---
title: Port17
pagetitle: Introduction to Port17
section: guides
order: 2
layout: base
---

<div class="alert alert-warning" role="alert">
  Port17 is currently still in Tech-Preview phase. When trying out the technology, please keep this in mind - it may be a bit rough around the edges. Also, only the base features are implemented - the UI (and this guide) hint at many other features that are not yet implemented.
</div>

## Installation

In the Tech-Preview phase, we do not yet provide a full installer, as it is not yet meant to be run 24/7. When you download the installer package, there is a small script that will start the daemon, user interface and notification bar agent, if available.

Please a keep a close eye on the console output of the daemon, as it will show you what it is doing and if there are any problems.

## Testing

As we do not yet provide a network for Port17 testing, you will have to create your own. This is easiest done with Docker. In the `safing-core` repo you can find a small guide and readme in the directory `port17/testing/simple` to get started.

You can then start the Portmaster with Port17 on the host and connect it to the network using the `-bootstrap` parameter to give the daemon the IP address of an initial Port17 it will connect to.

If you do not feel tech savvy enough, we would recommend to wait for the alpha release, which will also feature a ready-to-use test network with several Port17 nodes.

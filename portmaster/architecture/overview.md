---
title: Overview
layout: base
---

1. Numbered
{:toc}

##### Introduction

Before diving into details it is important to understand the big picture.
As any machine, the Portmaster Application has many parts and gears that have to work together seamlessly to deliver the privacy you deserve.
Take a look:

![Portmaster Architecture Overview](/assets/img/portmaster-architecture-diagram-simple.png)

### Portmaster Core Service

The Portmaster Core Service is where all the magic happens.
It consistently runs in the background, tirelessly protecting your privacy and keeping tabs on everything that is going in and out of your system.
As a system service it starts together with your device and ensures your privacy from the second you start working.

The Portmaster Core Service is divided into modules, which allows you to easily adapt the Portmaster Application to your preferences and threat model. You can dive deeper into each Module and explore its underlying tech.

- [**Fundamentals**\*: Provides all the basic internals.](../modules/fundamentals/)
- [**Core**\*: Integrates with the Operating System to get you back in control.](../modules/core/)
- [**Secure DNS**\*: Secures one of the most important types of traffic: DNS Requests.](../modules/secure-dns/)
- [**Privacy Filter**: Protects your privacy by blocking unwanted connections.](../modules/privacy-filter/)
- [**Safing Privacy Network**: A powerful VPN alternative.](../modules/spn/)

<small>\*Mandatory Module</small>

### Portmaster User Interface

The Portmaster UI is the main way you interact with the Portmaster Application. It connects to the Portmaster Core Service, which is running in the background. Through the Portmaster UI you can easily monitor network activity on your device, block domains and connections as well as configure settings and rules.

The Portmaster UI has no background activity in order to save your precious computing resources. Background interaction is being take care of the Notifier.

_Extended documentation of the Portmaster UI are yet to be written. You can [check out its source code](https://github.com/safing/portmaster-ui/) in the mean time._

### Notifier

The Notifier is a small utility that lives in your system's tray or menu bar. It continually signals you the status of the Portmaster Core Service via colored status indicators in the icon. If you have Desktop Notifications enabled, the notifier takes care of relaying them to your operating system.

You do not have to open the full Portmaster UI for more details or to make changes: If something goes wrong, you can get a first impression of what is going on by clicking the icon to open the menu. There you can quickly react to changed circumstances and switch your network rating.

_Extended documentation of the Notifier are yet to be written. You can [check out its source code](https://github.com/safing/portmaster-ui/tree/develop/notifier) in the mean time._

### OS Integration / Kext

The Portmaster Core Service cannot do all this magic by itself.
It works closely together with the Operating System's Core - the Kernel.

On Windows, this even requires that one part of the Portmaster Application runs directly within the OS Kernel itself, making it very powerful.

[Dive into how the how the Portmaster Application integrates with different Operating Systems.](../os-integration/)

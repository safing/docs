---
title: Portmaster
pagetitle: Introduction to Portmaster
section: guides
order: 1
layout: base
---

<div class="alert alert-warning" role="alert">
  The Portmaster is currently still in Tech-Preview phase. When trying out the technology, please keep this in mind - it may be a bit rough around the edges. Also, only the base features are implemented - the UI (and this guide) hint at many other features that are not yet implemented.
</div>

## Installation

In the Tech-Preview phase, we do not yet provide a full installer, as it is not yet meant to be run 24/7. When you download the installer package, there is a small script that will start the daemon, user interface and notification bar agent, if available.

Please a keep a close eye on the console output of the daemon, as it will show you what it is doing and if there are any problems.

## Basics: Security Levels and Application Profiles

The two things you should know about Portmaster when testing the software are:

### 1. Security Levels

There are three security levels

__Dynamic__  
Regular mode - provides additional security measures to protect your privacy, but will also try to not be in your way to help you stay focused. Use this mode in trusted networks.

__Secure__  
Heightend security measures - to keep you safe in untrusted environments. It is automatically activated if you enter an unknown network, like a café's Wi-Fi, or if an attack is detected. Use this mode when you do not trust a network, or are temporarily in need of more security.

__Fortress__  
All protective mechanisms available are activated. This will most likely cut off at least some applications from the Internet, but provides best protection technically possible. Use this mode if you think you are currently being attacked, like having clicked on a possible virus.

These Levels also influence which other features are activated. Check out the settings tab in the UI to see (planned) features are set in which security levels they should be active!

### 2. Application Profiles

Application Profiles are how you can control which application is allowed to connect to the Internet and how. Applications are matched by their installation path - be sure to have to path to the binary right to have a Profile applied (you can check the logs or the monitor tab in the UI).

#### Properties

All of the properties are explained where they are appear on settings page (press the small _i_ icon), so only the most important parts are covered here:

- __Security Level:__ Define the minimum Security Level (and it's configured features) that should be applied with this Profile.
- __Domain Whitelist__: Define a domain whitelist for this Profile, connections to all other domains will be denied.
- __ConnectPorts:__: Define a whitelist of remote TCP/UDP ports that applications are allowed to connect to.
- __ListenPorts:__: Define a whitelist of local TCP/UDP ports applications may listen on. Please note that the `Service` Flag needs to be set in order to allow listening at all.

#### Flags

Flags are an easy way to require or constraint to an application to a certain behavior.

- Executing User
  - __System:__ System apps must be run by system user, else deny
  - __Admin:__ Admin apps must be run by user with admin privileges, else deny
  - __User:__ User apps must be run by user (identified by having an active safing UI), else deny
- Network Scope
  - __Internet:__ Internet apps may connect to the Internet, if unset, all connections to the Internet are denied
  - __LocalNet:__ LocalNet apps may connect to the local network (i.e. private IP address spaces), if unset, all connections to the local network are denied
- Network Destinations
  - __Strict:__ Strict apps may only connect to domains that are related to themselves
  - __Gateway:__ Gateway apps will connect to user-defined servers
  - __Service:__ Service apps may accept incoming connections

#### Default Profiles

Because it is infeasible to have a separate Application Profile for every program you directly or indirectly use, you can also define a Profile for whole folders. These Profiles are called `Default` Profiles and are matched on a path prefix basis instead of an exact match basis.

## User Interface

When starting the Tech-Preview version for the first time, the UI should open automatically. There you can change settings, view and edit application profiles and monitor current connections.

## Inspection

There is already the option to have Portmaster check TLS validity of connections, but this module is not currently part of the Tech-Preview as it is not a core feature and needs more time for refinement. If you want to check it out, you can easily compile a version with it included by using an empty import `_ "githu...` on the Golang package in the main Golang file.

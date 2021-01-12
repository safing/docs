---
title: Core
layout: base
---

1. TOC
{:toc}

##### Module Management

{% include code_ref.html godoc_portbase_1="modules" godoc_portbase_2="modules/subsystems" %}

In order to maintain a clear concept and code structure, the Portmaster Core Service is split up into many modules. Everything that serves a distinct purpose usually is a separate module. This keeps the code clean and makes it easier to build and maintain high quality software.

The module management is responsible for preparing, starting and stopping all modules in the correct order and also provides utilities to safeguard module operation. These allow a module to quickly start a secure worker or a repeating task. The module manager can then schedule tasks and correctly wait for every bit to properly stop when shutting down.

For convenience, multiple small modules are bundled into big modules - such as "Privacy Filter", "Secure DNS", etc. In the code these "Big Modules" are referred to as `Subsystems`, while in marketing and other high level context they are simply called "Modules".

##### Logging

{% include code_ref.html godoc_portbase="log" %}

Writing logs is vital for understanding what is going on and is of tremendous help when trying to identify what is going wrong.

It uses a leveled log system in order to regulate the amount of information saved. On the `trace` level, it can also attach logs to a context, which are then written in a batch in order to clunk logs of one operation together. This is especially useful, as the Portmaster Core Service is highly concurrent and it can otherwise be hard to attribute log lines to a certain operation.

The log level can be configured by setting the cmdline argument `--log` to one of `trace`, `debug`, `info`, `warning`, `error` or `critical`.

This is what logs could look like:
```
210112 12:58:38.691 er/storage:096 ▶ DEBU 013 updates: loaded index stable.json
210112 12:58:38.700 api/router:065 ▶ INFO 050 api: starting to listen on 127.0.0.1:817
210112 12:59:19.785 connection:539 ▶ INFO 723 filter: connection user:/usr/lib/firefox/firefox:2854 to www.orf.at. ([REDACTED]) accepted: default permit Σ=7.728613ms
            6.114µs terception:092 ▶ TRAC     filter: handling packet: OUT TCP [REDACTED]
         4.344452ms ocess/find:022 ▶ TRAC     process: getting pid from system network state
            6.696µs ss/process:095 ▶ TRAC     process: getting process for PID 2854
           21.753µs ss/profile:025 ▶ TRAC     process: profile already loaded
           39.661µs terception:102 ▶ TRAC     filter: created new connection [REDACTED]
            5.436µs terception:234 ▶ TRAC     filter: handing over to connection-based handler
            9.038µs terception:271 ▶ TRAC     filter: starting decision process
          169.189µs tel/entity:300 ▶ TRAC     intel: CNAME filtering enabled, checking [] too
            4.986µs tel/entity:317 ▶ TRAC     intel: loading domain list for www.orf.at.
         2.982395ms tel/entity:317 ▶ TRAC     intel: loading domain list for orf.at.
            10.52µs tel/entity:371 ▶ TRAC     intel: loading ASN list for 5403
            4.124µs tel/entity:429 ▶ TRAC     intel: loading IP list for [REDACTED]
           22.082µs tel/entity:396 ▶ TRAC     intel: loading country list for AT
          102.167µs all/master:355 ▶ TRAC     filter: LMS score of eTLD+1 orf.at is 100.00
```

##### Data Root

{% include code_ref.html godoc_portbase="dataroot" github_portbase="utils/structure.go" %}

The Portmaster Application keeps everything it needs in a single directory. On Windows, this is `%APPDATA%\Safing\Portmaster` and on Linux it is `/var/lib/portmaster`.

The `dataroot` is not a module, but just a small utility that provides easy access to it. It uses the `DirStructure` utility to ensure that all the directories always have the correct file system permissions.

Note: Having everything structured into one directory has many practical advantages. However, we are aware that some operating systems do not like mixing live data (`databases`) with executables (`updates`). We are planning to improve on this in the future.

##### Configuration

{% include code_ref.html godoc_portbase="config" %}

This module is responsible for saving and processing user configuration. Via the Configuration Module, other modules can register settings or they can receive a settings' value and act upon it accordingly.

All global settings are saved in the `config.json` file located in the root data directory. The `config.json` file is read on start and written to on change.

Changes to settings go into effect immediately, unless otherwise noted.

###### Configuration Grouping

Every configuration item is categorized via two attributes. This enables the Portmaster UI to easily filter settings based on user preference. A user can hide advanced settings for more simplicity or show them for more control. The two attributes are:

**(1) User Interface Mode**

Indicates the technical complexity of a setting. The possible values are:

- **Simple** (`User`): A basic setting that is easy to understand.
- **Advanced** (`Expert`): A more complex setting that offers more control, but is not easy to understand without deeper technical knowledge.
- **Developer** (`Developer`): A complex settings that should only be used for development, testing or diagnostics. This setting may also break things.

Note: When complex settings are hidden, their configuration still stay in affect!

Note: In the code the "UI Mode" is called `ExpertiseLevel`.

**(2) Feature Stability**

Indicates the stability of a setting, or rather stability of the feature/functionality controlled by the setting. The possible values are:

- **Stable**: Functionality that has been tested well and is most probably going to work without a problem.
- **Beta**: Functionality that is has been tested to some extent, but is still considered unstable.
- **Experimental**: Functionality that has barely been tested or is not even finished, sometimes known to be broken to some extent.

Note: When moving from a more experimental to a less experimental Feature Stability Mode, not only will the Portmaster UI hide the beta/experimental features, but also will the Portmaster Core Service ignore the hidden, experimental settings and use their defaults instead. Only after moving back to Beta/Experimental will your defined settings come into affect again.

Note: In the code the "Feature Stability" is called `ReleaseLevel`.

Note: Some of the experimental settings are on by default, because turning them off is experimental, as it might be a crucial system. These settings exist for testing and diagnostics.

Note: Configurations can be overwritten by [App Settings](#app-settings)

##### API

{% include code_ref.html godoc_portbase="api" %}

The API provides an interface for all other software components, like the Portmaster UI, to interact with the Portmaster Core Service. Both the Portmaster UI and the Notifier (System Tray Applet) use the API to change settings and subscribe to data changes via the database API.

##### Database

{% include code_ref.html godoc_portbase="database" %}

The database module provides a persistence layer. This key/value storage provides a uniform interface to save, read and update data. It supports scoped data storages as well as virtual database backends.
The module also includes a simple permission layer to protect important assets.

There are included data interaction helpers for queries, bulk operations, subscribing to database changes and hooks. Read and write caching improves performance on slow devices.

###### List of Databases

The Portmaster Core Service uses these databases:

- `core`: Main storage for app settings.
- `cache`: For all data that is cached and can be automatically recovered if lost.
- `runtime`: Virtual database that exposes internal runtime data to benefit from the database layer features.
- `config`: Virtual database that gives easy access to configuration and associated metadata.
- `network`: Virtual database that exposes all the network activity for the monitoring in the App.

If you have the Development Mode enabled, you can access all the data in these database directly via the Dev Console, which is available at http://127.0.0.1:817/ui/modules/console/

##### Random Number Generator

{% include code_ref.html godoc_portbase="rng" %}

This module employs the [Fortuna PRNG](https://en.wikipedia.org/wiki/Fortuna_(PRNG)) by Ferguson and Schneier.

It sources randomness both from the standard OS interface as well as internal Portmaster Core Service modules, which can easily and safely ingest random data into the RNG. This ensures strong encryption in case of a weakness in the operating system's PRNG.  
Most prominently, the SPN will inject secret random data (eg. nonces or padding) received from SPN nodes.

The created randomness is then used by other modules wherever randomness is required. Examples are choosing random ports for DNS requests or generating secure cookies/access tokens.

##### Notifications

{% include code_ref.html godoc_portbase="notifications" %}

The notification module takes care of handling notifications: These range from informational messages to important, actionable items.

This module also takes care of connection prompts, even though they are displayed separately in the Portmaster UI.

On Windows, the Notifier (System Tray Applet) interfaces with the Windows Notification Center in order to display notifications via the native interface. We use [SnoreToast](https://github.com/KDE/snoretoast) as a helper for submitting notifications.

On Linux, the Notifier (System Tray Applet) sends notifications to the notification server [via D-BUS](https://specifications.freedesktop.org/notification-spec/latest/ar01s09.html), which is typically provided by your distribution.

Note: Desktop notifications can be disabled in the settings.

##### Update Framework

{% include code_ref.html godoc_portbase="updater" godoc_portmaster="updates" %}

The update system makes sure that all required resources are available and up to date. Resources include: executables, UI assets, filter lists.

The update system keeps track of available versions and automatically downloads new resource versions. Multiple versions are kept locally in case an upgrade breaks and needs a rollback.

The communication with the update server is _always_ encrypted and authenticated.

Note: In the future, all resources provided via the update framework will also be cryptographically signed as an additional layer of protection.

Currently, updates are checked for every hour. This frequency was chosen to stay up to date with the ever-changing landscape of malware/tracker/phishing domains managed by the various filter lists. Kudos to everyone doing excellent work in that field!

Note: You can always see the current active and available versions in the Portmaster UI.

##### UI Server

{% include code_ref.html godoc_portmaster="ui" %}

The UI Server module serves UI resources and assets locally on port `817`.

This is where the Portmaster User Interface gets its resources from - loading them directly from the Portmaster Core Service. Thus, with the Developer Mode enabled, you can also open the Portmaster UI in your browser if you prefer to do so via http://127.0.0.1:817/.

Please note that some (non-vital) features, such as Application icons on Windows will not work in the browser since they depend on the supplied Portmaster UI.

##### Status

{% include code_ref.html godoc_portmaster="status" %}

The Status Module keeps track of the currently set Network Rating. It also exposes network environment information received from the [Network Environment module](#network-environment), such as the current online status and detected captive portals.

####### Interpreting Configurations

As the Status Module always knows about the current Network Rating, it helps other modules interpret configurations as they themselves do not always know how to enact upon a setting.

As an example: if the setting to "Block Internet Access" is set to "Danger", another module will know about the set value "Danger" - but they will not know whether or not to currently block the Internet Access. They resolve this by asking the Status Module, which in return responds with instructions accordingly.

When "Block Internet Access" is set to "Danger", the Status Module responds with:

- If Network Rating is set to "Trusted": `False`, do not block Internet Access
- If Network Rating is set to "Untrusted": `False`, do not block Internet Access
- If Network Rating is set to "Danger": `True`, block Internet Access

##### Network Environment

{% include code_ref.html godoc_portmaster="netenv" %}

The Network Environment module keeps track of the network environment.

First, it monitors if the device is online. It receives hints by other modules if something might be amiss and then checks connectivity by resolving a test-domain. In that process it also detects if there is a captive portal that is intercepting HTTP requests and alerts the user about it.

It also provides information about the current Gateway/Router and Nameserver configured on the system. These may be either provided by DHCP or manually configured, which are indistinguishable to the Portmaster Core Service.

##### Network

{% include code_ref.html godoc_portmaster_1="network" godoc_portmaster_2="network/packet" godoc_portmaster_3="network/state" %}

This module manages information about network connections observed by the Portmaster Core Service, provides access to the system network state tables and can parse network packets.

In addition to just providing a lot of "glue code" for other modules, it is also responsible for handling connection inspection, where modules can take a closer look at network packets to help in the decision making.

The network state information is exposed via a virtual database.

##### Interception

{% include code_ref.html godoc_portmaster="firewall/interception" %}

The interception module varies heavily between the different platforms (operating systems). It has a single purpose: Feed observed network packets to the firewall and return decisions back to the system integration layer.

[Learn more about how the interception module interfaces with the network stack of the operating system at **OS Integration**](../../os-integration/).

##### Process

{% include code_ref.html godoc_portmaster="process" %}

The process module is responsible for attributing network packets to processes as well as gathering process information and maintaining their internal state.

##### App Settings

{% include code_ref.html godoc_portmaster="profile" %}

Note: Throughout the code, the App Settings are called profiles.

The App Settings Module is responsible for creating and managing profiles. It is the go-to place for other modules to ask about settings.

A profile is a collection of settings attached to a specific application or process. They are created automatically the first time an app/process is seen on the network. These profiles are created in the `local` scope and are currently bound to the path of the binary. Additionally, process information such as a human process name are gathered and attached to the profile.

Being the repository of all these profiles, the App Settings Module is the go-to place for other modules to ask about settings.

An example might be: "Is process XYZ allowed to connect to the Internet?". After retrieving this query, the App Settings Module will lookup the profile of XYZ and return its value for the config. Or if no value is set, it will fallback and retrieve the global settings' value.

Changes to profiles are immediately applied to new connections, but not to already accepted ones.

Profiles overlay the global settings. This enables an application - or rather its profile to overwrite global settings. But profiles can also overlay each other. This structure provides full flexibility for more advanced use-cases in the future.

Note: A setting for an application usually overrides the global setting. There are however settings, that are _stacked_ together with the global setting. These are marked accordingly in the UI.

##### Firewall

{% include code_ref.html godoc_portmaster="firewall" %}

The firewall handles the decision process of network packets.

Some special special connections are "fast-tracked" and are not further processed, and also do not show up in the Monitor, these are:

- ICMP/v6 ("ping")
- DHCP/v6
- Local DNS Requests to the Portmaster Core Service: Requests are checked when received.
- Local API requests to the Portmaster Core Service: Requests are authenticated when received.

For all other packets, the Portmaster Core Service next searches for an internal connection state and attributes the connection to the process that initiated or wants to accept the connection. Up until now every packet was processed fully in parallel, but as soon as the connection has been found, packets are queued up by the connection they belong to. This allows the Portmaster Core Service to sequentially look at packets of a single connection.

Now, the packet and the connection it belongs to are handed to the [Privacy Filter](../privacy-filter/).

##### Utilities

{% include code_ref.html godoc_portbase_1="utils" godoc_portbase_2="utils/osdetail" godoc_portbase_3="utils/debug" %}

While not a module, it is worth mentioning where we collect all our internal utilities that are used across the modules. These include basic Go helper functions, OS-specific interfaces and a small utility to gather and format debugging information.

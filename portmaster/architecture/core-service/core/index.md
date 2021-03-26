---
title: Core
layout: base
---

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

##### Status

{% include code_ref.html godoc_portmaster="status" %}

The Status Module keeps track of the currently set Network Rating. It also exposes network environment information received from the [Network Environment module](#network-environment), such as the current online status and detected captive portals.

###### Interpreting Configurations

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

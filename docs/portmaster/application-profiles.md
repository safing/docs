---
title: Application Profiles
section: portmaster
order: 3
layout: base
source-docs:
  - profiles
---

Application Profiles are how you can control which application is allowed to connect to the Internet and how. Applications are matched by their installation path - be sure to have to path to the binary right to have a Profile applied (you can check the logs or the monitor tab in the UI).

## Properties {% include source-docs.html a="profiles#Profile" %}

All of the properties are explained where they are appear on settings page (press the small _i_ icon), here we will go through them in some more detail:

- __Name:__ Name of the application.
- __Description:__ Description of the application. Meant for when users discover applications they know nothing about in the monitoring tool in the UI.
- __Security Level:__ Define the minimum Security Level (and it's configured features) that should be applied with this Profile.
- __Default:__ Define this profile as a default Profile. See explanation in section _Default Profiles_ below.
- __Framework, Find, Build, Virtual, Find parent level, Merge with parent:__ These are some kind of Helper-Profiles used to rematch special applications to correct profiles. See explanation in section _Framework Profiles_ below.
- __Domain Whitelist__: Define a domain whitelist for this Profile, connections to all other domains will be denied.
- __ConnectPorts:__: Define a whitelist of remote TCP/UDP ports that applications are allowed to connect to.
- __ListenPorts:__: Define a whitelist of local TCP/UDP ports applications may listen on. Please note that the `Service` Flag needs to be set in order to allow listening at all.

## Flags {% include source-docs.html a="profiles#Profile" %}

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
  - __Service:__ Service apps may accept incoming connections
  - __Direct Connect:__ These apps may directly connect to an IP address, without resolving DNS first. This is unusual and makes it harder to protect privacy, but may be required for P2P applications.
- Special
  - __Gateway:__ Gateway apps will connect to user-defined servers. Currently not in use.
  - __Browser:__ Browsers are special in that their behavior cannot really be defined. Currently not in use.

## Default Profiles {% include source-docs.html a="profiles#Profile" %}

Because it is infeasible to have a separate Application Profile for every program you directly or indirectly use, you can also define a Profile for whole folders. These Profiles are called `Default` Profiles and are matched on a path prefix basis instead of an exact match basis.

## Framework Profiles {% include source-docs.html a="profiles#Framework" %}

This system is work in progress.

Sometimes a program path may not be the real entity that is executing code. Framework Profiles provide a means to identify the real actor behind a program. For example, when a python script is executed, the program path will be python interpreter, but we actually want to match against the script that is executing, not the interpreter.

- __Framework:__ Defines that this Profile is a Framework profile. The program path will be rewritten and a new match will be tried. Should the new path not produce a match, this profile will be used as a fallback.

Going _down_ the process tree - eg. finding the actual script of an interpreter:

- __Find:__ Regex to find match groups within the path.
- __Build:__ String that uses the regex match groups to build a new path. The resulting path is checked if it exists.
- __Virtual:__ Do not check if the built path exists. This is useful to construct virtual namespaces for special categories of applications, like containerized/sandboxed applications.

Going _up_ the process tree, using the path of the parent process to match a profile:

- __Find parent level:__ Defines the number of levels to traverse the process tree up.
- __Merge with parent:__ If true, view connections of this process as a part of the identified parent process.

---
title: Application Profiles
section: portmaster
order: 3
layout: base
source-docs:
   profiles
---

Application Profiles are used to apply specific settings to applications. Whenever an application first becomes active on the network, the Portmaster creates and loads the corresponding Profile that should be applied.

## Profile Types

There are four profile types. When making decisions, the Portmaster merges these profiles together and draws preferences from this set. The following list is displayed in the correct precedence.

The “default profile” is the combination of the Global and the Fallback Profile. The difference is that the __Global Profile__ will overrule the Stamp Profile while the __Fallback Profile__ may be overridden by Stamp Profile settings.

__User Profiles__  
The User Profile is the application's _own_ profile. It overrides all other profiles.

__Global Profile__  
The Global Profile is shared among all applications and overrides the community supplied Stamp Profile.

__Stamp Profiles__  
These Profiles are built and managed by the [Stamp Community](https://stamp.community). These profiles are especially helpful if you are not very adept technically and generally give you good baseline of a Profile. _(coming soon)_

__Fallback Profile__  
This profile is also shared among all applications and holds sensible defaults for applications that have no other more specific settings applied to it.

## Security Level

In addition to the global Security Level, you may also define a minimum Security Level for an application in it's profile.

## Flags

Flags allow you to quickly define basic behavior.

#### Profile Mode

The Profile Mode defines how the Endpoint list below should be treated.
Whitelist takes precedence before Prompt takes precedence before Blacklist.

  - Blacklist: Only block denied entries, allow everything else.
  - Prompt: Ask if endpoint is not found in list.
  - Whitelist: Only allow permitted entires, block everything else.

#### Network Locations

Define the network scope for this application.

  - Internet: Only allow permitted entires, block everything else.
  - LAN: Only allow permitted entires, block everything else.
  - Localhost: Only allow permitted entires, block everything else.

#### Special Flags

Define special behaviour.

  - Related: When prompting, automatically allow domains that are related to the program.
  - PeerToPeer: Allow program to directly communicate with peers (ie. anyone in the permitted network scope), without resolving DNS first.
  - Service: Allow program to accept incoming connections and act as a server for other devices.
  - Independent: Ignore profile settings coming from the (Stamp) Community.
  - RequireGate17: Require all connections to go over Gate17. (Not quite yet)

## Labels

You can block labels defined by Stamp. _(coming soon)_

## Endpoints

If the Flags and Labels were not detailed enough for you, here you can really get down to it. An Endpoint is a single or a collection of Internet entities:

- Domain
- IPv4/6
- Network _(coming soon)_
- Autonomous System _(coming soon)_
- A whole country _(coming soon)_

Any of these may also additionally and optionally specify an IP protocol and a port range.

There is a second list, called __Service Endpoints__ that controls inbound connections.

## Framework

_This system is work in progress and is currently not part of the Portmaster. Please participate in discussion on our forum._

Sometimes a program path may not be the real entity that is executing code. The Framework settings provides a mean to identify the real actor behind a program. For example, when a python script is executed, the program path will be that of the python interpreter, but we actually want to match against the script that is executing, not the interpreter.

When a Profile with a Framework is evaluated, the executable path will be rewritten and the a new Profile will be searched for with this path.

Going _down_ the process tree - eg. finding the actual script of an interpreter:

- __Find:__ Regex to find match groups within the path.
- __Build:__ String that uses the regex match groups to build a new path. The resulting path is checked if it exists.
- __Virtual:__ Do not check if the built path exists. This is useful to construct virtual namespaces for special categories of applications, like containerized/sandboxed applications. Usual the current Profile would be used if the resulting path does not exist.

Going _up_ the process tree, using the path of the parent process to match a profile:

- __Find parent level:__ Defines the number of levels to traverse the process tree up.
- __Merge with parent:__ If true, view connections of this process as a part of the identified parent process.

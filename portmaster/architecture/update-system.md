---
title: Update System
layout: base
---

Portmaster features an automatic update system that keeps all components up to date and provides fresh hourly intelligence data for effective privacy protection. To secure this process, updates are signed and signatures are checked when downloading.

The Portmaster Core Service regularly checks for updates in the background by downloading small index files from the update server. It then checks if it has all the newest versions and downloads any updates files. Some updates are applied automatically in the background, for others you will be prompted to restart the Portmaster to apply them.

Currently, updates are checked shorty after starting and every hour after that. This tight update schedule is important both for supplying fixes and quickly providing crucial updates for intelligence data.

When designing this system, we took extra care to not only increase your personal security and privacy through fast updates, but also to protect your privacy from our systems during that process. We don't want Portmaster users to be trackable by the update system. To ensure this, we have taken great care to quickly delete any logs and make sure that nothing else leaks in the process. Our [privacy policy]({{ site.privacy_url }}) lays out the details.

The [changelog](/portmaster/changelog) shows the current versions and changes.

### Channels

In order to test new features and triage problems with users, we have different {% include setting/ref.html key="core/releaseChannel" %}s, which you can configure in the settings:

__Stable__  
The overwhelming majority of users will always be on the Stable release channel, as this will give them the best experience.
Releases in this channel have been tested to prevent severe issues.

While the intelligence data has its own index file, it is part of the Stable channel. All other release channels also include the Stable channel as a fallback for not otherwise defined versions.

__Beta__  
New features and complex bug fixes are first released to the Beta channel in order to test them on more devices.
While this means that Beta versions may have bugs more often, they are also fixed a lot faster.  
If anything disrupts your workflow, you can always switch back to Stable.  
This channel includes the Stable channel.

__Staging__  
The Staging release channel is used for smoke testing new releases or deploying internal development versions to many devices.
Releases in this channel may not have a matching version tag and their source may not yet be published.  
This channel includes both the Beta and Stable channels.  
Only use temporarily and when instructed.

__Support__  
When customers are facing issues, we sometimes push special versions to this channel to triage problems.  
This channel includes the Stable channel.  
Only use temporarily and when instructed.

### Signatures

All our updates are fully signed and protected. This fully secures the update system from being maliciously used to harm our users.

Updates are built and signed locally and then pushed to the update server. The update server itself does not have access to the signing keys.

### Disabling

If you wish to do so, you can disable {% include setting/ref.html key="core/automaticUpdates" %}. We do not recommend doing this as this will cut you off from quickly getting security fixes and new intelligence data.

If automatic updates are disabled, you can still manually trigger downloading updates when you want to - and you should do so regularly.

### Technical Details

#### Indexes

- `stable.json` - Defines versions for the Stable release channel.
- `beta.json` - Defines versions for the Beta release channel.
- `staging.json` - Defines versions for the Staging release channel.
- `support.json` - Defines versions for the Support release channel.
- `all/intel/intel.json` - Defines versions for intelligence data.

Please note that during migration phases, indexes are available as `.v2.json` on the update server, but as still saved as `.json` files locally.

#### Structure

The update system uses a very simple structure to organize its files:

- A plain file structure is kept on the server.
- Resource identifiers correspond to their filepath.
- Index files specify which versions should be used.

Here is excerpt of the main `stable.json` index file,

```
{
 "Channel": "stable",
 "Published": "2022-10-20T06:37:10Z",
 "Releases": {
[...]
  "all/ui/modules/portmaster.zip": "0.4.2",
  "windows_amd64/core/portmaster-core.exe": "1.0.0",
  "windows_amd64/kext/portmaster-kext.dll": "1.0.14",
  "windows_amd64/kext/portmaster-kext.sys": "1.0.14",
  "windows_amd64/notifier/portmaster-notifier.exe": "0.3.5",
[...]
 }
}
```

which corresponds to this file structure in the `updates` directory:

```
all/ui/modules/portmaster_v0-4-2.zip
windows_amd64/core/portmaster-core_v1-0-0.exe
windows_amd64/kext/portmaster-kext_v1-0-14.dll
windows_amd64/kext/portmaster-kext_v1-0-14.sys
windows_amd64/notifier/portmaster-notifier_v0-3-5.exe
```

#### Version Selection

The version selection algorithm makes sure that in whatever state the Portmaster is started,
it always find the best version available:

1. Select version `v0.0.0` if available and the {% include setting/ref.html key="core/devMode" %} is enabled.
2. Select the current release as defined by the indexes of the {% include setting/ref.html key="core/releaseChannel" %}.
3. If in Beta or Staging, select the newest version, regardless of it being a pre-release.
4. Select the newest stable version.
5. Default to the newest version.

This process is done by `portmaster-start` for selecting and starting an executable. The Portmaster Core Service then takes care of version selection of all internal resources.

In order to properly be able to take advantage of multiple available version, old version are not deleted immediately when a resource updated.
Instead, the Portmaster keeps a couple previous versions in order to either fall back automatically or when instructed to by an updated index.

#### Resources Explained

Some resources need to be built specifically for the different operating systems and architectures.
Here, these resources use an `OS_ARCH` as a placeholder for these values.
We have also omitted the `.exe` suffix for the Windows versions.

- Portmaster
  - `OS_ARCH/start/portmaster-start` (10-15MB)
    - Starts Portmaster components and integrates with system service controls.
  - `OS_ARCH/core/portmaster-core` (15-25MB)
    - The Portmaster Core Service that runs in the background.
  - `OS_ARCH/app/portmaster-app.zip` (70-100MB, unpacks to 150-200MB)
    - A wrapper for the web technology based user interface, currently based on electron.
    - We want to find a better solution, see the [Ditch Electron card on the backlog page](https://safing.io/backlog/).
  - `OS_ARCH/notifier/portmaster-notifier` (5-15MB)
    - The Portmaster Tray Notifier.
  - `windows_amd64/kext/portmaster-kext.sys` (<1MB)
    - Windows Kernel Extension Driver for the Core Service. Windows only.
  - `windows_amd64/kext/portmaster-kext.dll` (<1MB)
    - Windows Kernel Extension Library for the Core Service. Windows only.
  - `windows_amd64/notifier/portmaster-wintoast.dll` (<5MB)
    - Helper to interact with Windows notification system. Windows only.
  - `all/ui/modules/portmaster.zip` (<5MB)
    - The actual Portmaster user interface.
    - This is separate from the app wrapper to enable quick and cheap updates.
  - `all/ui/modules/assets.zip` (<10MB)
    - User interface related assets that change infrequently.
  - `all/intel/lists/base.dsdl` (<25M, high variation possible)
    - The base layer of the filter lists intelligence data, which is usually updated once a month.
  - `all/intel/lists/intermediate.dsdl` (<5MB, high variation)
    - The intermediate layer of the filter lists intelligence data, which is usually updated once a week.
  - `all/intel/lists/urgent.dsdl` (<1MB, high variation)
    - The urgent layer of the filter lists intelligence data, which is updated hourly, if there are changes.
  - `all/intel/geoip/geoipv4.mmdb.gz` (20-40MB, unpacks to 60-90MB)
    - IP version 4 address metadata database.
  - `all/intel/geoip/geoipv6.mmdb.gz` (70-90MB, unpacks to 180-220MB)
    - IP version 6 address metadata database.
  - `all/intel/portmaster/notifications.yaml` (<1MB)
    - Broadcast notifications to communicate with all or a subset of users.
- SPN
  - `OS_ARCH/hub/spn-hub` (<25MB)
    - The SPN server software.
  - `all/intel/spn/main-intel.yaml` (<1MB)
    - Bootstrap and intelligence info for the SPN.
- Installers
  - `windows_amd64/packages/portmaster-installer.exe`
    - Windows installer.
  - `linux_amd64/packages/portmaster-installer.deb`
    - Debian (based) installer.
  - `linux_amd64/packages/portmaster-installer.rpm`
    - Fedora (based) installer.
  - `linux_all/packages/install.sh`
    - Generic linux install script.
  - `linux_all/packages/installer-assets.tar.gz`
    - Assets for the generic linux install script.

During the installation about 300MB are downloaded, which are then expanded to 500MB locally.  
With all the other resources that are continually downloaded and processed, expect the installation to grow to 2-4GB.

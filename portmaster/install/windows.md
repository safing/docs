---
title: Install on Windows
layout: base
---

This page covers how to install and uninstall the Portmaster on Windows 7, 8, 10 and 11. The install process is the same for all supported Windows versions:

- [Download installer]({{ site.download_windows_url }})
- Use winget: `winget install -i --id Safing.Portmaster`

Please note that we currently only support the 64bit CPU Architecture, which is the current main standard. In case of Windows 7, you  require the 2015 security update KB3033929 for correctly verifying driver signatures.

### Installation Details

The Portmaster is installed to `%PROGRAMDATA%\Safing\Portmaster`, which resolves to `C:\ProgramData\Safing\Portmaster` on most systems.

In order to reduce confusion, a symlink to this location is placed in the usual install location `C:\Program Files\Safing\Portmaster\`.

The Portmaster UI and the Notifier are added to the Start Menu at `Safing\Portmaster`. The Notifier is added to Autostart.
The uninstaller is registered at `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\Portmaster`.  

In order to integrate with the Windows Notification Center, a special ID is placed in the registry to link back to the Notifier at `HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{7F00FB48-65D5-4BA8-A35B-F194DA7E1A51}\LocalServer32`.

The Portmaster Core Service is registered as a system service that starts automatically on boot and is named `PortmasterCore`.

**Deprecated for Versions 0.6.7+**

**Before version 0.6.7**, the Installer deactivated the system's DNS Cache Service in order to gain system integration for the Portmaster. This did break/impair some other software that depend on special functionality of said service. Since then we implemented a better approach for more stable system integration which you can [read all about in this devlog](https://safing.io/blog/2021/03/23/attributing-dns-requests-on-windows/)

The deactivation of the system's DNS Cache Service was done by setting the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Dnscache` -> `Start` from `2` to `4` and rebooting. Updating the Portmaster to [0.6.7](https://github.com/safing/portmaster/releases/tag/v0.6.7) will revert this change accordingly while any new installs will not touch the registry key at all.

### Uninstalling

You can easily uninstall the Portmaster by using the system preferences or by executing the `portmaster-uninstaller.exe`, which you can find in `C:\ProgramData\Safing\Portmaster`.

The uninstaller reverts all steps mentioned above and also requires a reboot afterwards.

### Frequently Asked Questions

You can find solutions to common problems in the [FAQ]({{ site.faq_url }})

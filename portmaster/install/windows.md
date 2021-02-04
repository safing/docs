---
title: Install on Windows
layout: base
---

This page covers how to install and uninstall the Portmaster on Windows 7, 8 and 10. [The installer is the same](https://updates.safing.io/latest/windows_amd64/packages/portmaster-installer.exe) for all supported Windows versions.

Please note that we currently only support the 64bit CPU Architecture, which is the current main standard. In case of Windows 7, you  require the 2015 security update KB3033929 for correctly verifying driver signatures.

#### Installation Details

The Portmaster is installed to `%PROGRAMDATA%\Safing\Portmaster`, which resolves to `C:\ProgramData\Safing\Portmaster` on most systems.

In order to reduce confusion, a symlink to this location is placed in the usual install location `C:\Program Files\Safing\Portmaster\`.

The Portmaster UI and the Notifier are added to the Start Menu at `Safing\Portmaster`. The Notifier is added to Autostart.
The uninstaller is registered at `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\Portmaster`.  

In order to integrate with the Windows Notification Center, a special ID is placed in the registry to link back to the Notifier at `HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{7F00FB48-65D5-4BA8-A35B-F194DA7E1A51}\LocalServer32`.

The Portmaster Core Service is registered as a system service that starts automatically on boot and is named `PortmasterCore`.

In order to gain the required system integration for the Portmaster to function properly, the Installer needs to deactivate the system's DNS Cache Service - the Portmaster replaces this service. This may break/impair some other software that depends on special functionality of said service.
This is done by setting the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Dnscache` -> `Start` to `4` and rebooting.

#### Uninstalling

You can easily uninstall the Portmaster by using the system preferences or by executing the `portmaster-uninstaller.exe`, which you can find in `C:\ProgramData\Safing\Portmaster`.

The uninstaller reverts all steps mentioned above and also requires a reboot afterwards.

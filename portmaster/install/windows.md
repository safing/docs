---
title: Install on Windows
layout: base
---

This page covers how to install and uninstall the Portmaster on Windows 7, 8 and 10. [The installer is the same](https://updates.safing.io/latest/windows_amd64/packages/portmaster-installer.exe) for all supported Windows versions.

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

### Known Issues

#### Notifications are not working on Windows 7 and 8.

Microsoft added a notification service that supports actions with Windows 10 so Portmaster's notifications won't work on Windows 7 or 8. We will push alternatives as we find solutions and time to do so. In the meantime we recommend not to use the "prompt" action as a default when running on Windows 7 or 8.

#### Portmaster fails to restart

In some cases the Portmaster will fail to restart, because the Portmaster Kernel Extensions cannot be loaded and returns the error code 0x422.
This stems from a known issue in Windows, where system services are not completely removed when something is monitoring the system services.
When the Portmaster restarts, it is then unable to initialize the Kernel Extension, because the system thinks it is still unloading.

If you experience this issue, please follow this workaround:

_Quoting from <https://stackoverflow.com/a/20565337>_

> There may be several causes which lead to the service being stuck in “marked for deletion”.
>
>  1. [SysInternals' Process Explorer is opened](http://blog.cyotec.com/2011/05/specified-service-has-been-marked-for.html). Closing it should lead to automatic removal of the service.
>
>  1. [Task Manager is opened](https://stackoverflow.com/questions/20561990/how-to-solve-the-specified-service-has-been-marked-for-deletion-error/21310096#comment32672750_20565337).
>
>  1. [Microsoft Management Console (MMC) is opened](https://stackoverflow.com/a/8529760/240613). To ensure all instances are closed, run `taskkill /F /IM mmc.exe`.
>
>  1. [Services console is opened](https://stackoverflow.com/a/21310096/240613). This is the same as the previous point, since Services console is hosted by MMC.
>
>  1. [Event Viewer is opened](https://stackoverflow.com/a/18467128/240613). Again, this is the same as the third point.
>  
>  1. [The key HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\\{service name} exists](https://stackoverflow.com/a/2804099/240613).
>
>  1. [Someone else is logged into the server](https://stackoverflow.com/a/28632820/240613) and has one of the previously mentioned applications opened.
>
>  1. An instance of Visual Studio *used to debug the service* is open.

#### Portmaster Core does not start at boot

While we haven't experienced this in a while, it might just happen that the Portmaster will not start at boot, although it is configured to do so. If that is the case, you can check its status in the "Services" Desktop App. There, search for the Service "Portmaster Core" and inspect and start it as needed.

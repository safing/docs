---
title: Install on Linux
layout: base
---

This page covers how to install and uninstall the Portmaster on Linux.

### Installers

We provide package installers for supported systems:

- [Download `.deb`]({{ site.download_linux_deb_url }}) for Debian, Ubuntu, Pop!_OS, ... [_how to_](https://linuxconfig.org/install-deb-file-on-ubuntu-20-04-focal-fossa-linux)
- [Download `.rpm`]({{ site.download_linux_rpm_url }}) for Fedora, CentOS, ... [_how to_](https://itsfoss.com/install-rpm-files-fedora/)
- [In AUR](https://aur.archlinux.org/packages/portmaster-stub-bin): `portmaster-stub-bin` for Arch, Manjaro, EndeavourOS, ...
- `curl -fsSL https://updates.safing.io/latest/linux_all/packages/install.sh | sudo bash` for Others

__Important Notes__:

1. The newest version of Portmaster will be __downloaded during installation__. (~300MB)
2. Portmaster will __not start automatically__ after the installation. We recommend a reboot for a clean first start.

---

Please note that we only support the latest stable and LTS versions. We may be able to help out with other systems, but will not be able to invest a lot of time in order to keep focus.

The installers should take care of any needed dependencies. [Please report back](https://github.com/safing/portmaster/issues/new?template=bug-report.md) if they do not!

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
      Please note that the Portmaster updates itself and that the provided packages are only meant for an initial install. Uninstalling the package from  your system will properly uninstall and remove the Portmaster.
    </p>
</div>

### Compatibility Reports

Help make the Portmaster better for everyone by [reporting your experience]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) on different Linux distros.

<!--

## Status Guideline

- 🟢 confirmed compatible                  (confirmed by the Safing team)
- 🟢 estimated compatible                  (reported by the community)
- 🟢 reported compatible                   (reported by the community)
- 🟡 issue reported                        (reported by the community)
- 🟡 issue confirmed, workaround available (confirmed by the Safing team)
- 🚫 issue confirmed                       (confirmed by the Safing team)
- ❔ request for report

-->

#### Linux Kernel

| System       | Version | Status                  | Link                                        |
|:------------ |:------- |:----------------------- |:-------------------------------------------:|
| Linux Kernel | >= 5.7  | 🟢 confirmed compatible |                                             |
|              | 5.6     | 🟡 issue reported       | [#82]({{ site.github_pm_url }}/issues/82)   |
|              | 2.4-5.5 | 🟢 confirmed compatible |                                             |
| NixOS        | 21.05   | 🟡 issue reported       | [#306]({{ site.github_pm_url }}/issues/306) |
| Parrot OS    |         | 🟡 issue reported       | [#465]({{ site.github_pm_url }}/issues/465) |

#### Desktop Environments

|| Environment | Version | Status | Link |
|:---|:---|:---|:---:|
| Budgie | ? | 🟡 issue reported | [#111]({{ site.github_pm_ui_url }}/issues/111)
| Cinnamon | 4.6.7 | 🟢 reported compatible | [#297]({{ site.github_pm_url }}/issues/297) |
| Deepin DE | | request for [report]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) |
| Gnome | 3.38 | 🟢 confirmed compatible |
| | >= 3 | 🟢 estimated compatible |
| KDE Plasma | 5.18 | 🟢 reported compatible | [#324]({{ site.github_pm_url }}/issues/324) |
| LXDE | | request for [report]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) |
| LXQt | | request for [report]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) |
| MATE | | request for [report]({{ site.github_pm_url }}{{ site.github_report_compatibility_url }}) |
| XFCE | ? | 🟢 confirmed compatible |

### Requirements

The Portmaster Core Service is compatible with the Linux Kernel as of version 2.4, but due to a breaking bug in at least v5.6, we recommend to use v5.7+.

Dependencies:

- [Network Manager](https://wiki.gnome.org/Projects/NetworkManager) - for better integration (_optional, but recommended_)
- _We managed to remove all other dependencies!_ 🎉

### Manual Install and Launching

_Consider using our `curl | bash` installer mentioned above._

__0.__ Install dependencies.

__1.__ Download the latest `portmaster-start` utility and initialize all resources:

```sh
# Create portmaster data dir
mkdir -p /opt/safing/portmaster

# Download portmaster-start utility
wget -O /tmp/portmaster-start https://updates.safing.io/latest/linux_amd64/start/portmaster-start
sudo mv /tmp/portmaster-start /opt/safing/portmaster/portmaster-start
sudo chmod a+x /opt/safing/portmaster/portmaster-start

# Download resources
sudo /opt/safing/portmaster/portmaster-start --data /opt/safing/portmaster update
```

All data is saved in `/opt/safing/portmaster`. The `portmaster-start` utility always needs to know where this data directory is.

__2.__ Reboot Your System

__3.__ Start the Portmaster Core Service

```sh
sudo /opt/safing/portmaster/portmaster-start core
```

__4.__ Start the Portmaster UI

```
/opt/safing/portmaster/portmaster-start app
```

__5.__ Start the Portmaster Notifier

```
/opt/safing/portmaster/portmaster-start notifier
```

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
     Your Desktop environment may not (yet) be compatible.
    </p>
</div>

__6.__ Start it on boot

In case you are not using `systemd` as your init system - you most likely know if that is the case - these guides contributed by the community will get you started:
- [Runit](#start-portmaster-automatically-with-runit)
- [Dinit](#start-portmaster-automatically-with-dinit)

In order to get the Portmaster Core Service to automatically start when booting, you need to create a systemd service unit at `/etc/systemd/system/portmaster.service`.
The following unit file works but excludes most of the security relevant settings. For a more restricted version [use this portmaster.service file](https://github.com/safing/portmaster-packaging/blob/master/linux/portmaster.service).

```ini
[Unit]
Description=Portmaster Privacy App

[Service]
Type=simple
ExecStart=/opt/safing/portmaster/portmaster-start core --data=/opt/safing/portmaster/
ExecStopPost=-/sbin/iptables -F C17
ExecStopPost=-/sbin/iptables -t mangle -F C170
ExecStopPost=-/sbin/iptables -t mangle -F C171
ExecStopPost=-/sbin/ip6tables -F C17
ExecStopPost=-/sbin/ip6tables -t mangle -F C170
ExecStopPost=-/sbin/ip6tables -t mangle -F C171

[Install]
WantedBy=multi-user.target
```

Finally, reload the systemd daemon and enable/start the Portmaster:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now portmaster
```

__7.__ Enjoy!

### Security-Enhanced Linux (SELinux)

If you are running with `SELINUX=enforcing` you probably were not successful with running the Portmaster and might see the following error in your `journalctl -u portmaster`:

```
dub 16 22:09:10 dev-fedora systemd[1]: Started Portmaster Privacy App.
dub 16 22:09:10 dev-fedora systemd[30591]: portmaster.service: Failed to execute command: Permission denied
dub 16 22:09:10 dev-fedora systemd[30591]: portmaster.service: Failed at step EXEC spawning /opt/safing/portmaster/portmaster-start: Permission denied
dub 16 22:09:10 dev-fedora systemd[1]: portmaster.service: Main process exited, code=exited, status=203/EXEC
```

This happens because SELinux will not allow you to run a binary from `/opt/safing/portmaster` as systemd service. For this to work you need to change the SELinux security context type of `portmaster-start` binary using the following command:

```sh
sudo chcon -t bin_t /opt/safing/portmaster/portmaster-start
```

Now you can restart the `portmaster` service and check that the `portmaster` started up successfully by running:

```sh
systemctl restart portmaster
systemctl status portmaster
```

### Desktop Entry

To find and launch the Portmaster from within your desktop environment you need to create a file with metadata which tells your system how to run the Portmaster, which icon it should display in the taskbar, etc.
The easiest way to do this on other distributions is to download the latest desktop entry and png icon from the [portmaster-packaging repository]({{ site.github_pm_packaging_url }}):

```sh
sudo wget https://raw.githubusercontent.com/safing/portmaster-packaging/master/linux/portmaster.desktop  -O /usr/local/share/applications/portmaster.desktop
sudo wget https://raw.githubusercontent.com/safing/portmaster-packaging/master/linux/portmaster_logo.png -O /usr/share/pixmaps/portmaster.png
```

Right after you download both files the Portmaster should appear in your system search with an icon.
If you still cannot see the Portmaster icon, please check whether the `portmaster-start` path in the desktop entry matches the path of your installation.

### Troubleshooting

#### Install Path Change

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
      Installs before November 2021 were located in <b>"/var/lib/portmaster"</b>, while new installs are located in <b>"/opt/safing/portmaster"</b>.
    </p>
</div>

The docs only reference the new path, but your system might still be using the old one.
In order to upgrade your path you can re-install the Portmaster with <a href="#installers">the newest installer</a>.

#### Check if the Portmaster Is Running

You can check if the Portmaster system service is actually running or if it somehow failed to start by executing the following command:

```sh
sudo systemctl status portmaster
```

This should show something like `active (running) since <start-time>`. Please also check if the start time seems reasonable. If it seems strange, try [looking at the logs](#accessing-the-logs).

#### Starting And Stopping the Portmaster

If you encounter any issues you might want to (temporarily) stop the Portmaster. You can do this like this:

```sh
# This will stop the portmaster until you reboot.
sudo systemctl stop portmaster

# This will disable automatically starting the Portmaster on boot.
sudo systemctl disable portmaster
```

#### Changing the Log Level

When debugging or troubleshooting issues it is always a good idea to increase the debug output by adjusting the {% include setting/ref.html key="core/log/level" %}.

#### Accessing the Logs

Portmaster logs can either be viewed using the system journal or by browsing the log files in `/opt/safing/portmaster/logs`. Installs before November 2021 used `/var/lib/portmaster` instead.
In most cases, the interesting log files will be in the `core` folder.

```sh
# View logs of the Portmaster using the system journal.
sudo journalctl -u portmaster

# You can also specify a time-range for viewing.
sudo journalctl -u portmaster --since "10 minutes ago"
```

#### Debugging Network Issues

Due to the Portmaster being an Application Firewall it needs to deeply integrate with the networking stack of your operating system.
That means that "no network connectivity" might be caused at different points during connection handling.
The following steps will help you to figure out where the actual issue comes from.
Please include any output of the below commands in any related issues as it is very valuable in debugging your problem.

###### 1. [Check if the Portmaster Is Actually Up and Running](#check-if-the-portmaster-is-running)

###### 2. Test Direct Network Connectivity

The Portmaster includes a local DNS resolver to provide its monitoring and some filtering capabilities.
In order to track down the issue, connect directly to an IP address.
Should this work, this would indicate that there is a problem with the Portmaster's DNS resolver.

```sh
# Check if a ping message succeeds.
# The Portmaster currently always allows ping messages.
ping 1.1.1.1

# Check if an HTTP request succeeds.
# In case of an error, look for "curl" in the network monitor of the Portmaster.
curl -I 1.1.1.1

# Or use wget to check if an HTTP request succeeds.
# In case of an error, look for "wget" in the network monitor of the Portmaster.
wget -S -O /dev/null 1.1.1.1
```

###### 3. Test DNS Resolving

If the above step works the issue most likely resides somewhere at the DNS resolving level. To confirm, please try the following:

```sh
# Check if a DNS requests suceeds.
# In case of an error, look for "dig" in the network monitor of the Portmaster.
dig one.one.one.one
dig wikipedia.org

# Or use nslookup to check if a DNS requests suceeds.
# In case of an error, look for "nslookup" in the network monitor of the Portmaster.
nslookup one.one.one.one
nslookup wikipedia.org
```

#### No Network Connectivity After the Portmaster Stops

In case of a rapid unscheduled shutdown, the Portmaster may sometimes fail to cleanup its iptables rules and thus break networking. To work around this either use the [recommended systemd service unit]({{ site.github_pm_packaging_url }}/blob/master/linux/portmaster.service) included in [our installers]({{ site.github_pm_packaging_url }}) or execute the following commands:

```sh
sudo /opt/safing/portmaster/portmaster-start recover-iptables
```

### Uninstall

Uninstalling the portmaster package from your system will properly uninstall and remove the Portmaster.

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
      Most distros will have a graphical software and package manager for uninstalling.<br>
      You can easily find it by opening the "Start Menu" and searching for "software".
    </p>
</div>

###### Debian/Ubuntu

```sh
sudo apt purge portmaster
```

###### Fedora

```sh
sudo yum remove portmaster
```

###### Arch

```sh
sudo pacman -Rnsu portmaster
```

### Community Contributions

#### Start Portmaster Automatically with Runit

__6.__ Start it on boot Runit (systems)

In order to get the Portmaster Core Service to run automatically at boot, you need to make a runit service by first creating a directory at `/usr/local/sv/portmaster/` (if there isn't any `/usr/local/sv/` directory just create with the 755 permission using `mkdir -p /usr/local/sv` ) with 755 permissions, then creating a `run` file at `/usr/local/sv/portmaster/run` with the same permissions as the `portmaster` folder we created. This file **must** contain the following:

```sh
#!/bin/sh
exec /opt/safing/portmaster/portmaster-start core --data=/opt/safing/portmaster/
```

**NOTE**: The portmaster-start script might be located elsewhere.

Finally, enable and start the service:

```sh
sudo ln -s /usr/local/sv/portmaster /etc/runit/runsvdir/default
sudo sv up portmaster
```

Artix Linux users can find the [portmaster-runit](https://aur.archlinux.org/packages/portmaster-runit/) package in the AUR

#### Start Portmaster Automatically with Dinit
__6.__ Start it on boot (Runit)

In order to get the Portmaster Core Service to automatically start when booting, you need to create a dinit service file at `/etc/dinit.d/portmaster`.
The following service file works, but may need to be apdated to your distribution as they do not all ship the same services.
```sh
type = process
command = /opt/safing/portmaster/portmaster-start --data /opt/safing/portmaster core 
depends-on = NetworkManager
pid-file=/opt/safing/portmaster/core-lock.pid
restart = yes
restart-delay = 10
working-dir = /opt/safing/portmaster
```
By default Dinit ships an environment file located at `/etc/dinit/environment`, make sure it exists and that it exports the PATH environment viariable, otherwise Portmaster Core won't be able to find the `iptables` binary
It may look like that this (but can be different):
```
PATH=/usr/bin
```
Finnally enable and start the Portmaster: `sudo dinitctl enable portmaster`

Artix Linux users can find the [portmaster-dinit](https://aur.archlinux.org/packages/portmaster-dinit) package in the AUR

### Frequently Asked Questions

You can find solutions to common problems in the [FAQ]({{ site.faq_url }})

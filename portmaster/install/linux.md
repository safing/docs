---
title: Install on Linux
layout: base
---

This page covers how to install and uninstall the Portmaster on Linux.

### Installers

We provide package installers for supported systems:

- [`.deb` for Debian/Ubuntu]({{ site.download_linux_deb_url }}) ([_how to_](https://linuxconfig.org/install-deb-file-on-ubuntu-20-04-focal-fossa-linux))
- [`PKGBUILD` for Arch](#arch-linux)
- [`.pkg.tar.xz` for Arch]({{ site.download_linux_arch_url }}) (Testing, [CI Build](https://github.com/safing/portmaster-packaging/actions?query=workflow%3A%22Arch+Linux%22+branch%3Amaster) / [_how to_](https://wiki.archlinux.org/index.php/Pacman#Additional_commands))

---

Please note that we only support the latest stable and LTS versions. We may be able to help out with other systems, but will not be able to invest a lot of time in order to keep focus.

The installers should take care of any needed dependencies. [Please report back](https://github.com/safing/portmaster/issues/new?template=bug-report.md) if they do not!


<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
      Please note that the Portmaster updates itself and that the provided packages are only meant for an initial install. Uninstalling the package from  your system will properly uninstall and remove the Portmaster.
    </p>
</div>


### Compatibility

| System | Version | Notes |
|:--|:-:|:--|
| Linux Kernel | >= 5.7 | 2.4-5.5 might also work, see issue [core#82](https://github.com/safing/portmaster/issues/82) |
| Gnome | >= 3? |
| KDE | ? |
| MATE | ? |
| Cinnamon | ? |
| Budgie | ? | Issues: [ui#111](https://github.com/safing/portmaster-ui/issues/111) |
| LXDE | ? |
| LXQt | ? |
| XFCE | ? | Seen working. |
| Deepin DE | ? |

### Requirements

The Portmaster Core Service is compatible with the Linux Kernel as of version 2.4, but due to a breaking bug in at least v5.6, we recommend to use v5.7+.

Dependencies:

- `libnetfilter_queue` - for network stack integration
- `libappindicator3` - for sending desktop notifications (_optional, but recommended_)
- [Network Manager](https://wiki.gnome.org/Projects/NetworkManager) - for better integration (_optional, but recommended_)

###### Debian/Ubuntu

```
sudo apt install libnetfilter-queue1 libappindicator3-1
```

<div class="notification-warning">
  <img src="{{ site.img_url }}icons/info.svg">
  <p>
    You may need to <a href="https://help.ubuntu.com/community/Repositories/Ubuntu">enable the universe or multiverse repositories</a>  sources on Ubuntu.
  </p>
</div>

###### Fedora

```
sudo yum install libnetfilter_queue
```

###### Arch

```
sudo pacman -S libnetfilter_queue libappindicator-gtk3
```

### Manual Install and Launching

__0.__ Install dependencies.

__1.__ Download the latest `portmaster-start` utility and initialize all resources:

```
# Download portmaster-start utility
wget -O /tmp/portmaster-start https://updates.safing.io/latest/linux_amd64/start/portmaster-start
sudo mv /tmp/portmaster-start /var/lib/portmaster/portmaster-start
sudo chmod a+x /var/lib/portmaster/portmaster-start

# Download resources
sudo /var/lib/portmaster/portmaster-start --data /var/lib/portmaster update
```

All data is saved in `/var/lib/portmaster`. The `portmaster-start` utility always needs to know where this data directory is.

__2.__ Start the Portmaster Core Service

```
sudo /var/lib/portmaster/portmaster-start core
```

__3.__ Start the Portmaster UI

```
/var/lib/portmaster/portmaster-start app
```

__4.__ Start the Portmaster Notifier

```
/var/lib/portmaster/portmaster-start notifier
```

<div class="notification-warning">
    <img src="/assets/img/icons/info.svg">
    <p>
     Your Desktop environment may not (yet) be compatible.
    </p>
</div>

__5.__ Start it on boot

In order to get the Portmaster Core Service to automatically start when booting, you need to create a systemd service unit at `/etc/systemd/system/portmaster.service`.
The following unit file works but excludes most of the security relevant settings. For a more restricted version [use this portmaster.service file](https://github.com/safing/portmaster-packaging/blob/master/linux/debian/portmaster.service).

```
[Unit]
Description=Portmaster Privacy App

[Service]
Type=simple
ExecStart=/usr/local/bin/portmaster-start core --data=/var/lib/portmaster/
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

```
sudo systemctl daemon-reload
sudo systemctl enable --now portmaster
```

__6.__ Enjoy!

### Arch Linux

For Arch users we provide a PKGBUILD file in the [portmaster-packaging](https://github.com/safing/portmaster-packaging) repository. It is not yet submitted to AUR as we want to collect some feedback first.

To install the Portmaster using the PKGBUILD, follow these steps:

```
# Install build-dependencies, you can remove them later:
sudo pacman -S imagemagick # required to convert the Portmaster logo to different resolutions

# Install runtime dependencies:
sudo pacman -S libnetfilter_queue webkit2gtk

# Clone the repository
git clone https://github.com/safing/portmaster-packaging

# Enter the repo and build/install the package (it's under linux/)
cd portmaster-packaging/linux
makepkg -i

# Start the Portmaster and enable autostart
sudo systemctl daemon-reload
sudo systemctl enable --now portmaster
```

### Troubleshooting

#### Check if the Portmaster Is Running

You can check if the Portmaster system service is actually running or if it somehow failed to start by executing the following command:

```
sudo systemctl status portmaster
```

This should show something like `active (running) since <start-time>`. Please also check if the start time seems reasonable. If it seems strange, try [looking at the logs](#accessing-the-logs).

#### Starting And Stopping the Portmaster

If you encounter any issues you might want to (temporarily) stop the Portmaster. You can do this like this:

```
# This will stop the portmaster until you reboot.
sudo systemctl stop portmaster

# This will disable automatically starting the Portmaster on boot.
sudo systemctl disable portmaster
```

#### Changing the Log Level

When debugging or troubleshooting issues it is always a good idea to increase the debug output by adjusting the {% include setting/ref.html key="core/log/level" %}.

#### Accessing the Logs

Portmaster logs can either be viewed using the system journal or by browsing the log files in `/var/lib/portmaster/logs`.
In most cases, the interesting log files will be in the `core` folder.

```
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

```
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

```
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

In case of a rapid unscheduled shutdown, the Portmaster may sometimes fail to cleanup its iptables rules and thus break networking. To work around this either use the [recommended systemd service unit]({{ site.github_pm_packaging_url }}/blob/master/linux/debian/portmaster.service) included in [our installers]({{ site.github_pm_packaging_url }}) or execute the following commands:

```
sudo /var/lib/portmaster/portmaster-start recover-iptables
```

### Uninstall

Uninstalling the package from your system will properly uninstall and remove the Portmaster.

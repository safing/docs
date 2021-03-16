---
title: Install on Linux
layout: base
---

1. Numbered
{:toc}

<br/>

This page covers how to install and uninstall the Portmaster on Linux.

#### Installers

We provide package installers for supported systems:

- [`.deb` for Debian/Ubuntu](https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb) ([_how to_](https://linuxconfig.org/install-deb-file-on-ubuntu-20-04-focal-fossa-linux))
- [`.pkg.tar.xz` for Arch](https://github.com/safing/portmaster-packaging/actions?query=workflow%3A%22Arch+Linux%22+branch%3Amaster) (Testing, CI Build / [_how to_](https://wiki.archlinux.org/index.php/Pacman#Additional_commands))

---

Please note that we only support the latest stable and LTS versions. We may be able to help out with other systems, but will not be able to invest a lot of time in order to keep focus.

The installers should take care of any needed dependencies. [Please report back](https://github.com/safing/portmaster/issues/new?template=bug-report.md) if they do not!


<div class="notification-warring">
    <img src="/assets/img/icons/info.svg">
    Please note that the Portmaster updates itself and that the provided packages are only meant for an initial install. Uninstalling the package from your system will properly uninstall and remove the Portmaster.
</div>


#### Compatibility

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

#### Requirements

The Portmaster Core Service is compatible with the Linux Kernel as of version 2.4, but due to a breaking bug in at least v5.6, we recommend to use v5.7+.

Dependencies:

- `libnetfilter_queue` - for network stack integration
- `libappindicator3` - for sending desktop notifications (_optional, but recommended_)
- [Network Manager](https://wiki.gnome.org/Projects/NetworkManager) - for better integration (_optional, but recommended_)

---

__Debian/Ubuntu__

```
sudo apt install libnetfilter-queue1 libappindicator3-1
```

<div class="notification-warring">
    <img src="{{ site.img_url }}icons/info.svg">
     You may need to <a href="https://help.ubuntu.com/community/Repositories/Ubuntu">enable the universe or multiverse repositories</a>  sources on Ubuntu.
</div>


__Fedora__

```
sudo yum install libnetfilter_queue
```

__Arch__

```
sudo pacman -S libnetfilter_queue libappindicator-gtk3
```

#### Manual Install and Launching

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

<div class="notification-warring">
    <img src="/assets/img/icons/info.svg">
     Your Desktop environment may not (yet) be compatible.
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
ExecStopPost=-/sbin/iptables -t mangle -F 171

[Install]
WantedBy=multi-user.target
```

Finally, reload the systemd daemon and enable/start the Portmaster:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now portmaster
```

__6.__ Enjoy!

#### Uninstall

Uninstalling the package from your system will properly uninstall and remove the Portmaster.

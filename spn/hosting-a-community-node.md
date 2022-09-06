---
title: Hosting a Community Node
layout: base
---

### Community Nodes Strengthen the Network

Community Nodes are servers not hosted by Safing, but by the Portmaster and SPN community. Hosting a node is very beneficial to all users, as it increases diversity in server ownership for even better privacy. These servers also create a much better coverage, as people living around the world know best where to host servers in their country.

### Community Nodes are Safe to Use

Except for one aspect, community nodes are treated exactly the same as nodes operated by Safing.

The only difference is, that network connections that are not encrypted by themselves, like plain HTTP, will never exit the network at community nodes. Instead, they exit the network at specially trusted servers, which are a subset of the servers operated by Safing.

Community nodes will therefore never see any connection contents, as the connections are always encrypted for the destination server. This makes community nodes safe to use. Not only are they safe to use, but they are recommended, as they provide even better privacy due to more diverse server ownership in the nodes you use.

### Hardware Requirements are Being Defined

As the network starts to scale up, we are still figuring out what the exact hardware requirements are for different use cases.

For now, please use a server that has at least two CPU Cores and 4GB of Memory.

### Running a Community Node

You can easily install a community node with our installer. This installer is built for systemd-based Linux systems. We recommend to use a server just for the SPN node and nothing else.

Before installing the SPN Node, you should go about hardening the server in order to prevent unauthorized access. If you are new to hosting and securing servers, please do some research before you start.

The SPN Node will attempt to configure itself automatically, using:

- The server hostname as the name for the node. (The installer will also ask you.)
- The public IPv4 address configured on the server, if there is only one.
- The public IPv6 address configured on the server, if there is only one.

If the server itself does not have a (single) public IP address, you will need to manually configure the IP address using the settings listed below in Appendix I.

If everything is prepared, you can now install the SPN Node using our install script:

```
# Run as root
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/safing/spn/master/tools/install.sh)"

# As an alternative, you can first download the install script and run it afterwards:
wget https://raw.githubusercontent.com/safing/spn/master/tools/install.sh
sudo sh ./install.sh
```

Please note that when you launch your server it will soon start handling traffic of users. Rapidly starting and stopping your server will lead to decreased user experience.

When everything goes well, you should see your server on the SPN page in Portmaster after a short time.

### Rewards for running a Community Node

We are extremely thankful for everyone who joins in strengthening the network and are planning to reward community node operators in the future.

### Appendix I: Available Settings for SPN Nodes

All these settings need to be set in the `spn` -> `publicHub` json object in the config.json file.

- `name`: Set the name of the node.
- `group`: Person or organisation, who is in control of the node (should be same for all nodes of this person or organisation).

- `contactAddress`: Contact possibility (recommended, but optional).
- `contactService`: Type of service of the contact address, if not email.

- `hosters`: Hosters - supply chain (reseller, hosting provider, datacenter operator, ...).
- `datacenter`: Datacenter in the format of COUNTRYCODE-COMPANY-INTERNALCODE (eg: DE-Hetzner-FSN1-DC5)

- `ip4`: IPv4 address must be global and accessible.
- `ip6`: IPv6 address must be global and accessible.
- `transports`: Define available protocols for communicating with other nodes and clients. Leave undefined to use defaults.

- `entry`: Set an entry policy (for clients) with the same syntax as rules.
- `exit` Set an exit policy (for destinations) with the same syntax as rules. The default is to block TCP/25 (SMTP) traffic. 

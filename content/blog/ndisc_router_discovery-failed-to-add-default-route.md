+++
author = "Caleb Callaway"
date = 2016-03-14T09:10:55Z
description = ""
draft = false
slug = "ndisc_router_discovery-failed-to-add-default-route"
title = "ndisc_router_discovery() failed to add default route"

+++


In Ubuntu 14.04 (and probably in other Debian derivatives), network interfaces with a statically configured IPv6 address and gateway will still accept [Neighborhood Discovery Protocol](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol) Router Advertisements and attempt to process them, leading to log spam of the following form:

```
...
ICMPv6 RA: ndisc_router_discovery() failed to add default route.
ICMPv6 RA: ndisc_router_discovery() failed to add default route.
ICMPv6 RA: ndisc_router_discovery() failed to add default route.
...
```

To prevent this, disable acceptance of RAs by adding `accept_ra 0` to the static configuration, as follows:

```
iface eth0 inet6 static
	address <static_ipv6_addr>
	netmask <netmask>
	gateway <gateway_addr>
	accept_ra 0
```


---
title: "Multihomed Webserver Routing in pf"
date: 2020-11-09T19:30:41-08:00
draft: false
tags: ['openbsd', 'pf', 'routing', 'ipv6']
---

Running a publicly accessible IPv6 webserver while blessed with a dynamic IPv6 prefix can be achieved with a static [tunnelbroker.net](tunnelbroker.net) prefix and [multihoming](https://en.wikipedia.org/wiki/Multihoming#Multihoming_with_multiple_addresses), but simply configuring multiple IPv6 addresses isn't enough. Additional router configuration is required.

The ISP-delegated prefix should be the default route for performance reasons. Simple `pass` rules will allow inbound requests to route through the tunnel and onward to the internal server; outbound packets aren't so easy. The server's response will originate from a static address associated with the tunnel, but will usually take the default route back to the external client and subsequently get dropped by an external router that doesn't service packets from the tunneled prefix. We need to route outbound packets from the server through the tunnel; in short, we need [source-based routing](https://en.wikipedia.org/wiki/Source_routing).

[pf](https://www.openbsd.org/faq/pf/) provides a convenient source-based routing solution with its `route-to` clause, but one must also disable state tracking for all inbound and outbound packets so the state tracker doesn't bypass our `route-to` rule. The state tracker is enabled by default, so we must disable state tracking _for every interface on the route_.

```bash
server = <webserver ipv6 addr>
...
pass in quick on $he_if proto tcp to $server port https no state
pass out quick on $lan proto tcp to $server port https no state
pass in quick on $lan proto tcp from $server port https route-to $he_if no state
pass out quick on $he_if proto tcp from $server port https no state
...
```

The use of `quick` may not be necessary if the rule set is cleverly crafted; I chose to emphasize legibility over cleverness. While it's possible to remove the port and protocol specifiers for these rules, I've found the interactions with other rules difficult to manage. Your mileage may vary.

# Notes on Debugging

Having a remote host from which to issue queries to my webserver was vital; I used a [Digital Ocean](https://www.digitalocean.com/) droplet. I got a lot of mileage out of [pf logging](https://www.openbsd.org/faq/pf/logging.html) and various `tcpdump` filters; I also found this shell snippet handy for isolating rules that had introduced spurious state tracker entries:

```bash
for i in `jot 30`; do echo "Rule $i" && doas pfctl -s states -R $i | grep <server ip>; done
```

+++
author = "Caleb Callaway"
date = 2018-01-17T12:32:52Z
description = ""
draft = false
slug = "ghost-1-0"
title = "Ghost 1.0"

+++


As you may notice, the blog got an update; specifically, Ghost was migrated from version 0.11 to version 1.20. I've been putting the upgrade off for a while, since I expected the upgrade to be tedious and frustrating. I wasn't wrong.

I'm philosophically opposed to switching to nginx to accomodate a single webapp, but there's no official support for Apache anymore, so I spent many hours puzzling out a valid Apache config (using Apache 2.4):

```
<Location /blog>
        ProxyPreserveHost On
        ProxyPass http://127.0.0.1:2368/blog
        # For my HTTPS-enabled site, this header was required;
        # Ghost generated redirect loops if it wasn't set.
        # The ugly condition appears to be a requirement;
        # the REQUEST_SCHEME environment variable was null for me
        <If "%{HTTPS} == 'on'">
                RequestHeader set X-Forwarded-Proto "https"
        </If>
        <Else>
                RequestHeader set X-Forwarded-Proto "http"

        </Else>
        ProxyPassReverse http:/127.0.0.1:2368/blog
</Location>
```                

The rest of the [migration process](https://docs.ghost.org/docs/migrating-to-ghost-1-0-0) mostly "Just Works."

Essential commands:

* (on the server) `sudo netstat -tlnp` to verify Ghost is running. The program name should be "node". The TCP port on which Ghost is listening is listed in the Local Address column.
* (on the server) `ghost stop && sudo nc -l 2368` to get a debug dump of the proxy requests coming from Apache. Replace 2368 with the correct port as needed.
* (on a client) `curl -v -L https://www.brainvitamins.net/blog/` to get a dump of the information observed by a client.


---
title: "Cryptpad"
date: 2020-12-57T18:48:13-08:00
draft: false
summary: "Hosting instructions for Cryptpad, a zero knowledge realtime collaborative editor"
---

In 2020, Google and I broke up. [DuckDuckGo](https://duckduckgo.com/) has long been my search engine of choice, but this year I replaced Gmail with [ProtonMail](https://protonmail.com/), Google Music died, and I found [Cryptpad](https://cryptpad.fr/), a "Zero Knowledge realtime collaborative editor" which provides everything I need from Google Docs (except [a backup strategy](https://www.redhat.com/sysadmin/world-backup-day)). With this [free, open-source software]((https://github.com/xwiki-labs/cryptpad)) deployed, I can log current events without fear of surveillance.

Though the project does not officially support Apache, nginx lacks features I require, so I still took the road less traveled. [A sample Apache proxy config](https://github.com/xwiki-labs/cryptpad/issues/62#issuecomment-270236705) was simple to find; I was particularly grateful for the hot tip regarding WebSocket traffic:

```bash
<VirtualHost *:80>
    Servername cryptpad.your-domain.tld
    ServerAlias www.cryptpad.your-domain.tld

    ProxyPass /cryptpad_websocket ws://127.0.0.1:3000/cryptpad_websocket
    ProxyPassReverse /cryptpad_websocket ws://127.0.0.1:3000/cryptpad_websocket

    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/
</VirtualHost>
```

Though I didn't explore the alternatives thoroughly, hosting the service in a separate vhost seems much simpler than hosting in a subdirectory. The modules that service these proxy rules weren't all enabled by default; running `sudo a2enmod proxy && sudo a2enmod proxy_http && sudo a2enmod proxy_wstunnel` brought up the requisite bits of code. [A systemd service descriptor](https://github.com/xwiki-labs/cryptpad/blob/02a4de58510ad7e9309b6757e99e8164cef91a58/docs/cryptpad.service) which launches Cryptpad on boot is available in the source tree.

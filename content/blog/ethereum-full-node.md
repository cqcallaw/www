---
title: "Contra Moxie - Ethereum Full Node"
date: 2022-01-22T12:28:16-08:00
draft: false
tags: ["howto", "foss", "web3", "dweb", "security"]
---

Moxie Marlinspike is [a Web3 skeptical](https://moxie.org/2022/01/07/web3-first-impressions.html). Though Marlinspike is no click-bait pundit, having helped deliver tremendous value to the world through [Signal](https://www.signal.org/), he's missing [technical details of NFTs](https://twitter.com/brian_armstrong/status/1479636373367922688), and I believe his first premise ("people don't want to run their own servers") is not generally true.

Communication technologies like email and Signal have stringent availability requirements, and are consequently high maintenance. Nobody wants to miss an important interview invitation or argue with their ISP about SLAs at 3 AM while the household frets. Conversely, many tech-savvy nodes in my social network have a [NAS](https://www.snia.org/education/what-is-nas), generally with underutilized compute resources. Many host personal websites and video game servers. People do this for the intellectual challenge, the practical education, and the sense of personal agency.

The key requirement is the ability to tolerate faults. If your uptime interferes with your sleep cycle, don't self-host. Occasional outages must be acceptable.

Ethereum [full nodes](https://ethereum.org/en/developers/docs/nodes-and-clients/#full-node) fall squarely in this fault-tolerant, low-maintenance category. If my node goes offline for hours with a failed RAID array, the network won't blink. No data will be lost. Setup is straightforward for folks with basic Linux sysadmin skills, as evidenced by the following tutorial.

Judging by the number of folks employed by major tech companies, there are probably 100s of thousands with access to these requirements. Only a subset of that population will care to participate, perhaps 10s of thousands. The number of active full nodes currently ranges around 5,000, per <https://ethernodes.org/history>.

## Ethereum Full Node Requirements

* Electricity
* Recent CPU, 16 GB of RAM, 500+ GB SSD (1 TB recommended)
  * As of this writing, an SSD is a hard requirement. HDDs [aren't fast enough](https://github.com/ethereum/go-ethereum/issues/20938#issuecomment-616402016).
* Stable Internet connection with unlimited bandwidth or a large bandwidth cap
* Basic Linux sysadmin skills

## Geth Setup

1. Create user and enable user service lingering:

    ```bash
    sudo adduser geth
    sudo loginctl enable-linger geth
    ```

2. Configure firewall to allow internode communication:

    ```bash
    sudo ufw allow 30303
    ```

3. Login as the `geth` user (`su` is not sufficient)

4. Download and deploy geth:

    ```bash
    mkdir -p /home/geth/.local/bin/ && cd /home/geth/.local/bin/
    wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.15-8be800ff.tar.gz
    tar xvzf geth-linux-amd64-1.10.15-8be800ff.tar.gz
    ln -sf geth-linux-amd64-1.10.15-8be800ff/geth geth
    ```

5. Configure service file `~/.config/systemd/user/geth.service`:

    ```bash
    # /home/geth/.config/systemd/user/geth.service
    [Unit]
    Description=Ethereum Go client

    [Service]
    Type=simple
    ExecStart=/home/geth/.local/bin/geth --http --http.corsdomain "chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn,https://localhost:3000,https://www.example.com/geth"

    [Install]
    WantedBy=default.target
    ```

    This service setup enables the HTTP RPC and configures CORS to support Metamask, local Node apps, and requests proxied by the server for `www.example.com`.
6. Start service:

    ```bash
    systemctl --user enable geth.service
    systemctl --user start geth.service
    ```

7. Monitor sync progress, which usually takes several hours to download the blockchain state and heal its state:

    ```bash
    journalctl --user -u geth.service -f
    ```

## Reverse Proxy Configuration

Nginx [recipes](https://www.nginx.com/resources/wiki/start/topics/recipes/geth/) are readily available, but I run Apache because [Nginx SPNEGO support](https://www.nginx.com/products/nginx/modules/kerberos-spnego/) requires Nginx Plus. To configure Apache:

1. Enable proxy modules

    ```bash
    sudo a2enmod proxy
    sudo a2enmod proxy_http
    ```

2. Configure geth proxy:

    ```bash
    # /etc/apache2/sites-enabled/000-default.conf
    ...
    <VirtualHost *:443>
        ServerName www.example.com
        ...
        <!-- geth proxy -->
        ProxyPass /geth http://127.0.0.1:8545
        ProxyPassReverse /geth http://127.0.0.1:8545
        ...
    </VirtualHost>

    ```

3. Restart service:

    ```bash
    sudo service apache2 restart
    ```

## Metamask Configuration

In Metamask's Settings, go to the Network section and click `Add a network`.

Any sufficiently descriptive value for the Network Name will do, but Chain ID must `1` and the RPC URL must point to the server's geth URL, e.g. `https://www.example.com/geth`.

## Verify

1. Check the Apache access logs to make sure Metamask is using the local node. For example:

    ```bash
    sudo tail -f /var/log/apache2/www.example.com.log
    ...
    <ip address> - - [29/Jan/2022:18:14:57 -0000] "POST /geth HTTP/1.1" 200 519 "-" <UA string>
    ...
    ```

2. Transfer a small amount of ETH between accounts when [gas prices](https://ethereumprice.org/gas/) are low. This transfer should be logged in the geth service log.

## References and Further Reading

* <https://ethereum.org/sk/developers/docs/nodes-and-clients/>
* <https://metamask.zendesk.com/hc/en-us/articles/360015290012-Using-a-Local-Node>
* <https://eth-docker.net/docs/About/Overview>
* <https://magnushansson.xyz/blog_posts/crypto_defi/2022-01-10-Erigon-Trueblocks>

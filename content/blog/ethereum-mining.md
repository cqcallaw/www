+++
author = "Caleb Callaway"
categories = ["cryptocurrency"]
date = 2020-05-02T20:52:58Z
description = ""
draft = false
slug = "ethereum-mining"
tags = ["cryptocurrency"]
title = "Mining Ethereum for Fun"

+++


# Step 1: Get a Wallet

To store the fruits of your computational labor, you will need an [Ethereum wallet](https://ethereum.org/wallets/). [Metamask](https://metamask.io/index.html) seems to be popular; [Atomic Wallet](https://atomicwallet.io/) is a decent stand-alone option. The wallet's *address* is shared with other agents to receive payment.

Most wallets offer plenty of advice about best practices for securing a wallet; follow it. Best practices usually reduce to the following:

1. Never share your password or your private key
3. There's no customer service center for crypto; make a backup
4. Be careful about sharing personally identifying information (more on this below)

# Step 2: Find Some Compute Power
A high-end GPU is the most common way to start mining. The best bang for one's buck changes as new hardware is released; a [quick search](https://duckduckgo.com/?q=ethereum+gpu+hashrates) should yield current data. Key metrics are *hashes per second* and *power consumption*.

For reference, the hashrate for my Nvidia GTX 1080 in its stock configuration is approximately 20.5 MH (megahashes) per second. As of this writing, 20.5 MH/s is enough to get started, but still squarely in hobbyist territory; more serious mining requires more serious hardware.

# Step 3: Get Software, Join a Pool
The software required for mining Ether is generally quite mature at this point. [ethminer](https://github.com/ethereum-mining/ethminer) seems to work well, though the latest "stable" release of ethminer has stability issues; I recommend [building from source](https://github.com/ethereum-mining/ethminer/blob/master/docs/BUILD.md).

With software in hand, one must join a mining pool; [ethermine](https://ethermine.org/) is a reasonable starting point. Key metrics for mining pools are *pool fees* and *payout schedules*. Every Ethereum transaction [has a transaction cost](https://ethereum.stackexchange.com/questions/3/what-is-meant-by-the-term-gas), so mining pools usually require a miner to reach a certain reward threshold before a payout is sent.

# Step 4: Testing
```
$ ~/src/ethminer/build/ethminer/ethminer -G -P stratum1+ssl://0xf7318Ac0253B14f703D969483fF2908b42b261cc.demo@us1.ethermine.org:5555
```

* -G selects OpenCL mining. I haven't noticed any different in hashrate between OpenCL and CUDA, so I opt for openness.
* -P specifies the pool in which I wish to participate.
* 0xf7318Ac0253B14f703D969483fF2908b42b261cc is the address of the Ethereum wallet I created to for demonstration purposes. Use your own wallet address here (or don't; I won't complain if you mine for me!)
* "demo" is a unique identifier for the mining platform, useful for differentiating mining platforms.

Mining pools have various payout rules. The ethermine.org minimum payout is 0.5 ETH; if you don't mine enough to hit that minimum in a week's time, your unpaid balance is swept to your wallet. The current status of my mining operation can be seen at https://ethermine.org/miners/0xf7318Ac0253B14f703D969483fF2908b42b261cc/dashboard. The mining operation for every wallet address will have a similar dashboard.

The dashboard URL neatly demonstrates an important property of cryptocurrencies; no personal information was required to start mining, but since I've identfied myself as the owner of wallet address 0xf7318Ac0253B14f703D969483fF2908b42b261cc by writing this blog post, you know exactly how much Ethereum I've mined. You can also [trace every transaction](https://www.etherchain.org/account/0xf7318Ac0253B14f703D969483fF2908b42b261cc) I make with this wallet. Every cryptocurrency transaction is a matter of public record, so think carefully before associating your personal information with a wallet!

# Step 5: Automation

ethminer occasionally loses its connection to the mining pool and then terminates, so I created a small user systemd service to automatically restart mining:

```bash
$ mkdir -p ~/.config/systemd/user/

# edit ~/.config/systemd/user/ethminer.service so it contains the following contents:
$ cat ~/.config/systemd/user/ethminer.service
Unit]
Description=Ethminer Ethereum Miner Daemon

[Service]
ExecStart=/home/caleb/src/ethminer/build/ethminer/ethminer -G -P stratum1+ssl://0x656d98Fe99fA98D4d38e45173203e8BFc881DD0C.pilgrim@us1.ethermine.org:5555 --cl-local-work 256 --cl-global-work 268435456
Restart=always
RestartSec=5s

[Install]
WantedBy=default.target

$ systemctl --user daemon-reload # reload service definitions
$ systemctl --user start ethminer.service # start service
$ journalctl --follow --user # follow service log
$ systemctl --user stop ethminer.service # stop service
$ systemctl --user enable ethminer.service # auto-start service when user logs in
```
More details about systemd user services can be found [on the Arch wiki](https://wiki.archlinux.org/index.php/Systemd/User).

# Useful Links

* https://ethereum.org/learn/
* https://unblock.net/cryptocurrency-consensus-algorithms/


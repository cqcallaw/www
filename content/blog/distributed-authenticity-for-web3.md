---
title: "Distributed Authenticity for Web3"
date: 2020-11-14T23:11:17-08:00
draft: false
tags: ["dweb", "web3", "security", "pgp", "gpg"]
---

[Certificate Authorities](https://en.wikipedia.org/wiki/Certificate_authority) are a form of centralized trust for which fully decentralized websites require an alternative. CAs are at the heart of the [Public Key Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) that provides authenticity, integrity, and confidentiality to millions of users around the world. While the tools to provide Web3 users with the similar capabilities are mostly complete, I see gaps in authentication capabilities, some of which I have attempted to fill.

Confidentiality and integrity are largely solved problems. Confidentiality can be established with libp2p [security transports](https://blog.ipfs.io/2020-08-07-deprecating-secio/) and [Tor](https://www.torproject.org/). Files published through [IPFS](https://ipfs.io/) aren't vulnerable to integrity issues as long as the content hashing scheme holds. Authentication is the only capability for which support is lacking.

If one trusts the public key of an ENS domain controller, an ENS record pointing to IPFS CID establishes authenticity for entire site. ENS records are continually updated, however, so old revisions of the site become unverifiable. Maintaining a history of ENS records would require non-trivial revisions to the ENS smart contract, and cause the data associated with a given domain to grow without bound, particularly busy sites.

Fortunately, we have an existing distributed trust model in the form of the venerable [GnuPG](https://gnupg.org/). While GPG is [famously unintuitive](https://www.gnupg.org/gph/en/manual/c562.html#AEN567), front ends like [Seahorse](https://wiki.gnome.org/Apps/Seahorse) and hardware solutions like [YubiKey](https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP) have alleviated some of this pain, and [quickstart guides abound](https://duckduckgo.com/?q=gnupg+quickstart).

An inline PGP signature makes HTML document validation difficult and corrupts a binary file, so we must use detached signatures. Signatures on one or two files at the root of the website isn't enough; signed files can be re-bundled with corrupted or inauthentic data. Every file must be signed.

Serially signing many files with GnuPG is not fast, but modern CPUs have many threads which are frequently idle. Using [GNU parallel](https://www.gnu.org/software/parallel/) and [Python multiprocessing](https://docs.python.org/3.7/library/multiprocessing.html#using-a-pool-of-workers) exhibited odd out-of-memory errors until Werner Koch, principle developer of GnuPG, [explained](https://lists.gnupg.org/pipermail/gnupg-users/2020-November/064346.html):

>This is all serialized because the gpg-agent does the actual signing. There is one gpg-agent per GNUPGHOME. Thus the easiest solution for you is to provide copies of the GNUPGHOME and either set this envvar for each process or pass --homedir=decicated-homedir-copy. You can't use links to the same directory because we use lock files. However, it should be possible to sumlink the private-keys-v1.d sub directories.

Armed with this knowledge, I wrote [a Python script](https://github.com/cqcallaw/www/blob/94f0dbb84fa3908acdd698d7b67071bf4f2a723b/sign.py) that generates good PGP signatures across every file on the website while fully utilizing all 16 of my CPU's threads. The result can be seen on [brainvitamins.eth](http://www.brainvitamins.eth). For any given file, a corresponding `.sig` file should exist that can be verified using [my public key](/pubkey.asc).

Next step: [building a browser extension to automatically verify signatures and trust pubkeys as required](/blog/qui).

---
title: "Regen"
author: "Caleb Callaway"
date: 2020-10-25T22:15:00-07:00
draft: false
tags: ["dweb"]
---

New look. New tools as well; replicating the site [on the Dweb](http://www.brainvitamins.eth) necessitated [a static site generator](https://gohugo.io/categories/getting-started). The technical details are something of a boring grind, but [my code is available](https://github.com/cqcallaw/www) to interested parties. It took some tinkering, but no links have rotted except the [RSS feed](/blog/index.xml).

The workflow for drafting posts is decidedly less friendly than Ghost, which provides a remote private backup that isn't easily replicated in git. That said, I generally like static generation; in addition to being [Web3](https://blockchainhub.net/web3-decentralized-web/) friendly, my webserver no longer requires Node and MySQL, which was [complicated](/blog/ghost-1-0.md), resource-intense, and presented a larger attack surface for hackers. Those extra dependencies will not be missed.

## Resources

* [IPFS Static Site Generator Docs](https://docs.ipfs.io/how-to/websites-on-ipfs/static-site-generators/)
* [Ghost to Hugo Convertor](https://github.com/jbarone/ghostToHugo)
* [Another blogger's conversion notes](https://blog.davidburela.eth/2020/05/23/converting-my-blog-from-wordpress-to-jekyll.html)
* [Previewing the site](https://ethereum.stackexchange.com/a/89612/64250)
* [Getting reproducible resume builds](https://tex.stackexchange.com/questions/568235/how-do-i-configure-pdflatex-to-output-binary-equivalent-pdfs-if-the-input-tex-fi)

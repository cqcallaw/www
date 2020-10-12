+++
author = "Caleb Callaway"
categories = ["security", "cryptocurrency", "dweb"]
date = 2020-09-25T10:48:50Z
description = ""
draft = false
slug = "the-dweb-needs-work"
tags = ["security", "cryptocurrency", "dweb"]
title = "The Dweb Needs Work"

+++


[Balaji Srinivasan](https://balajis.com/) has been evangalizing a decentralized Internet lately, which inspired me to explore [IPFS](https://ipfs.io/) + [ENS](https://app.ens.domains/) as a means of realizing a more resilient and censorship-resistent Internet. Hybrid solutions exist, but I believe decentralization needs work before it's ready for prime time. Updates cost too much, peer relationships are brittle, and authenticity seems largely unmapped.

# The Basics
This blog post does not replace [the ipfs.io docs](https://docs.ipfs.io/), which are good. Newcomers to IPFS would be particularly well-served by [What is IPFS?](https://docs.ipfs.io/concepts/what-is-ipfs/) and [the CLI quickstart](https://docs.ipfs.io/how-to/command-line-quick-start/).

# The Name of the Thing
IPFS Content Identifiers (CIDs) are long strings of alphanumeric characters less memorable than a corporate Twitter account, necessitating a map to human-readable names. ENS seems to be [the emerging standard](https://docs.ipfs.io/how-to/websites-on-ipfs/link-a-domain/). Anyone who's used a domain name registrar will have an intuition for how this works; specify a name, pay a fee, wait, and properly configured browsers start resolving your name. If you've got an IPFS node [setup](https://github.com/ipfs-shipyard/ipfs-desktop#install) and the [IFPS companion](https://github.com/ipfs-shipyard/ipfs-companion#ipfs-companion) installed, try accessing http://www.brainvitamins.eth for the Dweb version of my homepage.

Updates to ENS are _expensive_, though. Holy cow. The [public record](https://etherscan.io/address/0xf7318ac0253b14f703d969483ff2908b42b261cc) of my neophyte stumbling starts with a seemingly sufficient [transfer](https://etherscan.io/tx/0x192bce8910abd0ce5ebee5c0fbc86c843180aaa1b41baba6e9129fbf1daee6b3) of funds, quickly followed by [a second transfer](https://etherscan.io/tx/0x0224f10a3f3a839cadb4d227f5f0b3520a3e8f6970a2ac2b2559e5cd00374251), then a [third](https://etherscan.io/tx/0xabd014496180ffc79549b44d805eb6be0f1ee4934c2d0e8074eeb3209fa400c9) when the true cost of transaction fees is made manifest. As I write this, the registration fee is convertable to slightly north of 10 USD. The transaction fees for each record update are worth $2-$3.

The price of ENS updates may seem reasonable until one notes that every website update requires an ENS update, because everything in IPFS is stored in [Merkle DAGs](https://docs.ipfs.io/concepts/merkle-dag/), beautiful structures that might inspire site reliability engineers to write poetry and Dweb bloggers to form anti-poetry unions. In the pure and stateless world of Merkle DAGs, every change generates a new DAG. The size and scope of the change matters not; a single-character typo correction and a new blog post both require a new DAG, and every new DAG means a new root node to which the ENS record must point. The high cost of transactions is [a known issue](https://twitter.com/VitalikButerin/status/1285593115672358912); I don't expect ENS to be widely adopted until this issue is resolved.

If we move our decentralization goalposts, services like [Fleek](https://docs.ipfs.io/how-to/websites-on-ipfs/introducing-fleek/) can help. Fleek hosting workflows depend on centralized services like Github, so it's a hybrid solution that isn't fully censorship-resistant. Hybrid solutions might be an acceptable tradeoff; I'd want a damn good spellchecker if every misuse of "it's" as a possessive pronoun could cost me $5 to fix.

# Good Peers are Hard to Find
Browsing my Dweb homepage from the local host works. Browsing my Dweb homepage from my LAN-connected laptop works, once the laptop's IPFS service discovers the local peer. Browsing my Dweb homepage from Sweden does not work (so far). The IPFS nodes can't even `ipfs ping` each other.

The Swedish failure to access doesn't surprise me; discovery in a peer-to-peer network is a hard problem. Even if one has the technical skills to properly configure [firewall, NAT, and port-forwarding](https://docs.ipfs.io/how-to/nat-configuration/), ISPs often hand out dynamic IP address assignments, which means an update to the [DHT](https://docs.ipfs.io/concepts/dht/) must propagate to all interested nodes every time the utility company cuts power.

IPv6 ought to help but doesn't; ISPs can delegate prefixes dynamically. A static prefix delegation from a service like Hurricane Electric's legitimately awesome [tunnelbroker.net](https://tunnelbroker.net/) solves the problem for those with the relevant skillset, though such a solution is limited to IPv6; IPv4 peers need not apply. Folks that require immediate access to my cleverly captioned cat pictures might also want to [modify their peers list](https://docs.ipfs.io/how-to/modify-bootstrap-list/).

The solution on which I'm converging is a LAN-attached IPFS node with a publicly routable IP address in which my files are pinned and from which other local hosts fetch data as needed. My uptime is generally lousy, but likely sufficient for aficionados of captioned cat picture. For those with less technical inclination or stronger availability requirements, pinning services like [Pinata](https://pinata.cloud/) solve the availability problem by [pinning](https://docs.ipfs.io/concepts/persistence/) data on publicly accessible nodes; this is another example of a hybrid solution with centralized components.

# Infosec
Authenticity, confidentiality, and integrity are traditionally addressed (with varying degrees of success) by [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security). The Dweb's content-addressing model should address any integrity concerns; content tampering is instantly detectable as a change to the CID (if not, every user of distributed version control will have an extremely bad day). [Encrypted transport](https://blog.ipfs.io/2020-08-07-deprecating-secio/) should resolve any confidentially issues. Authenticity seems to be an area of [active research](https://www.researchgate.net/publication/325819333_IPFS-Blockchain-based_Authenticity_of_Online_Publications); applications of [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) signing are obvious, though [webs of trust](https://en.wikipedia.org/wiki/Web_of_trust) seem beyond the ken of Joe and Jane User. Something akin to SSH's "do you want to trust this server?" prompt might work. [InstaNotary](https://github.com/rekpero/InstaNotary) could be interesting if a desktop app is made available.

User tracking isn't really a thing, either. As the Dweb search engine [Almonit](http://almonit.eth.link/) says:

```
How does Almonit search engine protects [sic] your privacy?
The right question to ask is actually “Can Almonit search engine violate your privacy?”, and the answer is 'No'. The search process is done without any interaction with us or any other third party, hence we have no way to know what you search for.
```

On the other hand, there is no "right to be forgotten" on the Dweb. That's a good thing for folks fighting content censorship and a less good thing for folks fighting child pornography. The Dweb protects the extra-naughty as much as it protects the extra-nice.

Folks clamoring for an edit button on Twitter will have a bad time on the Dweb as well; all potentially embarrassing political opinions are preserved like ants in amber.

# The Solution Space
The technical hurdles described above would include solutions if I was clever enough to have solved them. The difficulty of maintaining robust peer-to-peer routes is a particularly thorny problem with [old solutions](https://en.wikipedia.org/wiki/STUN). A hybrid solution may be necessary. I'm most encouraged by the work done to establish Dweb authenticity, though the work I've seen depends on the Ethereum block-chain and is therefore limited by Ethereum gas prices. All eyes on the Ethereum community to get that one under control.

I also wonder if the content distribution mechanisms developed for a centralized web are simply unsuitable for the Dweb; maybe we're better served by new models that "lean in" to the Dweb's stateless eventual propagation. Maybe Martians will remember weblogs as historical curiosities.

_If you enjoyed this post and would like to support the blog, please feel free to tip me at Ethereum address 0xf7318Ac0253B14f703D969483fF2908b42b261cc_


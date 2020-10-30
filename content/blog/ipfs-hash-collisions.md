---
title: "IPFS Hash Collisions"
date: 2020-10-29T18:20:20-07:00
draft: false
tags: ["dweb", "security"]
---

IPFS decomposes large files into [blocks](https://docs.ipfs.io/concepts/bitswap/) which are [hashed](https://dweb-primer.ipfs.io/ipfs-dag/crypto-hash) to [Content Identifiers](https://docs.ipfs.io/concepts/content-addressing/). As of this writing, the default block size is [256 * 1024 bytes](https://docs.ipfs.io/reference/cli/#ipfs-add), hashed by SHA256 to generate a 256 bit hash. The size of a block exceeds that of the hash; by the [pigeonhole principle](https://en.wikipedia.org/wiki/Pigeonhole_principle), some number of blocks will share the same hash. If SHA256's distribution of hash values is perfectly uniform, 8192 blocks must share the same hash.

Is this a problem in practice? Probably not. While it's theoretically possible for my dog's adorable mug to share a hash with a blurry snapshot of some spoons, it's been [observed](https://discuss.ipfs.io/t/what-to-do-in-case-of-hash-collision/482/2) that even a supercomputer would require millennia to search the hash space for colliding hashes. Humans taking pictures of pretty creatures do not generate new hashes at nearly the same rate. As a failsafe, the [multihash](https://multiformats.io/multihash/) spec supports the use of newer hash functions should SHA256 ever become obsolete.

_My dog is glad I'm not worried about hash collisions but thinks I should tidy up so he can play with his raccoon._

![dog](/blog/content/images/2020/10/dog.jpg)

## Related

* [https://crypto.stackexchange.com/questions/47809/why-havent-any-sha-256-collisions-been-found-yet](https://crypto.stackexchange.com/questions/47809/why-havent-any-sha-256-collisions-been-found-yet)

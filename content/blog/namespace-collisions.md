+++
author = "Caleb Callaway"
date = 2016-03-25T12:20:23Z
description = ""
draft = false
slug = "namespace-collisions"
title = "Conflicting Names"

+++


The 17 lines of code that "[broke the Internet](http://arstechnica.com/information-technology/2016/03/rage-quit-coder-unpublished-17-lines-of-javascript-and-broke-the-internet/)" is probably familiar to most by now, but I believe it's worth noting that the underlying issue already has a robust solution in the form of the Internet's [Domain Name System](https://en.wikipedia.org/wiki/Domain_Name_System).

Put simply, the issue is that the name "kik" was ambiguous; that is, a [https://en.wikipedia.org/wiki/Naming_collision](naming collision) occurred. [Namespaces](https://en.wikipedia.org/wiki/Namespace) are a well-known solution to this problem, and npm supports namespaces in the form of [scopes](https://docs.npmjs.com/misc/scope), but in this case the scope used was the generic name `starters`. Mike Bostock of D3.js fame rightly observed:

<blockquote class="twitter-tweet tw-align-center" data-lang="en"><p lang="en" dir="ltr">That the owner can change as part of a patch upgrade with npm seems rather dangerous. Another reason to prefer “author/package” naming!</p>&mdash; Mike Bostock (@mbostock) <a href="https://twitter.com/mbostock/status/712686996389388288">March 23, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Disambiguation by author name is certainly a step in the right direction, but I believe that author names alone are insufficient, for author names _may also collide_: it's quite conceivable for some enterprising and talented developer use the handle `kik` as their author name on the npm package registry. Furthermore, the namespacing issue is not just a issue for npm, but for all package management systems. I therefore assert that ad-hoc, unmanaged namespaces are unacceptably fragile and collision-prone, and that a centralized, managed namespace authority is the only permanent solution to this class of problems.

The Internet's DNS is the most widely-used namespace authority on the planet, so there's precious little reason to build another one. It's slightly surprising that a package registry that is as Internet-oriented as npm hasn't reused this existing solution to the namespace problem, although I can respect the desire to simplify wherever possible.

In any event, having an established convention of using an Internet domain name as a package namespace and thereby avoiding repetition and wheel-reinvention would have avoided the original issue entirely. The folks at Kik would release their package in the `com.kik` namespace, Koçulu would release his package in some personal domain space (e.g. `me.azer`), and there would be no need to unpublish, change ownership, or break the Internet. The idea isn't original, of course, but rather one of the things I believe [Java gets right](http://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html).

Registering a domain name is not hard, doesn't have to be expensive, and provides a namespace that is very likely to be universally unique and can be re-used in a number of contexts, such as software package namespaces. It also has the nice side-effect of surfacing trademark issues quickly.

(Parenthetically, the linked article presents Koçulu as completely disinterested with negotiation and compromise with the "corporate dicks" at Kik. Perhaps facts have been omitted, but Koçulu appears to have engaged in exactly the same sort of intransigent behavior he finds so offensive, and therefore seems to be incredibly hypocritical.)


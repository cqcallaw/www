+++
author = "Caleb Callaway"
date = 2016-01-30T04:20:12Z
description = ""
draft = false
slug = "managing-the-namespace"
title = "Managing the Namespace"

+++


While deploying this blog, I found myself thinking deeply about the design of its URI and making it [cool](https://www.w3.org/Provider/Style/URI.html).

Three choices come to mind:

* www.brainvitamins.net (deploy at root)
* blog.brainvitamins.net (deploy in a virtual host)
* www.brainvitamins.net/blog (deploy in a path)

The first option puts the blog front and center, and is a very attractive landing page, but leaves the entire server path in the hands of a single application (unless exceptions are made). The second option is fairly common practice, but assigning an entire host name to a single web application--establishing a functional equivalence between a "host" and an "application"--has always felt like a poor abstraction to me.

The third option feels most correct, particularly since there are other [web applications](/tock) running on the server; the third option also provides the most room for growth and adaptation of the brainvitamins.net namespace. Flexibility is a desirable property for me: I don't want to write redirect/rewrite logic later because my blog moved. The lack of an attractive landing page and the reduced discoverability of the blog really bother me, but path deployment seems to best match my intentions for the blog's place in Universe. We'll see how it goes.


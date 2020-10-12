+++
author = "Caleb Callaway"
date = 2017-12-31T05:30:07Z
description = ""
draft = false
slug = "newt"
tags = ["newt"]
title = "newt does I/O"

+++


newt recently hit the (long over-due) milestone of basic I/O. Examples:

* https://github.com/cqcallaw/newt/blob/0.1/tests/t12000.nwt
* https://github.com/cqcallaw/newt/blob/0.1/tests/t12001.nwt

The examples rely on place-holder standard library definitions, specified in https://github.com/cqcallaw/newt/blob/0.1/tests/includes/io.nwt

Engineering the supporting functionality (recursive functions, using blocks, function overloads, import mechanisms, etc) took quite a bit of effort; memory management also chewed up a lot of time. I felt this cost was acceptable, since I've always intended for newt to be more than a proof-of-concept; I believe important data is lost in the implementation gaps and hand-waving that are frequently employed in POCs.

Happy New Year!


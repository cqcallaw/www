+++
author = "Caleb Callaway"
date = 2018-03-03T12:53:35Z
description = ""
draft = false
slug = "bdb0060-panic-fatal-region-error-detected-run-recovery"
title = "BDB0060 PANIC: fatal region error detected; run recovery"

+++


Recently I noticed the Github webhook that notified the Brainvitamins website of changes to my [resume](https://github.com/cqcallaw/resume) was bringing the site to its knees. Each time the webhook was triggered, the Apache error log was flooding with the following error:

> BDB0060 PANIC: fatal region error detected; run recovery
> BDB0060 PANIC: fatal region error detected; run recovery
> BDB0060 PANIC: fatal region error detected; run recovery
> [repeat ad infinitum until the server runs out of disk space]

Seems the recent Ghost upgrade corrupted the Apache installation somehow, because it was necessary to backup my Apache configuration files and purge the Apache installation (something akin to `sudo apt remove --purge apache2 && sudo apt --purge autoremove`) to resolve the issue. I found very little information about this error online; hopefully this post will help some other lost soul encountering a similar issue.


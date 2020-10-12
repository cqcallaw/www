+++
author = "Caleb Callaway"
date = 2019-12-01T05:46:35Z
description = ""
draft = false
slug = "new-monitor"
title = "New Monitor"

+++


[Skyrim SE](https://www.protondb.com/app/489830) looks fantastic at 2560x1440 on the [27 inch IPS ASUS ROG display](https://www.amazon.com/gp/product/B07HZSBW7V/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1) I picked up in a Black Friday sale. Works nicely with a [Flow monitor arm](https://www.hermanmiller.com/products/accessories/technology-support/flo-monitor-arms/) for maximum desktop real estate.

The max refresh rate reported by Ubuntu is 144hz. I'm not terribly worried about it because the [Steam overlay's FPS counter](https://ccm.net/faq/40667-how-to-display-the-in-game-fps-counter-on-steam) shows Skyrim capped at 60 FPS, even with [vysnc disabled system-wide](https://www.reddit.com/r/linux_gaming/comments/bmlywm/important_tips_for_steamplayprotondxvk_on_nvidia/). Apparently this is [limitation of the game](https://steamcommunity.com/app/489830/discussions/0/312265589446946685/). Shadow of Mordor cheerfully exceeds 60 FPS but only if the FPS cap and vsync are disabled in-game, so I suspect a modeline reporting issue of some sort. `xrandr --query` reports '59.95 + 144.00' as the refresh rate.

I've always thought it best for the environment and my bank account to use a piece of technology until it was completely broken and unusable, but this purchase has definitely made me reconsider that position. Maybe it's finally time to jump on the raytracing bandwagon.


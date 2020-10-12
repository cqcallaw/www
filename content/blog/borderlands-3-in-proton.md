+++
author = "Caleb Callaway"
date = 2020-03-28T19:05:09Z
description = ""
draft = false
slug = "borderlands-3-in-proton"
tags = ["gaming"]
title = "Borderlands 3 in Proton"

+++


Borderlands 3 recently became available through Steam, and I'm happy to report it plays quite well in Proton with the commonly available Media Foundation work-arounds installed. My Nvidia GTX 1080 yields a respectible 50 FPS at 2560x1440 with "Badass" quality settings.

Out-of-the box, I noticed a lot of choppiness in the framerate which disappears after the first few minutes of gameplay, even with the lowest quality settings. This is consistent with shader cache warmup issues, so I configured a dedicated, peristent shader cache with [Steam launch options](https://support.steampowered.com/kb_article.php?ref=1040-JWMT-2947):

```
__GL_SHADER_DISK_CACHE='1' __GL_SHADER_DISK_CACHE_PATH='/home/caleb/tmp/nvidia/shaders/cache' __GL_SHADER_DISK_CACHE_SKIP_CLEANUP='1' %command%
```

My GPU doesn't share a power budget with the CPU, so I also configured the [performance CPU frequency governor](https://support.feralinteractive.com/en/mac-linux-games/shadowofthetombraider/faqs/cpu_governor/).

With the tweaks, the game itself is quite playable, though I still see some stutter in the benchmark mode that's not present when the benchmark runs in Windows. Benchmarking data is limited to the average FPS number, which makes quantifying the choppiness difficult. The statistic of interest for choppiness would be the *minimum* FPS, but I haven't found a tool for logging this data. Suggestions?


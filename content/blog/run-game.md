---
title: "run-game.sh"
author: "Caleb Callaway"
date: 2026-08-08T11:09:36-07:00
draft: false
tags: ["gaming"]
---

# When PROTON_LOG=1 Isn’t Enough
Sometimes the basic Proton log just doesn’t cut it. For deeper debugging, you can wrap the game with a small helper script that can capture a much richer set of Wine/DXVK/VKD3D debug information and enable arbitrary environment overrides.

Credit to [Ken Graunke](http://www.whitecape.org/) for the original approach.

# Setup

1. Set the game’s launch options in Steam:

```
$HOME/run-game.sh %command%
```

2. Create the script:

```
cat >> $HOME/run-game.sh << 'EOF'
#!/bin/sh

export DXVK_LOG_LEVEL=debug
export VKD3D_DEBUG=trace
export WINEDEBUG=+winediag,+timestamp,+pid,+tid,+seh,+vkd3d,+vkd3d-proton,+unwind,+threadname,+debugstr,+loaddll,+mscoree
# force Intel vendor ID (example from my own Mesa testing)
# export force_vk_vendor=0x8086

exec "$@" 2>&1 | tee $HOME/run-game.log
EOF
chmod +x $HOME/run-game.sh
```

# Using the Log
After launching the game, inspect the output with:

```
tail -f $HOME/run-game.log
# or cat / grep as needed
```

**Note**: These debug channels can be extremely verbose. Be sure to unset the environment variables (or remove the script from the launch options) for any performance testing.

Wine debug channels reference: https://gitlab.winehq.org/wine/wine/-/wikis/Debug-Channels
---
title: "Building Mesa for Driver Bisection"
date: 2023-03-07T16:16:09-08:00
draft: true
author: "Caleb Callaway"
tags: ["tech", "linux", "gaming"]
---

For recent Ubuntu releases:

## 1. Build

```bash
# install dependencies
sudo apt build-dep mesa
# create source directory
mkdir -p ~/src && cd ~/src
# checkout source
git clone https://gitlab.freedesktop.org/mesa/mesa.git && cd mesa
# build and deploy
mkdir build-`git describe --always --tags`
cd build-`git describe --always --tags`
meson .. --prefix=/usr/local-`git describe --always --tags`
sudo ninja install
# symlink deployment directory to /usr/local
sudo ln -sfn /usr/local-`git describe --always --tags` /usr/local
```

## 2. Configure

Add the following lines to `/etc/environment`:

```bash
# Override GL driver path.
# The Steam UI and some game launchers require 32-bit libraries,
# so we include the 32-bit system library path.
LIBGL_DRIVERS_PATH=/usr/local/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri

# Override Vulkan ICD path.
# Here Intel is used; replace with other vendor ICDs as needed.
VK_ICD_FILENAMES=/usr/local/share/vulkan/icd.d/intel_icd.x86_64.json
```

## 3. Reload Environment

The Gnome Desktop Environment must be reloaded using the new environment. Rebooting works, but it's slow. To reload faster, switch to a new [virtual console](https://www.makeuseof.com/what-are-linux-virtual-consoles/) and start a new session, then restart the Gnome session manager with the following command:

```bash
sudo systemctl restart gdm3
```

## Debug

```bash
# Check that Vulkan is using correct the driver revision.
vulkaninfo --summary | grep driverInfo

# Display sorted environment variables;
# verify LIBGL_DRIVERS_PATH and VK_ICD_FILENAMES are set.
env | sort

# Check journalctl for errors.
journalctl -b | grep gdm-x-session
```

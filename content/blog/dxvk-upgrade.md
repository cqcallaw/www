---
title: "Upgrading DXVK in Proton"
date: 2021-02-24T21:22:26-08:00
draft: false
summary: "Upgrading DXVK in Proton"
---

Upgrading [DXVK](https://github.com/doitsujin/dxvk) is complicated by Proton's safeguards against corrupted prefixes. Running [setup_dxvk.sh](https://github.com/doitsujin/dxvk/blob/5e55ced8b26651d231254da66c8d914b72b2b5ac/setup_dxvk.sh) for a given prefix will fail because Proton [overwrites](https://github.com/ValveSoftware/Proton/blob/7c91f57ec93b1ebf07799651b993e01b88ce30b8/proton#L565-L570) the modified files when the game launches. Instead, updated DLLs must be deployed to the Proton folders from which updates are sourced.

For example, to upgrade [GloriousEggroll 6.1-GE-2](https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/6.1-GE-2) to [DXVK v1.8](https://github.com/doitsujin/dxvk/releases/tag/v1.8):

```bash
# Download new DXVK release
cd ~/Downloads
wget https://github.com/doitsujin/dxvk/releases/download/v1.8/dxvk-1.8.tar.gz
tar xvzf dxvk-1.8.tar.gz

# Backup existing DLLs
# It is very important to copy--not move--the original directory
# `dist/lib/wine/dxvk` contains files that aren't distributed in DXVK releases,
# and games will silently fail to launch if these extra files don't exist.
cp -vaur ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib/wine/dxvk/ \
 ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib/wine/dxvk_orig/
cp -vaur ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib64/wine/dxvk/ \
 ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib64/wine/dxvk_orig/

# copy new DLLs
cp -vaur ~/tools/dxvk-master/x32/* \
 ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib/wine/dxvk/
cp -vaur ~/tools/dxvk-master/x64/* \
 ~/.steam/compatibilitytools.d/Proton-6.1-GE-2/dist/lib64/wine/dxvk/
# <run game to update prefix>

# verify DLL version is correct--the output should be 'v1.8'
# substitute the correct Steam Game ID for the one used here
strings ~/.steam/steam/steamapps/compatdata/292030/pfx/drive_c/windows/system32/dxgi.dll | grep '^v[0-9]\.'
```

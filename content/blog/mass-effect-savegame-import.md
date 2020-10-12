+++
author = "Caleb Callaway"
date = 2020-08-16T20:05:31Z
description = ""
draft = false
slug = "mass-effect-savegame-import"
title = "Import Mass Effect Proton Savegame Into Mass Effect 2"

+++


```
$ mkdir -p ~/.steam/steamapps/compatdata/24980/pfx/drive_c/users/steamuser/My Documents/BioWare/Mass Effect 2/Save/ME1
$ cp -vr ~/.steam/steamapps/compatdata/17460/pfx/drive_c/users/steamuser/My\ Documents/BioWare/Mass\ Effect/Save/* ~/.steam/steamapps/compatdata/24980/pfx/drive_c/users/steamuser/My Documents/BioWare/Mass Effect 2/Save/ME1
```

The Mass Effect save should now be available for import in the Mass Effect 2 New Game interface.

The path prefixes here are the [WINE prefixes](https://linuxconfig.org/using-wine-prefixes) used by Proton. `17460` is the Steam game ID for [Mass Effect](https://store.steampowered.com/app/17460/Mass_Effect/); `24980` is the Steam game ID for [Mass Effect 2](https://store.steampowered.com/app/24980/Mass_Effect_2/).

This quick tip brought to you by information from https://answers.ea.com/t5/Mass-Effect-2/PC-Importing-a-save-file-from-Mass-Effect-1/m-p/5810699#M7696


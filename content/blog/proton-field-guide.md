+++
author = "Caleb Callaway"
date = 2020-10-08T06:28:13Z
description = ""
draft = false
slug = "proton-field-guide"
title = "A Proton Field Guide"

+++


[Proton](https://github.com/ValveSoftware/Proton/) is good. Backed by Valve Software, Proton builds on existing F/OSS projects like [Wine](https://www.winehq.org/) and [DXVK](https://github.com/doitsujin/dxvk) to provide Linux support for video games. Performance can be quite good; I've heard Proton out-performs poorly optimized native ports in some cases.

# Initial Setup
Valve provides [beta support](https://steamcommunity.com/games/221410/announcements/detail/1696055855739350561) for a small selection of titles. Less formal support is available for a larger set of titles through the "Steam Play->Enable Steam Play for all other titles" option in the Settings dialog.

![enable-steam-play](/blog/content/images/2020/10/enable-steam-play.png)

Steam downloads the Windows version of a Proton-enabled app, but still stores files in the familiar `~/.steam/steam/steamapps/common/[appname]` directory. On first launch, Proton provisions a Wine prefix (created in `~/.steam/steam/steamapps/compatdata/[appid]` by default) that holds pertinent state data and a basic Windows filesystem in `$WINEPREFIX/pfx/drive_c`. This filesystem is presented to the app as its root Windows filesystem. Save games are usually stored in the prefix as well, making save game import [complicated](https://www.brainvitamins.net/blog/mass-effect-savegame-import/). 

Windows applications frequently have additional dependencies like the [Visual C++ Runtime Redistributables](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads), and apps may require specific workarounds to run well in Wine environments. Many of these concerns are managed by the app's install script (usually `~/.steam/steam/steamapps/common/[appname]/installscript.vdf`), but `~/.steam/steam/legacycompat/iscriptevaluator.exe` also runs inside the Wine environment during initial provisioning and appears to manage Proton-specific dependencies and tweaks.

# Provisioning New Apps
Games don't launch with Proton support, but official Proton releases aren't built for tinkering; community-sourced forks of the Proton project have flourished as a result. [Glorious Eggroll](https://github.com/GloriousEggroll/proton-ge-custom) is one popular fork that contains bleeding-edge app compatibility fixes, quality-of-life improvements, and a few workarounds that Valve doesn't enable for legal reasons.

New apps generally don't work out-of-the-box; a bit of sleuthing is usually required to identify workarounds and missing dependencies. The Proton log is the first point of consult; this log can be [enabled per-app](https://www.reddit.com/r/linux_gaming/comments/9ahd3k/how_do_you_get_steam_to_output_logs_for_proton/e4venek?utm_source=share&utm_medium=web2x&context=3) or by launching Steam with `PROTON_LOG=1` in the environment (just be sure to close all open instances of Steam; the app's environment is derived from the environment in which Steam initially launches). I prefer the CLI, so I use something like this:

```
$ killall -w steam && PROTON_LOG=1 steam -applaunch [appid]
```

The Steam app ID can be found in the app's Steam URL. For example, 3DMark's URL is https://store.steampowered.com/app/223850/3DMark/ and its app ID is 223850.

Once an app issue has been root-caused, [protonfixes](https://github.com/simons-public/protonfixes) (available as part of Proton-GE) is a handy framework for applying a fix. protonfixes relies heavily on [the protontricks wrapper for Winetricks](https://github.com/Matoking/protontricks), so common workarounds are generally available as [Winetricks verbs](https://github.com/Winetricks/Winetricks/blob/master/files/verbs/all.txt). For example, if my fun new game requires the VC++ 2015 redistributable, I would use this in `~/.config/protonfixes/localfixes/[appid].py`:

```
from protonfixes import util

def main():
    util.protontricks('vcrun2015')
```

protonfixes supports more complicated workarounds as well; see [Writing Gamefixes](https://github.com/simons-public/protonfixes/wiki/Writing-Gamefixes) for details.

# Provisioning Non-Steam Apps
Proton is mature enough to support apps outside of Steam, though setup is a bit more complicated. I prefer the CLI for such cases; Steam's builtin "Add a Non-Steam Game to My Library" tends to obscure important details.

When Proton is launched from the command line, one must provide the `STEAM_COMPAT_DATA_PATH` env var and the `SteamGameId` env var must be set for Proton logging to function correctly. The game ID will necessarily be fake; pick whatever suits you. For example, to run a hypothetical FunGame's installer:

```
$ SteamGameId=FunGame STEAM_COMPAT_DATA_PATH=~/Games/FunGame/ ~/.steam/steam/compatibilitytools.d/Proton-5.9-GE-6-ST/proton waitforexitandrun ~/Downloads/fun_game_installer.exe
```

Then, with the game installed:

```
$ SteamGameId=FunGame STEAM_COMPAT_DATA_PATH=~/Games/FunGame/ ~/.steam/steam/compatibilitytools.d/Proton-5.9-GE-6-ST/proton waitforexitandrun ~/Games/FunGame/pfx/drive_c/fungame/install/path/fungame.exe
```

# Sleuthing Tips
Crafting a compatibility recipe requires some familiarity with Windows workloads and their requirements, but in general:

* Some apps work better with older Proton releases; the version of Proton used can be controlled in the app's Properties dialog
* Hacking print statements into the proton script is useful for debugging startup issues (make a backup!)
* Dependency issues often show up in the Proton log (make sure SteamGameId is defined)
* Compatibilty reports from [protondb](https://www.protondb.com/) often include useful tips and tricks
* Take inspiration from officially supported apps where possible:
    * Use `ps auxw | grep -i [app]` to identify the app PID, then run `strings /proc/[PID]/environ | sort` to view the process environment.
    * Snoop iscriptevaluator.exe operation. For example, iscriptevaluator.exe consumes a file named `~/steam/debian-installation/legacycompat/evaluatorscript_223850.vdf` during 3DMark first run setup; this temporary file describes the procedure for installing VC++ Runtime and DirectX redistributables.
* Install scripts from [Lutris](https://lutris.net/) contain useful provisioning info
* Always test the final version of your recipe in a clean prefix

# Example: GOG Galaxy + Wasteland 3
I opted for the DRM-free version of Wasteland 3 so I could exercise Proton's advanced features:

1. Download and [install](https://github.com/GloriousEggroll/proton-ge-custom#installation) the [Proton-5.9-GE-7-ST](https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/5.9-GE-7-ST) release.
2. Download https://content-system.gog.com/open_link/download?path=/open/galaxy/client/setup_galaxy_2.0.16.187.exe (as seen in the [Lutris install script](https://lutris.net/games/install/17225/view)).
3. Create a compatibility recipe in `~/.config/protonfixes/localfixes/gog.py` (derived from various [protonfix gamefixes](https://github.com/simons-public/protonfixes/tree/master/protonfixes/gamefixes)):
```
#pylint: disable=C0103

from protonfixes import util

def main():
    util.protontricks('corefonts')
    util.protontricks('mfc140')
    util.protontricks('win10')
```
4. Run the GOG Galaxy installer:
```
$ SteamGameId='gog' STEAM_COMPAT_DATA_PATH=~/Games/GOG/ ~/.steam/steam/compatibilitytools.d/Proton-5.9-GE-7-ST/proton waitforexitandrun ~/Downloads/setup_galaxy_2.0.16.187.exe
```
5. Click through the installer. You can launch GOG Galaxy immediately, or relaunch with:
```
$ SteamGameId='gog' STEAM_COMPAT_DATA_PATH=~/Games/GOG/ ~/.steam/steam/compatibilitytools.d/Proton-5.9-GE-7-ST/proton waitforexitandrun ~/Games/GOG/pfx/drive_c/Program Files (x86)/GOG Galaxy/GalaxyClient.exe
```
6. Disable the GOG in-game overlay (Settings->Game features->Overlay) to prevent in-game stutter
7. Install Wasteland 3 through the GOG Galaxy interface.
8. Launch and enjoy. One can also launch the game though CLI:

```
$ SteamGameId='gog' STEAM_COMPAT_DATA_PATH=~/Games/GOG/ ~/.steam/steam/compatibilitytools.d/Proton-5.9-GE-7-ST/proton waitforexitandrun ~/Games/GOG/pfx/drive_c/Program\ Files\ \(x86\)/GOG\ Galaxy/Games/Wasteland\ 3/WL3.exe 
```

![Screenshot-from-2020-10-09-10-39-29](/blog/content/images/2020/10/Screenshot-from-2020-10-09-10-39-29.png)

As of this writing, Wasteland 3 will eventually terminate with an error, "eventfd: Too many open files" (observed while launching the game directly). The existing [workaround](https://askubuntu.com/questions/1182021/too-many-open-files) hasn't worked around the issue.


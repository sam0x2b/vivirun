
# Vivirun

**vivirun** is a LiveSplit AutoSplitter for use with Vividerie by WangleLine.

Implements Game Time and all timer behaviors (start, split, reset).  Has a setting for an alternative reset behavior. 

## Supported game versions

**June 8th 2026 public demo is supported.**  Version 0.48 is also supported.  The script will be updated for the official release.  When the game gets its entry on [speedrun.com](https://speedrun.com/), this AutoSplitter will be available in LiveSplit natively.  Before that there is no guarantee of any backwards or forwards compatibility (altho the script might work, you will have to try.)

## Download and use

A `*.zip` with the AutoSplitter (`*.asl`), splits (`*.lss`) and basic layout (`*.lsl`) can be found in the latest release [on this page](https://github.com/sam0x2b/vivirun/releases).  Package version should match the latest supported game version.  Backward or forward compatibility is not guaranteed!

An example of how to use these files can be found [here](https://steamcommunity.com/sharedfiles/filedetails/?id=2860375240) (for reference only).

`[NOTE]` It is strongly recommended to speedrun the game **"Hit-Freeze"** effect disabled!  It can be found in Settings > Accessibility.

## More info

Check the [supplemental documentation](DOC.md).

## Known issues

- Opening Vividerie after LiveSplit causes LiveSplit to crash, and there is nothing i can do on the script side to fix it _(?)_.  This can be worked around by running LiveSplit with administrator privileges.

## Reporting issues

Before you report an issue, please check your copies of both Vividerie and LiveSplit are at the latest version available.  Before the game is officially released there is no guarantee of any backwards or forwards compatibility!

If you find an issue with the **AutoSplitter** (not the layout or the splits or the LiveSplit itself), you can *easily* find me on the game's Discord server.  If you have a GitHub account, you can create an issue in this repository.  If you feel fancy, you can contact me via [qrysa@disroot.org](mailto:qrysa@disroot.org?subject=vivirun%20issue%20report) (OpenPGP included).

To help me diagnose the issue (especially a crash) you would have to export event viewer log:

- open Event Viewer (`Win+X` then `V`);
- select Applications log (left panel > Windows Logs > Application);
- filter the log (right panel > Filter Current Log... > Logged: `Last hour` (or other appropriate timeframe) > change `<All Event IDs>` to `0`);
- save filtered log as file (right panel) with no display information.

`[IMPORTANT NOTE]` This file may contain personal information, like your user name, computer name, folder structure, and whatever else Windows decides to put it.  Throwing it on the web for everyone to see is not a great idea!  You can tell me in the issue how to contact you to get it.

If you are able to find exact event log messages relating to the crash, you can just attach those as text **with timestamps**.

## License

vivirun, a LiveSplit AutoSplitter for use with Vividerie by WangleLine, is provided under GNU General Public License Version 2. Copyright (C) 2026  Vivirun Team

## Vividerie links

[Steam page](https://store.steampowered.com/app/1769200/Vividerie/) | [Vividerie Discord](https://discord.gg/nABbtZT4bj) | [WangleLine's Discord](http://discord.gg/DbfTn7w)

***

_Happy running!_

# Vivirun

**vivirun** is a LiveSplit AutoSplitter for use with Vividerie by WangleLine.  Auto start, configurable reset.  Provides in-game time.  Splits at every room, including boss chambers.  Is available through LiveSplit natively.

## Supported game versions

**June 8th 2026 public demo is supported** (v0.49).  Version 0.48 is also supported.  This script will be updated for every official release (in due time).  There is no guarantee of any backwards or forwards compatibility (altho the script might work, you will have to try it).

## Install and use

`[NOTE]` It is strongly recommended to speedrun the game with the **"Hit-Freeze"** effect disabled!  It can be found in Settings > Accessibility.

### LiveSplit-native

Open LiveSplit > right click on the timer window > Open Splits > From URL... > paste this link:

    https://github.com/sam0x2b/vivirun/releases/latest/download/vivirun.splits.lss

Alternatively, download the splits file (`*.lss`) from the [latest release](https://github.com/sam0x2b/vivirun/releases) amd import it manually.

### Manual installation

This option is mostly for people who want to modify the script. The AutoSplitter (`*.asl`) can be found in the [latest release](https://github.com/sam0x2b/vivirun/releases).  Package version should match the latest supported game version.  You will have to modify the timer layout by adding a "Scriptable Auto Splitter".  An example of how to use these files can be found [here](https://steamcommunity.com/sharedfiles/filedetails/?id=2860375240) (for reference only).

## Known issues

- Opening Vividerie after LiveSplit causes LiveSplit to crash, and there is nothing i can do on the script side to fix it _(?)_.  This can be worked around by running LiveSplit with administrator privileges.
- Resetting a run does not correctly save the split time, overriding it with the time of the last split.  Workaround: confirm the time by resetting the timer first.

## Reporting issues

Before you report an issue, please check your copies of both Vividerie and LiveSplit are at the latest version available.

If you find an issue with the **AutoSplitter** (not the layout or the splits or the LiveSplit itself), you can *easily* find me on the game's Discord server.  If you have a GitHub account, you can create an issue in this repository.  If you feel fancy, you can contact me via [qrysa@disroot.org](mailto:qrysa@disroot.org?subject=vivirun%20issue%20report) (OpenPGP included).

To help me diagnose the issue (especially a crash) you would have to export the event viewer log:

- open Event Viewer (`Win+X` then `V`);
- select Applications log (left panel > Windows Logs > Application);
- filter the log (right panel > Filter Current Log... > Logged: `Last hour` (or other appropriate timeframe) > change `<All Event IDs>` to `0`);
- save filtered log as file (right panel) with no display information.

`[IMPORTANT NOTE]` This file may contain personally identifiable information, like your user name, computer name, folder structure, and whatever else Windows decides to put in.  Throwing it on the web for everyone to see is not a great idea!  You can tell me in the issue how to contact you to get it.

If you are able to find exact event log messages relating to the crash, you can just attach those as text **with timestamps**.

## More info

Check [DOC.md](DOC.md). LiveSplit PR tracking:
- <https://github.com/LiveSplit/LiveSplit.AutoSplitters/pull/2786> (Initial)

## License

Copyright 2026 Sam Pazur

Licensed under the Apache NON-AI License, Version 2.0 (the "License");  you may not use this file except in compliance with the License. You may obtain a copy of the License at <https://raw.githubusercontent.com/non-ai-licenses/non-ai-licenses/main/NON-AI-APACHE2>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.

## Vividerie links

[Steam page](https://store.steampowered.com/app/1769200/Vividerie/) | [Vividerie Discord](https://discord.gg/nABbtZT4bj) | [WangleLine's Discord](http://discord.gg/DbfTn7w)

***

_Happy running!_
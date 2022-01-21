# vivirun
Vividerie AutoSplitter for LiveSplit

![vivirun banner v2](https://user-images.githubusercontent.com/77988565/145692998-f45c6aa0-20fa-4786-88c7-b2b9f6a809ab.png)

> Run, shoot, dash and magic your way through hordes of vile creatures in various procedurally generated dungeons. Combine items in countless ways and master each character – all while discovering secret places and finding out more about the enchanted world of Vividerie. 

[Steam](https://store.steampowered.com/app/1769200/Vividerie/) *TBR (Q3 2022)* | [The Internet Archive](https://archive.org/details/vividerie-0.1) *Alpha 0.11*

[Game's Discord](https://discord.gg/R7GE7qEAw2) | [WnagleLine's Discord](http://discord.gg/DbfTn7w)

### About
Implements IGT and all timer behaviors (start, split, reset). Also provides version checking (based on the data.win hash). Built-in settings provide control over optional splits and debugging features. Log files are located in `"vivi_asl"` folder aside the script.

**Supported versions:**
- `"alpha" 0.11` -- "indev" build, was distributed for limited time during public playtesting session. File version is `0.1.0.0`. _IGT uses level's frame counter, so pausing in game pauses IGT_.

**Deprecated versions:**
- `"alpha" 0.1` -- buggy, version `0.11` changed nothing in terms of gameplay.

**Splits:**
- `(start)` Crystal Caves level entered;
- `(optional)` Crystal Caves cleared;
- Crystal Titan level entered;
- Crystal Titan defeated.

**Resets:**
- Closing the game;
- Exiting to main menu;
- Resetting using in-game key or dying (even if the last split happened; **if you die after defeating last boss confirm your times as quickly as possible!**).


### Special thanks
- **WangleLine** for making this amazing game game. Updates on the game development are here https://trello.com/b/HBLu50ih/vividerie;
- Line's Discord servers members for updating me on Vividerie development process when I'm not arround;
- **SFKR** for uploading all the game versions on The Internet Archive;
- **Ero** from LiveSplit Discord development community for help in early stages of development;
- **doesthisusername** for making me addicted to A Hat In Time speedruns (and making me try speedrunning unknown games like this one too).

### Changelog
- `r0-1a (v0.1.2)`
	- Fixed no version error message when `chime` is off;
	- `chime` is off by default;
	- Logging by default if off for all levels (`log` and `debug`) and does not create unnecessary files;
	- More clear tick logging;
	- `update{}` now compares ticks and not states;
	- Removed unnecessary code in `init{}`.
- `r0-1 (v0.1.1)`
	- initial

### TODO
- [x] Basic functionality;
- [x] Settings;
- [x] Shortening `update{}` as much as possible;
- [x] Exhaustive testing; 
- [ ] Pattern matching for cleaner state string generation;
- [ ] Bit fields to replace strings;
- [ ] Support for delayed events (internal counters);
- [ ] _When the game releases_, export to LiveSplit public repo.

## License
GNU Geenral Public License Version 2

_"Vivirun" graphic made by recreating and combining graphics from indev screenchots of the game._


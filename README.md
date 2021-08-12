# vivirun
Vividerie AutoSplitter for LiveSplit

_Vividerie is a rouge-like bullet-hell pixel-art RoTMG-inspired game developed by WangleLine._

![vivirun banner](https://user-images.githubusercontent.com/77988565/129139065-8b226797-cc23-436e-bfd5-d370e2a34d70.png)

### About
Implements IGT and all timer behaviors (start, split, reset). Also provides version checking (based on the data.win hash). Built-in settings provide control over optional splits and debugging features. Log files are located in `"vivi_asl"` folder aside the script.

**Supported versions:**
- `0.11` -- "indev" build, was distributed for limited time durring public playtesting session. File version is `0.1.0.0`. _IGT uses level's frame counter, so pausing in game pauses IGT_.

**Deprecated versions:**
- `0.1` -- buggy, version `0.11` changed nothing in terms of gameplay.

**Splits:**
- `(start)` Crystal Caves level entered;
- `(optional)` Crystal Caves cleared;
- Crystal Titan level entered;
- Crystal Titan defeated.

**Resets:**
- Closing the game;
- Exiting to main menu;
- Resetting using in-game key or dying (even if the last split happened; **if you die after defeating last boss confirm your times as quick as possible!**).


### Special thanks
- **WangleLine** for banning me from her server and ignoring bug reports; Also making this game;
- **kaori** for updating me on Vividerie development process;
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

## License
GNU Geenral Public License Version 2

_"Vivirun" graphic made by recreating and combining graphics from screenchots of the game._


# How it works

`[NOTE]` This document will be updated **a lot**, considering a pre-release version of the game was used for AutoSplitter development.

## Inside Vividerie

Vividerie provides its game data in a nice contiguous memory area, that starts with a 32-byte `Magic` value.  It includes two 64-byte strings ("pretty" and "semantic" version variants), as well as unsigned 32-bit game state values, padded to 8 bytes starting at offset 0x80, in this order:

- `is_player_dead`, used to pause the time on failure;
- `room_id`, the index of the current room (either main level or boss chamber), for splits;
- `room_time`, frame count since the room loaded;
- `is_paused`, only used for Game Time pausing (removes jitter in the numbers);
- `is_game_won`, *not currently in use;*
- `is_boss_dead`, for splits.

<!-- TODO: check if this is true -->
Game's framerate is capped at 60 frames per second, but the "Hit-Freeze" visual effect lowers it.  It is strongly recommended to speedrun the game with it disabled (Settings > Accessibility), as well as using Game Time mode in the LiveSplit.  Also, the game is prone to slowdowns on weaker systems.


## Inside the AutoSplitter

For now, version strings are not used, since some decisions will have to be made before the main startup routine.  A memory scan is set up during startup, and the `Magic` string is being searched for.  Three variables are added to a MemoryWatcherList, which provides us with both `.Old` and `.Current` values of those.  An additional time accumulator is used (`vars.total_time`).

There is only one setting for the script, `"alt_reset"`.  If enabled, resetting the run while in "Crystal Caves" room will not add to the total attempt count.  This is useful for "rolling" favorable dungeon generation. 

Timer starts upon room time incrementing from 0, and stops running after the player is dead or after the last split.  Splits are generated after every even-numbered room (main levels), and upon each boss' death.  Reset is triggered upon going back to "Crystal Caves" room or, if `"alt_reset"` is disabled, reset of the room time to 0.

`[NOTE]` Currently the script lacks any timer stop condition, but we are figuring it out!


# Development pointers

`*.asl` is just some C# code, so tools for C# development might be useful.  LiveSplit's [AutoSplitter Documentation](https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md) is a good place to start.  

Since there is no command line interface for LiveSplit, it throws everything out into Windows' debug stream.  You can view it using the [Sysinternals DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview) tool.  It also writes a lot of messages into Windows' Event Log, so i recommend keeping an eye on it.

Previous version of the script has some logging code [here](https://github.com/sam0x2b/vivirun/blob/2d309193d488c003725b08564ae5c00865e31222/vivirun.asl#L35).  It is also possible to output text into the debug stream, but i dont think any logging should be left in committed code. 

Memory scanning is a very strange topic to me, so i had to peek at [A Hat In Time AutoSplitter](https://github.com/CryZe/AHatInTimeAutoSplitter/blob/master/AHatInTime.asl).

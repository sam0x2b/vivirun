
/*
	vivirun, a LiveSplit AutoSplitter for use with Vividerie by
	WangleLine, is provided under GPL-2.0.
	Copyright (C) 2026  Vivirun Team

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, see <https://www.gnu.org/licenses/>.
*/

// VERSION: v0.48-rev0


state("Vividerie")
{ }


startup
{
	vars.scanTarget = new SigScanTarget(
		32, 
		"5C 5F 36 15 64 01 22 02 5B 1B 11 22 3B 40 13 5E " + 
		"13 08 25 39 27 3D 50 13 5E 33 5B 14 03 32 2A 04" // Magic
	); 

	settings.Add("alt_reset", false, "Do not count Crystal Caves resets");
	settings.SetToolTip(
		"alt_reset",
		"While in Crystal Caves, retrying does not reset the run " +
"completely. It will only reset the time, but will not stop the timer, " +
"and the attempt counter will not increase. Useful for rotating through " +
"dungeon generation."
	);
}


init
{
	// thx A Hat In Time ASL
	vars.threadScan = new Thread(() => {
        var ptr = IntPtr.Zero;

        foreach (var page in game.MemoryPages(true).Reverse()) {
			var scanner = new SignatureScanner(
				game, 
				page.BaseAddress, 
				(int)page.RegionSize
			);
			if (ptr == IntPtr.Zero) {
				ptr = scanner.Scan(vars.scanTarget);
			} else {
				break;
			}
        }

		if (ptr == IntPtr.Zero) {
			Thread.Sleep(1000); // NOTE: a crude hack
			// NOTE: this does produce heaps of garbage in dbgview
			// But restarts `init {}`!
			throw new Exception(); 
        }
		// 0x00 and 0x40 are game version strings
		vars.is_player_dead  = new MemoryWatcher<ulong>(ptr + 0x80);
		vars.room_id         = new MemoryWatcher<ulong>(ptr + 0x88);
		vars.room_time       = new MemoryWatcher<ulong>(ptr + 0x90);
		vars.is_paused       = new MemoryWatcher<ulong>(ptr + 0x98);
		//vars.is_game_won     = new MemoryWatcher<ulong>(ptr + 0xA0);
		vars.is_boss_dead    = new MemoryWatcher<ulong>(ptr + 0xA8);

		vars.watchers = new MemoryWatcherList() {
			vars.is_player_dead,
			vars.room_id,
			vars.room_time,
			vars.is_paused,
			//vars.is_game_won,
			vars.is_boss_dead
        };

		vars.total_time = 0UL;
	});
    vars.threadScan.Start();
}


update
{
    if(vars.threadScan.IsAlive){
        return false;
    }
	vars.watchers.UpdateAll(game);

	// timer stops running if player dead. idk about this behavior tbh 
	if (vars.is_player_dead.Current > vars.is_player_dead.Old) {
		vars.total_time += vars.room_time.Current;
	}
}


split
{
	return
		(vars.room_id.Old < vars.room_id.Current && vars.room_id.Old % 2 == 0)
		|| vars.is_boss_dead.Current > vars.is_boss_dead.Old;
}


reset
{
	if (vars.room_id.Old > 0 && vars.room_id.Current == 0) {
		return true;
	}
	if (!settings["alt_reset"]) {
		return vars.room_time.Old > vars.room_time.Current &&
			vars.room_id.Current == 0;
	} 		
}


onReset
{
	vars.total_time = 0UL;
}


start
{
	return vars.room_time.Current > 0 && 
		vars.room_time.Current != vars.room_time.Old;
}


isLoading
{
	return vars.is_paused.Current != 0 || vars.room_time.Current == 0 ||
		vars.room_time.Current == vars.room_time.Old ||
		vars.is_player_dead.Current == 1;
}


gameTime
{	
	// NOTE: doing this here to avoid weird behavior during room switching
	if (vars.room_id.Old < vars.room_id.Current) {
		vars.total_time += vars.room_time.Old;
	}
	if (vars.is_player_dead.Current != 1) {
		return TimeSpan.FromSeconds(
			(vars.total_time + vars.room_time.Current) / 60d
		); 
	} else {
		return TimeSpan.FromSeconds((vars.total_time) / 60d);
	}
}


// exit{}


// shutdown{}

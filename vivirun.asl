
/*
	vivirun is provided under GPL-2.0.
	Copyright (C) 2021  keycattie

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	version 2 as published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
*/

state("Vividerie", "0.11")
{
	double frame: "Vividerie.exe", 0x708C38, 0xF24, 0x7C0;
	int level: "Vividerie.exe", 0x436ED8;
	int menu: "Vividerie.exe", 0x436EC0;
	double titan_health: "Vividerie.exe", 0x43E0F8, 0xD90, 0xC, 0x2C, 0x10, 0x5B8, 0x0;
	double enemies: "Vividerie.exe", 0x708C38, 0xC8, 0xC60;
}

startup
{
	settings.Add("enemies", false, "Split on all enemies killed (100%)");
	settings.Add("log", true, "Enable basic logging");
	settings.Add("debug", false, "Enable verbose logging");
	settings.Add("chime", true, "Sounds when checking versions");

	Directory.CreateDirectory("vivi_asl");
	if (File.Exists("vivi_asl/vivi_asl.log.9"))
		File.Delete("vivi_asl/vivi_asl.log.9");
	for (int i = 9; i > 0; --i)
		if (File.Exists("vivi_asl/vivi_asl.log." + (i-1)))
			File.Move("vivi_asl/vivi_asl.log." + (i-1), "vivi_asl/vivi_asl.log." + i);
}

init
{
	#region logging
	// thx Undertale asl
	vars.log = (Func<string, bool>)((message) =>
	{
		if(settings["log"]) {
			using (StreamWriter sw = File.AppendText("vivi_asl/vivi_asl.log.0"))
				sw.WriteLine(DateTime.Now.ToString("HHmmssff  ") +
				(settings["debug"] ? "    " : "") + message);
			return true;
		}
		print("LOG " + message);
		return false;
	});
	vars.dbg = (Func<string, bool>)((message) =>
	{
		if(settings["debug"]) {
			using (StreamWriter sw = File.AppendText("vivi_asl/vivi_asl.log.0"))
				sw.WriteLine(DateTime.Now.ToString("HHmmssff  ") + 
				"DBG " + message);
			return true;
		}
		print("DBG " + message);
		return false;
	});
	vars.log("[info] vivirun by keycattie [r0-1]");
	#endregion // logging

	#region version check
	// thx Undertale asl
	var moduleSize = modules.First().ModuleMemorySize;
	string hash;
	bool norun = false;
	using (System.Security.Cryptography.MD5 md5Hash = System.Security.Cryptography.MD5.Create())
	{
		string gamepath = Path.GetDirectoryName(modules.First().FileName);
		string dataspath = Path.Combine(gamepath, "data.win");
		vars.dbg("[info] path: " + dataspath);
		FileStream stream = File.Open(dataspath, FileMode.Open, FileAccess.Read, FileShare.Read);
		byte[] data = md5Hash.ComputeHash(stream);
		System.Text.StringBuilder sb = new System.Text.StringBuilder();
		foreach(byte d in data)
			sb.Append(d.ToString("x2"));
		hash = sb.ToString();

		string ver = string.Empty;
		switch(hash){
		case "961e14af280cc829198490299d46b2ba": 
			vars.version = "0.1";
			norun = true;
			break;
		case "df379886f88cbc9ef7ee7228e335b2c8":
			vars.version = "0.11";
			break;
		default:
			vars.version = null;
			break;
		}
		vars.dbg("[info] modulesize: " + moduleSize + ", hash:" + hash);
	}

	if(settings["chime"]) {
		if(string.IsNullOrEmpty(vars.version)) {
			Console.Beep(440, 100);
			Console.Beep(38, 25);
			Console.Beep(440, 50);
			Console.Beep(370, 100);
			vars.log("[err ] cant run: wrong hash");
		} else if(norun) {
			vars.log("[info] Vividerie v" + vars.version);
			Console.Beep(330, 100);
			Console.Beep(290, 50);
			Console.Beep(330, 100);
			Console.Beep(277, 50);
			vars.log("[err ] cant run: deprecated version");
		} else {
			vars.log("[info] Vividerie v" + vars.version);
			Console.Beep(295, 50);
			Console.Beep(38, 1);
			Console.Beep(495, 100);
		}
	}
	#endregion // version check

	switch((string)vars.version) {
	case "0.11": 
		vars.ticks = new List<string>();
		vars.ticks.Add("_______");

		vars.match = (Func<List<string[]>, bool>)((p) => {
			var dbg = true; // development switch
			foreach(var patterns in p) {
				if(patterns.Length > vars.ticks.Count || patterns.Length < 1)
					continue;
				if(dbg) vars.dbg("[mtch] patterns " + String.Join("|", patterns));
				var fail = true;
				for(var i = patterns.Length - 1; i >= 0; --i) { 
					var pattern = patterns[i];
					if(dbg) vars.dbg("[mtch] testing " + pattern + " on " + vars.ticks[vars.ticks.Count - patterns.Length + i]);
					pattern = pattern.Replace("?", "\\S"); 
					var res = System.Text.RegularExpressions.Regex.IsMatch(
						vars.ticks[vars.ticks.Count - patterns.Length + i], 
						pattern, 
						0);
					vars.dbg("[mtch] result " + res);
					if(!res) {
						fail = true;
						if(dbg) vars.dbg("[mtch] failed");
						break;
					}
					fail = false;
					if(dbg) vars.dbg("[mtch] passed");
				}
				if(!fail) {
					if(dbg) vars.dbg("[mtch] matched");
					return true;
				}
			}
			return false;
		});

		vars.resets = new List<string[]>();
		vars.resets.Add(new string[]{"ml?????"});
		vars.resets.Add(new string[]{"_l__ebf","_l__eb_","__0_eb_"});
		vars.resets.Add(new string[]{"_l__ebf","_l__eb_","____eb_","__0_eb_"});

		vars.starts = new List<string[]>();
		vars.starts.Add(new string[]{"__0_eb_","__0__b_"});

		vars.splits = new List<string[]>();
		if(settings["enemies"]) vars.splits.Add(new string[]{"__0_e?_"});
		vars.splits.Add(new string[]{"___1?__"});
		vars.splits.Add(new string[]{"___1?__","___1?b_"});

		vars.frames = 0d;
		vars.splitno = 0;

		vars.igton = false;
		vars.split = false;
		vars.reset = false;
		vars.start = false;

		current.now_menu = false;
		current.now_loading = false;
		current.now_caves = false;
		current.now_titan = false;
		current.clear_caves = false;
		current.clear_titan = false;
		current.framedrop = false;

		old.now_menu = false;
		old.now_loading = false;
		old.now_caves = false;
		old.now_titan = false;
		old.clear_caves = false;
		old.clear_titan = false;
		old.framedrop = false;
		break; // 0.11
	}
}


update
{
	switch((string)vars.version) {
	case "0.11":
		old.now_menu	= current.now_menu;
		old.now_loading	= current.now_loading;
		old.now_caves	= current.now_caves;
		old.now_titan	= current.now_titan;
		old.clear_caves	= current.clear_caves;
		old.clear_titan	= current.clear_titan;
		old.framedrop	= current.framedrop;
	
		current.now_menu	= current.menu == 32;
		current.now_loading	= current.level == 4096;
		current.now_caves	= current.level == 2047;
		current.now_titan	= current.level == 3071;
		current.clear_caves	= current.enemies == 0;
		current.clear_titan	= current.titan_health <= 0d;
		current.framedrop	= current.frame < old.frame;
		
		if(
			current.now_menu	!=	old.now_menu	||
			current.now_loading	!=	old.now_loading	||
			current.now_caves	!=	old.now_caves	||
			current.now_titan	!=	old.now_titan	||
			current.clear_caves	!=	old.clear_caves	||
			current.clear_titan	!=	old.clear_titan	||
			current.framedrop	!=	old.framedrop	||
			false) {
				string tick = "" +
					((current.now_menu)	? "m" : "_") +
					((current.now_loading)	? "l" : "_") +
					((current.now_caves)	? "0" : "_") +
					((current.now_titan)	? "1" : "_") +
					((current.clear_caves)	? "e" : "_") +
					((current.clear_titan)	? "b" : "_") +
					((current.framedrop)	? "f" : "_") +
					"";
					vars.ticks.Add(tick);
				vars.log("[tick] " + tick + "\t"+ current.frame + "\t" + old.frame);

				vars.reset = vars.match(vars.resets);
				if(vars.reset) vars.log("[upd ] matched reset, tick " + (vars.ticks.Count - 2));
				else {
					vars.split = false; // fix for fresh game startup
					vars.start = vars.match(vars.starts);
					if(vars.start) vars.log("[upd ] matched start, tick " + (vars.ticks.Count - 2));
					else {
						vars.split = vars.match(vars.splits);
						if(vars.split) vars.log("[upd ] matched split, tick " + (vars.ticks.Count - 2));
					}
				}
				if(current.framedrop) vars.frames += old.frame;
			}
			if(current.enemies != old.enemies) vars.dbg("[upd ] enemies " + current.enemies);
		break; // 0.11
	default:
		return false;
		break;
	}
}

split
{
	switch((string)vars.version) {
	case "0.11":
		bool split = vars.split;
		if(split) {
			++vars.splitno;
			vars.log("[splt] time " + (vars.frames + current.frame) / 60d);
		}
		vars.split = false;
		return split;
		break; // 0.11
	}
}

reset
{
	switch((string)vars.version) {
	case "0.11":
		bool reset = vars.reset;
		if(reset) {
			vars.igton = false;
			vars.log("[rst ] time " + (vars.frames + current.frame) / 60d);
			vars.frames = 0d;
		}
		vars.reset = false;
		return reset;
		break; // 0.11
	}
}

start
{	
	switch((string)vars.version) {
	case "0.11":
		bool start = vars.start;
		if(start) {
			vars.igton = true;
			vars.frames = 0d;
			vars.log("[strt]" + ((settings["enemies"]) ? " 100%" : ""));
			vars.ticks.Clear();
			vars.ticks.Add("_______");
		}
		vars.start = false;
		return start;
		break; // 0.11
	}
}

isLoading
{
	switch((string)vars.version) {
	case "0.11":
		return current.now_loading || vars.igton;
		break; // 0.11
	}
}

gameTime
{	switch((string)vars.version) {
	case "0.11":
		return TimeSpan.FromSeconds((vars.frames + current.frame) / 60d);
		break; // 0.11
	}
}

// exit{}

// shutdown{}

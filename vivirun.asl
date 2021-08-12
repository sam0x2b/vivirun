
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
	settings.Add("log", false, "Enable basic logging");
	settings.Add("debug", false, "Enable verbose logging");
	settings.Add("chime", false, "Sounds when checking versions");
}

init
{
	#region logging
	// thx Undertale asl
	if(settings["log"]) {
		Directory.CreateDirectory("vivi_asl");
		if (File.Exists("vivi_asl/vivi_asl.log.9"))
			File.Delete("vivi_asl/vivi_asl.log.9");
		for (int i = 9; i > 0; --i)
			if (File.Exists("vivi_asl/vivi_asl.log." + (i-1)))
				File.Move("vivi_asl/vivi_asl.log." + (i-1), "vivi_asl/vivi_asl.log." + i);
	}
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
		if(settings["debug"] && settings["log"]) {
			using (StreamWriter sw = File.AppendText("vivi_asl/vivi_asl.log.0"))
				sw.WriteLine(DateTime.Now.ToString("HHmmssff  ") + 
				"DBG " + message);
			return true;
		}
		print("DBG " + message);
		return false;
	});

	vars.log("[info] vivirun by keycattie [r0-1a v0.1.2]");
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

	if(string.IsNullOrEmpty(vars.version)) {
		vars.log("[err ] cant run: wrong hash");
		if(settings["chime"]) {
			Console.Beep(440, 100);
			Console.Beep(38, 25);
			Console.Beep(440, 50);
			Console.Beep(370, 100);
		}
	} else { 
		vars.log("[info] Vividerie v" + vars.version);
		if(norun) {
				vars.log("[err ] cant run: deprecated version");
			if(settings["chime"]) {
				Console.Beep(330, 100);
				Console.Beep(290, 50);
				Console.Beep(330, 100);
				Console.Beep(277, 50);
			}
		} else {
			if(settings["chime"]) {
				Console.Beep(295, 50);
				Console.Beep(38, 1);
				Console.Beep(495, 100);
			}
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
					var target = vars.ticks[vars.ticks.Count - patterns.Length + i];
					if(dbg) vars.dbg("[mtch] testing " + pattern + " on " + target);
					pattern = pattern.Replace("?", "\\S"); 
					var res = System.Text.RegularExpressions.Regex.IsMatch(target, pattern, 0);
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
		break; // 0.11
	}
}


update
{
	switch((string)vars.version) {
	case "0.11":
		current.now_loading	= current.level == 4096;
		current.framedrop	= current.frame < old.frame;
		string tick = "" +
			((current.menu == 32)			? "m" : "_") +
			((current.now_loading)			? "l" : "_") +
			((current.level == 2047)		? "0" : "_") +
			((current.level == 3071)		? "1" : "_") +
			((current.enemies == 0)			? "e" : "_") +
			((current.titan_health <= 0d)	? "b" : "_") +
			((current.framedrop)			? "f" : "_") +
			"";

		if(!String.Equals(vars.ticks[vars.ticks.Count - 1], tick)) {
			vars.ticks.Add(tick);
			vars.log("[tick] " + (vars.ticks.Count - 2) + " " + tick +
				"\tframes "+ old.frame + " to " + current.frame);

			vars.reset = vars.match(vars.resets);
			if(vars.reset) vars.log("[upd ] matched reset");
			else {
				vars.split = false; // fix for fresh game startup
				vars.start = vars.match(vars.starts);
				if(vars.start) vars.log("[upd ] matched start");
				else {
					vars.split = vars.match(vars.splits);
					if(vars.split) vars.log("[upd ] matched split");
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
			vars.frames = 0d;
			vars.log("[rst ] time " + (vars.frames + current.frame) / 60d);
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
			vars.ticks.Clear();
			vars.ticks.Add("_______");
			vars.log("[strt]" + ((settings["enemies"]) ? " 100%" : ""));
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
{
	switch((string)vars.version) {
	case "0.11":
		return TimeSpan.FromSeconds((vars.frames + current.frame) / 60d);
		break; // 0.11
	}
}

// exit{}

// shutdown{}

package funkin.save;

import haxe.ds.StringMap;

/**
 * A structure object used for save data.
 */
typedef SaveData =
{
	var scores:StringMap<Int>;
	var favorites:StringMap<Bool>;
	var options:SaveOptionsData;
}

/**
 * A structure object used for the save options data.
 */
typedef SaveOptionsData =
{
	var downscroll:Bool;
	var ghostTapping:Bool;
	var showTimer:Bool;
	var showFPS:Bool;
	var showFPSBGOpacity:Int;
	var fpsCap:Int;
	var discordRPC:Bool;
}

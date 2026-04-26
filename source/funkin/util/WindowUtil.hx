package funkin.util;

import openfl.Lib;

/**
 * A utility class for handling window-related things.
 */
class WindowUtil
{
	public static function exit()
	{
		trace('Exiting the game...');
		trace('This is NOT a crash.');

		Sys.exit(0);
	}

	public static function alert(message:String)
	{
		Lib.application.window.alert(message);
	}
}

package funkin;

import funkin.play.PlayState;
import funkin.save.Save;

/**
 * A class containing the player's preferences.
 * 
 * These preferences can be changed ingame through the options menu.
 */
class Preferences
{
	public static var downscroll(get, set):Bool;
	public static var ghostTapping(get, set):Bool;
	public static var showTimer(get, set):Bool;

	#if HAS_FPS_COUNTER
	public static var showFPS(get, set):Bool;
	public static var showFPSBGOpacity(get, set):Int;
	#end

	public static var fpsCap(get, set):Int;

	#if HAS_DISCORD_RPC
	public static var discordRPC(get, set):Bool;
	#end

	static inline function set_downscroll(value:Bool):Bool
	{
		Save.instance.options.downscroll = value;
		Save.instance.flush();

		PlayState.instance?.refresh();

		return value;
	}

	static inline function get_downscroll():Bool
		return Save.instance.options.downscroll;

	static inline function set_ghostTapping(value:Bool):Bool
	{
		Save.instance.options.ghostTapping = value;
		Save.instance.flush();

		return value;
	}

	static inline function get_ghostTapping():Bool
		return Save.instance.options.ghostTapping;

	static inline function set_showTimer(value:Bool):Bool
	{
		Save.instance.options.showTimer = value;
		Save.instance.flush();

		PlayState.instance?.refresh();

		return value;
	}

	static inline function get_showTimer():Bool
		return Save.instance.options.showTimer;

	#if HAS_FPS_COUNTER
	static inline function set_showFPS(value:Bool):Bool
	{
		Save.instance.options.showFPS = value;
		Save.instance.flush();

		Main.fpsCounter.visible = value;
		Main.fpsCounter.set_backgroundOpacityVisible(value);

		return value;
	}

	static inline function get_showFPS():Bool
		return Save.instance.options.showFPS;

	static inline function set_showFPSBGOpacity(value:Int):Int
	{
		Save.instance.options.showFPSBGOpacity = value;
		Save.instance.flush();

		Main.fpsCounter.backgroundOpacity = value / 100;
		trace('showFPSBGOpacity set to $value, opacity: ${value / 100}');
		
		return value;
	}

	static inline function get_showFPSBGOpacity():Int
		return Save.instance.options.showFPSBGOpacity;
	#end

	static inline function set_fpsCap(value:Int):Int
	{
		Save.instance.options.fpsCap = value;
		Save.instance.flush();

		FlxG.updateFramerate = value;
		FlxG.drawFramerate = value;

		return value;
	}

	static inline function get_fpsCap():Int
		return Save.instance.options.fpsCap;

	#if HAS_DISCORD_RPC
	static inline function set_discordRPC(value:Bool):Bool
	{
		Save.instance.options.discordRPC = value;
		Save.instance.flush();

		if (value)
			DiscordRPC.start();
		else
			DiscordRPC.shutdown(0);

		return value;
	}

	static inline function get_discordRPC():Bool
		return Save.instance.options.discordRPC;
	#end

	//
	// DEBUG
	//
	public static var botplay:Bool = false;
}

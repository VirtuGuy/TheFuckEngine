package funkin;

import openfl.utils.Assets;

/**
 * A class for retrieving the game's asset paths.
 */
class Paths
{
	public static inline function path(id:String):String
		return 'assets/$id';

	public static inline function random(id:String, min:Int, max:Int):String
		return '$id${FlxG.random.int(min, max)}';

	public static inline function image(id:String):String
		return path('$id.${Constants.IMAGE_EXT}');

	public static inline function sound(id:String):String
		return path('$id.${Constants.SOUND_EXT}');

	public static inline function json(id:String):String
		return path('$id.${Constants.JSON_EXT}');

	public static inline function exists(id:String):Bool
		return Assets.exists(id);
}

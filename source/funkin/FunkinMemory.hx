package funkin;

import openfl.utils.Assets;
import polymod.Polymod;
#if cpp
import cpp.vm.Gc;
#end

/**
 * A class for handling sound and image cache.
 * 
 * For now, its main purpose is clearing the cache.
 */
class FunkinMemory
{
	public static function clearCache()
	{
		// Clears the polymore cache
		// Yes that's right
		// Clearing the polymore cache
		Polymod.clearCache();

		Assets.cache.clear();
		FlxG.bitmap.clearCache();

		// Run the garbage collector
		// Major? Pfff I don't know what that means
		#if cpp
		Gc.run(true);
		#end

		trace('Done clearing cache.');
	}
}

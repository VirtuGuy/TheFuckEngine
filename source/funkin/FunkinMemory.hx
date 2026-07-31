package funkin;

import cpp.vm.Gc;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFlAssets;
import polymod.Polymod;

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

		LimeAssets.cache.clear();
		OpenFlAssets.cache.clear();

		// Runs garbage collector
		Gc.compact();

		trace('Done clearing cache.');
	}
}

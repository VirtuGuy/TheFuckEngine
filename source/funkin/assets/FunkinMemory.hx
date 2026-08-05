package funkin.assets;

import cpp.vm.Gc;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFlAssets;

/**
 * A class for handling sound and image cache.
 * 
 * For now, its main purpose is clearing the cache.
 */
class FunkinMemory
{
	public static function clearCache()
	{
		LimeAssets.cache.clear();
		OpenFlAssets.cache.clear();

		// Runs garbage collector
		// Pffff I don't know what major means
		Gc.run(true);

		trace('Done clearing cache.');
	}
}

package funkin.assets;

import cpp.vm.Gc;
import openfl.utils.Assets;

/**
 * A class for handling sound and image cache.
 * 
 * For now, its main purpose is clearing the cache.
 */
class FunkinCache
{
	public static function clearCache()
	{
		Assets.cache.clear('');

		// Runs garbage collector
		// Pffff I don't know what major means
		Gc.run(true);

		trace('Done clearing cache.');
	}

	public static function clearStickers()
	{
		Assets.cache.clear('sticker/');

		trace('Done clearing sticker cache.');
	}
}

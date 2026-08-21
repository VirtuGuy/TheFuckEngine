package funkin.util.plugins;

import flixel.FlxBasic;
import funkin.modding.ModHandler;
import funkin.ui.menu.MainMenuState;
import funkin.util.plugins.StickerPlugin;

/**
 * A plugin that allows the player to hot-reload the engine.
 */
class ReloadPlugin extends FlxBasic
{
	public static var instance:ReloadPlugin;

	public static function init()
	{
		FlxG.plugins.addPlugin(new ReloadPlugin());
	}

	public function new()
	{
		super();

		instance = this;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Press F5 to hot-reload
		if (FlxG.keys.justPressed.F5)
		{
			ModHandler.reload();

			FlxG.resetState();

			// Clear stickers because problems
			StickerPlugin.instance.clear();
		}

		// Press F4 to eject back into the main menu
		if (FlxG.keys.justPressed.F4)
		{
			FlxG.switchState(() -> new MainMenuState());

			// Clear stickers because problems
			StickerPlugin.instance.clear();
		}
	}
}

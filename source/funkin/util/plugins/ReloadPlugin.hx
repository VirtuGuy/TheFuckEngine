package funkin.util.plugins;

import flixel.FlxBasic;
import funkin.modding.ModHandler;
import funkin.ui.menu.MainMenuState;

/**
 * A plugin that allows the player to hot-reload the engine.
 */
class ReloadPlugin extends FlxBasic
{
	public static var instance:ReloadPlugin;

	public static function init()
		FlxG.plugins.addPlugin(new ReloadPlugin());

	public function new()
	{
		super();

		instance = this;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F5)
		{
			// Reload mods
			ModHandler.reload();

			// The state has to be reloaded
			// It's kinda the point of "hot-reloading"
			FlxG.resetState();
		}

		// Eh why not include this I guess
		if (FlxG.keys.justPressed.F4)
			FlxG.switchState(() -> new MainMenuState());
	}
}

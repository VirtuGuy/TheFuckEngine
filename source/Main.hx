package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.util.typeLimit.NextState.InitialState;
import funkin.Conductor;
import funkin.data.character.CharacterRegistry;
import funkin.data.event.EventRegistry;
import funkin.data.song.SongRegistry;
import funkin.data.stage.StageRegistry;
import funkin.data.sticker.StickerRegistry;
import funkin.data.story.LevelRegistry;
import funkin.input.Controls;
import funkin.modding.ModHandler;
import funkin.modding.module.ModuleHandler;
import funkin.save.Save;
import funkin.ui.menu.MainMenuState;
import funkin.util.plugins.ReloadPlugin;
import funkin.util.plugins.ScreenshotPlugin;
import openfl.display.FPS;

/**
 * The engine's main class where the game is initialized.
 */
class Main extends FlxGame
{
	#if HAS_FPS_COUNTER
	public static var fpsCounter:FPS;
	#end

	public function new()
	{
		final width:Int = 0;
		final height:Int = 0;
		final state:InitialState = MainMenuState;
		final framerate:Int = 180;
		final skipSplash:Bool = true;
		final startFullscreen:Bool = false;

		super(width, height, state, framerate, framerate, skipSplash, startFullscreen);

		//
		// INIT
		//

		ModHandler.init();

		// Instances
		Conductor.instance = new Conductor();
		Controls.instance = new Controls();
		Save.instance = new Save();

		// Registries
		CharacterRegistry.instance = new CharacterRegistry();
		StageRegistry.instance = new StageRegistry();
		SongRegistry.instance = new SongRegistry();
		LevelRegistry.instance = new LevelRegistry();
		EventRegistry.instance = new EventRegistry();
		StickerRegistry.instance = new StickerRegistry();

		// Load modules
		ModuleHandler.load();
	}

	override function create(_)
	{
		super.create(_);

		// Adds the FPS counter
		// Only if it's enabled though
		#if HAS_FPS_COUNTER
		fpsCounter = new FPS(10, 10, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		// Flixel
		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 30;
		FlxG.inputs.resetOnStateSwitch = false;
		FlxG.mouse.visible = false;
		FlxObject.defaultMoves = false;

		// Plugins
		ReloadPlugin.init();
		#if HAS_SCREENSHOTS
		ScreenshotPlugin.init();
		#end
	}
}

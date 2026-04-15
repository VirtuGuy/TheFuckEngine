package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.typeLimit.NextState.InitialState;
import funkin.Conductor;
import funkin.DiscordRPC;
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
import funkin.ui.title.TitleState;
import funkin.util.plugins.ReloadPlugin;
#if HAS_FPS_COUNTER
import funkin.ui.debug.FPSCounter;
#end
#if HAS_SCREENSHOTS
import funkin.util.plugins.ScreenshotPlugin;
#end

/**
 * The engine's main class where the game is initialized.
 */
class Main extends FlxGame
{
	#if HAS_FPS_COUNTER
	public static var fpsCounter:FPSCounter;
	#end

	public function new()
	{
		final width:Int = 0;
		final height:Int = 0;
		final state:InitialState = TitleState;
		final framerate:Int = 60;
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
		fpsCounter = new FPSCounter(10, 3, FlxTextBorderStyle.OUTLINE);
		addChild(fpsCounter);
		fpsCounter.createBackground();
		#end

		// Flixel
		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 30;
		FlxG.inputs.resetOnStateSwitch = false;
		FlxG.mouse.visible = false;
		FlxObject.defaultMoves = false;

		#if HAS_DISCORD_RPC
		DiscordRPC.init();
		#end

		// Save data has to be loaded here
		// It just has to be
		Save.instance = new Save();

		// Plugins
		ReloadPlugin.init();
		#if HAS_SCREENSHOTS
		ScreenshotPlugin.init();
		#end
	}
}

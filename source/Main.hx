package;

import flixel.FlxGame;
import flixel.util.typeLimit.NextState.InitialState;
import openfl.display.FPS;
import openfl.display.Sprite;

/**
 * The main project class where Flixel is initialized.
 */
class Main extends Sprite
{
	#if HAS_FPS_COUNTER
	public static var fpsCounter:FPS;
	#end

	public function new()
	{
		super();

		// Starts the game
		final gameWidth:Int = 0;
		final gameHeight:Int = 0;
		final initialState:InitialState = funkin.InitState;
		final framerate:Int = 120;
		final skipSplash:Bool = true;
		final startFullscreen:Bool = false;

		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

		// Adds the FPS counter
		// Only if it's enabled though
		// Creates the FPS counter
		#if HAS_FPS_COUNTER
		fpsCounter = new FPS(10, 10, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}
}

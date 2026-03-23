package;

import flixel.FlxGame;
import openfl.display.FPS;

/**
 * The engine's main class where Flixel is initialized.
 */
class Main extends FlxGame
{
	#if HAS_FPS_COUNTER
	public static var fpsCounter:FPS;
	#end

	public function new()
	{
		final framerate:Int = 180;

		super(0, 0, funkin.InitState, framerate, framerate, true, false);
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
	}
}

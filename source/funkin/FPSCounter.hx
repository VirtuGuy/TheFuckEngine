package funkin;

#if HAS_FPS_COUNTER
import flixel.math.FlxMath;
import openfl.display.Shape;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * A simple FPS counter that displays your current FPS, and memory usage.
 * Thank you AnimatingLegend :D
 */
class FPSCounter extends TextField
{
	final BG_MARGIN:Int = 4;
	final BG_BORDER:Int = 2;

	public var bg:Shape;

	var currentFPS(default, null):Int;
	var systemMemory(default, null):Float = 0;
	var maxMemory:Float = 0;

	var times:Array<Float> = [];

	public function new(x:Float, y:Float)
	{
		super();

		this.x = x;
		this.y = y;

		defaultTextFormat = new TextFormat('_sans', 12, 0xFFFFFFFF, true);

		selectable = false;
		autoSize = LEFT;

		bg = new Shape();
		bg.x = x - BG_MARGIN;
		bg.y = y - BG_MARGIN;
	}

	override function __enterFrame(deltaTime:Float)
	{
		// FPS
		final now:Float = haxe.Timer.stamp() * 1000;

		times.push(now);
		while (times[0] < now - 1000)
			times.shift();
		currentFPS = times.length;

		// Memory
		systemMemory = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2));
		if (systemMemory > maxMemory)
			maxMemory = systemMemory;

		updateDisplay();
		redrawBackground();
	}

	function redrawBackground()
	{
		bg.graphics.clear();

		if (!visible)
			return;

		final width:Float = width + BG_MARGIN + 6;
		final height:Float = height + BG_MARGIN + 3;

		// Border
		bg.graphics.beginFill(0xFFFFFF);
		bg.graphics.drawRect(-BG_BORDER, -BG_BORDER, width + BG_BORDER * 2, height + BG_BORDER * 2);
		bg.graphics.endFill();

		// Background
		bg.graphics.beginFill(0x202020);
		bg.graphics.drawRect(0, 0, width, height);
		bg.graphics.endFill();
	}

	function updateDisplay()
	{
		var memoryUnit = systemMemory >= 1000 ? 'gb' : 'mb';

		text = 'FPS: $currentFPS\nMEM: $systemMemory / $maxMemory$memoryUnit';
		textColor = 0xFFFFFFFF;

		if (maxMemory > 3000 || currentFPS <= Preferences.fpsCap / 2)
			textColor = 0xFFFF0000;
	}
}
#end

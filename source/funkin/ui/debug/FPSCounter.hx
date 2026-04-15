package funkin.ui.debug;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import haxe.Timer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;


/**
 * A simple FPS Counter that displays your current FPS, and Memory usage.
 * [!NOTE] This is only available if the `HAS_FPS_COUNTER` flag is enabled in your project.xml.
 */
class FPSCounter extends TextField 
{
     /**
      * The opacity of the FPS Counters background.
      */
     public var backgroundOpacity(default, set):Float = 0.5;

     /**
      * The current FPS, calculated as the number of frames rendered in the last second.
      */
     public var currentFPS(default, null):Int;


     /**
      * The current memory usage of the game.
      */
     public var systemMemory(default, null):Float = 0;

     /**
      * The highest amount of memory used since the counter was created.
      */
     public var maxMemory:Float = 0;

	/**
	 * The timestamps of the frames rendered in the last second.
	 */
	@:noCompletion private var times:Array<Float>;

     var debugDisplayBG:Shape;

     public function new(x:Float = 10, y:Float = 10, args:FlxTextBorderStyle) 
     {
          super();

		this.x = x;
		this.y = y;

          this.times = [];

          this.selectable = false;
          this.mouseEnabled = false;

          this.textColor = FlxColor.WHITE;
          this.defaultTextFormat = new TextFormat('_sans', 12, FlxColor.BLACK, true);
          this.multiline = true;
          this.autoSize = LEFT;
     }

     public function createBackground():Void
     {
          if (parent == null)
          {
               trace('Parent is null, retrying next frame...');
               addEventListener(Event.ADDED_TO_STAGE, retryCreateBackground);
               return;
          }
          debugDisplayBG = new Shape();
          debugDisplayBG.x = this.x;
          debugDisplayBG.y = this.y;
          debugDisplayBG.alpha = backgroundOpacity;
          parent.addChildAt(debugDisplayBG, parent.getChildIndex(this));
          trace('debugDisplayBG Initialized.');
     }

     function retryCreateBackground(_):Void
     {
          if (parent == null) return;
          removeEventListener(Event.ADDED_TO_STAGE, retryCreateBackground);
          createBackground();
     }

     
     function redrawBackground():Void
     {
          if (debugDisplayBG == null) return;
          debugDisplayBG.x = this.x - 4;
          debugDisplayBG.y = this.y - 2;
          debugDisplayBG.graphics.clear();

          // Border
          debugDisplayBG.graphics.beginFill(0xFFFFFF, 0.6);
          debugDisplayBG.graphics.drawRect(0, 0, this.width + 8, this.height + 4);
          debugDisplayBG.graphics.endFill();

          // Background
          debugDisplayBG.graphics.beginFill(0x2c2f30, 1);
          debugDisplayBG.graphics.drawRect(1, 1, this.width + 6, this.height + 2);
          debugDisplayBG.graphics.endFill();
          
          debugDisplayBG.alpha = backgroundOpacity;
     }

     var deltaTimeout:Float = 0.0;

     /**
      * `__enterFrame` event handler that updates the FPS and memory usage every second.
      */
     @:noCompletion 
     private override function __enterFrame(deltaTime:Float):Void 
     {
          final now:Float = haxe.Timer.stamp() * 1000;
          times.push(now);
          while (times[0] < now - 1000) times.shift();

          // If the time between updates is less than 50 milliseconds, don't update the display yet.
          if (deltaTimeout < 50) { deltaTimeout += deltaTime; return; }

          systemMemory = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2)); // Convert bytes to megabytes and round to 2 decimal places.
          if (systemMemory > maxMemory) maxMemory = systemMemory; // Update max memory if current memory exceeds it.

          currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
          updateDisplay();
          redrawBackground();
          deltaTimeout = 0.0;
     }

     /**
      * Updates the display of the FPS and memory usage.
      * [!NOTE] Made the function `dynamic` so it can be overridden by mods and custom builds.
      */
     public dynamic function updateDisplay():Void
     {
          // If your memory usage is above 1000 megabytes, display it in gigabytes. (default: megabytes)
          var memoryUnit = systemMemory >= 1000 ? 'gb' : 'mb';

          text = [
               'FPS: ${currentFPS}',
               'MEM: ${systemMemory} / ${maxMemory}${memoryUnit}',
          ].join('\n');

          textColor = FlxColor.WHITE;
          if (maxMemory > 3000 || currentFPS <= Preferences.fpsCap / 2) textColor = FlxColor.RED;
     }

     public function set_backgroundOpacityVisible(value:Bool):Void { if (debugDisplayBG != null) debugDisplayBG.visible = value; }

     function set_backgroundOpacity(value:Float):Float
     {
          trace('backgroundOpacity set to $value, debugDisplayBG is ${debugDisplayBG == null ? "null" : "not null"}');
          if (debugDisplayBG != null) debugDisplayBG.alpha = value;
          return backgroundOpacity = value;
     }
}
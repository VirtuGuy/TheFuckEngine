package funkin.util;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;

/**
 * A utility class containing math functions and all that annoying crap.
 */
class MathUtil
{
    /**
     * A lerp function, but it's actually framerate independent.
     */
    public static inline function lerp(a:Float, b:Float, ratio:Float):Float
        return FlxMath.lerp(a, b, FlxMath.getElapsedLerp(ratio, FlxG.elapsed));

    /**
     * Converts an array to an `FlxPoint`.
     * `number` is the default value for either X and Y.
     */
    public static function arrayToPoint(array:Array<Float>, number:Float = 0):FlxPoint
    {
        var x:Float = number;
        var y:Float = number;

        if (array != null)
        {
            x = array[0] ?? x;
            y = array[1] ?? y;
        }

        return FlxPoint.get(x, y);
    }
}
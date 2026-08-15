package funkin.util.tools;

/**
 * A tools class for handling numbers.
 */
class NumberTools
{
	public static function clamp(x:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, x));
	}
}

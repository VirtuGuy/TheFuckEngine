package funkin.graphics;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * A better version of Flixel's `FlxBar` class because `FlxBar` is dumb and stupid.
 */
class FunkinBar extends FlxSpriteGroup
{
	public var min:Float;
	public var max:Float;
	public var isLeft:Bool;

	public var value(default, set):Float;
	public var percent(get, never):Float;

	public var fillPosition(get, never):Float;

	var empty:FunkinSprite;
	var fill:FunkinSprite;

	public function new(x:Float, y:Float, width:Int, height:Int, min:Float = 0, max:Float = 100, isLeft:Bool = false)
	{
		super(x, y);

		this.min = min;
		this.max = max;
		this.isLeft = isLeft;

		empty = FunkinSprite.createSolidColor(0, 0, width, height, 0xFFFFFFFF);
		empty.active = false;
		add(empty);

		fill = empty.clone();
		fill.offset.x = isLeft ? -width + 1 : 0;
		fill.origin.x = isLeft ? 1 : 0;
		add(fill);

		value = max;
	}

	public function setColors(emptyColor:FlxColor, fillColor:FlxColor)
	{
		empty.color = emptyColor;
		fill.color = fillColor;
	}

	function set_value(value:Float):Float
	{
		if (this.value == value)
			return value;
		this.value = value;

		fill.scale.x = percent * fill.width;

		return value;
	}

	inline function get_percent():Float
	{
		return value / max;
	}

	inline function get_fillPosition():Float
	{
		var pos:Float = percent * fill.width;
		if (isLeft)
			pos = fill.width - pos;
		return x + pos;
	}
}

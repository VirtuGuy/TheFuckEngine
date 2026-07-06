package funkin.ui.charselect;

import flixel.FlxObject;
import funkin.graphics.FunkinSprite;
import funkin.util.MathUtil;

/**
 * A sprite used as an indicator for which character select icon you have selected.
 * Unlike Funkin', the cursor sprite is a `FunkinSprite` and not a container.
 */
class CursorSprite extends FunkinSprite
{
	public var target:FlxObject;

	public var targetX(get, never):Float;
	public var targetY(get, never):Float;

	var _backX:Float = 0;
	var _backY:Float = 0;

	public function new()
	{
		super();

		loadSprite('menu/character-select/cursor', 1.25);

		active = false;
	}

	public function snap()
	{
		setPosition(targetX, targetY);

		_backX = x;
		_backY = y;
	}

	override public function draw()
	{
		// Draws the light blue cursor
		// or I guess the back cursor
		final lastX:Float = x;
		final lastY:Float = y;

		_backX = MathUtil.lerp(_backX, targetX, 0.175);
		_backY = MathUtil.lerp(_backY, targetY, 0.175);

		x = _backX;
		y = _backY;

		color = 0xFF00EEFF;

		// Draws the yellow cursor
		super.draw();

		x = MathUtil.lerp(lastX, targetX, 0.3);
		y = MathUtil.lerp(lastY, targetY, 0.3);

		color = 0xFFFFEE00;

		super.draw();
	}

	@:noCompletion
	inline function get_targetX():Float
	{
		return target.x + (target.width - width) / 2;
	}

	@:noCompletion
	inline function get_targetY():Float
	{
		return target.y + (target.height - height) / 2;
	}
}

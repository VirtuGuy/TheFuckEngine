package funkin.ui.charselect;

import funkin.graphics.FunkinSprite;
import funkin.util.MathUtil;

/**
 * A sprite used as an indicator for which character select icon you have selected.
 * Unlike Funkin', the cursor sprite is a `FunkinSprite` and not a container.
 */
class CursorSprite extends FunkinSprite
{
	public var targetX:Float = 0;
	public var targetY:Float = 0;

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
		x = targetX;
		y = targetY;

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
}

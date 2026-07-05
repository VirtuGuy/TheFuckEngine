package funkin.ui.charselect;

import funkin.graphics.FunkinSprite;

/**
 * The lock sprite used for the character select menu.
 */
class LockSprite extends FunkinSprite
{
	public function new()
	{
		super();

		loadSprite('menu/charselect/lock', 1.5);

		active = false;
	}
}

package funkin.ui.charselect.icon;

import funkin.graphics.FunkinSprite;
import funkin.ui.freeplay.player.Player;

/**
 * The icon sprite used for the character select menu.
 */
class IconSprite extends FunkinSprite
{
	public var player:Player;

	public function new(player:Player)
	{
		super();

		this.player = player;

		// TODO: Add support for player icons
		loadSprite('menu/character-select/lock', 1.5);

		if (player != null)
			flipY = true;

		active = false;
	}
}

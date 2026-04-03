package funkin.ui.sticker;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` mainly used to help cover the screen for the `StickerSubState` class.
 */
class StickerSprite extends FunkinSprite
{
	public function new(pack:String, id:String)
	{
		super();

		loadSprite('ui/sticker/packs/$pack/$id', 2.65);

		visible = false;
		active = false;
		angle = FlxG.random.float(-10, 10);
	}
}

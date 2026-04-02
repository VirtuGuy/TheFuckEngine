package funkin.ui.sticker;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` mainly used to help cover the screen for the `StickerSubState` class.
 */
class StickerSprite extends FunkinSprite
{
	public var id:String;

	public function new(x:Float = 0, y:Float = 0, id:String)
	{
		super(x, y);

		this.id = id;

		loadSprite('ui/stickers/$id', 2.65);

		visible = false;
		active = false;
		angle = FlxG.random.float(-10, 10);
	}
}

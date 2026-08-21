package funkin.util.plugins;

import flixel.FlxBasic;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;
import funkin.audio.FunkinSound;
import funkin.data.sticker.StickerRegistry;
import funkin.ui.sticker.StickerPack;
import funkin.ui.sticker.StickerSprite;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * A plugin for playing a sticker transition when exiting a song.
 */
@:access(openfl.display.Sprite)
class StickerPlugin extends FlxBasic
{
	public static var instance:StickerPlugin;

	final START_OFFSET:Int = -100;
	final STICKER_TIME:Float = 0.0075;

	var sprite:Sprite;

	public static function init()
	{
		FlxG.plugins.addPlugin(new StickerPlugin());
	}

	public function new()
	{
		super();

		instance = this;

		sprite = new Sprite();
		sprite.scrollRect = new Rectangle();

		FlxG.addChildBelowMouse(sprite, 1);
		FlxG.signals.gameResized.add((_, _) -> onResize());

		onResize();
	}

	public function switchState(?id:String, nextState:NextState)
	{
		start(id, () ->
		{
			FlxG.switchState(nextState);
			FlxG.signals.preStateCreate.addOnce(_ -> popup());
		});
	}

	public function clear()
	{
		sprite.removeChildren();
	}

	function start(?id:String, ?callback:() -> Void)
	{
		if (sprite.numChildren > 0)
			return;

		if (!StickerRegistry.instance.exists(id))
			id = Constants.DEFAULT_STICKER_PACK;

		final pack:StickerPack = StickerRegistry.instance.fetch(id);

		if (pack == null)
		{
			if (callback != null)
				callback();
			return;
		}

		var x:Float = START_OFFSET;
		var y:Float = START_OFFSET;

		while (x < FlxG.width)
		{
			var sticker:StickerSprite = new StickerSprite(pack, pack.pickRandom());

			sticker.x = x;
			sticker.y = y;

			sprite.addChild(sticker);

			x += sticker.width / 2;

			if (x >= FlxG.width && y < FlxG.height)
			{
				x = START_OFFSET;
				y += FlxG.random.int(50, 100);
			}
		}

		FlxG.random.shuffle(sprite.__children);

		popup(callback);
	}

	function popup(?callback:() -> Void)
	{
		for (i => sticker in sprite.__children)
		{
			FlxTimer.wait(STICKER_TIME * (i + 1), () ->
			{
				sticker.visible = !sticker.visible;

				FunkinSound.playOnce(Paths.random('general/sticker/sounds/sticker', 1, 5));

				if (i == sprite.numChildren - 1)
				{
					if (!sticker.visible)
						clear();
					if (callback != null)
						callback();
				}
			});
		}
	}

	function onResize()
	{
		final scaleX:Float = FlxG.scaleMode.scale.x;
		final scaleY:Float = FlxG.scaleMode.scale.y;
		final width:Float = FlxG.width * Math.max(1, scaleX);
		final height:Float = FlxG.height * Math.max(1, scaleY);

		sprite.scaleX = scaleX;
		sprite.scaleY = scaleY;

		sprite.__scrollRect.setTo(0, 0, width, height);
	}
}

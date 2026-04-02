package funkin.ui.sticker;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;
import funkin.audio.FunkinSound;

/**
 * The sub state where the screen is filled with stickers.
 * This is used to make a clean transition from one state to the other.
 */
class StickerSubState extends FunkinSubState
{
	final START_OFFSET:Int = -100;
	final STICKER_TIME:Float = 0.01;

	static var stickers:FlxTypedGroup<StickerSprite>;

	public var nextState:NextState;

	var persist:Bool = false;

	public function new(?nextState:NextState)
	{
		super();

		this.nextState = nextState;
	}

	override public function create()
	{
		super.create();

		camera = new FlxCamera();
		camera.bgColor = 0x0;
		FlxG.cameras.add(camera, false);

		stickers ??= new FlxTypedGroup<StickerSprite>();
		add(stickers);

		// Generates the stickers
		if (stickers.length == 0)
		{
			var x:Float = START_OFFSET;
			var y:Float = START_OFFSET;

			while (x < FlxG.width)
			{
				final image:String = Paths.random('sticker', 1, 4);

				var sticker:StickerSprite = new StickerSprite(x, y, image);
				stickers.add(sticker);

				x += sticker.width / 2;

				if (x >= FlxG.width && y < FlxG.height)
				{
					x = START_OFFSET;
					y += FlxG.random.int(50, 100);
				}
			}

			// Shuffles the stickers to be in a more unique order
			// I LOVE random!! :ivebeenabadbrother:
			FlxG.random.shuffle(stickers.members);
		}

		for (i => sticker in stickers)
		{
			FlxTimer.wait(STICKER_TIME * (i + 1), () ->
			{
				sticker.visible = !sticker.visible;

				// Plays a cool sticker sound :)
				FunkinSound.playOnce(Paths.random('ui/stickers/sounds/sticker', 1, 5));

				if (i == stickers.length - 1)
					transition();
			});
		}
	}

	function transition()
	{
		if (nextState != null)
		{
			persist = true;

			FlxG.switchState(nextState);
			FlxG.signals.preStateCreate.addOnce(state ->
			{
				var stickers:StickerSubState = new StickerSubState();

				// This is so dumb :whattheangry:
				@:privateAccess
				if (state._requestedSubState != null)
					state._requestedSubState.openSubState(stickers);
				else
					state.openSubState(stickers);

				// Clears the cache
				FunkinMemory.clearCache();
			});
		}
		else
			close();
	}

	override public function destroy()
	{
		// The stickers are removed so that they aren't destroyed
		if (persist)
			remove(stickers);
		else
		{
			stickers.destroy();
			stickers = null;

			trace('Destroyed stickers.');
		}

		super.destroy();
	}

	public static function switchState(nextState:NextState)
	{
		var stickers:StickerSubState = new StickerSubState(nextState);

		if (FlxG.state.subState != null)
			FlxG.state.subState.openSubState(stickers);
		else
			FlxG.state.openSubState(stickers);
	}
}

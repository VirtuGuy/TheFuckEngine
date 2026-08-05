package funkin.audio;

import flixel.system.ui.FlxSoundTray;
import funkin.util.MathUtil;
import openfl.display.Bitmap;
import openfl.utils.Assets;

/**
 * An extension of `FlxSoundTray`, but with style.
 */
class FunkinSoundTray extends FlxSoundTray
{
	static final SCALE:Float = 1.25;

	var isSilent:Bool;
	var lerpPos:Float;

	var back:Bitmap;

	public function new()
	{
		super();

		removeChildren();

		back = new Bitmap(Assets.getBitmapData(Paths.image(getPath('back'))));
		back.x = -back.width / 2;
		back.y = -back.height / 2;
		addChild(back);

		var bars:Bitmap = buildBar(10);
		bars.alpha = 0.3;

		_bars = [];

		for (i in 1...11)
			_bars.push(buildBar(i));
	}

	override function update(elapsed:Float)
	{
		if (!isSilent)
		{
			_timer = Math.min(1, _timer + elapsed / Constants.MS_PER_SEC);

			if (_timer == 1)
			{
				lerpPos = -height;

				if (y <= -height)
				{
					visible = false;
					active = false;
				}
			}
		}

		x = FlxG.width / 2;
		y = MathUtil.lerp(y, lerpPos, 0.25);

		scaleX = MathUtil.lerp(scaleX, SCALE, 0.3);
		scaleY = MathUtil.lerp(scaleY, SCALE, 0.3);
	}

	override function showIncrement()
	{
		FunkinSound.playOnce(getPath('sounds/${FlxG.sound.volume == 1 ? 'max' : 'up'}'));

		popup(true);
	}

	override function showDecrement()
	{
		FunkinSound.playOnce(getPath('sounds/down'));

		popup(false);
	}

	function popup(up:Bool)
	{
		final volume:Int = FlxG.sound.muted ? 0 : Math.round(FlxG.sound.logToLinear(FlxG.sound.volume) * 10);

		_timer = 0;

		isSilent = volume == 0;
		lerpPos = 70;

		scaleX = SCALE * 1.25;
		scaleY = SCALE * 0.75;

		visible = true;
		active = true;

		for (i => bar in _bars)
			bar.visible = i < volume;
	}

	function buildBar(index:Int):Bitmap
	{
		var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.image(getPath('bars/bar$index'))));
		bar.x = -bar.width / 2;
		bar.y = back.y + bar.height / 2 - 2;

		addChild(bar);

		return bar;
	}

	inline function getPath(id:String):String
	{
		return 'general/soundtray/$id';
	}
}

package funkin.ui.menu;

#if HAS_TRANS_SECRET
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

/**
 * An overlay that displays the transgender flag. Why? Because why the hell not.
 */
@:access(flixel.FlxCamera)
class TransOverlay extends Bitmap
{
	public function new()
	{
		super(Assets.getBitmapData(Paths.image('ui/menu/trans/flag')));

		scrollRect = new Rectangle();
		alpha = 0.5;

		FlxG.signals.gameResized.add((_, _) -> onResize());

		onResize();
	}

	function onResize()
	{
		final width:Float = FlxG.camera._scrollRect.scrollRect.width;
		final height:Float = FlxG.camera._scrollRect.scrollRect.height;

		scaleX = width;
		scaleY = height / 10;

		__scrollRect.setTo(0, 0, width, height);
	}
}
#end

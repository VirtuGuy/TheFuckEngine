package funkin.graphics;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * The base class for all of the engine's sprites.
 */
class FunkinSprite extends FlxSprite
{
	var images:Array<String> = [];

	public function loadSprite(id:String, scale:Float = 1, width:Int = 0, height:Int = 0):FunkinSprite
	{
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image(id));

		// Validates the width and height
		// Hooray no more crashy!!!
		width = Std.int(width.clamp(0, graphic?.width));
		height = Std.int(height.clamp(0, graphic?.height));

		// Properly loads the graphic
		loadGraphic(graphic, width > 0 || height > 0, width, height);

		if (graphic != null)
		{
			setGraphicSize(Std.int(this.width * Constants.ZOOM * scale));
			updateHitbox();
		}

		return this;
	}

	public function loadAdditionalFrames(id:String, ?width:Int, ?height:Int, ?key:String):FunkinSprite
	{
		key ??= id;

		if (frames?.type != TILES || images.contains(key))
			return this;

		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image(id));

		if (graphic == null)
			return this;

		width ??= frameWidth;
		height ??= frameHeight;

		if (width <= 0)
			width = graphic.width;
		if (height <= 0)
			height = graphic.height;

		width = Std.int(width.clamp(0, graphic.width));
		height = Std.int(height.clamp(0, graphic.height));

		var size:FlxPoint = FlxPoint.get(width, height);
		var tiles:FlxTileFrames = FlxTileFrames.fromGraphic(graphic, size);

		for (frame in tiles.frames)
			frames.pushFrame(frame);

		size.put();
		images.push(key);

		return this;
	}

	public function makeSolidColor(width:Int, height:Int, color:FlxColor):FunkinSprite
	{
		makeGraphic(1, 1, color);

		scale.set(width, height);
		updateHitbox();

		return this;
	}

	public function addAnimation(name:String, frames:Array<Int>, framerate:Int = 10, looped:Bool = true)
	{
		animation.add(name, frames, framerate, looped);
	}

	public function removeAnimation(name:String)
	{
		animation.remove(name);
	}

	public function playAnimation(name:String, force:Bool = false)
	{
		if (!hasAnimation(name))
			return;
		animation.play(name, force);
	}

	public function hasAnimation(name:String):Bool
	{
		return animation.exists(name);
	}

	public function getCurrentAnimation():String
	{
		return animation.curAnim?.name ?? '';
	}

	override function clone():FunkinSprite
	{
		var sprite:FunkinSprite = new FunkinSprite();

		sprite.loadGraphicFromSprite(this);
		sprite.setGraphicSize(width, height);
		sprite.updateHitbox();

		sprite.animation.copyFrom(animation);
		sprite.scrollFactor.copyFrom(scrollFactor);
		sprite.offset.copyFrom(offset);
		sprite.origin.copyFrom(origin);

		sprite.angle = angle;
		sprite.flipX = flipX;
		sprite.flipY = flipY;

		sprite.visible = visible;
		sprite.active = active;

		sprite.zIndex = zIndex;

		return sprite;
	}

	public static function create(x:Float, y:Float, id:String, scale:Float = 1, width:Int = 0, height:Int = 0):FunkinSprite
	{
		return new FunkinSprite(x, y).loadSprite(id, scale, width, height);
	}

	public static function createSolidColor(x:Float, y:Float, width:Int, height:Int, color:FlxColor):FunkinSprite
	{
		return new FunkinSprite(x, y).makeSolidColor(width, height, color);
	}
}

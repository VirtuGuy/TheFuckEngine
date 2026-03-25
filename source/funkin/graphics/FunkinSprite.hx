package funkin.graphics;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * The base class for all of the engine's sprites.
 */
class FunkinSprite extends FlxSprite
{
    public static function create(x:Float, y:Float, id:String, scale:Float = 1, width:Int = 0, height:Int = 0):FunkinSprite
        return new FunkinSprite(x, y).loadSprite(id, scale, width, height);

    public function loadSprite(id:String, scale:Float = 1, width:Int = 0, height:Int = 0):FunkinSprite
    {
        loadGraphic(Paths.image(id), width > 0 || height > 0, width, height);
        setGraphicSize(Std.int(this.width * Constants.ZOOM * scale));
        updateHitbox();

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
        animation.add(name, frames, framerate, looped);

    public function playAnimation(name:String, force:Bool = false)
    {
        if (!hasAnimation(name)) return;
        animation.play(name, force);
    }

    public function hasAnimation(name:String):Bool
        return animation.exists(name);

    public function getCurrentAnimation():String
        return animation.curAnim?.name ?? '';

    /**
     * A better version of `FlxSprite`'s `clone` function.
     */
    public function copy():FunkinSprite
    {
        var sprite:FunkinSprite = new FunkinSprite();

        sprite.loadGraphicFromSprite(this);
        sprite.setGraphicSize(width, height);
        sprite.updateHitbox();

        sprite.animation.copyFrom(animation);
        sprite.offset.copyFrom(offset);
        sprite.origin.copyFrom(origin);

        sprite.angle = angle;
        sprite.flipX = flipX;
        sprite.flipY = flipY;
        
        sprite.visible = visible;
        sprite.active = active;

        return sprite;
    }
}
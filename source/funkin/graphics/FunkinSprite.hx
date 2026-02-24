package funkin.graphics;

import flixel.FlxSprite;

/**
 * The base class for all of the engine's sprites.
 */
class FunkinSprite extends FlxSprite
{
    public function loadSprite(id:String, scale:Float = 1, frameWidth:Int = 0, frameHeight:Int = 0):FunkinSprite
    {
        loadGraphic(Paths.image(id), frameWidth > 0 || frameHeight > 0, frameWidth, frameHeight);
        setGraphicSize(Std.int(width * Constants.ZOOM * scale));
        updateHitbox();

        return this;
    }

    public function addAnimation(name:String, frames:Array<Int>, framerate:Int = 10, looped:Bool = true)
        animation.add(name, frames, framerate, looped);

    public function playAnimation(name:String, force:Bool = false)
    {
        if (!animation.exists(name)) return;
        animation.play(name, force);
    }

    public function hasAnimation(name:String):Bool
        return animation.exists(name);
}
package funkin.play.popup;

import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * A group used for making popup sprites appear. Don't confuse this with `Popups`.
 * 
 * `Popups` is a group containing a bunch of `PopupGroup` objects.
 * 
 * `PopupGroup` is what actually makes the `PopupSprite` objects appear.
 */
class PopupGroup extends FlxTypedGroup<PopupSprite>
{
    public function new()
    {
        super();
    }

    public function popup(x:Float = 0, y:Float = 0):PopupSprite
    {
        var sprite:PopupSprite = recycle(PopupSprite);
        sprite.popup();
        sprite.setPosition(x, y);

        // Ensure that the sprite is on top
        sprite.zIndex = getLast(spr -> spr.zIndex > sprite.zIndex)?.zIndex + 1;
        
        refresh();

        return sprite;
    }
}
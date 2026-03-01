package funkin.graphics;

import flixel.math.FlxPoint;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

/**
 * The engine's text sprite.
 */
class FunkinText extends FlxBitmapText
{
    static final LETTERS:String = '!"#$%&\'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[\\]^_`{|}~';
    static final FONT_SIZE:FlxPoint = new FlxPoint(26, 34);

    public var size(default, set):Int = 32;

    public function new(x:Float = 0, y:Float = 0, text:String = '')
    {
        super(x, y, text, FlxBitmapFont.fromMonospace(Paths.image('ui/font'), LETTERS, FONT_SIZE));
        
        letterSpacing = 2;
        lineSpacing = 4;

        active = false;
    }

    override function set_text(text:String):String
    {
        text = text?.toLowerCase();
        if (this.text == text) return text;
        return super.set_text(text);
    }

    function set_size(size:Int):Int
    {
        this.size = size;

        // The base font size is 32, so divide size by 32
        scale.x = size / 32;
        scale.y = scale.x;

        updateHitbox();

        return size;
    }
}
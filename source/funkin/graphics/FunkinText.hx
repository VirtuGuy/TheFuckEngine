package funkin.graphics;

import flixel.math.FlxPoint;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

/**
 * The engine's text sprite.
 * 
 * TODO: Add more characters to the font.
 */
class FunkinText extends FlxBitmapText
{
    static final LETTERS:String = '1234567890-';
    static final FONT_SIZE:FlxPoint = new FlxPoint(26, 34);

    public var size(default, set):Int = 32;

    public function new(x:Float = 0, y:Float = 0, text:String = '')
    {
        super(x, y, text.toLowerCase(), FlxBitmapFont.fromMonospace(Paths.image('ui/font'), LETTERS, FONT_SIZE));
        
        letterSpacing = 2;
        active = false;
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
package funkin.audio;

import flixel.FlxG;
import flixel.sound.FlxSound;

/**
 * A class for playing and handling sounds.
 */
class FunkinSound extends FlxSound
{
    public function new(id:String, volume:Float = 1, looped:Bool = false, autoDestroy:Bool = true)
    {
        super();

        loadEmbedded(Paths.sound(id), looped, autoDestroy);
        
        this.volume = volume;

        FlxG.sound.list.add(this);
    }

    override public function destroy()
    {
        super.destroy();

        FlxG.sound.list.remove(this, true);
    }

    public static function playOnce(id:String, volume:Float = 1):FunkinSound
    {
        var sound:FunkinSound = new FunkinSound(id, volume);
        sound.play();
        return sound;
    }

    public static function playMusic(id:String, volume:Float = 1, looped:Bool = true, autoStart:Bool = true)
    {
        FlxG.sound.playMusic(Paths.sound(id), volume, looped);

        // Don't play the music if auto start is off
        if (!autoStart) FlxG.sound.music.stop();
    }
}
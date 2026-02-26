package funkin.audio;

import flixel.FlxG;
import flixel.sound.FlxSound;

/**
 * A class for playing and handling sounds.
 * 
 * TODO: Use unique sound list and groups.
 */
class FunkinSound extends FlxSound
{
    public static var music:FunkinSound;

    public static function load(id:String, volume:Float = 1, looped:Bool = true):FunkinSound
    {
        var sound:FunkinSound = cast FlxG.sound.list.recycle(FunkinSound);
        sound.loadEmbedded(Paths.sound(id), false, true);

        sound.persist = false;
        sound.volume = volume;

        FlxG.sound.list.add(sound);
        FlxG.sound.defaultSoundGroup.add(sound);

        return sound;
    }

    public static function playOnce(id:String, volume:Float = 1):FunkinSound
    {
        var sound:FunkinSound = load(id, volume, false);
        sound.play();
        return sound;
    }

    public static function playMusic(id:String, volume:Float = 1, looped:Bool = true, autoPlay:Bool = true)
    {
        if (music == null)
            music = new FunkinSound();
        else if (music.active)
            music.stop();

        music.loadEmbedded(Paths.sound(id), looped);
        music.volume = volume;
        music.persist = true;

        FlxG.sound.music = music;
        FlxG.sound.defaultMusicGroup.add(music);

        if (autoPlay) music.play();
    }
}
package funkin.audio;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;

/**
 * A helper class for handling the engine's audio.
 * 
 * TODO: Change `playMusic` to use streamed audio.
 */
class FunkinSound extends FlxSound
{
	public static var music(default, null):FunkinSound;

	static var pool(default, null) = new FlxTypedGroup<FunkinSound>();

	override public function destroy()
	{
		super.destroy();

		fadeTween?.cancel();
		fadeTween = null;

		FlxTween.cancelTweensOf(this);
	}

	//
	// FunkinSound
	//

	public static inline function load(id:String, volume:Float = 1, looped:Bool = true, autoDestroy:Bool = true, autoPlay:Bool = true):FunkinSound
	{
		var sound:FunkinSound = pool.recycle(FunkinSound);

		sound.loadEmbedded(Paths.sound(id), looped, autoDestroy);
		sound.volume = volume;
		sound.persist = false;

		if (autoPlay)
			sound.play();

		FlxG.sound.list.add(sound);

		return sound;
	}

	public static inline function playOnce(id:String, volume:Float = 1):FunkinSound
	{
		return load(id, volume, false);
	}

	public static function playMusic(id:String, volume:Float = 1, looped:Bool = true, autoPlay:Bool = true, overrideMusic:Bool = true)
	{
		if (music?.playing && !overrideMusic)
			return;

		if (music == null)
			music = load(id, volume, looped, false, false);
		else
			music.loadEmbedded(Paths.sound(id), looped, false);

		music.volume = volume;
		music.persist = true;

		if (autoPlay)
			music.play();

		FlxG.sound.list.add(music);
	}

	public static function pauseAllSounds()
	{
		FlxG.sound.list.forEachAlive(sound -> sound.pause());
	}

	public static function resumeAllSounds()
	{
		FlxG.sound.list.forEachAlive(sound -> sound.resume());
	}

	public static function stopAllSounds(stopMusic:Bool = false)
	{
		FlxG.sound.list.forEachAlive(sound ->
		{
			if (sound == music && !stopMusic)
				return;
			sound.stop();
		});
	}
}

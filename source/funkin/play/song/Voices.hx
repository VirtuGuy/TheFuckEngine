package funkin.play.song;

import flixel.FlxG;
import flixel.sound.FlxSound;

/**
 * A class for handling the vocals for a song.
 */
class Voices
{
    public var opponent:FlxSound;
    public var player:FlxSound;

    public var time(default, set):Float;

    public var opponentVolume(default, set):Float = 1;
    public var playerVolume(default, set):Float = 1;

    public function new(id:String)
    {
        opponent = new FlxSound();
        opponent.loadEmbedded(Paths.sound('songs/$id/voices-opponent'));
        
        player = new FlxSound();
        player.loadEmbedded(Paths.sound('songs/$id/voices-player'));

        FlxG.sound.list.add(opponent);
        FlxG.sound.list.add(player);
    }

    public function play()
    {
        opponent.play();
        player.play();
    }

    public function stop()
    {
        opponent.stop();
        player.stop();
    }

    public function pause()
    {
        opponent.pause();
        player.pause();
    }

    public function checkResync(time:Float)
    {
        // Opponent vocals resync
        if (Math.abs(time - opponent.time) > Constants.RESYNC_THRESHOLD)
        {
            opponent.pause();
            opponent.time = time;
            opponent.play();
        }

        // Player vocals resync
        if (Math.abs(time - player.time) > Constants.RESYNC_THRESHOLD)
        {
            player.pause();
            player.time = time;
            player.play();
        }
    }

    function set_time(time:Float):Float
    {
        this.time = time;

        opponent.time = time;
        player.time = time;

        return time;
    }

    function set_opponentVolume(opponentVolume:Float):Float
    {
        this.opponentVolume = opponentVolume;
        opponent.volume = opponentVolume;
        return opponentVolume;
    }

    function set_playerVolume(playerVolume:Float):Float
    {
        this.playerVolume = playerVolume;
        player.volume = playerVolume;
        return playerVolume;
    }

    public function destroy()
    {
        opponent.destroy();
        player.destroy();

        // Removes the vocals from the sound list
        FlxG.sound.list.remove(opponent, true);
        FlxG.sound.list.remove(player, true);
    }
}
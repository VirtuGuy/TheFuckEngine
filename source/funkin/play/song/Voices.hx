package funkin.play.song;

import flixel.FlxG;
import funkin.audio.FunkinSound;

/**
 * A class for handling the vocals for a song.
 */
class Voices
{
    public var opponent:FunkinSound;
    public var player:FunkinSound;

    public var time(default, set):Float;

    public var opponentVolume(default, set):Float = 1;
    public var playerVolume(default, set):Float = 1;

    public function new(id:String)
    {
        opponent = new FunkinSound(Paths.voices(id, 'opponent'), 1, false, false);
        player = new FunkinSound(Paths.voices(id, 'player'), 1, false, false);
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
    }
}
package funkin.play.song;

import funkin.audio.FunkinSound;

/**
 * A class for handling the vocals for a song.
 */
class Voices
{
    public var opponent:FunkinSound;
    public var player:FunkinSound;

    public var opponentVolume(get, set):Float;
    public var playerVolume(get, set):Float;

    public function new(id:String)
    {
        opponent = FunkinSound.load(Paths.voices(id, 'opponent'), 1, false);
        player = FunkinSound.load(Paths.voices(id, 'player'), 1, false);
    }

    public function play()
    {
        opponent.play();
        player.play();
    }

    public function pause()
    {
        opponent.pause();
        player.pause();
    }

    public function stop()
    {
        opponent.stop();
        player.stop();
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

    function set_opponentVolume(opponentVolume:Float):Float
    {
        opponent.volume = opponentVolume;
        return opponentVolume;
    }

    function set_playerVolume(playerVolume:Float):Float
    {
        player.volume = playerVolume;
        return playerVolume;
    }

    inline function get_opponentVolume():Float
        return opponent.volume;

    inline function get_playerVolume():Float
        return player.volume;
}
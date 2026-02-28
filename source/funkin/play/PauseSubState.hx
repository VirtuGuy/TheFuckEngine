package funkin.play;

import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.ui.FunkinSubState;

/**
 * The game's pause menu sub state.
 */
class PauseSubState extends FunkinSubState
{
    var justOpened:Bool;

    var bg:FunkinSprite;
    var songText:FunkinText;

    override public function create()
    {
        super.create();

        justOpened = controls.ACCEPT;

        bg = new FunkinSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0;
        bg.active = false;
        add(bg);

        songText = new FunkinText(0, 20);
        songText.size = 24;
        songText.alignment = RIGHT;
        add(songText);

        songText.text = 'song name: ${PlayState.song.name}';
        songText.text += '\ndifficulty: ${PlayState.difficulty}';
        songText.text += '\nartist: ${PlayState.song.artist}';

        songText.x = FlxG.width - songText.width - 20;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Gotta do this as tweens cannot be used here :(
        bg.alpha = Math.min(0.8, bg.alpha += elapsed * 5);

        if (controls.ACCEPT)
        {
            if (justOpened)
            {
                justOpened = false;
                return;
            }
            close();
        }
    }
}
package funkin.play;

import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.play.song.Song;
import funkin.ui.FunkinSubState;
import funkin.ui.MenuList;
import funkin.ui.freeplay.FreeplayState;

/**
 * The game's pause menu sub state.
 */
class PauseSubState extends FunkinSubState
{
    final ogItems:Array<String> = ['resume', 'restart', 'difficulty', 'exit to menu'];

    var song(get, never):Song;
    var difficulty(get, never):String;

    var changingDiff:Bool = false;
    var justOpened:Bool;

    var music:FunkinSound;

    var bg:FunkinSprite;
    var songText:FunkinText;
    var items:MenuList;

    override public function create()
    {
        super.create();

        justOpened = controls.ACCEPT;

        music = FunkinSound.load('play/music/pause', 0);
        music.play();

        bg = new FunkinSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0;
        bg.active = false;
        add(bg);

        songText = new FunkinText(0, 20);
        songText.size = 24;
        songText.alignment = RIGHT;
        add(songText);

        items = new MenuList(ogItems);
        items.itemSelected.add(itemSelected);
        add(items);

        if (song.difficulties.length < 2) items.removeItem('difficulty');

        // Updates the song text
        songText.text = song.name;
        songText.text += '\ndifficulty: ${difficulty}';
        songText.text += '\nartist: ${song.artist}';
        songText.x = FlxG.width - songText.width - 20;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Gotta do this as tweens cannot be used here :(
        music.volume = Math.min(1, music.volume += elapsed / 8);
        bg.alpha = Math.min(0.8, bg.alpha += elapsed * 5);
    }

    function itemSelected(item:String)
    {
        // Input is so dumb lol
        if (justOpened)
        {
            justOpened = false;
            return;
        }

        if (changingDiff)
        {
            // Checks if back was pressed
            // I mean, you never know if someone makes a BACK difficulty
            if (items.selected == items.count() - 1)
            {
                items.setItems(ogItems);
                changingDiff = false;
            }
            else
            {
                PlayState.difficulty = item;
                PlayState.instance.resetSong();
                close();
            }
        }
        else
        {
            switch (item)
            {
                case 'resume' | 'restart':
                    if (item == 'restart')
                        PlayState.instance.resetSong();
                    close();
                case 'exit to menu':
                    FlxG.switchState(() -> new FreeplayState());
                case 'difficulty':
                    changingDiff = true;

                    items.setItems(song.difficulties.copy());
                    items.removeItem(difficulty);
                    items.addItem('back');
            }
        }
    }

    override public function destroy()
    {
        super.destroy();

        // Destroys the music as it isn't needed anymore
        // If you remove this line, great things will happen
        music.destroy();
    }

    inline function get_song():Song
        return PlayState.song;

    inline function get_difficulty():String
        return PlayState.difficulty;
}
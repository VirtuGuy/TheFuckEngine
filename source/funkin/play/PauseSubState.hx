package funkin.play;

import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.play.song.Song;
import funkin.ui.FunkinSubState;
import funkin.ui.MenuList;

/**
 * The game's pause menu sub state.
 */
class PauseSubState extends FunkinSubState
{
    var song(get, never):Song;
    var difficulty(get, never):String;

    var ogItems:Array<String>;
    var changingDiff:Bool = false;

    var music:FunkinSound;

    var bg:FunkinSprite;
    var songText:FunkinText;
    var items:MenuList;

    override public function create()
    {
        super.create();

        ogItems = ['resume', 'restart', 'exit to menu'];
        if (song.difficulties.length > 1) ogItems.insert(2, 'difficulty');

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
        if (changingDiff)
        {
            // Checks if back was pressed
            // I mean, you never know if someone makes a BACK difficulty
            if (items.selected == items.items.length - 1)
            {
                items.items = ogItems;
                changingDiff = false;
            }
            else
            {
                PlayState.difficulty = item;
                PlayState.instance.resetSong();
                close();
            }

            return;
        }

        switch (item)
        {
            case 'resume' | 'restart':
                if (item == 'restart')
                    PlayState.instance.resetSong();
                close();
            case 'difficulty':
                var newItems:Array<String> = song.difficulties.copy();

                newItems.remove(difficulty);
                newItems.push('back');
                
                items.items = newItems;
                changingDiff = true;
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
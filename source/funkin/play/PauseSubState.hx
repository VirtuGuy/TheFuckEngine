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
    final DEFAULT_ENTRIES:Array<String> = ['resume', 'restart', 'exit to menu'];

    var song(get, never):Song;
    var difficulty(get, never):String;
    var deaths(get, never):Int;

    var justOpened:Bool = true;
    var changingDiff:Bool = false;

    var music:FunkinSound;

    var bg:FunkinSprite;
    var songText:FunkinText;
    var menuList:MenuList;

    override public function create()
    {
        super.create();

        if (song.difficulties.length > 1)
            DEFAULT_ENTRIES.insert(2, 'difficulty');
        #if debug
        DEFAULT_ENTRIES.insert(3, 'botplay');
        #end

        music = FunkinSound.load('play/music/pause', 0);

        bg = new FunkinSprite();
        bg.makeSolidColor(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0;
        bg.active = false;
        add(bg);

        songText = new FunkinText(0, 20);
        songText.size = 24;
        songText.alignment = RIGHT;
        add(songText);

        menuList = new MenuList(DEFAULT_ENTRIES);
        menuList.onSelected.add(select);
        add(menuList);

        updateSongText();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        justOpened = false;

        // Gotta do this as tweens cannot be used here :(
        music.volume = Math.min(1, music.volume += elapsed / 5);
        bg.alpha = Math.min(0.8, bg.alpha += elapsed * 5);
    }

    function updateSongText()
    {
        // Gotta display some good info
        songText.text = song.name;
        songText.text += '\ndifficulty: $difficulty';
        songText.text += '\nartist: ${song.artist}';
        songText.text += '\n$deaths blue ball';

        if (deaths != 1) songText.text += 's';
        if (Preferences.botplay) songText.text += '\nbotplay';

        songText.x = FlxG.width - songText.width - 20;
    }

    function select(item:String)
    {
        if (justOpened) return;

        if (changingDiff)
        {
            // Checks if back was pressed
            // I mean, you never know if someone makes a BACK difficulty
            if (menuList.selected == menuList.size - 1)
            {
                menuList.entries = DEFAULT_ENTRIES;
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
                case 'resume': 
                    close();
                case 'restart':
                    PlayState.instance.resetSong();
                    close();
                case 'exit to menu':
                    FlxG.switchState(() -> new FreeplayState());
                case 'difficulty':
                    var entries:Array<String> = song.difficulties.copy();

                    entries.remove(difficulty);
                    entries.push('back');

                    menuList.entries = entries;
                    changingDiff = true;
                case 'botplay':
                    Preferences.botplay = !Preferences.botplay;
                    updateSongText();
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

    inline function get_deaths():Int
        return PlayState.instance.deaths;
}
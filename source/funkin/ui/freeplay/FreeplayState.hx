package funkin.ui.freeplay;

import funkin.audio.FunkinSound;
import funkin.data.song.SongRegistry;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.play.PlayState;
import funkin.util.SortUtil;

/**
 * The engine's freeplay state, where the player is able to select a song.
 * 
 * TODO: Make this a proper freeplay menu.
 */
class FreeplayState extends FunkinState
{
    var songs:MenuList;

    override public function create()
    {
        super.create();

        FunkinSound.playMusic('ui/music/menu', 1, true, true, false);

        // TODO: Make the difficulty changeable
        PlayState.difficulty = 'hard';
        PlayState.song = null;

        var bg:FunkinSprite = FunkinSprite.create(0, 0, 'ui/bg', 1.5);
        bg.color = 0xFF151515;
        add(bg);

        var freeplayText:FunkinText = new FunkinText(0, 50, 'freeplay\nthis is a huge wip');
        freeplayText.alignment = CENTER;
        freeplayText.screenCenter(X);
        add(freeplayText);

        // Loads the songs
        var songsList:Array<String> = SongRegistry.instance.list();
        
        songsList.sort(SortUtil.defaultsAlphabetically.bind(Constants.DEFAULT_SONGS));

        songs = new MenuList(songsList);
        songs.onSelected.add(select);
        add(songs);
    }

    function select(id:String)
    {
        PlayState.song = SongRegistry.instance.fetch(id);
        FlxG.switchState(() -> new PlayState());
    }
}
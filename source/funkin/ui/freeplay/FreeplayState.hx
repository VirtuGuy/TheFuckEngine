package funkin.ui.freeplay;

import funkin.data.song.SongRegistry;
import funkin.graphics.FunkinText;
import funkin.play.PlayState;
import funkin.util.SortUtil;

/**
 * The game's freeplay state, where the player is able to select a song.
 * 
 * TODO: Make this a proper freeplay menu.
 */
class FreeplayState extends FunkinState
{
    var songs:MenuList;

    override public function create()
    {
        super.create();

        // TODO: Make the difficulty changeable
        PlayState.difficulty = 'hard';
        PlayState.song = null;

        var freeplayText:FunkinText = new FunkinText(0, 50, 'freeplay\nthis is a huge wip');
        freeplayText.alignment = CENTER;
        freeplayText.screenCenter(X);
        add(freeplayText);

        // Loads the songs
        var songsList:Array<String> = SongRegistry.instance.list();
        songsList.sort(SortUtil.alphabetically);

        songs = new MenuList(songsList);
        songs.itemSelected.add(selectSong);
        add(songs);
    }

    function selectSong(id:String)
    {
        PlayState.song = SongRegistry.instance.fetch(id);
        FlxG.switchState(() -> new PlayState());
    }
}
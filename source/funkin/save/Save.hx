package funkin.save;

import funkin.data.song.SongRegistry;
import funkin.play.song.Song;
import haxe.ds.StringMap;

/**
 * A class for saving and loading data.
 */
class Save
{
    public static var instance:Save;

    public var scores(get, never):StringMap<Int>;
    public var favorites(get, never):StringMap<Bool>;

    var data:SaveData;

    public function new()
    {
        // Loads default data if there is none
        FlxG.save.mergeData(getDefault());

        data = FlxG.save.data;
    }

    public function flush()
    {
        FlxG.save.mergeData(data, true);
        FlxG.save.flush();
    }

    public function setScore(id:String, diff:String, score:Int, force:Bool = true)
    {
        // Don't save the score if it wasn't beaten
        if (score <= getSongScore(id, diff) && !force) return;
        scores.set('$id-$diff', score);

        trace('Updated song score to $score for $id.');

        flush();
    }

    public function setFavorite(id:String, favorite:Bool)
    {
        // Don't favorite the song if it's already favorited
        if (isSongFavorited(id) == favorite) return;
        favorites.set(id, favorite);

        if (favorite)
            trace('Favorited song $id.');
        else
            trace('Unfavorited song $id.');

        flush();
    }

    public function getSongScore(id:String, diff:String):Int
        return scores.get('$id-$diff') ?? 0;

    public function isSongFavorited(id:String):Bool
        return favorites.get(id) ?? false;

    public function isSongComplete(id:String):Bool
    {
        var song:Song = SongRegistry.instance.fetch(id);

        if (song == null) return false;

        for (diff in song.difficulties)
        {
            if (getSongScore(song.id, diff) > 0)
                return true;
        }

        return false;
    }

    inline function get_scores():StringMap<Int>
        return data.song.scores;

    inline function get_favorites():StringMap<Bool>
        return data.song.favorites;

    inline function getDefault():SaveData
    {
        return {
            song: {
                scores: new StringMap<Int>(),
                favorites: new StringMap<Bool>()
            }
        }
    }
}
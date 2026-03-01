package funkin.util;

import flixel.FlxBasic;
import flixel.util.FlxSort;
import funkin.data.song.SongData.SongNoteData;

/**
 * A utility class for sorting.
 */
class SortUtil
{
    public static inline function byTime(order:Int, a:SongNoteData, b:SongNoteData):Int
        return FlxSort.byValues(order, a.t, b.t);

    public static inline function byZIndex(order:Int, a:FlxBasic, b:FlxBasic):Int
        return FlxSort.byValues(order, a.zIndex, b.zIndex);

    public static function alphabetically(a:String, b:String):Int
    {
        if (a == b) return 0;
        return a < b ? -1 : 1;
    }
}
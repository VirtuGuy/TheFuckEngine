package funkin.play.song;

import funkin.data.song.SongData;
import haxe.ds.StringMap;

/**
 * A class containing meta and chart data for a song.
 */
class Song
{
    public var id:String;
    public var meta:SongMetadata;
    public var charts:StringMap<SongChartData> = new StringMap<SongChartData>();

    public var name(get, never):String;
    public var bpm(get, never):Float;
    public var artist(get, never):String;
    public var difficulties(get, never):Array<String>;

    public var stage(get, never):String;

    public var opponent(get, never):String;
    public var player(get, never):String;
    public var gf(get, never):String;

    public function new(id:String, meta:SongMetadata)
    {
        this.id = id;
        this.meta = meta;
    }

    public function getChart(diff:String):SongChartData
        return charts.get(diff);

    public function getNotes(diff:String):Array<SongNoteData>
        return getChart(diff)?.notes ?? [];
    
    public function getSpeed(diff:String):Float
        return getChart(diff)?.speed ?? Constants.DEFAULT_SPEED;

    inline function get_name():String
    {
        var name:Null<String> = meta.name;
        if (name == null || name.trim() == '')
            name = Constants.DEFAULT_SONG_NAME;
        return name;
    }

    inline function get_bpm():Float
        return meta.bpm;

    inline function get_artist():String
    {
        var artist:Null<String> = meta.artist;
        if (artist == null || artist.trim() == '')
            artist = Constants.DEFAULT_SONG_ARTIST;
        return artist;
    }

    inline function get_difficulties():Array<String>
        return meta.difficulties;

    inline function get_stage():String
        return meta.stage;

    inline function get_opponent():String
        return meta.opponent;

    inline function get_player():String
        return meta.player;

    inline function get_gf():String
        return meta.gf;
}
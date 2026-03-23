package funkin.play.song;

import funkin.data.event.EventData;
import funkin.data.song.SongData;

/**
 * A class containing meta and chart data for a song.
 */
class Song
{
    public var id:String;
    public var meta:SongMetadata;
    public var chart:SongChartData;

    public var events(get, never):Array<EventData>;

    public var name(get, never):String;
    public var bpm(get, never):Float;
    public var artist(get, never):String;
    public var difficulties(get, never):Array<String>;

    public var stage(get, never):String;

    public var opponent(get, never):String;
    public var player(get, never):String;
    public var gf(get, never):String;

    public var instPath(get, never):String;
    public var opponentPath(get, never):String;
    public var playerPath(get, never):String;

    var path(get, never):String;

    public function new(id:String, meta:SongMetadata, chart:SongChartData)
    {
        this.id = id;
        this.meta = meta;
        this.chart = chart;
    }

    public function getRating(diff:String):Int
        return meta.rating?.get(diff) ?? 0;

    public function getNotes(diff:String):Array<SongNoteData>
        return chart.notes?.get(diff) ?? [];

    public function getSpeed(diff:String):Float
        return chart.speed?.get(diff) ?? Constants.DEFAULT_SPEED;

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

    inline function get_events():Array<EventData>
        return chart.events;

    inline function get_instPath():String
        return '$path/inst';

    inline function get_opponentPath():String
        return '$path/opponent';

    inline function get_playerPath():String
        return '$path/player';

    inline function get_path():String
        return 'play/songs/$id';
}
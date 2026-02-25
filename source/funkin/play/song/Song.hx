package funkin.play.song;

import flixel.util.FlxSort;
import funkin.data.song.SongData;

/**
 * A class containing meta and chart data for a song.
 */
class Song
{
    public var id:String;
    public var meta:SongMetadata;
    public var chart:SongChartData;

    public var name(get, never):String;
    public var bpm(get, never):Float;

    public var speed(get, never):Float;
    public var notes(get, never):Array<SongNoteData>;

    public var stage(get, never):String;

    public var opponent(get, never):String;
    public var player(get, never):String;
    public var gf(get, never):String;

    public function new(id:String, meta:SongMetadata, chart:SongChartData)
    {
        this.id = id;
        this.meta = meta;
        this.chart = chart;

        // Sorts the notes because it should be nice and neat :)
        notes.sort((note1, note2) -> return FlxSort.byValues(FlxSort.ASCENDING, note1.t, note2.t));
    }

    inline function get_name():String
        return meta.name;

    inline function get_bpm():Float
        return meta.bpm;

    inline function get_speed():Float
        return chart.speed;

    inline function get_notes():Array<SongNoteData>
        return chart.notes;

    inline function get_stage():String
        return meta.stage;

    inline function get_opponent():String
        return meta.opponent;

    inline function get_player():String
        return meta.player;

    inline function get_gf():String
        return meta.gf;
}
package funkin.play.song;

import funkin.data.event.EventData;
import funkin.data.song.SongData;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;

/**
 * A class containing meta and chart data for a song.
 */
class Song implements IPlayStateScriptedClass
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

    public function new(id:String)
    {
        this.id = id;
    }

    public function getRating(diff:String):Int
        return meta.rating?.get(diff) ?? 0;

    public function getNotes(diff:String):Array<SongNoteData>
        return chart.notes?.get(diff) ?? [];

    public function getSpeed(diff:String):Float
        return chart.speed?.get(diff) ?? Constants.DEFAULT_SPEED;

    function get_name():String
    {
        var name:Null<String> = meta.name;
        if (name.isEmpty())
            name = Constants.DEFAULT_NAME;
        return name;
    }

    function get_bpm():Float
        return meta.bpm;

    function get_artist():String
    {
        var artist:Null<String> = meta.artist;
        if (artist == null || artist.trim() == '')
            artist = Constants.DEFAULT_ARTIST;
        return artist;
    }

    function get_difficulties():Array<String>
        return meta.difficulties;

    function get_stage():String
        return meta.stage;

    function get_opponent():String
        return meta.opponent;

    function get_player():String
        return meta.player;

    function get_gf():String
        return meta.gf;

    function get_events():Array<EventData>
        return chart.events;

    inline function get_instPath():String
        return '$path/inst';

    inline function get_opponentPath():String
        return '$path/opponent';

    inline function get_playerPath():String
        return '$path/player';

    inline function get_path():String
        return 'play/songs/$id';

    public function onCreate(event:ScriptEvent) {}
    public function onUpdate(event:UpdateScriptEvent) {}
    public function onDestroy(event:ScriptEvent) {}

    public function onNoteHit(event:NoteScriptEvent) {}
    public function onNoteMiss(event:NoteScriptEvent) {}
    public function onHoldNoteHold(event:HoldNoteScriptEvent) {}
    public function onHoldNoteDrop(event:HoldNoteScriptEvent) {}
    public function onGhostMiss(event:GhostMissScriptEvent) {}

    public function onStepHit(event:ConductorScriptEvent) {}
    public function onBeatHit(event:ConductorScriptEvent) {}
    public function onSectionHit(event:ConductorScriptEvent) {}

    public function onSongLoaded(event:SongLoadScriptEvent) {}
    public function onSongStart(event:ScriptEvent) {}
    public function onSongEnd(event:ScriptEvent) {}
    public function onSongRetry(event:ScriptEvent) {}
    public function onCountdownStart(event:CountdownScriptEvent) {}
    public function onCountdownStep(event:CountdownScriptEvent) {}
    public function onPause(event:ScriptEvent) {}
    public function onGameOver(event:ScriptEvent) {}

    public function toString():String
        return name;
}
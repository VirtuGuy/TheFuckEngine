package funkin.ui.story;

import funkin.data.song.SongRegistry;
import funkin.data.story.LevelData;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.play.song.Song;

/**
 * A class containing the metadata for a level.
 */
class Level implements IPlayStateScriptedClass
{
    public var id:String;
    public var meta:LevelData;

    public var name(get, never):String;
    public var title(get, never):String;

    public var opponent(get, never):String;
    public var player(get, never):String;
    public var gf(get, never):String;

    public var color(get, never):String;

    var songs:Array<String>;
    var songNames:Array<String>;

    public function new(id:String)
    {
        this.id = id;
    }

    public function getSongs():Array<String>
    {
        // Use a cached array to make it real easy for the engine
        if (songs != null) return songs;

        songs = [];

        for (song in meta.songs)
        {
            // Skip duplicate songs
            if (songs.contains(song)) continue;

            // Push the song if it exists
            // There's no point of keeping null songs
            if (SongRegistry.instance.exists(song))
                songs.push(song);
        }

        return songs;
    }

    public function getSongNames():Array<String>
    {
        // Use a cached array to make it real easy for the engine
        if (songNames != null) return songNames;

        songNames = [];

        for (song in getSongs())
        {
            var song:Song = SongRegistry.instance.fetch(song);
            var name:String = song.name;

            songNames.push(name);
        }

        return songNames;
    }

    public function hasSong(id:String):Bool
        return getSongs().contains(id);

    function get_name():String
    {
        var name:Null<String> = meta.name;
        if (name.isEmpty())
            name = Constants.DEFAULT_NAME;
        return name;
    }

    function get_title():String
        return meta.title ?? id;

    function get_opponent():String
        return meta.opponent;

    function get_player():String
        return meta.player;

    function get_gf():String
        return meta.gf;

    function get_color():String
        return meta.color;

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
    public function onSongEvent(event:SongEventScriptEvent) {}
    public function onCountdownStart(event:CountdownScriptEvent) {}
    public function onCountdownStep(event:CountdownScriptEvent) {}
    public function onPause(event:ScriptEvent) {}
    public function onGameOver(event:ScriptEvent) {}

    public function toString():String
        return name;
}
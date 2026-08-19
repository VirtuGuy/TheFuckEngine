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
	var diffs:Array<String>;

	public function new(id:String)
	{
		this.id = id;
	}

	public function getSongs():Array<String>
	{
		// Use a cached array to make it real easy for the engine
		if (songs != null)
			return songs;

		songs = [];

		for (song in meta.songs)
		{
			// Skip duplicate songs
			if (songs.contains(song))
				continue;

			final song:Song = SongRegistry.instance.fetch(song);

			// Skip songs that are null or lack difficulties
			if (song == null || song.getDifficulties(false).length == 0)
				continue;

			songs.push(song.id);
		}

		return songs;
	}

	public function getSongNames():Array<String>
	{
		var result:Array<String> = [];
		for (song in getSongs())
			result.push(SongRegistry.instance.fetch(song).name);
		return result;
	}

	public function getDifficulties():Array<String>
	{
		if (diffs != null)
			return diffs;

		diffs = [];

		var checked:Bool = false;

		for (song in getSongs())
		{
			final song:Song = SongRegistry.instance.fetch(song);

			if (!checked)
			{
				diffs = song.getDifficulties(false);
				checked = true;
			}

			for (diff in diffs.copy())
			{
				if (!song.hasDifficulty(diff, false))
					diffs.remove(diff);
			}
		}

		return diffs;
	}

	public function hasSong(id:String):Bool
	{
		return getSongs().contains(id);
	}

	@:noCompletion
	function get_name():String
	{
		var name:Null<String> = meta.name;
		if (StringTools.isEmpty(name))
			name = Constants.DEFAULT_NAME;
		return name;
	}

	@:noCompletion
	function get_title():String
	{
		return meta.title ?? id;
	}

	@:noCompletion
	function get_opponent():String
	{
		return meta.opponent;
	}

	@:noCompletion
	function get_player():String
	{
		return meta.player;
	}

	@:noCompletion
	function get_gf():String
	{
		return meta.gf;
	}

	@:noCompletion
	function get_color():String
	{
		return meta.color;
	}

	public function onCreate(event:ScriptEvent) {}

	public function onUpdate(event:UpdateScriptEvent) {}

	public function onDestroy(event:ScriptEvent) {}

	public function onScriptEvent(event:ScriptEvent) {}

	public function onNoteHit(event:NoteScriptEvent) {}

	public function onNoteMiss(event:NoteScriptEvent) {}

	public function onHoldNoteHold(event:HoldNoteScriptEvent) {}

	public function onHoldNoteDrop(event:HoldNoteScriptEvent) {}

	public function onGhostMiss(event:GhostMissScriptEvent) {}

	public function onStepHit(event:ConductorScriptEvent) {}

	public function onBeatHit(event:ConductorScriptEvent) {}

	public function onSongLoaded(event:SongLoadScriptEvent) {}

	public function onSongStart(event:ScriptEvent) {}

	public function onSongEnd(event:ScriptEvent) {}

	public function onSongRetry(event:ScriptEvent) {}

	public function onSongEvent(event:SongEventScriptEvent) {}

	public function onCountdownStart(event:CountdownScriptEvent) {}

	public function onCountdownStep(event:CountdownScriptEvent) {}

	public function onPause(event:ScriptEvent) {}

	public function onResume(event:ScriptEvent) {}

	public function onGameOverStart(event:ScriptEvent) {}

	public function onGameOverLoop(event:ScriptEvent) {}

	public function onGameOverRetry(event:ScriptEvent) {}

	public function toString():String
	{
		return '$id | $name';
	}
}

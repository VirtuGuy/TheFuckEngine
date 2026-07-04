package funkin.play;

import funkin.data.song.SongRegistry;
import funkin.play.song.Song;
import funkin.ui.story.Level;

/**
 * A class for handling the playback of multiple songs.
 */
class Playlist
{
	public static var level:Level;
	public static var isStory(get, never):Bool;

	public static var songs:Array<String>;
	public static var score:Int;
	public static var tallies:Tallies;

	public static function reset(?level:Level)
	{
		Playlist.level = level;

		songs = [];
		score = 0;
		tallies = new Tallies();
	}

	public static function load()
	{
		PlayState.song = SongRegistry.instance.fetch(songs[0]);
	}

	public static function next():Bool
	{
		songs.shift();

		if (songs.length == 0)
			return false;

		load();

		return true;
	}

	@:noCompletion
	static inline function get_isStory():Bool
	{
		return level != null;
	}
}

package funkin.play;

import funkin.play.song.Song;

/**
 * A structure object containing parameters used for loading `PlayState`.
 */
typedef PlayParams =
{
	var song:Song;
	var difficulty:String;
	@:optional
	var instrumental:String;
}

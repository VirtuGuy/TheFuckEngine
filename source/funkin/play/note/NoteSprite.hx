package funkin.play.note;

import funkin.data.song.SongData.SongNoteData;
import funkin.graphics.FunkinSprite;
import funkin.play.note.hold.HoldNoteSprite;

/**
 * A `FunkinSprite` used as a note for a `Strumline`.
 */
class NoteSprite extends FunkinSprite
{
	public var data(default, set):SongNoteData;
	public var holdNote:HoldNoteSprite;

	public var time(get, never):Float;
	public var direction(get, never):NoteDirection;
	public var kind(get, never):String;

	public var isPlayer(get, never):Bool;

	public var mayHit:Bool;
	public var willMiss:Bool;
	public var wasMissed:Bool;

	public function buildSprite(style:NoteStyle)
	{
		active = false;

		loadSprite(style.getNote('image'), style.note.scale, style.note.width, style.note.height);

		for (i in 0...Constants.NOTE_COUNT)
		{
			final direction:NoteDirection = NoteDirection.fromInt(i);
			final frame:Int = direction + Constants.NOTE_COUNT * 3;

			addAnimation(direction.name, [frame]);
		}
	}

	override function revive()
	{
		super.revive();

		data = null;
		holdNote = null;

		mayHit = false;
		willMiss = false;
		wasMissed = false;
	}

	@:noCompletion
	function set_data(value:SongNoteData):SongNoteData
	{
		if (data == value)
			return data;
		data = value;

		playAnimation(direction.name);

		return data;
	}

	@:noCompletion
	inline function get_time():Float
	{
		return data?.t;
	}

	@:noCompletion
	inline function get_direction():NoteDirection
	{
		return NoteDirection.fromInt(data?.d);
	}

	@:noCompletion
	inline function get_kind():String
	{
		return data?.k;
	}

	@:noCompletion
	inline function get_isPlayer():Bool
	{
		return data.d < Constants.NOTE_COUNT;
	}
}

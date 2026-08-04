package funkin.play.note;

import funkin.data.note.style.NoteStyleData;
import funkin.data.note.style.NoteStyleRegistry;
import funkin.play.note.NoteDirection;
import funkin.util.RhythmUtil.Judgement;

/**
 * The note style class that gives the gameplay its lovely appearance.
 */
class NoteStyle
{
	public var id:String;
	public var meta:NoteStyleData;

	public var name(get, never):String;
	public var artist(get, never):String;
	public var scale(get, never):Float;
	public var note(get, never):NoteStyleNoteData;
	public var noteSplash(get, never):NoteStyleNoteData;
	public var holdCover(get, never):NoteStyleNoteData;

	public var path(get, never):String;

	public function new(id:String)
	{
		this.id = id;
	}

	public function getPath(id:String):String
	{
		return '$path/$id';
	}

	public function getNote(id:String):String
	{
		return getPath('note/$id');
	}

	public function getCountdown(id:String):String
	{
		return getPath('countdown/$id');
	}

	public function getJudgement(judgement:Judgement):String
	{
		return getPath('judgement/$judgement');
	}

	public function getComboNumber(number:Int):String
	{
		return getPath('combo/num$number');
	}

	public function getNoteFrames(data:NoteStyleAnimData, direction:NoteDirection):Array<Int>
	{
		return switch (direction)
		{
			case LEFT: return data.left;
			case DOWN: return data.down;
			case UP: return data.up;
			case RIGHT: return data.right;
		}
	}

	@:noCompletion
	function get_name():String
	{
		var name:String = meta.name;
		if (name.isEmpty())
			name = Constants.DEFAULT_NAME;
		return name;
	}

	@:noCompletion
	function get_artist():String
	{
		var artist:String = meta.artist;
		if (artist.isEmpty())
			artist = Constants.DEFAULT_ARTIST;
		return artist;
	}

	@:noCompletion
	function get_scale():Float
	{
		return meta.scale;
	}

	@:noCompletion
	function get_note():NoteStyleNoteData
	{
		return meta.note;
	}

	@:noCompletion
	function get_noteSplash():NoteStyleNoteData
	{
		return meta.noteSplash;
	}

	@:noCompletion
	function get_holdCover():NoteStyleNoteData
	{
		return meta.holdCover;
	}

	@:noCompletion
	inline function get_path():String
	{
		return '${NoteStyleRegistry.instance.path}/$id';
	}

	public function toString():String
	{
		return '$id | $name';
	}
}

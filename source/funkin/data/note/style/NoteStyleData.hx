package funkin.data.note.style;

/**
 * A structure object used for style data.
 */
typedef NoteStyleData =
{
	var name:String;
	var artist:String;
	var note:NoteStyleNoteData;
	var noteSplash:NoteStyleNoteData;
	var holdCover:NoteStyleNoteData;
	@:default(1)
	var scale:Float;
}

/**
 * A structure object used for style note data.
 */
typedef NoteStyleNoteData =
{
	var width:Int;
	var height:Int;
	@:default(1)
	var scale:Float;
	@:default(10)
	var framerate:Int;
	var animations:NoteStyleAnimData;
}

/**
 * A structure object used for style note animation data.
 */
typedef NoteStyleAnimData =
{
	@:default([])
	var left:Array<Int>;
	@:default([])
	var down:Array<Int>;
	@:default([])
	var up:Array<Int>;
	@:default([])
	var right:Array<Int>;
}

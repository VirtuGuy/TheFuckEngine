package funkin.play.note.hold;

import flixel.FlxStrip;
import funkin.data.song.SongData.SongNoteData;

/**
 * A sprite used as a sustain note that the player must hold.
 */
class HoldNoteSprite extends FlxStrip
{
	final HOLD_HEIGHT:Int = 1;

	public var data(default, set):SongNoteData;
	public var speed(default, set):Float;

	public var time(get, never):Float;
	public var direction(get, never):NoteDirection;
	public var kind(get, never):String;
	public var length(default, set):Float;

	public var fullLength(default, null):Float;

	public var isPlayer(get, never):Bool;

	public var wasHit:Bool;
	public var wasMissed:Bool;

	var holdHeight:Float;
	var endHeight:Float;

	var graphicWidth:Float;
	var graphicHeight:Float;

	public function new()
	{
		super();

		active = false;

		// Sets the indices
		// This doesn't need to be changed at all
		indices[0] = 0;
		indices[1] = 1;
		indices[2] = 2;
		indices[3] = 1;
		indices[4] = 3;
		indices[5] = 2;
		indices[6] = 4;
		indices[7] = 5;
		indices[8] = 6;
		indices[9] = 5;
		indices[10] = 7;
		indices[11] = 6;
	}

	public function buildSprite(style:NoteStyle)
	{
		loadGraphic(Paths.image(style.getNote('hold/image')));
		setGraphicSize(Std.int(width * Constants.ZOOM * style.note.scale));
		updateHitbox();

		graphicWidth = graphic?.width;
		graphicHeight = graphic?.height;
	}

	public function redraw()
	{
		holdHeight = length * Constants.PIXELS_PER_MS * speed;
		endHeight = (graphicHeight - HOLD_HEIGHT) * scale.y;

		final endClip:Float = Math.min(0, holdHeight - endHeight);
		final flipOff:Float = flipY ? holdHeight : 0;
		final flip:Int = flipY ? -1 : 1;

		// Order:
		// Top left, top right, bottom left, bottom right

		// Hold
		vertices[0] = 0;
		vertices[1] = flipOff;
		vertices[2] = graphicWidth * scale.x / Constants.NOTE_COUNT;
		vertices[3] = vertices[1];
		vertices[4] = vertices[0];
		vertices[5] = Math.max(0, holdHeight - endHeight) * flip + flipOff;
		vertices[6] = vertices[2];
		vertices[7] = vertices[5];

		uvtData[0] = direction / Constants.NOTE_COUNT;
		uvtData[1] = 0;
		uvtData[2] = (direction + 1) / Constants.NOTE_COUNT;
		uvtData[3] = uvtData[1];
		uvtData[4] = uvtData[0];
		uvtData[5] = HOLD_HEIGHT / graphicHeight;
		uvtData[6] = uvtData[2];
		uvtData[7] = uvtData[5];

		// End
		vertices[8] = vertices[4];
		vertices[9] = vertices[5];
		vertices[10] = vertices[6];
		vertices[11] = vertices[9];
		vertices[12] = vertices[8];
		vertices[13] = vertices[9] + (endHeight + endClip) * flip;
		vertices[14] = vertices[10];
		vertices[15] = vertices[13];

		uvtData[8] = uvtData[0];
		uvtData[9] = uvtData[5] - endClip / scale.y / graphicHeight;
		uvtData[10] = uvtData[2];
		uvtData[11] = uvtData[9];
		uvtData[12] = uvtData[8];
		uvtData[13] = 0.99;
		uvtData[14] = uvtData[10];
		uvtData[15] = uvtData[13];

		updateHitbox();
	}

	override public function updateHitbox()
	{
		width = graphicWidth * scale.x / Constants.NOTE_COUNT;
		height = holdHeight;

		offset.set(0, flipY ? height : 0);
		origin.set();
	}

	override public function revive()
	{
		super.revive();

		data = null;
		speed = 0;

		wasHit = false;
		wasMissed = false;

		holdHeight = 0;
		endHeight = 0;
	}

	@:noCompletion
	function set_data(value:SongNoteData):SongNoteData
	{
		if (data == value)
			return data;
		data = value;

		length = data?.l;
		fullLength = length;

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
	function set_length(value:Float):Float
	{
		value = Math.max(0, value);

		if (length == value)
			return length;
		length = value;

		redraw();

		return length;
	}

	@:noCompletion
	function set_speed(value:Float):Float
	{
		if (speed == value)
			return speed;
		speed = value;

		redraw();

		return speed;
	}

	@:noCompletion
	override function set_flipY(value:Bool):Bool
	{
		if (flipY == value)
			return flipY;
		flipY = super.set_flipY(value);

		redraw();

		return flipY;
	}

	@:noCompletion
	inline function get_isPlayer():Bool
	{
		return data.d < Constants.NOTE_COUNT;
	}
}

package funkin.play.note;

import funkin.input.Controls;

/**
 * An enum abstract used for note directions.
 */
enum abstract NoteDirection(Int) to Int from Int
{
    var LEFT = 0;
    var DOWN = 1;
    var UP = 2;
    var RIGHT = 3;

	public var name(get, never):String;

	public var pressed(get, never):Bool;
	public var justPressed(get, never):Bool;

    @:from
    public static function fromInt(value:Int):NoteDirection
    {
        return switch (value % Constants.NOTE_COUNT)
        {
            case 0: LEFT;
            case 1: DOWN;
            case 2: UP;
            case 3: RIGHT;
            default: LEFT;
        }
    }

	public static inline function isPlayer(value:Int):Bool
		return value < Constants.NOTE_COUNT;

	function get_name():String
	{
		return switch (abstract)
		{
			case LEFT: 'left';
			case DOWN: 'down';
			case UP: 'up';
			case RIGHT: 'right';
		}
	}

	function get_pressed():Bool
	{
		var controls:Controls = Controls.instance;

		return switch (abstract)
		{
			case LEFT: controls.NOTE_LEFT;
			case DOWN: controls.NOTE_DOWN;
			case UP: controls.NOTE_UP;
			case RIGHT: controls.NOTE_RIGHT;
		}
	}

	function get_justPressed():Bool
	{
		var controls:Controls = Controls.instance;

		return switch (abstract)
		{
			case LEFT: controls.NOTE_LEFT_P;
			case DOWN: controls.NOTE_DOWN_P;
			case UP: controls.NOTE_UP_P;
			case RIGHT: controls.NOTE_RIGHT_P;
		}
	}
}
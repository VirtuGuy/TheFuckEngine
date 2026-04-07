package funkin.play.song;

import funkin.play.character.Character;

/**
 * The base class for the engine's song events.
 */
class SongEvent
{
	public var id:String;

	var value:Dynamic;

	public function new(id:String)
	{
		this.id = id;
	}

	public function handle(value:Dynamic)
	{
		this.value = value;

		// Override type shit
	}

	function getInt(id:String):Int
		return Std.int(getValue(id));

	function getFloat(id:String):Float
		return getValue(id);

	function getBool(id:String):Bool
		return getValue(id);

	function getString(id:String):String
		return Std.string(getValue(id));

	function getCharacter(id:String):Character
	{
		return switch (getInt(id))
		{
			case 0:
				PlayState.instance.stage.opponent;
			case 1:
				PlayState.instance.stage.player;
			case 2:
				PlayState.instance.stage.gf;
			default:
				null;
		}
	}

	function getValue(id:String):Dynamic
		return Reflect.field(value, id);

	inline function hasValue(id:String):Bool
		return Reflect.hasField(value, id);

	public function toString():String
		return id;
}

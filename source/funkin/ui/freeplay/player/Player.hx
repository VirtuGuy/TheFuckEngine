package funkin.ui.freeplay.player;

import funkin.data.freeplay.player.PlayerData;
import funkin.data.freeplay.player.PlayerRegistry;

/**
 * A class containing the metadata of a playable character.
 */
class Player
{
	public var id:String;
	public var meta:PlayerData;

	public var name(get, never):String;
	public var players(get, never):Array<String>;
	public var position(get, never):Int;

	public var showUnowned(get, never):Bool;

	public function new(id:String)
	{
		this.id = id;
	}

	public function isOwner(id:String):Bool
	{
		if (showUnowned)
			return !PlayerRegistry.instance.isOwned(id);
		else
			return PlayerRegistry.instance.getOwner(id) == this.id;
	}

	@:noCompletion
	function get_name():String
	{
		var name:Null<String> = meta.name;
		if (name.isEmpty())
			name = Constants.DEFAULT_NAME;
		return name;
	}

	@:noCompletion
	function get_players():Array<String>
	{
		return meta.players ?? [];
	}

	@:noCompletion
	function get_position():Int
	{
		return meta.position;
	}

	@:noCompletion
	function get_showUnowned():Bool
	{
		return players.length == 0;
	}

	public function toString():String
	{
		return id;
	}
}

package funkin.data.freeplay.player;

import funkin.ui.freeplay.player.Player;
import funkin.util.FileUtil;
import haxe.ds.StringMap;
import json2object.JsonParser;

class PlayerRegistry extends BaseRegistry<Player>
{
	public static var instance:PlayerRegistry;

	static var parser(default, null) = new JsonParser<PlayerData>();

	/**
	 * A list of character ids that can be used keep track of what player owns what.
	 */
	static var owned(default, null) = new StringMap<String>();

	public function new()
	{
		super('players', 'ui/freeplay/players');
	}

	override public function load()
	{
		super.load();

		owned.clear();

		//
		// VANILLA
		//

		for (id in FileUtil.listFolders(path))
		{
			final metaPath:String = Paths.json('$path/$id/meta');

			// Skip the player if it doesn't exist
			if (!Paths.exists(metaPath))
				continue;

			var player:Player = new Player(id);

			player.meta = parser.fromJson(FileUtil.getText(metaPath));

			for (character in player.players)
				owned.set(character, id);

			register(id, player);
		}
	}

	public function getOwner(id:String):String
	{
		return owned.get(id);
	}

	public function isOwned(id:String):Bool
	{
		return owned.exists(id);
	}

	override public function listDefaults():Array<String>
	{
		return ['bf', 'pico'];
	}
}

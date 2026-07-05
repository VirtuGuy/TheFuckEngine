package funkin.ui.charselect;

import funkin.data.charselect.CharacterSelectData;
import funkin.graphics.FunkinSprite;
import json2object.JsonParser;

class Character extends FunkinSprite
{
	static var parser(default, null) = new JsonParser<CharacterSelectData>();

	public var meta:CharacterSelectData;

	public function load(id:String) {}
}

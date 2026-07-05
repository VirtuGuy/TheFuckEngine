package funkin.data.charselect;

import funkin.data.stage.StageData.PropAnimData;

/**
 * A structure object used for character select character data.
 */
typedef CharacterSelectData =
{
	var name:String;
	var width:Int;
	var height:Int;
	@:default(1)
	var scale:Float;
	@:default([])
	var animations:Array<PropAnimData>;
}

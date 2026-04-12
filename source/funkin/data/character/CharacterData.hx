package funkin.data.character;

import funkin.data.stage.StageData.PropAnimData;

/**
 * A structure object used for... you guessed it... character data!
 */
typedef CharacterData =
{
	var name:String;
	@:optional
	var image:String;
	var frameWidth:Int;
	var frameHeight:Int;
	var icon:CharacterIconData;
	var globalOffset:Array<Float>;
	var cameraOffset:Array<Float>;
	@:default(1)
	var scale:Float;
	var flipX:Bool;
	var flipY:Bool;
	@:default(2)
	var bopEvery:Int;
	@:default(8)
	var singDuration:Float;
	@:default([])
	var animations:Array<PropAnimData>;
}

/**
 * A structure object used for the health icon data of characters.
 */
typedef CharacterIconData =
{
	var image:String;
	@:default(1)
	var scale:Float;
	var flipX:Bool;
	var flipY:Bool;
	@:default(1)
	var bopEvery:Int;
	@:optional
	var bopAngle:Float;
}

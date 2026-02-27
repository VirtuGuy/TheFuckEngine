package funkin.data.stage;

/**
 * A structure object used for stage data.
 */
typedef StageData = {
    var name:String;
    @:optional
    var zoom:Float;
    var opponent:StageCharacterData;
    var player:StageCharacterData;
    var gf:StageCharacterData;
    @:default([])
    var props:Array<StagePropData>;
}

/**
 * A structure object used for stage character data.
 */
typedef StageCharacterData = {
    @:optional
    var position:Array<Float>;
    @:optional
    var scroll:Array<Float>;
    @:optional
    var zIndex:Int;
}

/**
 * A structure object used for stage prop data.
 */
typedef StagePropData = {
    var id:String;
    @:optional
    var position:Array<Float>;
    @:optional
    var scroll:Array<Float>;
    @:default(1)
    var scale:Float;
    var flipX:Bool;
    var flipY:Bool;
    var zIndex:Int;
}
package funkin.data.song;

/**
 * A structure object used for song metadata.
 */
typedef SongMetadata = {
    @:optional
    var name:String;
    @:default(100)
    var bpm:Float;
    @:default([])
    var difficulties:Array<String>;
    @:optional
    var artist:String;
    var stage:String;
    var opponent:String;
    var player:String;
    var gf:String;
}

/**
 * A structure object used for song chart data.
 */
typedef SongChartData = {
    var speed:Map<String, Float>;
    var notes:Map<String, Array<SongNoteData>>;
}

/**
 * A structure object used for song note data.
 */
typedef SongNoteData = {
    var t:Float;
    var d:Int;
    var l:Float;
}
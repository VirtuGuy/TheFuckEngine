package funkin.data.song;

import funkin.data.event.EventData;

/**
 * A structure object used for song metadata.
 */
typedef SongMetadata = {
    @:optional
    var name:String;
    @:default(100)
    var bpm:Float;
    @:optional
    var artist:String;
    @:default([])
    var difficulties:Array<String>;
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
    @:default([])
    var events:Array<EventData>;
}

/**
 * A structure object used for song note data.
 */
typedef SongNoteData = {
    var t:Float;
    var d:Int;
    var l:Float;
}
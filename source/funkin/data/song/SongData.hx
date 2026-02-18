package funkin.data.song;

/**
 * A structure object used for song metadata.
 */
typedef SongMetadata = {
    @:default('Untitled')
    var name:String;
    @:default(100)
    var bpm:Float;
    var opponent:String;
    var player:String;
}

/**
 * A structure object used for song chart data.
 */
typedef SongChartData = {
    @:default(1)
    var speed:Float;
    @:default([])
    var notes:Array<SongNoteData>;
}

/**
 * A structure object used for song note data.
 */
typedef SongNoteData = {
    var t:Float;
    var d:Int;
    var l:Float;
}
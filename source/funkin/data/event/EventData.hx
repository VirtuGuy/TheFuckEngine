package funkin.data.event;

/**
 * A structure object used for song events.
 */
typedef EventData = {
    var t:Float;
    var e:String;
    @:jcustomparse(funkin.data.DataParse.dynamicParse)
    @:jcustomwrite(funkin.data.DataParse.dynamicWrite)
    @:default(new Map<String, Dynamic>())
    var v:Dynamic;
}
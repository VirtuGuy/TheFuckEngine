package funkin.data;

import hxjsonast.Json;
import hxjsonast.Tools;

/**
 * A class for handling how data is parsed or written.
 */
class DataParse
{
    public static function dynamicParse(json:Json, name:String):Dynamic
        return Tools.getValue(json);

    public static function dynamicWrite(value:Dynamic):String
        return haxe.Json.stringify(value, '\t');
}
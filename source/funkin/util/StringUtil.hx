package funkin.util;

/**
 * A utility class for handling strings.
 */
class StringUtil
{
    public static inline function leadingZeros(s:Dynamic, zeros:Int):String
        return Std.string(s).lpad('0', zeros);
}
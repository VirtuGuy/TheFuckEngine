package funkin.util;

/**
 * A class used as a store for constant variables that are used globally.
 */
class Constants
{
    public static final IMAGE_EXT:String = 'png';
    public static final SOUND_EXT:String = #if web 'mp3' #else 'ogg' #end;
    public static final JSON_EXT:String = 'json';

    public static final MS_PER_SEC:Int = 1000;
    public static final SECS_PER_MIN:Int = 60;
    public static final PIXELS_PER_MS:Float = 0.45;

    public static final STEPS_PER_BEAT:Int = 4;
    public static final STEPS_PER_SECTION:Int = 16;
    
    public static final NOTE_COUNT:Int = 4;
    public static final ZOOM:Float = 1.35;

    public static final HIT_WINDOW_MS:Float = 160;
}
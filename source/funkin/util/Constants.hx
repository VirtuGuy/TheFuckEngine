package funkin.util;

import flixel.util.FlxColor;

/**
 * A class used as a store for constant variables that are used globally.
 */
class Constants
{
    public static final IMAGE_EXT:String = 'png';
    public static final SOUND_EXT:String = 'ogg';
    public static final JSON_EXT:String = 'json';

    public static final MS_PER_SEC:Int = 1000;
    public static final SECS_PER_MIN:Int = 60;
    public static final PIXELS_PER_MS:Float = 0.45;
    public static final STEPS_PER_BEAT:Int = 4;
    public static final STEPS_PER_SECTION:Int = 16;
    
    public static final NOTE_COUNT:Int = 4;
    public static final ZOOM:Float = 1.35;

    /**
     * This is so that the engine's levels have higher priority over custom levels.
     */
    public static final DEFAULT_LEVELS:Array<String> = [
        'tutorial',
        'week1'
    ];

    public static final DEFAULT_NAME:String = 'Untitled';
    public static final DEFAULT_ARTIST:String = 'Unknown';
    public static final DEFAULT_SPEED:Float = 1;
    public static final DEFAULT_CAMERA_ZOOM:Float = 1;

    public static final RESYNC_THRESHOLD:Float = 30;

    public static final HIT_WINDOW_MS:Float = 160;
    public static final SICK_WINDOW_MS:Float = 45;
    public static final GOOD_WINDOW_MS:Float = 90;
    public static final BAD_WINDOW_MS:Float = 135;

    public static final HOLD_SCORE_PER_SEC:Int = 200;
    public static final SICK_SCORE:Int = 500;
    public static final GOOD_SCORE:Int = 300;
    public static final BAD_SCORE:Int = 100;
    public static final SHIT_SCORE:Int = 50;
    public static final MISS_SCORE:Int = -100;
    public static final GHOST_MISS_SCORE:Int = -50;

    public static final STARTING_HEALTH:Float = 0.5;
    public static final HEALTH_FILL_COLOR:FlxColor = 0xFF00FF00;
    public static final HEALTH_EMPTY_COLOR:FlxColor = 0xFFFF0000;
    public static final HOLD_HEALTH_PER_SEC:Float = 0.04;
    public static final NOTE_HEALTH:Float = 0.035;
    public static final MISS_HEALTH:Float = -0.03;
    public static final GHOST_MISS_HEALTH:Float = -0.025;
}
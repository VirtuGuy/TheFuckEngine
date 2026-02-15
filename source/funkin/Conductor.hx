package funkin;

import flixel.util.FlxSignal;

/**
 * The conductor class for the game. This is what handles steps and beats and all that crap.
 */
class Conductor
{
    public static var instance:Conductor;

    public var time:Float;
    public var bpm(default, set):Float;

    public var step:Int;
    public var beat:Int;
    public var section:Int;

    public var crotchet(get, never):Float;
    public var quaver(get, never):Float;

    public var stepHit(default, null) = new FlxTypedSignal<Int->Void>();
    public var beatHit(default, null) = new FlxTypedSignal<Int->Void>();
    public var sectionHit(default, null) = new FlxTypedSignal<Int->Void>();
    
    var changeSteps:Int = 0;
    var changeTimestamp:Float = 0;

    public function new() {}

    public function update()
    {
        final lastStep:Int = step;
        final lastBeat:Int = beat;
        final lastSection:Int = section;

        // Calculates the current step
        step = changeSteps + Math.floor((time - changeTimestamp) / quaver);
        beat = Math.floor(step / Constants.STEPS_PER_BEAT);
        section = Math.floor(step / Constants.STEPS_PER_SECTION);

        // Dispatches signals
        if (lastStep != step) stepHit.dispatch(step);
        if (lastBeat != beat) beatHit.dispatch(beat);
        if (lastSection != section) sectionHit.dispatch(section);
    }

    function set_bpm(bpm:Float):Float
    {
        if (this.bpm == bpm) return this.bpm;
        this.bpm = bpm;

        changeSteps = step;
        changeTimestamp = time;

        return this.bpm;
    }

    inline function get_crotchet():Float
        return Constants.SECS_PER_MIN / bpm * Constants.MS_PER_SEC;

    inline function get_quaver():Float
        return crotchet / Constants.STEPS_PER_BEAT;
}
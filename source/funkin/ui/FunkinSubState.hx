package funkin.ui;

import flixel.FlxSubState;
import funkin.input.Controls;

/**
 * A class used as the base for all the game's sub states.
 */
class FunkinSubState extends FlxSubState
{
    var conductor(get, never):Conductor;
    var controls(get, never):Controls;

    public function new()
    {
        super();

        // Adds conductor callbacks
        conductor.stepHit.add(stepHit);
        conductor.beatHit.add(beatHit);
        conductor.sectionHit.add(sectionHit);
    }

    override public function destroy()
    {
        super.destroy();

        // Removes conductor callbacks
        conductor.stepHit.remove(stepHit);
        conductor.beatHit.remove(beatHit);
        conductor.sectionHit.remove(sectionHit);
    }

    function stepHit(step:Int) {}
    function beatHit(beat:Int) {}
    function sectionHit(section:Int) {}

    inline function get_conductor():Conductor
        return Conductor.instance;

    inline function get_controls():Controls
        return Controls.instance;
}
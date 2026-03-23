package funkin.ui;

import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * A class for handling the engine's mover objects.
 * A mover is an object that smoothly transitions in or out.
 */
class ExitMovers
{
    final DURATION:Float = 0.75;

    public var onIntroDone:Void->Void;
    public var onOutroDone:Void->Void;

    var movers(default, null) = new Map<FlxObject, ExitMoverData>();
    var endTimer:FlxTimer;

    public function new() {}

    public function add(object:FlxObject, ?x:Float, ?y:Float)
        movers.set(object, { x: x, y: y });

    public function intro()
    {
        for (object => data in movers)
            move(object, data);

        endTimer?.cancel();
        endTimer = FlxTimer.wait(DURATION, () -> onIntroDone());
    }

    public function outro()
    {
        for (object => data in movers)
            move(object, data, true);
        
        endTimer?.cancel();
        endTimer = FlxTimer.wait(DURATION, () -> onOutroDone());
    }

    function move(object:FlxObject, data:ExitMoverData, reversed:Bool = false)
    {
        // Can't move a null object
        if (object == null || data == null) return;

        var x:Float = data.x ?? object.x;
        var y:Float = data.y ?? object.y;

        FlxTween.cancelTweensOf(object);
        FlxTween.tween(object, { x: x, y: y }, DURATION, {
            ease: FlxEase.quintOut,
            type: (!reversed ? BACKWARD : null)
        });

        // Force the tween manager to update
        // This is to put an end to flickering
        FlxTween.globalManager.update(0);
    }
}

/**
 * A structure object used for the `ExitMovers` class.
 */
typedef ExitMoverData = {
    @:optional
    var x:Float;
    @:optional
    var y:Float;
}
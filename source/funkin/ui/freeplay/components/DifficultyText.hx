package funkin.ui.freeplay.components;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinText;
import funkin.input.Controls;

/**
 * Text that displays the current difficulty in the freeplay menu.
 */
class DifficultyText extends FunkinText
{
    public var selected:Int;
    public var difficulties:Array<String>;
    public var difficulty(get, never):String;

    public var busy:Bool = false;

    public var onSelected(default, null) = new FlxTypedSignal<Int->Void>();

    var selectTimer:FlxTimer;

    public function new(selected:Int = 0, difficulties:Array<String>)
    {
        super();

        this.selected = selected;
        this.difficulties = difficulties;

        // Not doing this will cause problems lol
        autoBounds = false;
        active = true;

        size = 48;

        select();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (busy) return;

        var left:Bool = Controls.instance.UI_LEFT_P;
        var right:Bool = Controls.instance.UI_RIGHT_P;

        if (left || right)
            select(left ? -1 : 1);
    }

    function select(change:Int = 0)
    {
        final lastSelected:Int = selected;

        selected += change;

        if (selected < 0)
            selected = difficulties.length - 1;
        else if (selected >= difficulties.length)
            selected = 0;

        text = difficulty;
        
        updateHitbox();

        offset.y = 0;

        if (lastSelected != selected && change != 0)
        {
            FunkinSound.playOnce('ui/sounds/scroll');

            offset.y = 5;

            selectTimer?.cancel();
            selectTimer = FlxTimer.wait(0.05, () -> offset.y = 0);

            onSelected.dispatch(selected);
        }
    }

    inline function get_difficulty():String
        return difficulties[selected];
}
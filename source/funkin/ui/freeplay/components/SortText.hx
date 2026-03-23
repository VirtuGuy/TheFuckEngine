package funkin.ui.freeplay.components;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinText;
import funkin.input.Controls;

/**
 * Text that displays how freeplay songs are currently being sorted.
 */
class SortText extends FunkinText
{
    final MAX_SORTS:Int = 2;

    public var selected:Int;
    public var busy:Bool = false;

    public var onSelected(default, null) = new FlxTypedSignal<Int->Void>();

    var selectTimer:FlxTimer;

    public function new(selected:Int = 0)
    {
        super();
        
        this.selected = selected;

        // Not doing this will cause problems lol
        active = true;
        autoBounds = false;

        offset.y = 0;

        select();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (busy) return;

        var left:Bool = Controls.instance.SORT_LEFT;
        var right:Bool = Controls.instance.SORT_RIGHT;

        if (left || right)
            select(left ? -1 : 1);
    }

    function select(change:Int = 0)
    {
        final lastSelected:Int = selected;

        selected += change;

        if (selected < 0)
            selected = MAX_SORTS - 1;
        else if (selected >= MAX_SORTS)
            selected = 0;

        switch (selected)
        {
            case 1:
                text = 'favorites';
            default:
                text = 'all';
        }

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
}
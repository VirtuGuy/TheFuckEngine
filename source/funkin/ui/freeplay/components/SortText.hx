package funkin.ui.freeplay.components;

import funkin.input.Controls;

/**
 * Text that displays how freeplay songs are currently being sorted.
 */
class SortText extends SelectorText
{
    final MAX_SORTS:Int = 2;

    public function new(selected:Int = 0)
    {
        super(selected, 'ui/freeplay/sort-arrow');
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var left:Bool = Controls.instance.SORT_LEFT;
        var right:Bool = Controls.instance.SORT_RIGHT;

        if (left || right)
            select(left ? -1 : 1);
    }

    override function updateSelected()
    {
        if (selected < 0)
            selected = MAX_SORTS - 1;
        else if (selected >= MAX_SORTS)
            selected = 0;
    }

    override function updateText()
    {
        switch (selected)
        {
            case 1:
                text.text = 'favorites';
            default:
                text.text = 'all';
        }

        super.updateText();
    }
}
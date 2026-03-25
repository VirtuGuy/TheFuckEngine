package funkin.ui.freeplay.components;

import funkin.input.Controls;

/**
 * Text that displays the current difficulty in the freeplay menu.
 */
class DifficultyText extends SelectorText
{
    public var difficulties:Array<String>;
    public var difficulty(get, never):String;

    public function new(selected:Int = 0, difficulties:Array<String>)
    {
        // This HAS to be set before
        // Setting this after the super will CRASH
        this.difficulties = difficulties;

        super(selected, 'ui/freeplay/arrow');

        text.size = 48;

        updateText();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var left:Bool = Controls.instance.UI_LEFT_P;
        var right:Bool = Controls.instance.UI_RIGHT_P;

        if (left || right)
            select(left ? -1 : 1);
    }

    override function updateSelected()
    {
        if (selected < 0)
            selected = difficulties.length - 1;
        else if (selected >= difficulties.length)
            selected = 0;
    }

    override function updateText()
    {
        text.text = difficulty;

        super.updateText();
    }

    inline function get_difficulty():String
        return difficulties[selected];
}
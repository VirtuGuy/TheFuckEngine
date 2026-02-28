package funkin.ui;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinText;
import funkin.input.Controls;
import funkin.util.MathUtil;

/**
 * A list of `FunkinText` objects that the player can scroll through.
 */
class MenuList extends FlxTypedGroup<FunkinText>
{
    public var items(default, set):Array<String>;
    public var selected:Int = 0;

    public var itemSelected(default, null) = new FlxTypedSignal<String->Void>();

    var controls(get, never):Controls;
    var justAccepted:Bool = false;

    public function new(items:Array<String>)
    {
        super();

        this.items = items;

        // This exists because input is stupid
        justAccepted = controls.ACCEPT;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.UI_UP_P || controls.UI_DOWN_P)
            changeItem(controls.UI_UP_P ? -1 : 1);

        if (controls.ACCEPT)
        {
            if (justAccepted)
                justAccepted = false;
            else
                selectItem();
        }

        // Updates the items to be in the correct position
        forEachAlive(item -> {
            item.alpha = item.ID == selected ? 1 : 0.6;
            item.x = MathUtil.lerp(item.x, getItemX(item), 0.15);
            item.y = MathUtil.lerp(item.y, getItemY(item), 0.15);
        });
    }

    public function changeItem(change:Int)
    {
        FunkinSound.playOnce('ui/sounds/scroll');

        selected += change;

        if (selected < 0) selected = items.length - 1;
        if (selected >= items.length) selected = 0;
    }

    public function selectItem()
    {
        // Safety check to ensure that the selected item exists
        if (items[selected] == null) return;

        itemSelected.dispatch(items[selected]);
    }

    public function refreshItems()
    {
        selected = 0;

        killMembers();

        for (i => item in items)
        {
            var text:FunkinText = recycle(FunkinText);
            text.text = item;
            text.size = 56;
            text.ID = i;
            text.setPosition(getItemX(text) - 500, getItemY(text));
        }
    }

    function getItemX(item:FunkinText):Float
    {
        return 80 + (item.ID - selected) * 20;
    }

    function getItemY(item:FunkinText):Float
    {
        return FlxG.height / 2 + (item.ID - selected - 0.5) * (item.height + 50);
    }

    function set_items(items:Array<String>):Array<String>
    {
        if (this.items == items) return items;
        this.items = items;

        refreshItems();

        return items;
    }

    inline function get_controls():Controls
        return Controls.instance;
}
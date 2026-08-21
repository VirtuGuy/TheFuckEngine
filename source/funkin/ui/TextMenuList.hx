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
class TextMenuList extends FlxTypedGroup<FunkinText>
{
	public var selected:Int = 0;

	public var busy:Bool = false;

	public var onChange(default, null) = new FlxTypedSignal<Int->Void>();
	public var onSelect(default, null) = new FlxTypedSignal<Int->Void>();

	var callbacks(default, null) = new Map<Int, () -> Void>();

	/**
	 * What a stupid fucking variable.
	 */
	var allowInput:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowInput)
		{
			final up:Bool = Controls.instance.UI_UP_P;
			final down:Bool = Controls.instance.UI_DOWN_P;
			final accept:Bool = Controls.instance.ACCEPT_P;

			if (up || down)
				change(up ? -1 : 1);
			if (accept)
				select();
		}

		forEachAlive(item ->
		{
			item.alpha = item.ID == selected ? 1 : 0.6;

			item.x = MathUtil.lerp(item.x, getTargetX(item.ID), 0.2);
			item.y = MathUtil.lerp(item.y, getTargetY(item.ID), 0.2);
		});

		allowInput = true;
	}

	public function addItem(text:String, callback:() -> Void)
	{
		var item:FunkinText = recycle(FunkinText);

		item.ID = countLiving() - 1;

		item.text = text;
		item.size = 56;

		item.x = getTargetX(item.ID) - 500;
		item.y = getTargetY(item.ID);

		callbacks.set(item.ID, callback);
	}

	public function removeItem(index:Int)
	{
		members[index]?.kill();
		callbacks.remove(index);

		if (selected >= countLiving())
			selected = countLiving() - 1;
	}

	public function clearItems()
	{
		killMembers();

		callbacks.clear();
		selected = 0;
	}

	function change(change:Int)
	{
		if (busy)
			return;

		final lastSelected:Int = selected;

		selected += change;

		if (selected >= countLiving())
			selected = 0;
		else if (selected < 0)
			selected = countLiving() - 1;

		if (selected != lastSelected)
		{
			onChange.dispatch(selected);

			FunkinSound.playOnce('general/sounds/scroll');
		}
	}

	function select()
	{
		final item:FunkinText = members[selected];

		if (item == null || busy)
			return;

		onSelect.dispatch(selected);

		if (callbacks.get(item.ID) != null)
			callbacks.get(item.ID)();
	}

	function getTargetX(index:Int):Float
	{
		return 80 + (index - selected) * 20;
	}

	function getTargetY(index:Int):Float
	{
		return FlxG.height / 2 + (index - selected - 0.5) * 100;
	}
}

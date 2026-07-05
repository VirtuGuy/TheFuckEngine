package funkin.ui.charselect;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.input.Controls;

/**
 * A group of icons used for selecting players in the character select menu.
 */
class IconGroup extends FlxSpriteGroup
{
	static final SPACING:Float = 120;
	static final COLUMNS:Int = 3;

	public var selected:Int;
	public var busy:Bool = false;

	public var icon(get, never):FunkinSprite;

	public var onChanged(default, null) = new FlxTypedSignal<Int->Void>();

	public function new(selected:Int)
	{
		super();

		this.selected = selected;

		for (i in 0...9)
		{
			var lock:LockSprite = new LockSprite();
			lock.ID = i;
			lock.x = (i % COLUMNS) * SPACING;
			lock.y = Math.floor(i / COLUMNS) * SPACING;
			add(lock);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (busy)
			return;

		final left:Bool = Controls.instance.UI_LEFT_P;
		final right:Bool = Controls.instance.UI_RIGHT_P;
		final up:Bool = Controls.instance.UI_UP_P;
		final down:Bool = Controls.instance.UI_DOWN_P;

		if (left || right)
			scroll(left ? -1 : 1);
		else if (up || down)
			scroll(up ? -COLUMNS : COLUMNS);
	}

	public function scroll(change:Int)
	{
		selected += change;

		if (selected < 0)
			selected = length - 1;
		else if (selected >= length)
			selected = 0;

		onChanged.dispatch(selected);

		FunkinSound.playOnce('menu/charselect/sounds/scroll');
	}

	@:noCompletion
	inline function get_icon():FunkinSprite
	{
		return cast members[selected];
	}
}

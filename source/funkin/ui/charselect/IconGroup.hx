package funkin.ui.charselect;

import flixel.group.FlxSpriteGroup;
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
	static final ROWS:Int = 3;

	public var cursorX:Int;
	public var cursorY:Int;

	public var busy:Bool = false;

	public var icon(get, never):FunkinSprite;

	public function new(selected:Int)
	{
		super();

		cursorX = selected % COLUMNS;
		cursorY = Math.floor(selected / COLUMNS);

		// Loads the icons
		final count:Int = COLUMNS * ROWS;

		for (i in 0...count)
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
			scroll(left ? -1 : 1, 0);
		else if (up || down)
			scroll(0, up ? -1 : 1);
	}

	public function scroll(x:Int, y:Int)
	{
		// Horizontal
		cursorX += x;

		if (cursorX < 0)
			cursorX = COLUMNS - 1;
		else if (cursorX >= COLUMNS)
			cursorX = 0;

		// Vertical
		cursorY += y;

		if (cursorY < 0)
			cursorY = ROWS - 1;
		else if (cursorY >= ROWS)
			cursorY = 0;

		FunkinSound.playOnce('menu/charselect/sounds/scroll');
	}

	@:noCompletion
	inline function get_icon():FunkinSprite
	{
		return cast members[cursorX + cursorY * COLUMNS];
	}
}

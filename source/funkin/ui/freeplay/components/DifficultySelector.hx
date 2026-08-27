package funkin.ui.freeplay.components;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.input.Controls;
import funkin.util.MathUtil;

/**
 * A selector for choosing which difficulty to play in the freeplay menu.
 */
class DifficultySelector extends FlxSpriteGroup
{
	public var difficulties(default, set):Array<String>;
	public var selected:Int;

	public var busy:Bool = false;
	public var difficulty(get, never):String;

	public var text:FunkinText;
	public var arrowLeft:FunkinSprite;
	public var arrowRight:FunkinSprite;

	public var onChanged(default, null) = new FlxTypedSignal<Int->Void>();

	var off:Float = 0;

	public function new(selected:Int = 0, difficulties:Array<String>)
	{
		super();

		this.difficulties = difficulties;
		this.selected = selected;

		text = new FunkinText();
		text.size = 48;
		add(text);

		arrowLeft = FunkinSprite.create(0, 0, 'ui/freeplay/selector/difficulty');
		arrowLeft.y = y + (text.height - arrowLeft.height) / 2;
		add(arrowLeft);

		arrowRight = arrowLeft.clone();
		arrowRight.y = arrowLeft.y;
		arrowRight.flipX = true;
		add(arrowRight);

		updateText();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updateText();

		if (busy)
			return;

		final left:Bool = Controls.instance.UI_LEFT_P;
		final right:Bool = Controls.instance.UI_RIGHT_P;

		if (left || right)
			change(left ? -1 : 1);
	}

	function updateText()
	{
		visible = difficulties.length > 0;

		off = MathUtil.lerp(off, 0, 0.5);

		// TODO: Find a way to softcode this
		text.text = switch (difficulty)
		{
			case 'nightmare':
				'night';
			default:
				difficulty;
		}

		final x:Float = x - text.width / 2;

		text.x = x - off;

		arrowLeft.x = x - arrowLeft.width - 10;
		arrowRight.x = x + text.width + 10;
	}

	function change(change:Int)
	{
		final lastSelected:Int = selected;

		selected += change;

		if (selected >= difficulties.length)
			selected = 0;
		else if (selected < 0)
			selected = difficulties.length - 1;

		if (selected != lastSelected)
		{
			onChanged.dispatch(selected);
			off = 50 * change;
			FunkinSound.playOnce('general/sounds/scroll');
		}
	}

	@:noCompletion
	inline function set_difficulties(value:Array<String>):Array<String>
	{
		if (selected >= value.length)
			selected = value.length - 1;
		return difficulties = value;
	}

	@:noCompletion
	inline function get_difficulty():String
	{
		return difficulties[selected];
	}
}

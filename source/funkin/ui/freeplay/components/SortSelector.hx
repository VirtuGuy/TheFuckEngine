package funkin.ui.freeplay.components;

import funkin.data.story.LevelRegistry;
import funkin.input.Controls;
import funkin.ui.freeplay.components.SelectorText;
import funkin.ui.story.Level;

/**
 * A selector for sorting songs in the freeplay menu.
 * 
 * TODO: Recode this
 */
class SortSelector extends SelectorText
{
	public var count(get, never):Int;
	public var level(get, never):Level;

	public function new(selected:Int = 0)
	{
		super(selected, 'ui/freeplay/selector/sort');
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		final left:Bool = Controls.instance.SORT_LEFT;
		final right:Bool = Controls.instance.SORT_RIGHT;

		if (left || right)
			change(left ? -1 : 1);
	}

	override function updateSelected()
	{
		if (selected < 0)
			selected = count - 1;
		else if (selected >= count)
			selected = 0;
	}

	override function updateText()
	{
		var sortText:String = 'all';

		if (selected == count - 1)
			sortText = 'favorites';
		else if (selected > 0)
			sortText = level.title;

		text.text = sortText;

		super.updateText();
	}

	@:noCompletion
	inline function get_count():Int
	{
		return 2 + LevelRegistry.instance.list().length;
	}

	@:noCompletion
	inline function get_level():Level
	{
		// Gets the level id
		// Holy moly :O
		final id:String = LevelRegistry.instance.listSorted()[selected - 1];

		return LevelRegistry.instance.fetch(id);
	}
}

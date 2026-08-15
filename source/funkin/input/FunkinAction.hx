package funkin.input;

import lime.app.Application;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;

/**
 * The engine's control action class.
 */
class FunkinAction
{
	public final id:Control;

	public var pressed(default, null):Bool;
	public var justPressed(default, null):Bool;

	var wasPressed:Bool;

	var keys:Array<KeyCode> = [];
	var buttons:Array<GamepadButton> = [];

	public function new(id:Control, keys:Array<KeyCode>, buttons:Array<GamepadButton>)
	{
		this.id = id;

		this.keys = keys;
		this.buttons = buttons;

		Application.current.onUpdate.add(update);
	}

	public function press()
	{
		if (pressed)
			return;
		pressed = true;
	}

	public function release()
	{
		pressed = false;
		wasPressed = false;
	}

	public function hasKey(key:KeyCode):Bool
	{
		return keys.contains(key);
	}

	public function hasButton(button:GamepadButton):Bool
	{
		return buttons.contains(button);
	}

	function update(_)
	{
		if (wasPressed)
			justPressed = false;
		else if (pressed)
		{
			justPressed = true;
			wasPressed = true;
		}
	}
}

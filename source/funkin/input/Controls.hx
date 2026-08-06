package funkin.input;

import flixel.util.FlxSignal.FlxTypedSignal;
import funkin.play.note.NoteDirection;
import lime.app.Application;
import lime.ui.Gamepad;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

/**
 * The engine's controls class where input is handled.
 */
class Controls
{
	public static var instance:Controls;

	var actions:Map<Control, FunkinAction> = [
		Control.NOTE_LEFT => new FunkinAction([A, LEFT], [DPAD_LEFT, X]),
		Control.NOTE_DOWN => new FunkinAction([S, DOWN], [DPAD_DOWN, A]),
		Control.NOTE_UP => new FunkinAction([W, UP], [DPAD_UP, Y]),
		Control.NOTE_RIGHT => new FunkinAction([D, RIGHT], [DPAD_RIGHT, B]),
		Control.UI_LEFT => new FunkinAction([A, LEFT], [DPAD_LEFT]),
		Control.UI_DOWN => new FunkinAction([S, DOWN], [DPAD_DOWN]),
		Control.UI_UP => new FunkinAction([W, UP], [DPAD_UP]),
		Control.UI_RIGHT => new FunkinAction([D, RIGHT], [DPAD_RIGHT]),
		Control.ACCEPT => new FunkinAction([Z, SPACE, RETURN], [START, A]),
		Control.BACK => new FunkinAction([X, ESCAPE, BACKSPACE], [B]),
		Control.PAUSE => new FunkinAction([P, RETURN, ESCAPE], [START]),
		Control.RESET => new FunkinAction([R], []),
		Control.FAVORITE => new FunkinAction([F], [Y]),
		Control.SORT_LEFT => new FunkinAction([Q], [LEFT_SHOULDER]),
		Control.SORT_RIGHT => new FunkinAction([E], [RIGHT_SHOULDER]),
		Control.CHAR_SELECT => new FunkinAction([TAB], [X])
	];

	public var directionDown(default, null) = new FlxTypedSignal<NoteDirection->Void>();
	public var directionUp(default, null) = new FlxTypedSignal<NoteDirection->Void>();

	public var NOTE_LEFT(get, never):Bool;
	public var NOTE_DOWN(get, never):Bool;
	public var NOTE_UP(get, never):Bool;
	public var NOTE_RIGHT(get, never):Bool;
	public var NOTE_LEFT_P(get, never):Bool;
	public var NOTE_DOWN_P(get, never):Bool;
	public var NOTE_UP_P(get, never):Bool;
	public var NOTE_RIGHT_P(get, never):Bool;
	public var UI_LEFT(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_UP(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;
	public var UI_LEFT_P(get, never):Bool;
	public var UI_DOWN_P(get, never):Bool;
	public var UI_UP_P(get, never):Bool;
	public var UI_RIGHT_P(get, never):Bool;
	public var ACCEPT(get, never):Bool;
	public var ACCEPT_P(get, never):Bool;
	public var BACK(get, never):Bool;
	public var PAUSE(get, never):Bool;
	public var RESET(get, never):Bool;
	public var FAVORITE(get, never):Bool;
	public var SORT_LEFT(get, never):Bool;
	public var SORT_RIGHT(get, never):Bool;
	public var CHAR_SELECT(get, never):Bool;

	@:noCompletion
	inline function get_NOTE_LEFT():Bool
	{
		return getAction(Control.NOTE_LEFT).pressed;
	}

	@:noCompletion
	inline function get_NOTE_DOWN():Bool
	{
		return getAction(Control.NOTE_DOWN).pressed;
	}

	@:noCompletion
	inline function get_NOTE_UP():Bool
	{
		return getAction(Control.NOTE_UP).pressed;
	}

	@:noCompletion
	inline function get_NOTE_RIGHT():Bool
	{
		return getAction(Control.NOTE_RIGHT).pressed;
	}

	@:noCompletion
	inline function get_NOTE_LEFT_P():Bool
	{
		return getAction(Control.NOTE_LEFT).justPressed;
	}

	@:noCompletion
	inline function get_NOTE_DOWN_P():Bool
	{
		return getAction(Control.NOTE_DOWN).justPressed;
	}

	@:noCompletion
	inline function get_NOTE_UP_P():Bool
	{
		return getAction(Control.NOTE_UP).justPressed;
	}

	@:noCompletion
	inline function get_NOTE_RIGHT_P():Bool
	{
		return getAction(Control.NOTE_RIGHT).justPressed;
	}

	@:noCompletion
	inline function get_UI_LEFT():Bool
	{
		return getAction(Control.UI_LEFT).pressed;
	}

	@:noCompletion
	inline function get_UI_DOWN():Bool
	{
		return getAction(Control.UI_DOWN).pressed;
	}

	@:noCompletion
	inline function get_UI_UP():Bool
	{
		return getAction(Control.UI_UP).pressed;
	}

	@:noCompletion
	inline function get_UI_RIGHT():Bool
	{
		return getAction(Control.UI_RIGHT).pressed;
	}

	@:noCompletion
	inline function get_UI_LEFT_P():Bool
	{
		return getAction(Control.UI_LEFT).justPressed;
	}

	@:noCompletion
	inline function get_UI_DOWN_P():Bool
	{
		return getAction(Control.UI_DOWN).justPressed;
	}

	@:noCompletion
	inline function get_UI_UP_P():Bool
	{
		return getAction(Control.UI_UP).justPressed;
	}

	@:noCompletion
	inline function get_UI_RIGHT_P():Bool
	{
		return getAction(Control.UI_RIGHT).justPressed;
	}

	@:noCompletion
	inline function get_ACCEPT():Bool
	{
		return getAction(Control.ACCEPT).pressed;
	}

	@:noCompletion
	inline function get_ACCEPT_P():Bool
	{
		return getAction(Control.ACCEPT).justPressed;
	}

	@:noCompletion
	inline function get_BACK():Bool
	{
		return getAction(Control.BACK).justPressed;
	}

	@:noCompletion
	inline function get_PAUSE():Bool
	{
		return getAction(Control.PAUSE).justPressed;
	}

	@:noCompletion
	inline function get_RESET():Bool
	{
		return getAction(Control.RESET).justPressed;
	}

	@:noCompletion
	inline function get_FAVORITE():Bool
	{
		return getAction(Control.FAVORITE).justPressed;
	}

	@:noCompletion
	inline function get_SORT_LEFT():Bool
	{
		return getAction(Control.SORT_LEFT).justPressed;
	}

	@:noCompletion
	inline function get_SORT_RIGHT():Bool
	{
		return getAction(Control.SORT_RIGHT).justPressed;
	}

	@:noCompletion
	inline function get_CHAR_SELECT():Bool
	{
		return getAction(Control.CHAR_SELECT).justPressed;
	}

	var gamepadConnected:Bool = false;

	public function new()
	{
		Application.current.window.onKeyDown.add(keyDown);
		Application.current.window.onKeyUp.add(keyUp);

		// Connects any gamepad devices that are already connected
		// This is need so that controllers don't have to be plugged in AFTER the game starts
		// So basically, this makes the game less annoying
		gamepadConnect(Gamepad.devices[0]);

		Gamepad.onConnect.add(gamepadConnect);
	}

	function keyDown(keyCode:KeyCode, modifier:KeyModifier)
	{
		for (id => action in actions)
		{
			if (!action.hasKey(keyCode))
				continue;
			handleActionPress(id, action);
		}
	}

	function keyUp(keyCode:KeyCode, modifier:KeyModifier)
	{
		for (id => action in actions)
		{
			if (!action.hasKey(keyCode))
				continue;
			handleActionRelease(id, action);
		}
	}

	function gamepadConnect(gamepad:Gamepad)
	{
		if (gamepad == null || gamepadConnected)
			return;

		gamepadConnected = true;

		gamepad.onButtonDown.add(button ->
		{
			for (id => action in actions)
			{
				if (!action.hasButton(button))
					continue;
				handleActionPress(id, action);
			}
		});

		gamepad.onButtonUp.add(button ->
		{
			for (id => action in actions)
			{
				if (!action.hasButton(button))
					continue;
				handleActionRelease(id, action);
			}
		});

		gamepad.onDisconnect.add(() ->
		{
			trace('Disconnected gamepad device.');

			gamepadConnected = false;
		});

		trace('Connected gamepad device.');
	}

	function handleActionPress(id:Control, action:FunkinAction)
	{
		if (action.pressed)
			return;

		switch (id)
		{
			case NOTE_LEFT:
				directionDown.dispatch(LEFT);
			case NOTE_DOWN:
				directionDown.dispatch(DOWN);
			case NOTE_UP:
				directionDown.dispatch(UP);
			case NOTE_RIGHT:
				directionDown.dispatch(RIGHT);
			default:
				// Does literally nothing
		}

		action.press();
	}

	function handleActionRelease(id:Control, action:FunkinAction)
	{
		if (!action.pressed)
			return;

		switch (id)
		{
			case NOTE_LEFT:
				directionUp.dispatch(LEFT);
			case NOTE_DOWN:
				directionUp.dispatch(DOWN);
			case NOTE_UP:
				directionUp.dispatch(UP);
			case NOTE_RIGHT:
				directionUp.dispatch(RIGHT);
			default:
				// Does literally nothing
		}

		action.release();
	}

	inline function getAction(id:Control):FunkinAction
	{
		return actions.get(id);
	}
}

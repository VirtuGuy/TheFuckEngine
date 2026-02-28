package funkin.input;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionSet;
import flixel.input.keyboard.FlxKey;

/**
 * An enum abstract of the different `FunkinAction` ids.
 */
enum abstract Control(String) to String from String
{
    var NOTE_LEFT = 'note-left';
    var NOTE_DOWN = 'note-down';
    var NOTE_UP = 'note-up';
    var NOTE_RIGHT = 'note-right';
    var ACCEPT = 'accept';
    var PAUSE = 'pause';
}

/**
 * A class for handling input controls.
 */
class Controls extends FlxActionSet
{
    public static var instance:Controls;

    var note_left(default, null) = new FunkinAction(Control.NOTE_LEFT);
    var note_down(default, null) = new FunkinAction(Control.NOTE_DOWN);
    var note_up(default, null) = new FunkinAction(Control.NOTE_UP);
    var note_right(default, null) = new FunkinAction(Control.NOTE_RIGHT);
    var accept(default, null) = new FunkinAction(Control.ACCEPT);
    var pause(default, null) = new FunkinAction(Control.PAUSE);

    public var NOTE_LEFT(get, never):Bool;
    public var NOTE_DOWN(get, never):Bool;
    public var NOTE_UP(get, never):Bool;
    public var NOTE_RIGHT(get, never):Bool;
    public var NOTE_LEFT_P(get, never):Bool;
    public var NOTE_DOWN_P(get, never):Bool;
    public var NOTE_UP_P(get, never):Bool;
    public var NOTE_RIGHT_P(get, never):Bool;
    public var ACCEPT(get, never):Bool;
    public var PAUSE(get, never):Bool;

    inline function get_NOTE_LEFT():Bool
        return note_left.check();

    inline function get_NOTE_DOWN():Bool
        return note_down.check();

    inline function get_NOTE_UP():Bool
        return note_up.check();

    inline function get_NOTE_RIGHT():Bool
        return note_right.check();

    inline function get_NOTE_LEFT_P():Bool
        return note_left.checkPressed();

    inline function get_NOTE_DOWN_P():Bool
        return note_down.checkPressed();

    inline function get_NOTE_UP_P():Bool
        return note_up.checkPressed();

    inline function get_NOTE_RIGHT_P():Bool
        return note_right.checkPressed();

    inline function get_ACCEPT():Bool
        return accept.checkPressed();

    inline function get_PAUSE():Bool
        return pause.checkPressed();

    public function new()
    {
        super('controls');

        // Adds the actions
        add(note_left);
        add(note_down);
        add(note_up);
        add(note_right);
        add(accept);
        add(pause);

        // Sets the keys
        setKeys(Control.NOTE_LEFT, [A, LEFT]);
        setKeys(Control.NOTE_DOWN, [S, DOWN]);
        setKeys(Control.NOTE_UP, [W, UP]);
        setKeys(Control.NOTE_RIGHT, [D, RIGHT]);
        setKeys(Control.ACCEPT, [Z, ENTER]);
        setKeys(Control.PAUSE, [P, ENTER]);
    }

    public function setKeys(id:Control, keys:Array<FlxKey>)
    {
        func(id, action -> {
            // Clears any set keys
            action.removeDevice(KEYBOARD);

            // Adds the keys
            for (key in keys)
            {
                action.addKey(key, PRESSED);
                action.addKey(key, JUST_PRESSED);
            }
        });
    }

    function func(id:Control, func:FunkinAction->Void)
    {
        switch (id)
        {
            case NOTE_LEFT: func(note_left);
            case NOTE_DOWN: func(note_down);
            case NOTE_UP: func(note_up);
            case NOTE_RIGHT: func(note_right);
            case ACCEPT: func(accept);
            case PAUSE: func(pause);
        }
    }
}

/**
 * An extension of `FlxActionDigital` used for `Controls`.
 */
class FunkinAction extends FlxActionDigital
{
    public function new(id:Control)
    {
        super(id);
    }

    public override function check():Bool
        return checkFiltered(PRESSED);

    public function checkPressed():Bool
        return checkFiltered(JUST_PRESSED);

    public function removeDevice(device:FlxInputDevice)
    {
        for (input in inputs)
        {
            if (input.device != device) continue;
            input.destroy();
        }
    }

    function checkFiltered(trigger:FlxInputState):Bool
    {
        // Borrowed from FlxActionDigital hehehe
        _x = null;
		_y = null;
		
		_timestamp = FlxG.game.ticks;
		triggered = false;
		
		var i = inputs != null ? inputs.length : 0;
		while (i-- > 0) // Iterate backwards, since we may remove items
		{
			final input = inputs[i];
			
			if (input.destroyed)
			{
				inputs.remove(input);
				continue;
			}

            // Skip the input if it doesn't match the specified trigger
            if (input.trigger != trigger) continue;
			
			input.update();
			
			if (input.check(this))
				triggered = true;
		}
		
		return triggered;
    }
}
package funkin.input;

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
    var UI_LEFT = 'ui-left';
    var UI_DOWN = 'ui-down';
    var UI_UP = 'ui-up';
    var UI_RIGHT = 'ui-right';
    var ACCEPT = 'accept';
    var PAUSE = 'pause';
    var RESET = 'reset';
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
    var ui_left(default, null) = new FunkinAction(Control.UI_LEFT);
    var ui_down(default, null) = new FunkinAction(Control.UI_DOWN);
    var ui_up(default, null) = new FunkinAction(Control.UI_UP);
    var ui_right(default, null) = new FunkinAction(Control.UI_RIGHT);
    var accept(default, null) = new FunkinAction(Control.ACCEPT);
    var pause(default, null) = new FunkinAction(Control.PAUSE);
    var reset(default, null) = new FunkinAction(Control.RESET);

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
    public var PAUSE(get, never):Bool;
    public var RESET(get, never):Bool;

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

    inline function get_UI_LEFT():Bool
        return ui_left.check();

    inline function get_UI_DOWN():Bool
        return ui_down.check();

    inline function get_UI_UP():Bool
        return ui_up.check();

    inline function get_UI_RIGHT():Bool
        return ui_right.check();

    inline function get_UI_LEFT_P():Bool
        return ui_left.checkPressed();

    inline function get_UI_DOWN_P():Bool
        return ui_down.checkPressed();

    inline function get_UI_UP_P():Bool
        return ui_up.checkPressed();

    inline function get_UI_RIGHT_P():Bool
        return ui_right.checkPressed();

    inline function get_ACCEPT():Bool
        return accept.checkPressed();

    inline function get_PAUSE():Bool
        return pause.checkPressed();

    inline function get_RESET():Bool
        return reset.checkPressed();

    public function new()
    {
        super('controls');

        // Adds the actions
        add(note_left);
        add(note_down);
        add(note_up);
        add(note_right);
        add(ui_left);
        add(ui_down);
        add(ui_up);
        add(ui_right);
        add(accept);
        add(pause);
        add(reset);

        // Sets the keys
        setKeys(Control.NOTE_LEFT, [A, LEFT]);
        setKeys(Control.NOTE_DOWN, [S, DOWN]);
        setKeys(Control.NOTE_UP, [W, UP]);
        setKeys(Control.NOTE_RIGHT, [D, RIGHT]);
        setKeys(Control.UI_LEFT, [A, LEFT]);
        setKeys(Control.UI_DOWN, [S, DOWN]);
        setKeys(Control.UI_UP, [W, UP]);
        setKeys(Control.UI_RIGHT, [D, RIGHT]);
        setKeys(Control.ACCEPT, [Z, ENTER]);
        setKeys(Control.PAUSE, [P, ENTER]);
        setKeys(Control.RESET, [R]);
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
            case UI_LEFT: func(ui_left);
            case UI_DOWN: func(ui_down);
            case UI_UP: func(ui_up);
            case UI_RIGHT: func(ui_right);
            case ACCEPT: func(accept);
            case PAUSE: func(pause);
            case RESET: func(reset);
        }
    }
}
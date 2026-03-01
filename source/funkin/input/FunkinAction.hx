package funkin.input;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import funkin.input.Controls.Control;

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
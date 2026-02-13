package funkin;

import flixel.FlxG;
import flixel.FlxState;
import funkin.input.Controls;

/**
 * The initial state of the game. This is what sets up the game.
 */
class InitState extends FlxState
{
    override public function create()
    {
        // Flixel
        FlxG.fixedTimestep = false;
        FlxG.game.focusLostFramerate = 30;
        FlxG.inputs.resetOnStateSwitch = false;
        FlxG.mouse.visible = false;
        FlxG.stage.showDefaultContextMenu = false;

        Conductor.instance = new Conductor();
        Controls.instance = new Controls();

        // Starts the game
        FlxG.switchState(() -> new funkin.play.PlayState());

        super.create();
    }
}
package funkin;

import flixel.FlxObject;
import flixel.FlxState;
import funkin.data.character.CharacterRegistry;
import funkin.data.song.SongRegistry;
import funkin.data.stage.StageRegistry;
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
        FlxObject.defaultMoves = false;

        // Instances
        Conductor.instance = new Conductor();
        Controls.instance = new Controls();

        CharacterRegistry.instance = new CharacterRegistry();
        StageRegistry.instance = new StageRegistry();
        SongRegistry.instance = new SongRegistry();

        // TODO: Change this to a title screen once there is one
        FlxG.switchState(() -> new funkin.ui.freeplay.FreeplayState());

        super.create();
    }
}
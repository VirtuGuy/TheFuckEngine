package funkin;

import flixel.FlxObject;
import flixel.FlxState;
import funkin.data.character.CharacterRegistry;
import funkin.data.event.EventRegistry;
import funkin.data.song.SongRegistry;
import funkin.data.stage.StageRegistry;
import funkin.input.Controls;
import funkin.save.Save;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * The initial state of the game. This is what sets up the game.
 */
class InitState extends FlxState
{
    override public function create()
    {
        super.create();

        // Flixel
        FlxG.fixedTimestep = false;
        FlxG.game.focusLostFramerate = 30;
        FlxG.inputs.resetOnStateSwitch = false;
        FlxG.mouse.visible = false;
        FlxObject.defaultMoves = false;

        // Instances
        Conductor.instance = new Conductor();
        Controls.instance = new Controls();
        Save.instance = new Save();

        CharacterRegistry.instance = new CharacterRegistry();
        StageRegistry.instance = new StageRegistry();
        SongRegistry.instance = new SongRegistry();
        EventRegistry.instance = new EventRegistry();

        FlxG.switchState(() -> FreeplaySubState.build(false));
    }
}
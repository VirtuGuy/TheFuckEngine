package funkin;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import funkin.data.character.CharacterRegistry;
import funkin.data.song.SongRegistry;
import funkin.input.Controls;
import funkin.play.PlayState;

/**
 * The initial state of the game. This is what sets up the game.
 * On web, this is used as a "Click to Start" screen.
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

        // Velocity isn't ever used much
        FlxObject.defaultMoves = false;

        Conductor.instance = new Conductor();
        Controls.instance = new Controls();

        CharacterRegistry.instance = new CharacterRegistry();
        SongRegistry.instance = new SongRegistry();

        // TODO: Remove this once songs can be loaded ingame
        PlayState.song = SongRegistry.instance.fetch('fresh');

        // Switches the state to PlayState
        // TODO: Change this to a title screen once there is one
        FlxG.switchState(() -> new funkin.play.PlayState());

        super.create();
    }
}
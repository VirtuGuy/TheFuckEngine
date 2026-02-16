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

        // Starts the game
        // Also loads up a test chart
        PlayState.song = SongRegistry.instance.fetch('test');

        FlxG.switchState(() -> new funkin.play.PlayState());

        super.create();
    }
}
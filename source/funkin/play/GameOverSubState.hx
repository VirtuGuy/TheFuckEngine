package funkin.play;

import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.data.character.CharacterRegistry;
import funkin.play.character.Character;
import funkin.ui.FunkinSubState;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * The game over sub state that appears when the player dies.
 */
class GameOverSubState extends FunkinSubState
{
    var skipped:Bool = false;

    var music:FunkinSound;
    var startSound:FunkinSound;

    var character:Character;

    override public function create()
    {
        super.create();

        // Increments the death counter
        PlayState.instance.deaths++;

        _parentState.persistentDraw = false;

        music = FunkinSound.load('play/music/gameover', 1, true, true, false);

        startSound = FunkinSound.load('play/sounds/gameover/start', 1, false);
        startSound.onComplete = () -> music.play();

        buildCharacter();

        if (character != null)
        {
            PlayState.instance.setCameraTarget(character);
            FlxG.camera.active = true;
        }

        conductor.reset(100);
    }

    function buildCharacter()
    {
        var player:Character = PlayState.instance.stage.player;
        if (player == null) return;

        character = CharacterRegistry.instance.fetchCharacter('${player.id}-death');

        // Don't do the actual character stuff if it's null
        // Because I guess you never know when the death sprite doesn't exist
        if (character == null) return;

        character.scrollFactor.copyFrom(player.scrollFactor);
        character.setPosition(player.x, player.y);
        character.playAnimation('start');
        add(character);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Updates the conductor
        conductor.time = music?.time;
        conductor.update();

        if (controls.ACCEPT)
            skip();
        if (controls.BACK)
            FlxG.switchState(() -> FreeplaySubState.build());
    }

    function skip()
    {
        if (skipped) return;
        skipped = true;

        character?.playAnimation('end');

        music.destroy();
        startSound.destroy();

        // Gotta reset this!
        // Or else the character keeps bopping
        conductor.reset();

        FunkinSound.playOnce('play/sounds/gameover/end');
        FlxTimer.wait(1, () -> FlxG.camera.fade(0xFF000000, 2, false, close));
    }

    override function beatHit(beat:Int)
    {
        super.beatHit(beat);

        character?.playAnimation('loop', true);
    }

    override public function close()
    {
        super.close();

        _parentState.persistentDraw = true;

        FlxG.camera.fade(0xFF000000, 1, true);
        
        PlayState.instance.resetSong();
    }
}
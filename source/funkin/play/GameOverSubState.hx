package funkin.play;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.data.character.CharacterRegistry;
import funkin.ui.FunkinSubState;

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

        _parentState.persistentDraw = false;

        music = FunkinSound.load('play/music/gameover');

        startSound = FunkinSound.load('play/sounds/gameover/start', 1, false);
        startSound.onComplete = startLoop;
        startSound.play();

        buildCharacter();

        if (character != null)
        {
            final followPos:FlxPoint = character.getGraphicMidpoint();

            PlayState.instance.camFollow.setPosition(followPos.x, followPos.y);
            FlxG.camera.followLerp = 0.03;
        }
    }

    function buildCharacter()
    {
        final player:Character = PlayState.instance.stage.player;
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

        if (music != null)
        {
            conductor.time = music.time;
            conductor.update();
        }

        if (controls.ACCEPT) skip();
    }

    function startLoop()
    {
        conductor.reset(100);
        music.play();
    }

    function skip()
    {
        if (skipped) return;
        skipped = true;

        character?.playAnimation('end');

        music.destroy();
        startSound.destroy();
        
        conductor.reset();

        FunkinSound.playOnce('play/sounds/gameover/end');
        FlxTimer.wait(1, () -> FlxG.camera.fade(0xFF000000, 1, false, close));
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

        PlayState.instance.resetSong();
        FlxG.camera.fade(0xFF000000, 1, true);
    }
}
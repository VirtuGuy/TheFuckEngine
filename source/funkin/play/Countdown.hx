package funkin.play;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` used for the game's countdown before the song starts.
 */
class Countdown extends FunkinSprite
{
    public var started:Bool = false;
    public var step:Int;

    public function new()
    {
        super();

        loadSprite('play/ui/countdown', 1.35, 259, 99);
        screenCenter();

        addAnimation('ready', [0]);
        addAnimation('set', [1]);
        addAnimation('go', [2]);

        visible = false;
    }

    public function start()
    {
        started = true;
        step = -1;

        visible = false;

        FlxTween.cancelTweensOf(this);
    }

    public function advance()
    {
        if (!started) return;

        step++;

        switch (step)
        {
            case 0:
                FunkinSound.playOnce('play/sounds/countdown/three');
            case 1:
                FunkinSound.playOnce('play/sounds/countdown/two');
                playAnimation('ready');
            case 2:
                FunkinSound.playOnce('play/sounds/countdown/one');
                playAnimation('set');
            case 3:
                FunkinSound.playOnce('play/sounds/countdown/go');
                playAnimation('go');
        }
    }

    override public function playAnimation(name:String, force:Bool = false)
    {
        super.playAnimation(name, force);

        alpha = 1;
        visible = true;

        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut, onComplete: _ -> visible = false });
    }
}
package funkin.play.popup;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.graphics.FunkinSprite;
import funkin.util.RhythmUtil;

/**
 * A `FunkinSprite` used as a judgement popup.
 * 
 * TODO: Make a base popup class.
 */
class JudgementSprite extends FunkinSprite
{
    public function new()
    {
        super();

        scrollFactor.set();
        acceleration.y = 600;
        moves = true;

        loadSprite('play/ui/judgements', 192, 96);

        addAnimation(Judgement.SICK, [0]);
        addAnimation(Judgement.GOOD, [1]);
        addAnimation(Judgement.BAD, [2]);
        addAnimation(Judgement.SHIT, [3]);
    }

    public function popup(judgement:Judgement)
    {
        acceleration.x = FlxG.random.int(-10, 10);
        velocity.y = -250;
        alpha = 1;

        playAnimation(judgement);

        new FlxTimer().start(0.5, _ -> {
            FlxTween.tween(this, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut, onComplete: _ -> kill() });
        }); 
    }
}
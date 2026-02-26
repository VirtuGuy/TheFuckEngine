package funkin.play.popup;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` that pops up on the screen and fades away.
 */
class PopupSprite extends FunkinSprite
{
    public function new()
    {
        super();

        acceleration.y = 450;
        moves = true;
    }

    public function popup()
    {
        velocity.y = -200;
        alpha = 1;

        new FlxTimer().start(0.25, _ -> {
            FlxTween.tween(this, { alpha: 0 }, 0.6, { ease: FlxEase.quadOut, onComplete: _ -> kill() });
        }); 
    }
}
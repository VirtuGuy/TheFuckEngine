package funkin.play.popup;

import funkin.audio.FunkinSound;

/**
 * A `PopupGroup` used for the game's countdown.
 */
class Countdown extends PopupGroup
{
    public var started:Bool = false;
    public var step:Int;

    public function start()
    {
        started = true;
        step = -1;

        killMembers();
    }

    public function advance()
    {
        if (!started) return;
        step++;

        var sprite:PopupSprite = null;

        if (step > 0)
        {
            sprite = popup();

            if (sprite.graphic == null)
            {
                sprite.loadSprite('play/ui/countdown', 1.25, 259, 99);

                sprite.addAnimation('ready', [0]);
                sprite.addAnimation('set', [1]);
                sprite.addAnimation('go', [2]);
            }

            sprite.screenCenter();
            sprite.y += 50;
        }

        switch (step)
        {
            case 0:
                FunkinSound.playOnce('play/sounds/countdown/three');
            case 1:
                FunkinSound.playOnce('play/sounds/countdown/two');
                sprite.playAnimation('ready');
            case 2:
                FunkinSound.playOnce('play/sounds/countdown/one');
                sprite.playAnimation('set');
            case 3:
                FunkinSound.playOnce('play/sounds/countdown/go');
                sprite.playAnimation('go');
                started = false;
        }
    }
}
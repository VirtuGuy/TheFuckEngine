package funkin.play.note;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` used as a note splash that appears when hitting a note perfectly.
 */
class NoteSplash extends FunkinSprite
{
    public function new()
    {
        super();

        buildSprite();
    }

    public function buildSprite()
    {
        loadSprite('play/ui/note/splashes', 1.35, 82, 85);

        for (i in 0...Constants.NOTE_COUNT)
        {
            var direction:NoteDirection = NoteDirection.fromInt(i);
            var frame:Int = direction * 3;
            
            addAnimation(direction.name, [frame, frame + 1, frame + 2], 15, false);
        }

        animation.onFinish.add(_ -> kill());
    }

    public function play(strum:StrumSprite)
    {
        x = strum.x + (strum.width - width) / 2;
        y = strum.y + (strum.height - height) / 2;

        playAnimation(strum.direction.name);
    }
}
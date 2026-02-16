package funkin.play.note;

import flixel.FlxSprite;

/**
 * An `FlxSprite` used as a note splash that appears when hitting a note perfectly.
 */
class NoteSplash extends FlxSprite
{
    public function new()
    {
        super();

        buildSprite();
    }

    public function buildSprite()
    {
        loadGraphic(Paths.image('play/ui/note/note-splashes'), true, 82, 85);
        setGraphicSize(Std.int(width * Constants.ZOOM * 1.35));
        updateHitbox();

        for (direction in 0...Constants.NOTE_COUNT)
        {
            var frame:Int = direction * 3;
            
            animation.add('splash$direction', [frame, frame + 1, frame + 2], 15, false);
        }

        animation.onFinish.add(_ -> kill());
    }

    public function play(strum:StrumSprite)
    {
        var direction:NoteDirection = strum.direction;

        x = strum.x + (strum.width - width) / 2;
        y = strum.y + (strum.height - height) / 2;

        animation.play('splash$direction');
    }
}
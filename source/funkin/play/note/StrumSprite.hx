package funkin.play.note;

import flixel.FlxSprite;

/**
 * An `FlxSprite` used as the recepter for a `Strumline`.
 */
class StrumSprite extends FlxSprite
{
    public var direction:NoteDirection;
    public var confirmTime:Float = 0;

    public function new(direction:NoteDirection)
    {
        super();

        this.direction = direction;

        buildSprite();
    }

    override public function update(elapsed:Float)
    {
        confirmTime = Math.max(0, confirmTime - elapsed * 10);

        super.update(elapsed);
    }

    public function buildSprite()
    {
        loadGraphic(Paths.image('play/ui/notes'), true, 84, 84);
        setGraphicSize(Std.int(width * Constants.ZOOM));
        updateHitbox();

        animation.add('static', [direction], 10);
        animation.add('press', [direction + Constants.NOTE_COUNT], 10);
        animation.add('confirm', [direction + Constants.NOTE_COUNT * 2], 10);

        animation.play('static');
    }
}
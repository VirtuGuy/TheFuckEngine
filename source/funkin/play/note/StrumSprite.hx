package funkin.play.note;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` used as the recepter for a `Strumline`.
 */
class StrumSprite extends FunkinSprite
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
        loadSprite('play/ui/note/notes', 84, 84);

        addAnimation('static', [direction]);
        addAnimation('press', [direction + Constants.NOTE_COUNT]);
        addAnimation('confirm', [direction + Constants.NOTE_COUNT * 2]);

        playAnimation('static');
    }
}
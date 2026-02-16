package funkin.play.note;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` used as a note for a `Strumline`.
 */
class NoteSprite extends FunkinSprite
{
    public var time:Float;
    public var direction(default, set):NoteDirection;

    public var mayHit:Bool;
    public var tooLate:Bool;

    public var holdNote:HoldNoteSprite;

    public function new()
    {
        super();

        // No point of having this active
        // Not like there's animation to the sprite
        active = false;

        buildSprite();
    }

    public function buildSprite()
    {
        loadSprite('play/ui/note/notes', 84, 84);

        for (i in 0...Constants.NOTE_COUNT)
        {
            final direction:NoteDirection = NoteDirection.fromInt(i);

            addAnimation(direction.name, [direction + Constants.NOTE_COUNT * 3]);
        }

        set_direction(direction);
    }

    override public function revive()
    {
        super.revive();

        y = -9999;

        time = 0;
        direction = LEFT;

        mayHit = false;
        tooLate = false;

        holdNote = null;
    }

    function set_direction(direction:NoteDirection):NoteDirection
    {
        this.direction = direction % Constants.NOTE_COUNT;

        playAnimation(this.direction.name);

        return this.direction;
    }
}
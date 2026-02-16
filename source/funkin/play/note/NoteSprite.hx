package funkin.play.note;

import flixel.FlxSprite;

/**
 * An `FlxSprite` used as a note for a `Strumline`.
 */
class NoteSprite extends FlxSprite
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
        loadGraphic(Paths.image('play/ui/note/notes'), true, 84, 84);
        setGraphicSize(Std.int(width * Constants.ZOOM));
        updateHitbox();

        for (direction in 0...Constants.NOTE_COUNT)
            animation.add('note$direction', [direction + Constants.NOTE_COUNT * 3]);

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

        animation.play('note${this.direction}');

        return this.direction;
    }
}
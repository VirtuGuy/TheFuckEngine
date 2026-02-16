package funkin.play.note;

import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` that goes over the strumline while a hold note is being held.
 */
class HoldNoteCover extends FunkinSprite
{
    public var holdNote:HoldNoteSprite;

    public function new()
    {
        super();

        buildSprite();
    }

    override public function update(elapsed:Float)
    {
        // Kill the cover if its hold note is dead
        // This is because the hold note wants the cover to be in the afterlife
        if (holdNote == null || !holdNote.alive) kill();

        super.update(elapsed);
    }

    public function buildSprite()
    {
        loadSprite('play/ui/note/hold-note-cover', 44, 23);
        setGraphicSize(Std.int(width * 0.95));
        updateHitbox();

        for (i in 0...Constants.NOTE_COUNT)
        {
            final direction:NoteDirection = NoteDirection.fromInt(i);
            final frame:Int = direction * 3;
            
            addAnimation(direction.name, [frame, frame + 1, frame + 2], 30);
        }
    }

    public function play(holdNote:HoldNoteSprite, strum:StrumSprite)
    {
        this.holdNote = holdNote;

        x = strum.x + (strum.width - width) / 2;
        y = strum.y + (strum.height - height) / 2;

        playAnimation(strum.direction.name);
    }

    override public function revive()
    {
        super.revive();

        holdNote = null;
    }
}
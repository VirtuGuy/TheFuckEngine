package funkin.play.note;

import flixel.FlxSprite;

/**
 * An `FlxSprite` that goes over the strumline while a hold note is being held.
 */
class HoldNoteCover extends FlxSprite
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
        loadGraphic(Paths.image('play/ui/hold-note-covers'), true, 14, 6);
        setGraphicSize(Std.int(width * Constants.ZOOM));
        updateHitbox();

        animation.add('cover', [0, 1, 2, 3], 20);
    }

    public function play(holdNote:HoldNoteSprite, strum:StrumSprite)
    {
        this.holdNote = holdNote;

        x = strum.x + (strum.width - width) / 2;
        y = strum.y + (strum.height - height) / 2;

        animation.play('cover');
    }

    override public function revive()
    {
        super.revive();

        holdNote = null;
    }
}
package funkin.play.note.hold;

import funkin.graphics.FunkinSprite;
import funkin.play.note.strum.StrumSprite;

/**
 * A `FunkinSprite` that goes over the strumline while a hold note is being held.
 */
class HoldNoteCover extends FunkinSprite
{
	public var holdNote:HoldNoteSprite;
	public var strum:StrumSprite;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Kill the cover if its hold note is dead
		// This is because the hold note wants the cover to be in the afterlife
		if (holdNote == null || !holdNote.alive)
			kill();
	}

	public function buildSprite(style:NoteStyle)
	{
		loadSprite(style.getNote('hold/covers'), style.holdCover.scale, style.holdCover.width, style.holdCover.height);

		for (i in 0...Constants.NOTE_COUNT)
		{
			var direction:NoteDirection = NoteDirection.fromInt(i);
			var frames:Array<Int> = style.getNoteFrames(style.holdCover.animations, direction);
			var framerate:Int = style.holdCover.framerate;

			addAnimation(direction.name, frames, framerate);
		}
	}

	public function play(holdNote:HoldNoteSprite, strum:StrumSprite)
	{
		this.holdNote = holdNote;
		this.strum = strum;

		if (graphic == null)
			kill();

		playAnimation(strum.direction.name);
	}

	override function draw()
	{
		if (strum != null)
		{
			x = strum.x + (strum.width - width) / 2;
			y = strum.y + (strum.height - height) / 2;
		}

		super.draw();
	}

	override function revive()
	{
		super.revive();

		holdNote = null;
		strum = null;
	}
}

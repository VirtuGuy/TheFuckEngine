package funkin.play.note;

import funkin.graphics.FunkinSprite;
import funkin.play.note.strum.StrumSprite;

/**
 * A `FunkinSprite` used as a note splash that appears when hitting a note perfectly.
 */
class NoteSplash extends FunkinSprite
{
	public var strum:StrumSprite;

	public function buildSprite(style:NoteStyle)
	{
		loadSprite(style.getNote('splashes'), style.noteSplash.scale, style.noteSplash.width, style.noteSplash.height);

		for (i in 0...Constants.NOTE_COUNT)
		{
			final direction:NoteDirection = NoteDirection.fromInt(i);
			final frames:Array<Int> = style.getNoteFrames(style.noteSplash.animations, direction);
			final framerate:Int = Std.int(Math.max(1, style.noteSplash.framerate));

			addAnimation(direction.name, frames, framerate, false);
		}

		animation.onFinish.add(_ -> kill());

		if (strum != null)
			playAnimation(strum.direction.name);
	}

	public function play(strum:StrumSprite)
	{
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

		strum = null;
	}
}

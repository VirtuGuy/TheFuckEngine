package funkin.play;

import flixel.FlxG;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.ui.FunkinState;

/**
 * A state where the gameplay occurs. Kinda like a "play" state. Hah! I said the thing!
 */
class PlayState extends FunkinState
{
	var loadedSong:Bool = false;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;

	override public function create()
	{
		opponentStrumline = new Strumline();
		opponentStrumline.offset = 0.25;
		add(opponentStrumline);

		playerStrumline = new Strumline();
		playerStrumline.offset = 0.75;
		add(playerStrumline);

		loadSong();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (loadedSong)
		{
			conductor.time += elapsed * Constants.MS_PER_SEC;
			conductor.update();
		}

		opponentStrumline.process(false);
		playerStrumline.process(true);

		processInput();

		if (FlxG.keys.justPressed.R) FlxG.resetState();

		super.update(elapsed);
	}

	function loadSong()
	{
		conductor.bpm = 100;
		conductor.time = -conductor.crotchet * 4;

		playerStrumline.speed = 1;
		playerStrumline.data = [];

		for (i in 0...20)
			playerStrumline.data.push({ t: i * 200, d: 0 });

		opponentStrumline.data = playerStrumline.data.copy();
		opponentStrumline.speed = 1;

		loadedSong = true;
	}

	function processInput()
	{
		// Player input
		// TODO: Make a proper input system
		for (note in playerStrumline.getMayHitNotes())
		{
			if (note.direction.justPressed)
				playerStrumline.hitNote(note);
		}
		
		playerStrumline.strums.forEach(strum -> {
			if (strum.direction.pressed)
			{
				if (strum.confirmTime > 0)
					strum.animation.play('confirm');
				else
					strum.animation.play('press');
			}
			else
				strum.animation.play('static');
		});

		// Opponent input
		for (note in opponentStrumline.getMayHitNotes())
			opponentStrumline.hitNote(note);

		opponentStrumline.strums.forEach(strum -> {
			if (strum.confirmTime > 0)
				strum.animation.play('confirm');
			else
				strum.animation.play('static');
		});
	}
}

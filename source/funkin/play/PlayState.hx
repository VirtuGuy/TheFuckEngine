package funkin.play;

import flixel.FlxCamera;
import flixel.FlxG;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.play.popup.Popups;
import funkin.ui.FunkinState;
import funkin.util.RhythmUtil;

/**
 * A state where the gameplay occurs. Kinda like a "play" state. Hah! I said the thing!
 */
class PlayState extends FunkinState
{
	public static var instance:PlayState;
	public static var song:Song;

	var loadedSong:Bool = false;

	var camHUD:FlxCamera;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;
	var popups:Popups;

	override public function create()
	{
		instance = this;

		// Eject the player if the song is null
		// It's WAY too dangerous to be here
		if (song == null)
		{
			// TODO: Make it switch to a menu once there is one
			// For now, throw an error at the player
			throw 'Cannot load the song if it\'s null!';
		}

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x0;
		FlxG.cameras.add(camHUD, false);

		// TODO: Remove this
		// This is only here until there's a proper stage
		FlxG.camera.bgColor = 0xFF252525;

		opponentStrumline = new Strumline();
		opponentStrumline.offset = 0.25;
		opponentStrumline.camera = camHUD;
		add(opponentStrumline);

		playerStrumline = new Strumline();
		playerStrumline.offset = 0.75;
		playerStrumline.camera = camHUD;
		add(playerStrumline);

		popups = new Popups();
		add(popups);

		loadCharacters();
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
		playerStrumline.process(!Preferences.botplay);

		processInput();

		// TODO: Remove this
		// This is only here for debugging purposes
		if (FlxG.keys.justPressed.R) FlxG.resetState();

		super.update(elapsed);
	}

	function loadCharacters()
	{
		// TODO: Add characters
	}

	function loadSong()
	{
		conductor.bpm = song.bpm;
		conductor.time = -conductor.crotchet * 4;

		playerStrumline.speed = song.speed;
		opponentStrumline.speed = playerStrumline.speed;
		
		for (noteData in song.notes)
		{
			if (noteData.d >= Constants.NOTE_COUNT)
				opponentStrumline.data.push(noteData);
			else
				playerStrumline.data.push(noteData);
		}

		loadedSong = true;
	}

	function processInput()
	{
		// Player input
		final directionNotes:Array<Array<NoteSprite>> = [[], [], [], []];

		for (note in playerStrumline.getMayHitNotes()) directionNotes[note.direction].push(note);

		for (i in 0...directionNotes.length)
		{
			final note:NoteSprite = directionNotes[i][0];
			final direction:NoteDirection = NoteDirection.fromInt(i);
			final pressed:Bool = direction.justPressed || Preferences.botplay;

			if (!pressed || note == null) continue;

			final judgement:Judgement = RhythmUtil.judgeNote(note);

			playerStrumline.hitNote(note);
			popups.playJudgement(judgement);
			
			// Only play the note splash if the player got a Sick!
			if (judgement == SICK) playerStrumline.playSplash(direction);
		}

		// Opponent input
		for (note in opponentStrumline.getMayHitNotes())
			opponentStrumline.hitNote(note);
	}
}

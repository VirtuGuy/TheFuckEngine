package funkin.play;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxText;
import funkin.data.character.CharacterRegistry;
import funkin.play.note.HoldNoteSprite;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.play.popup.Popups;
import funkin.ui.FunkinState;
import funkin.util.MathUtil;
import funkin.util.RhythmUtil;

/**
 * A state where the gameplay occurs. Kinda like a "play" state. Hah! I said the thing!
 */
class PlayState extends FunkinState
{
	public static var instance:PlayState;
	public static var song:Song;

	var loadedSong:Bool = false;

	// Score is secretly a float because hold note scoring is ass
	var score:Float = 0;

	var camHUD:FlxCamera;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;
	var scoreText:FlxText;
	var popups:Popups;

	var dad:Character;
	var bf:Character;

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
		opponentStrumline.noteHit.add(opponentNoteHit);
		opponentStrumline.holdNoteHit.add(opponentHoldNoteHit);
		add(opponentStrumline);

		playerStrumline = new Strumline();
		playerStrumline.offset = 0.75;
		playerStrumline.camera = camHUD;
		playerStrumline.noteHit.add(playerNoteHit);
		playerStrumline.noteMiss.add(playerNoteMiss);
		playerStrumline.holdNoteHit.add(playerHoldNoteHit);
		playerStrumline.holdNoteDrop.add(playerHoldNoteDrop);
		add(playerStrumline);

		scoreText = new FlxText();
		scoreText.size = 24;
		scoreText.alignment = CENTER;
		scoreText.camera = camHUD;
		add(scoreText);

		popups = new Popups();
		add(popups);

		loadCharacters();
		loadSong();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
		if (FlxG.keys.justPressed.R) resetSong();

		// HUD stuff
		camHUD.zoom = MathUtil.lerp(camHUD.zoom, 1, 0.03);
		
		scoreText.text = Std.string(Std.int(score));
		scoreText.screenCenter(X);
		scoreText.y = FlxG.height - scoreText.height - 50;
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		// Only bop the HUD camera every four beats
		if (beat % 4 == 0) camHUD.zoom = 1.02;

		// Character bopping
		dad?.dance();
		bf?.dance();
	}

	function loadCharacters()
	{
		dad = CharacterRegistry.instance.fetchCharacter(song.opponent);
		bf = CharacterRegistry.instance.fetchCharacter(song.player, true);
		
		dad?.setPosition(130, 350);
		bf?.setPosition(850, 350);

		if (dad != null) add(dad);
		if (bf != null) add(bf);
	}

	function loadSong()
	{
		conductor.bpm = song.bpm;
		conductor.time = -conductor.crotchet * 4;

		playerStrumline.speed = song.speed;
		opponentStrumline.speed = playerStrumline.speed;
		
		for (noteData in song.notes)
		{
			if (NoteDirection.isPlayer(noteData.d))
				playerStrumline.data.push(noteData);
			else
				opponentStrumline.data.push(noteData);
		}

		loadedSong = true;
	}

	function resetSong()
	{
		loadedSong = false;
		score = 0;

		opponentStrumline.clean();
		playerStrumline.clean();

		loadSong();
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

			// Miss if ghost tapping is disabled
			// Don't count the miss if botplay is enabled though
			if (note == null && pressed && !Preferences.ghostTapping && !Preferences.botplay) playerGhostMiss(direction);

			// Don't hit the note if nothing's being pressed
			// Especially don't hit the note if it's null
			if (!pressed || note == null) continue;

			playerStrumline.hitNote(note);
		}

		// Opponent input
		for (note in opponentStrumline.getMayHitNotes())
			opponentStrumline.hitNote(note);
	}

	function playerNoteHit(note:NoteSprite)
	{
		final judgement:Judgement = RhythmUtil.judgeNote(note);
		popups.playJudgement(judgement);

		score += judgement.score;
		
		// Only play the note splash if the player got a Sick!
		if (judgement == SICK) playerStrumline.playSplash(note.direction);

		// Force Boyfriend to sing
		bf?.sing(note.direction);
	}

	function playerHoldNoteHit(holdNote:HoldNoteSprite)
	{
		// Kinda based on PR #3832 for Funkin'
		// This is only a TINY bit inconsistent
		final diff:Float = (holdNote.lastLength - holdNote.length) / 1000;

		score += Constants.HOLD_SCORE_PER_SEC * diff;

		// Resets Boyfriend's sing timer
		bf?.resetSingTimer();
	}

	function playerNoteMiss(note:NoteSprite)
	{
		var missScore:Float = Constants.MISS_SCORE;

		if (note.holdNote != null) missScore *= (note.holdNote.length / 500);
		score += missScore;

		bf?.miss(note.direction);
	}

	function playerGhostMiss(direction:NoteDirection)
	{
		score += Constants.GHOST_TAP_SCORE;

		bf?.miss(direction);
	}

	function playerHoldNoteDrop(holdNote:HoldNoteSprite)
	{
		// Takes away score based on how long the hold note is
		score += Constants.MISS_SCORE * (holdNote.length / 500);

		bf?.miss(holdNote.direction);
	}

	function opponentNoteHit(note:NoteSprite)
	{
		dad?.sing(note.direction);
	}

	function opponentHoldNoteHit(holdNote:HoldNoteSprite)
	{
		dad?.resetSingTimer();
	}
}

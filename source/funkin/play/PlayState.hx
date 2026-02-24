package funkin.play;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import funkin.data.character.CharacterRegistry;
import funkin.play.note.HoldNoteSprite;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.play.popup.Popups;
import funkin.play.song.Song;
import funkin.play.song.Voices;
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

	var songLoaded:Bool;
	var songStarted:Bool;
	var songEnded:Bool;

	var score:Float;

	var voices:Voices;

	var camHUD:FlxCamera;
	var camFollow:FlxObject;
	var camTarget:Character;
	var camZoom:Float = 1.15;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;
	var scoreText:FlxText;
	var popups:Popups;

	var opponent:Character;
	var player:Character;
	var gf:Character;

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

		camFollow = new FlxObject();

		// TODO: Remove this
		// This is only here until there's a proper stage
		FlxG.camera.bgColor = 0xFF252525;
		FlxG.camera.zoom = camZoom;
		FlxG.camera.follow(camFollow, LOCKON, 0.03);

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

		loadCharacters();

		// Popups should be above characters
		popups = new Popups();
		add(popups);
		
		resetCameraTarget();
		resetSong();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (songLoaded)
		{
			conductor.time += elapsed * Constants.MS_PER_SEC;
			conductor.update();

			if (conductor.time >= 0 && !songStarted) startSong();

			checkSongTime();
		}

		opponentStrumline.process(false);
		playerStrumline.process(!Preferences.botplay);

		processInput();

		// TODO: Remove this
		// This is only here for debugging purposes
		if (FlxG.keys.justPressed.R) resetSong();
		if (FlxG.keys.justPressed.O) conductor.time = FlxG.sound.music.length;
		if (FlxG.keys.justPressed.J) FlxG.switchState(() -> new FunkinState());

		FlxG.camera.zoom = MathUtil.lerp(FlxG.camera.zoom, camZoom, 0.03);
		camHUD.zoom = MathUtil.lerp(camHUD.zoom, 1, 0.03);
		
		// HUD stuff
		scoreText.text = Std.string(Std.int(score));
		scoreText.screenCenter(X);
		scoreText.y = FlxG.height - scoreText.height - 50;

		if (Preferences.downscroll) scoreText.y = 50;
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		// Camera bopping
		if (beat % 2 == 0)
		{
			FlxG.camera.zoom = camZoom + 0.05;
			camHUD.zoom = 1.02;
		}

		// Character bopping
		opponent?.dance();
		player?.dance();
		gf?.dance();
	}

	override function sectionHit(section:Int)
	{
		super.sectionHit(section);
		
		if (!songStarted) return;

		// Moves the camera
		// TODO: Remove this once events are added
		setCameraTarget(camTarget == opponent ? player : opponent);
	}

	function loadCharacters()
	{
		opponent = CharacterRegistry.instance.fetchCharacter(song.opponent);
		player = CharacterRegistry.instance.fetchCharacter(song.player, true);
		gf = CharacterRegistry.instance.fetchCharacter(song.gf);
		
		opponent?.setPosition(-300, 350);
		player?.setPosition(300, 350);
		gf?.setPosition(0, 300);

		add(gf);
		add(opponent);
		add(player);
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

		// Loads the actual song
		FlxG.sound.playMusic(Paths.inst(song.id), 1, false);
		FlxG.sound.music.stop();

		voices = new Voices(song.id);

		songLoaded = true;
	}

	function startSong()
	{
		songStarted = true;

		FlxG.sound.music.play();
		voices.play();
	}

	function endSong()
	{
		songEnded = true;

		// Stops the music
		// Remove this line if you want to hear something loud
		FlxG.sound.music.stop();
		voices.stop();

		// TODO: Add song end logic
	}

	function resetSong()
	{
		songLoaded = false;
		songStarted = false;
		songEnded = false;

		score = 0;

		FlxG.sound.music?.stop();
		voices?.stop();

		opponentStrumline.clean();
		playerStrumline.clean();

		resetCameraTarget();

		loadSong();
	}

	function checkSongTime()
	{
		if (!FlxG.sound.music.playing) return;

		// End the song of the time has come...
		if (conductor.time >= FlxG.sound.music.length)
		{
			endSong();
			return;
		}

		// Instrumental resync
		if (Math.abs(conductor.time - FlxG.sound.music.time) > Constants.RESYNC_THRESHOLD)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = conductor.time;
			FlxG.sound.music.play();

			trace('Resynced instrumental.');
		}

		// Vocals resync
		// Because the vocals are two sounds, it needs special treatment
		voices.checkResync(conductor.time);
	}

	function setCameraTarget(character:Character, instant:Bool = false)
	{
		// Can't target a character when it's null
		if (character == null) return;

		var camPos:FlxPoint = character.getGraphicMidpoint();

		camPos.x += character.isPlayer ? -100 : 100;
		camPos.y -= 100;

		camFollow.setPosition(camPos.x, camPos.y);
		camTarget = character;

		// Instantly focus on camFollow if enabled
		if (instant) FlxG.camera.focusOn(camFollow.getPosition());
	}

	function resetCameraTarget()
	{
		// Target the opponent if there is one
		// If not, try and target the player
		if (opponent != null)
			setCameraTarget(opponent, true);
		else if (player != null)
			setCameraTarget(player, true);
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

		// Only play the note splash if the player got a Sick!
		if (judgement == SICK) playerStrumline.playSplash(note.direction);

		score += judgement.score;
		player?.sing(note.direction);

		voices.playerVolume = 1;
	}

	function playerHoldNoteHit(holdNote:HoldNoteSprite)
	{
		// Kinda based on PR #3832 for Funkin'
		// This is only a TINY bit inconsistent
		final diff:Float = (holdNote.lastLength - holdNote.length) / 1000;

		score += Constants.HOLD_SCORE_PER_SEC * diff;
		player?.resetSingTimer();

		voices.playerVolume = 1;
	}

	function playerNoteMiss(note:NoteSprite)
	{
		var missScore:Float = Constants.MISS_SCORE;
		if (note.holdNote != null) missScore *= (note.holdNote.length / 500);

		score += missScore;
		player?.miss(note.direction);

		voices.playerVolume = 0;
	}

	function playerGhostMiss(direction:NoteDirection)
	{
		score += Constants.GHOST_TAP_SCORE;
		player?.miss(direction);

		voices.playerVolume = 0;
	}

	function playerHoldNoteDrop(holdNote:HoldNoteSprite)
	{
		// No penalty if the note is too short
		if (holdNote.length < 30) return;

		// Takes away score based on how long the hold note is
		score += Constants.MISS_SCORE * (holdNote.length / 500);
		player?.miss(holdNote.direction);

		voices.playerVolume = 0;
	}

	function opponentNoteHit(note:NoteSprite)
	{
		opponent?.sing(note.direction);
	}

	function opponentHoldNoteHit(holdNote:HoldNoteSprite)
	{
		opponent?.resetSingTimer();
	}

	override public function destroy()
	{
		super.destroy();

		FlxG.sound.music.stop();

		// Destroy the voices
		voices.destroy();
	}
}

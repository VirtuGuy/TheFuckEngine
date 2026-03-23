package funkin.play;

import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import funkin.audio.FunkinSound;
import funkin.data.event.EventData;
import funkin.data.event.EventRegistry;
import funkin.data.song.SongData.SongNoteData;
import funkin.data.stage.StageRegistry;
import funkin.graphics.FunkinBar;
import funkin.graphics.FunkinText;
import funkin.play.character.Character;
import funkin.play.character.HealthIcon;
import funkin.play.components.Countdown;
import funkin.play.components.Popups;
import funkin.play.components.Stage;
import funkin.play.note.HoldNoteSprite;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.play.song.Song;
import funkin.play.song.Voices;
import funkin.save.Save;
import funkin.ui.FunkinState;
import funkin.ui.freeplay.FreeplaySubState;
import funkin.util.MathUtil;
import funkin.util.RhythmUtil;
import funkin.util.SortUtil;

/**
 * A state where the gameplay occurs. Kinda like a "play" state. Hah! I said the thing!
 */
class PlayState extends FunkinState
{
	public static var instance:PlayState;
	public static var difficulty:String;
	public static var song:Song;

	public var score:Float;
	public var tallies:Tallies;
	public var deaths:Int = 0;
	
	public var camFollow:FlxObject;
	public var stage:Stage;

	var events:Array<EventData>;
	var voices:Voices;

	var songLoaded:Bool;
	var songStarted:Bool;
	var songEnded:Bool;

	var health:Float;
	var healthLerp:Float;

	var camHUD:FlxCamera;
	var camPause:FlxCamera;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;
	var healthBar:FunkinBar;
	var opponentIcon:HealthIcon;
	var playerIcon:HealthIcon;
	var scoreText:FunkinText;
	var timeText:FunkinText;
	var countdown:Countdown;
	var popups:Popups;

	override public function create()
	{
		super.create();

		instance = this;

		//
		// CAMERAS
		//

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x0;
		FlxG.cameras.add(camHUD, false);

		camPause = new FlxCamera();
		camPause.bgColor = 0x0;
		FlxG.cameras.add(camPause, false);

		camFollow = new FlxObject();
		camFollow.active = false;

		FlxG.camera.follow(camFollow, LOCKON, 0.03);

		//
		// HUD
		//

		opponentStrumline = new Strumline();
		opponentStrumline.x = 325;
		opponentStrumline.camera = camHUD;
		opponentStrumline.noteHit.add(opponentNoteHit);
		opponentStrumline.holdNoteHit.add(opponentHoldNoteHit);
		add(opponentStrumline);

		playerStrumline = new Strumline();
		playerStrumline.x = FlxG.width - opponentStrumline.x;
		playerStrumline.camera = camHUD;
		playerStrumline.noteHit.add(playerNoteHit);
		playerStrumline.noteMiss.add(playerNoteMiss);
		playerStrumline.holdNoteHit.add(playerHoldNoteHit);
		playerStrumline.holdNoteDrop.add(playerHoldNoteDrop);
		add(playerStrumline);

		healthBar = new FunkinBar(0, 0, 500, 15, 0, 1, true);
		healthBar.setColors(Constants.HEALTH_EMPTY_COLOR, Constants.HEALTH_FILL_COLOR);
		healthBar.screenCenter(X);
		healthBar.y = FlxG.height - healthBar.height - 60;
		healthBar.camera = camHUD;
		add(healthBar);

		timeText = new FunkinText(0, 0, '1:23');
		timeText.size = 24;
		timeText.alignment = CENTER;
		timeText.camera = camHUD;
		timeText.y = 35;
		timeText.visible = Preferences.showTimer;
		add(timeText);

		if (Preferences.downscroll)
		{
			healthBar.y = FlxG.height - healthBar.height - healthBar.y;
			timeText.y = FlxG.height - timeText.height - timeText.y;
		}

		scoreText = new FunkinText(0, 0, '123456');
		scoreText.size = 15;
		scoreText.alignment = CENTER;
		scoreText.camera = camHUD;
		scoreText.y = healthBar.y + healthBar.height + 20;
		scoreText.zIndex = 1;
		add(scoreText);

		countdown = new Countdown();
		countdown.camera = camHUD;
		add(countdown);

		//
		// SETUP
		//

		stage = StageRegistry.instance.fetchStage(song.stage);
		add(stage);

		popups = new Popups();
		add(popups);

		tallies = new Tallies();

		loadCharacters();
		loadSong();

		resetSong();

		refresh();

		healthLerp = health;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Updates the conductor
		if (songLoaded)
		{
			conductor.time += elapsed * Constants.MS_PER_SEC;
			conductor.update();

			if (conductor.time >= 0 && !songStarted) startSong();

			checkSongTime();
		}

		opponentStrumline.process(false);
		playerStrumline.process(!Preferences.botplay);

		processEvents();
		processInput();

		//
		// HUD
		//

		health = FlxMath.bound(health, healthBar.min, healthBar.max);
		healthLerp = MathUtil.lerp(healthLerp, health, 0.15);

		healthBar.value = healthLerp;
		
		if (opponentIcon != null)
		{
			opponentIcon.x = healthBar.fillPosition - opponentIcon.width + 15;
			opponentIcon.isDead = health > 0.8;
		}

		if (playerIcon != null)
		{
			playerIcon.x = healthBar.fillPosition - 15;
			playerIcon.isDead = health < 0.2;
		}

		scoreText.text = 'score: ${Std.int(score)} | misses: ${tallies.misses}';
		scoreText.screenCenter(X);

		if (!songEnded)
		{
			timeText.text = FlxStringUtil.formatTime((FunkinSound.music.length - FunkinSound.music.time) / Constants.MS_PER_SEC);
			timeText.screenCenter(X);
		}
		
		FlxG.camera.zoom = MathUtil.lerp(FlxG.camera.zoom, stage.zoom, 0.03);
		camHUD.zoom = MathUtil.lerp(camHUD.zoom, 1, 0.03);

		if (controls.PAUSE)
			pause();

		if (controls.RESET)
		{
			health = 0;
			healthLerp = 0;
		}

		// Death :(
		if (health <= healthBar.min)
			openSubState(new GameOverSubState());
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		if (subState != null) return;

		stage.opponent?.dance();
		stage.player?.dance();
		stage.gf?.dance();

		countdown.advance();

		// Don't bop all this stuff until the song starts
		if (!songStarted) return;

		opponentIcon?.bop();
		playerIcon?.bop();

		if (beat % 2 == 0)
		{
			FlxG.camera.zoom = stage.zoom + 0.05;
			camHUD.zoom = 1.02;
		}
	}

	public function resetSong()
	{
		songStarted = false;
		songEnded = false;

		score = 0;
		health = Constants.STARTING_HEALTH;
		tallies.reset();

		events = song.events.copy();
		events.sort(SortUtil.byEventTime.bind(FlxSort.ASCENDING));

		setCameraTarget(stage.player, true);

		FlxG.camera.zoom = stage.zoom;

		// Loads the strumline
		var notes:Array<SongNoteData> = song.getNotes(difficulty);
		var speed:Float = song.getSpeed(difficulty);

		opponentStrumline.clean();
		playerStrumline.clean();

		opponentStrumline.load(notes.filter(note -> return note.d >= Constants.NOTE_COUNT), speed);
		playerStrumline.load(notes.filter(note -> return note.d < Constants.NOTE_COUNT), speed);

		// Resets the conductor
		conductor.reset(song.bpm);
		conductor.time = -conductor.crotchet * 4;

		// Starts the countdown
		countdown.start();

		FunkinSound.stopAllSounds(true);
	}

	public function setCameraTarget(target:Character, instant:Bool = false)
	{
		// Why????
		if (target == null) return;

		var pos:FlxPoint = target.getGraphicMidpoint();
        var offset:FlxPoint = MathUtil.arrayToPoint(target.meta.cameraOffset);

        PlayState.instance.camFollow.setPosition(pos.x + offset.x, pos.y + offset.y);

		if (instant)
			FlxG.camera.snapToTarget();
	}

	function loadCharacters()
	{
		stage.setPlayer(song.player);
		stage.setOpponent(song.opponent);
		stage.setGF(song.gf);

		// GF opponent
		if (stage.opponent != null && song.opponent == song.gf)
		{
			stage.opponent.setPosition(stage.gf.x, stage.gf.y);
			stage.opponent.zIndex = stage.gf.zIndex;
			stage.gf.destroy();
			stage.refresh();
		}

		// Sets up character health icons
		opponentIcon = stage.opponent?.buildHealthIcon();
		playerIcon = stage.player?.buildHealthIcon();

		if (opponentIcon != null)
		{
			opponentIcon.camera = camHUD;
			opponentIcon.y = healthBar.y - opponentIcon.height / 2;
			add(opponentIcon);
		}

		if (playerIcon != null)
		{
			playerIcon.camera = camHUD;
			playerIcon.y = healthBar.y - playerIcon.height / 2;
			add(playerIcon);
		}
	}

	function loadSong()
	{
		songLoaded = true;

		FunkinSound.playMusic(song.instPath, 1, false, false);
		voices = new Voices(song);
	}

	function startSong()
	{
		songStarted = true;

		FunkinSound.music.play();
		voices.play();
	}

	function endSong()
	{
		songEnded = true;

		// Save the song score
		Save.instance.setScore(song.id, difficulty, Std.int(score), false);

		FunkinSound.stopAllSounds(true);

		// TODO: Make this open the results screen instead
		FlxG.switchState(() -> FreeplaySubState.build());
	}

	function pause()
	{
		var state:PauseSubState = new PauseSubState();
		state.camera = camPause;
		openSubState(state);
	}

	function checkSongTime()
	{
		// End the song if the time has come...
		// Doing this normally has a problem unfortunately :(
		if (conductor.time >= FunkinSound.music.length)
		{
			endSong();
			return;
		}

		// Don't resync if the song isn't playing
		if (!FunkinSound.music.playing) return;

		if (Math.abs(conductor.time - FunkinSound.music.time) > Constants.RESYNC_THRESHOLD)
		{
			FunkinSound.music.pause();
			FunkinSound.music.time = conductor.time;
			FunkinSound.music.play();

			trace('Resynced instrumental.');
		}

		voices.checkResync(conductor.time);
	}

	function processEvents()
	{
		while (events.length > 0)
		{
			var event:EventData = events[0];

			// Don't handle the event until it's the right time
			if (event.t > conductor.time)
				break;

			// Skip the event if it's one second late
			if (conductor.time - event.t > 1000)
			{
				events.shift();
				break;
			}

			// Handle the event
			EventRegistry.instance.handleEvent(event.e, event.v);

			events.shift();

			trace('Handling event ${event.e}.');
		}
	}

	function processInput()
	{
		// Player input
		var directionNotes:Array<Array<NoteSprite>> = [[], [], [], []];

		for (note in playerStrumline.getMayHitNotes())
			directionNotes[note.direction].push(note);

		for (i in 0...directionNotes.length)
		{
			var note:NoteSprite = directionNotes[i][0];
			var direction:NoteDirection = NoteDirection.fromInt(i);
			var pressed:Bool = direction.justPressed || Preferences.botplay;

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
		var judgement:Judgement = RhythmUtil.judgeNote(note);

		score += judgement.score;
		health += Constants.NOTE_HEALTH;

		tallies.hits++;
		tallies.combo++;

		switch (judgement)
		{
			case SICK:
				playerStrumline.playSplash(note.direction);
				tallies.sicks++;
			case GOOD:
				tallies.goods++;
			case BAD:
				tallies.bads++;
			case SHIT:
				tallies.shits++;
		}

		stage.player?.sing(note.direction);
		voices.playerVolume = 1;

		popups.popupJudgement(judgement);
		popups.popupCombo(tallies.combo);
	}

	function playerHoldNoteHit(holdNote:HoldNoteSprite)
	{
		score += Constants.HOLD_SCORE_PER_SEC * FlxG.elapsed;
		health += Constants.HOLD_HEALTH_PER_SEC * FlxG.elapsed;

		stage.player?.resetSingTimer();
		voices.playerVolume = 1;
	}

	function playerNoteMiss(note:NoteSprite)
	{
		var missScore:Float = Constants.MISS_SCORE;
		
		if (note.holdNote != null)
			missScore *= (note.holdNote.length / 500);

		score += missScore;

		tallies.misses++;
		tallies.combo = 0;

		health += Constants.MISS_HEALTH;

		stage.player?.miss(note.direction);
		voices.playerVolume = 0;
	}

	function playerGhostMiss(direction:NoteDirection)
	{
		score += Constants.GHOST_MISS_SCORE;
		health += Constants.GHOST_MISS_HEALTH;

		stage.player?.miss(direction);
		voices.playerVolume = 0;
	}

	function playerHoldNoteDrop(holdNote:HoldNoteSprite)
	{
		// Takes away score based on how long the hold note is
		score += Constants.MISS_SCORE * (holdNote.length / 500);
		health += Constants.MISS_HEALTH;

		stage.player?.miss(holdNote.direction);
		voices.playerVolume = 0;
	}

	function opponentNoteHit(note:NoteSprite)
	{
		stage.opponent?.sing(note.direction);
	}

	function opponentHoldNoteHit(holdNote:HoldNoteSprite)
	{
		stage.opponent?.resetSingTimer();
	}

	override public function openSubState(subState:FlxSubState)
	{
		super.openSubState(subState);

		FunkinSound.music.pause();
		voices.pause();

		FlxTween.globalManager.active = false;
		FlxG.sound.defaultSoundGroup.pause();

		FlxG.camera.active = false;
	}

	override public function closeSubState()
	{
		super.closeSubState();

		if (songStarted && !songEnded)
		{
			FunkinSound.music.play();
			voices.play();
		}

		FlxTween.globalManager.active = true;
		FlxG.sound.defaultSoundGroup.resume();

		FlxG.camera.active = true;
	}

	override public function destroy()
	{
		super.destroy();

		FunkinSound.music.stop();

		// Gonna want to reactivate this when the state is destroyed
		// There are problems if this isn't done
		FlxTween.globalManager.active = true;
	}
}

package funkin.play;

import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.data.event.EventData;
import funkin.data.event.EventRegistry;
import funkin.data.song.SongData.SongNoteData;
import funkin.data.stage.StageRegistry;
import funkin.graphics.FunkinBar;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.modding.event.ScriptEvent;
import funkin.modding.event.ScriptEventDispatcher;
import funkin.play.character.Character;
import funkin.play.character.HealthIcon;
import funkin.play.components.Countdown;
import funkin.play.components.Popups;
import funkin.play.note.HoldNoteSprite;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;
import funkin.play.note.Strumline;
import funkin.play.song.Song;
import funkin.play.song.Voices;
import funkin.play.stage.Stage;
import funkin.save.Save;
import funkin.ui.FunkinState;
import funkin.ui.freeplay.FreeplaySubState;
import funkin.ui.sticker.StickerSubState;
import funkin.ui.story.StoryMenuSubState;
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
	var songActive:Bool;

	var health:Float;
	var healthLerp:Float;

	var camHUD:FlxCamera;

	var opponentStrumline:Strumline;
	var playerStrumline:Strumline;
	var healthBar:FunkinBar;
	var healthBorder:FunkinSprite;
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

		camFollow = new FlxObject();
		camFollow.active = false;
		FlxG.camera.follow(camFollow, LOCKON, 0.03);

		//
		// HUD
		//

		opponentStrumline = new Strumline(false);
		opponentStrumline.x = 325;
		opponentStrumline.camera = camHUD;
		opponentStrumline.noteHit.add(opponentNoteHit);
		opponentStrumline.holdNoteHit.add(opponentHoldNoteHit);
		add(opponentStrumline);

		playerStrumline = new Strumline(true);
		playerStrumline.x = FlxG.width - opponentStrumline.x;
		playerStrumline.camera = camHUD;
		playerStrumline.noteHit.add(playerNoteHit);
		playerStrumline.noteMiss.add(playerNoteMiss);
		playerStrumline.holdNoteHit.add(playerHoldNoteHit);
		playerStrumline.holdNoteDrop.add(playerHoldNoteDrop);
		add(playerStrumline);

		healthBorder = FunkinSprite.create(0, 0, 'play/ui/bar');
		healthBorder.screenCenter(X);
		healthBorder.active = false;
		healthBorder.camera = camHUD;
		healthBorder.zIndex = 1;
		add(healthBorder);

		healthBar = new FunkinBar(0, 0, Std.int(healthBorder.width - 7), Std.int(healthBorder.height - 10), 0, 1, true);
		healthBar.setColors(Constants.HEALTH_EMPTY_COLOR, Constants.HEALTH_FILL_COLOR);
		healthBar.camera = camHUD;
		add(healthBar);

		timeText = new FunkinText(0, 0, '1:23');
		timeText.size = 24;
		timeText.alignment = CENTER;
		timeText.camera = camHUD;
		add(timeText);

		scoreText = new FunkinText(0, 0, '123456');
		scoreText.size = 15;
		scoreText.alignment = CENTER;
		scoreText.camera = camHUD;
		scoreText.zIndex = 2;
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

		loadCharacters();
		resetSong(false);

		refresh();

		// Runs the create script event
		dispatch(new ScriptEvent(Create));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		//
		// SONG
		//

		if (songActive)
		{
			if (songLoaded)
			{
				conductor.time += elapsed * Constants.MS_PER_SEC;
				conductor.update();

				if (conductor.time >= 0 && !songStarted)
					startSong();

				checkSongTime();
			}

			opponentStrumline.process();
			playerStrumline.process();

			processEvents();
			processInput();
		}

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

		// Death :(
		if (health <= healthBar.min)
		{
			var event:ScriptEvent = new ScriptEvent(GameOver);
			dispatch(event);

			if (!event.cancelled)
				openSubState(new GameOverSubState());
		}
	}

	override public function refresh()
	{
		super.refresh();

		timeText.y = 35;
		timeText.visible = Preferences.showTimer;

		healthBorder.y = FlxG.height - healthBorder.height - 60;

		if (Preferences.downscroll)
		{
			timeText.y = FlxG.height - timeText.height - timeText.y;
			healthBorder.y = FlxG.height - healthBorder.height - healthBorder.y;
		}

		healthBar.x = healthBorder.x + 3.5;
		healthBar.y = healthBorder.y + 5;

		scoreText.y = healthBorder.y + healthBorder.height + 20;

		if (opponentIcon != null)
			opponentIcon.y = healthBar.y - opponentIcon.height / 2;
		if (playerIcon != null)
			playerIcon.y = healthBar.y - playerIcon.height / 2;

		opponentStrumline.refresh();
		playerStrumline.refresh();
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		if (subState != null)
			return;

		if (countdown.step < 3)
		{
			var event:CountdownScriptEvent = new CountdownScriptEvent(CountdownStep, countdown.step + 1);
			dispatch(event);

			if (!event.cancelled)
				countdown.advance();
		}

		// Don't bop all this stuff until the song starts
		if (!songStarted)
			return;

		opponentIcon?.bop();
		playerIcon?.bop();

		if (beat % 2 == 0)
		{
			FlxG.camera.zoom = stage.zoom + 0.05;
			camHUD.zoom = 1.02;
		}
	}

	public function resetSong(isRetry:Bool = true)
	{
		// Canceling the retry event causes a softlock when dying
		// Putting this before it to stop that from happening
		health = Constants.STARTING_HEALTH;

		if (!songLoaded)
		{
			songLoaded = true;

			healthLerp = health;
			tallies = new Tallies();

			FunkinSound.playMusic(song.instPath, 1, false, false);
			voices = new Voices(song);
		}

		if (isRetry)
		{
			var event:ScriptEvent = new ScriptEvent(SongRetry);
			dispatch(event);

			if (event.cancelled)
				return;
		}

		songStarted = false;
		songEnded = false;
		songActive = false;

		score = 0;
		tallies.reset();

		setCameraTarget(stage.player, true);

		FlxG.camera.zoom = stage.zoom;

		//
		// STRUMLINE
		//

		var notes:Array<SongNoteData> = song.getNotes(difficulty);
		var speed:Float = song.getSpeed(difficulty);

		events = song.events.copy();
		events.sort(SortUtil.byEventTime.bind(FlxSort.ASCENDING));

		dispatch(new SongLoadScriptEvent(notes, events));

		opponentStrumline.clean();
		playerStrumline.clean();

		playerStrumline.isPlayer = !Preferences.botplay;

		opponentStrumline.load(notes.filter(note -> return note.d >= Constants.NOTE_COUNT), speed);
		playerStrumline.load(notes.filter(note -> return note.d < Constants.NOTE_COUNT), speed);

		//
		// CONDUCTOR
		//

		conductor.reset(song.bpm);
		conductor.time = -conductor.crotchet * 4;

		startCountdown();

		FunkinSound.stopAllSounds(true);
	}

	public function startCountdown()
	{
		var event:CountdownScriptEvent = new CountdownScriptEvent(CountdownStart, -1);
		dispatch(event);

		if (event.cancelled)
			return;

		songActive = true;
		countdown.start();
	}

	public function setCameraTarget(target:Character, instant:Bool = false)
	{
		// Why????
		if (target == null)
			return;

		var pos:FlxPoint = target.getGraphicMidpoint();
		var offset:FlxPoint = MathUtil.arrayToPoint(target.meta.cameraOffset);

		PlayState.instance.camFollow.setPosition(pos.x + offset.x, pos.y + offset.y);

		if (instant)
			FlxG.camera.snapToTarget();
	}

	public function pause()
	{
		var event:ScriptEvent = new ScriptEvent(Pause);
		dispatch(event);

		if (event.cancelled)
			return;

		openSubState(new PauseSubState());
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
			opponentIcon.zIndex = healthBorder.zIndex;
			add(opponentIcon);
		}

		if (playerIcon != null)
		{
			playerIcon.camera = camHUD;
			playerIcon.zIndex = healthBorder.zIndex;
			add(playerIcon);
		}
	}

	function startSong()
	{
		dispatch(new ScriptEvent(SongStart));

		songStarted = true;

		FunkinSound.music.play();
		voices.play();
	}

	function endSong()
	{
		var event:ScriptEvent = new ScriptEvent(SongEnd);
		dispatch(event);

		if (event.cancelled)
			return;

		songEnded = true;

		FunkinSound.stopAllSounds(true);

		// Saves the song score
		final score:Int = Std.int(score);

		Save.instance.setSongScore(song.id, difficulty, score, false);

		Playlist.tallies.combine(tallies);
		Playlist.score += score;

		if (Playlist.next())
			FlxG.resetState();
		else
		{
			// Saves the level score
			if (Playlist.isStory)
				Save.instance.setLevelScore(Playlist.level.id, difficulty, Playlist.score, false);

			// Exits the state
			exit();
		}
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
		if (!FunkinSound.music.playing)
			return;

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
			if (conductor.time - event.t > Constants.MS_PER_SEC)
			{
				events.shift();
				break;
			}

			// Handle the event
			// That's if the script event wasn't cancelled though
			var event:SongEventScriptEvent = new SongEventScriptEvent(event.e, event.v);
			dispatch(event);

			if (event.cancelled)
			{
				events.shift();
				break;
			}

			EventRegistry.instance.handleEvent(event.kind, event.value);

			events.shift();

			trace('Handling event ${event.kind}.');
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
			if (note == null && pressed && !Preferences.ghostTapping && !Preferences.botplay)
				playerGhostMiss(direction);

			// Don't hit the note if nothing's being pressed
			// Especially don't hit the note if it's null
			if (!pressed || note == null)
				continue;

			var event:NoteScriptEvent = new NoteScriptEvent(NoteHit, note);
			dispatch(event);

			if (event.cancelled)
				continue;

			playerStrumline.hitNote(note);
		}

		// Opponent input
		for (note in opponentStrumline.getMayHitNotes())
		{
			var event:NoteScriptEvent = new NoteScriptEvent(NoteHit, note);
			dispatch(event);

			if (event.cancelled)
				continue;

			opponentStrumline.hitNote(note);
		}

		// The misc stuff
		// Pausing, resetting, etc.
		if (controls.PAUSE)
			pause();

		if (controls.RESET)
		{
			health = 0;
			healthLerp = 0;
		}
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

		if (note.kind != 'noanim')
			stage.player?.sing(note.direction);

		voices.playerVolume = 1;

		popups.popupJudgement(judgement);
		popups.popupCombo(tallies.combo);
	}

	function playerHoldNoteHit(holdNote:HoldNoteSprite)
	{
		var event:HoldNoteScriptEvent = new HoldNoteScriptEvent(HoldNoteHold, holdNote);
		dispatch(event);

		if (event.cancelled)
			return;

		score += Constants.HOLD_SCORE_PER_SEC * FlxG.elapsed;
		health += Constants.HOLD_HEALTH_PER_SEC * FlxG.elapsed;

		if (holdNote.kind != 'noanim')
			stage.player?.resetSingTimer();

		voices.playerVolume = 1;
	}

	function playerNoteMiss(note:NoteSprite)
	{
		var event:NoteScriptEvent = new NoteScriptEvent(NoteMiss, note);
		dispatch(event);

		if (event.cancelled)
			return;

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
		var event:GhostMissScriptEvent = new GhostMissScriptEvent(direction);
		dispatch(event);

		if (event.cancelled)
			return;

		score += Constants.GHOST_MISS_SCORE;
		health += Constants.GHOST_MISS_HEALTH;

		stage.player?.miss(direction);
		voices.playerVolume = 0;
	}

	function playerHoldNoteDrop(holdNote:HoldNoteSprite)
	{
		var event:HoldNoteScriptEvent = new HoldNoteScriptEvent(HoldNoteDrop, holdNote);
		dispatch(event);

		if (event.cancelled)
			return;

		// Takes away score based on how long the hold note is
		score += Constants.MISS_SCORE * (holdNote.length / 500);
		health += Constants.MISS_HEALTH;

		stage.player?.miss(holdNote.direction);
		voices.playerVolume = 0;
	}

	function opponentNoteHit(note:NoteSprite)
	{
		if (note.kind != 'noanim')
			stage.opponent?.sing(note.direction);
	}

	function opponentHoldNoteHit(holdNote:HoldNoteSprite)
	{
		if (holdNote.kind != 'noanim')
			stage.opponent?.resetSingTimer();
	}

	public function exit()
	{
		if (Playlist.isStory)
			StickerSubState.switchState(() -> StoryMenuSubState.build(), song.stickerpack);
		else
			StickerSubState.switchState(() -> FreeplaySubState.build(), song.stickerpack);
	}

	override function dispatch(event:ScriptEvent)
	{
		super.dispatch(event);

		ScriptEventDispatcher.dispatch(Playlist.level, event);
		ScriptEventDispatcher.dispatch(song, event);

		ScriptEventDispatcher.dispatch(stage, event);
		ScriptEventDispatcher.dispatch(stage.opponent, event);
		ScriptEventDispatcher.dispatch(stage.player, event);
		ScriptEventDispatcher.dispatch(stage.gf, event);
	}

	override public function openSubState(subState:FlxSubState)
	{
		super.openSubState(subState);

		FunkinSound.music?.pause();
		voices?.pause();

		FlxTimer.globalManager.forEach(timer ->
		{
			if (!timer.active)
				return;
			timer.active = false;
		});

		FlxTween.globalManager.forEach(tween ->
		{
			if (!tween.active)
				return;
			tween.active = false;
		});

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

		FlxTimer.globalManager.forEach(timer ->
		{
			if (timer.active)
				return;
			timer.active = true;
		});

		FlxTween.globalManager.forEach(tween ->
		{
			if (tween.active)
				return;
			tween.active = true;
		});

		FlxG.sound.defaultSoundGroup.resume();
		FlxG.camera.active = true;
	}

	override public function destroy()
	{
		super.destroy();

		// Not doing this can cause things to crash
		// Even if it's accessed in a safe way
		instance = null;

		FunkinSound.music.stop();

		// Runs the destroy script event
		dispatch(new ScriptEvent(Destroy));
	}
}

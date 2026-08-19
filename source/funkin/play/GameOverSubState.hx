package funkin.play;

import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.modding.event.ScriptEvent;
import funkin.modding.event.ScriptEventDispatcher;
import funkin.play.character.Character;
import funkin.ui.FunkinSubState;

/**
 * The game over sub state that appears when the player dies.
 */
class GameOverSubState extends FunkinSubState
{
	public static var instance:GameOverSubState;

	var retrying:Bool = false;

	var menuConductor:Conductor;

	var music:FunkinSound;
	var startSound:FunkinSound;

	var player:Character;
	var character:Character;
	var id:String;

	override function create()
	{
		super.create();

		instance = this;

		_parentState.persistentDraw = false;

		PlayState.instance.deaths++;

		// This doesn't need a unique camera
		// This should use the game's camera actually
		FlxG.cameras.remove(camera);

		camera = FlxG.camera;

		menuConductor = new Conductor();
		menuConductor.beatHit.add(beatHit);
		menuConductor.reset(100);

		player = PlayState.instance.stage.player;

		music = FunkinSound.load(player?.getDeathMusic(), 1, true, true, false);

		startSound = FunkinSound.load(player?.getDeathSFX('start'), 1, false);
		startSound.onComplete = startLoop;

		buildCharacter();

		var event:ScriptEvent = ScriptEvent.get(GAMEOVER_START);
		dispatch(event);

		if (event.cancelled)
			return close();

		if (character != null)
		{
			PlayState.instance.setCameraTarget(character);

			camera.active = true;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Updates the conductor
		menuConductor.time = music?.time;
		menuConductor.update();

		if (controls.ACCEPT_P)
			retry();
		if (controls.BACK)
			exit();
	}

	override function dispatch(event:ScriptEvent)
	{
		ScriptEventDispatcher.dispatch(character, event);

		super.dispatch(event);
	}

	function startLoop()
	{
		var event:ScriptEvent = ScriptEvent.get(GAMEOVER_LOOP);
		dispatch(event);

		if (event.cancelled)
			return;

		music.play();
	}

	function retry()
	{
		if (retrying)
			return;

		var event:ScriptEvent = ScriptEvent.get(GAMEOVER_RETRY);
		dispatch(event);

		if (event.cancelled)
			return;

		retrying = true;

		character?.playAnimation('end');

		music.destroy();
		startSound.destroy();

		// Gotta reset this!
		// Or else the character keeps bopping
		menuConductor.reset();

		FunkinSound.playOnce(player?.getDeathSFX('end'));

		FlxTimer.wait(1, () -> camera.fade(0xFF000000, 2, false, close));
	}

	function exit()
	{
		if (retrying)
			return;
		PlayState.instance.exit();
	}

	function buildCharacter()
	{
		character = player?.buildDeathCharacter();
		character?.playAnimation('start');

		if (character == null)
			return;

		add(character);
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		character?.playAnimation('loop', true);
	}

	override function close()
	{
		super.close();

		_parentState.persistentDraw = true;

		camera.fade(0xFF000000, 1, true);

		PlayState.instance.loadSong();
	}

	override function destroy()
	{
		super.destroy();

		instance = null;
	}
}

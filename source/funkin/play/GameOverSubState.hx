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

	public var retrying:Bool = false;

	public var music:FunkinSound;
	public var character:Character;

	var _conductor:Conductor;
	var startTimer:FlxTimer;

	var player(get, never):Character;

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

		_conductor = new Conductor();
		_conductor.beatHit.add(beatHit);
		_conductor.reset(100);

		music = FunkinSound.load(player?.getDeathMusic(), 1, true, true, false);
		startTimer = FlxTimer.wait(1.5, startLoop);

		FunkinSound.load(player?.getDeathSFX('start'), 1, false);

		buildCharacter();

		if (character != null)
		{
			PlayState.instance.setCameraTarget(character);

			camera.active = true;
		}

		var event:ScriptEvent = ScriptEvent.get(GAMEOVER_START);
		dispatch(event);

		if (event.cancelled)
			close();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_conductor.time = music?.time;
		_conductor.update();

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
		startTimer.cancel();

		_conductor.reset();

		FunkinSound.stopAllSounds();
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

		if (character != null)
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
		startTimer.cancel();
	}

	@:noCompletion
	inline function get_player():Character
	{
		return PlayState.instance.stage.player;
	}
}

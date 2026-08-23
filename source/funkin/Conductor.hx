package funkin;

import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * The conductor class for the game. This is what handles steps and beats and all that crap.
 */
class Conductor
{
	public static var instance:Conductor;

	public var time(default, set):Float;
	public var bpm(default, set):Float;

	public var step(get, never):Int;
	public var beat(get, never):Int;

	public var crotchet(get, never):Float;
	public var quaver(get, never):Float;

	/**
	 * TODO: Make this changeable ingame.
	 */
	public var offset:Float = 0;

	public var stepHit(default, null) = new FlxTypedSignal<Int->Void>();
	public var beatHit(default, null) = new FlxTypedSignal<Int->Void>();

	var changeStep:Int = 0;
	var changeTimestamp:Float = 0;

	public function new() {}

	/**
	 * Resets everything, including time, BPM, and steps.
	 * You're going to want to run this whenever music is changed.
	 */
	public function reset(bpm:Float = 0)
	{
		time = 0;

		changeStep = 0;
		changeTimestamp = 0;

		this.bpm = bpm;
	}

	@:noCompletion
	function set_time(value:Float):Float
	{
		final lastStep:Int = step;
		final lastBeat:Int = beat;

		time = value;

		if (lastStep != step)
			stepHit.dispatch(step);
		if (lastBeat != beat)
			beatHit.dispatch(beat);

		// Debug watching (for debugging purposes)
		FlxG.watch.addQuick('time', time);
		FlxG.watch.addQuick('bpm', bpm);
		FlxG.watch.addQuick('step', step);
		FlxG.watch.addQuick('beat', beat);

		return time;
	}

	@:noCompletion
	function set_bpm(value:Float):Float
	{
		bpm = value;

		changeStep = step;
		changeTimestamp = time;

		return bpm;
	}

	@:noCompletion
	function get_step():Int
	{
		return changeStep + Math.floor((time - changeTimestamp) / quaver);
	}

	@:noCompletion
	function get_beat():Int
	{
		return Math.floor(step / Constants.STEPS_PER_BEAT);
	}

	@:noCompletion
	function get_crotchet():Float
	{
		return Constants.SECS_PER_MIN / bpm * Constants.MS_PER_SEC;
	}

	@:noCompletion
	function get_quaver():Float
	{
		return crotchet / Constants.STEPS_PER_BEAT;
	}
}

package funkin.ui;

import flixel.FlxState;
import funkin.input.Controls;
import funkin.modding.event.ScriptEvent;
import funkin.modding.module.ModuleHandler;

/**
 * A class used as the base for all the game's states.
 */
class FunkinState extends FlxState
{
	var conductor(get, never):Conductor;
	var controls(get, never):Controls;

	public function new()
	{
		super();

		// Adds conductor callbacks
		conductor.stepHit.add(stepHit);
		conductor.beatHit.add(beatHit);
		conductor.sectionHit.add(sectionHit);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		dispatch(new UpdateScriptEvent(elapsed));
	}

	public function dispatch(event:ScriptEvent)
	{
		// Don't run the create, update, or destroy events for modules
		// Modules handle these events on their own
		if (event.type == Create || event.type == Update || event.type == Destroy)
			return;

		ModuleHandler.dispatch(event);
	}

	function stepHit(step:Int)
		dispatch(new ConductorScriptEvent(StepHit, step, conductor.beat, conductor.section));

	function beatHit(beat:Int)
		dispatch(new ConductorScriptEvent(BeatHit, conductor.step, beat, conductor.section));

	function sectionHit(section:Int)
		dispatch(new ConductorScriptEvent(SectionHit, conductor.step, conductor.beat, section));

	override public function destroy()
	{
		super.destroy();

		// Removes conductor callbacks
		conductor.stepHit.remove(stepHit);
		conductor.beatHit.remove(beatHit);
		conductor.sectionHit.remove(sectionHit);
	}

	inline function get_conductor():Conductor
		return Conductor.instance;

	inline function get_controls():Controls
		return Controls.instance;
}

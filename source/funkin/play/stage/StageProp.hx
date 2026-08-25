package funkin.play.stage;

import funkin.data.stage.StageData.PropAnimData;
import funkin.graphics.FunkinSprite;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;

/**
 * A `FunkinSprite` used for the props of a `Stage`.
 */
class StageProp extends FunkinSprite implements IPlayStateScriptedClass
{
	public final id:String;

	public var idleSuffix:String = '';
	public var bopEvery:Int = 1;

	public function new(id:String)
	{
		super();

		this.id = id;
	}

	public function loadAnimations(animations:Array<PropAnimData>)
	{
		for (anim in animations)
		{
			if (anim == null)
				continue;
			addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);
		}
	}

	public function bop(force:Bool = false)
	{
		if (Conductor.instance.beat % bopEvery == 0 || force)
			playAnimation('idle$idleSuffix', true);
	}

	public function onCreate(event:ScriptEvent) {}

	public function onUpdate(event:UpdateScriptEvent) {}

	public function onDestroy(event:ScriptEvent) {}

	public function onScriptEvent(event:ScriptEvent) {}

	public function onNoteHit(event:NoteScriptEvent) {}

	public function onNoteMiss(event:NoteScriptEvent) {}

	public function onNoteIncoming(event:NoteScriptEvent) {}

	public function onHoldNoteHold(event:HoldNoteScriptEvent) {}

	public function onHoldNoteDrop(event:HoldNoteScriptEvent) {}

	public function onGhostMiss(event:GhostMissScriptEvent) {}

	public function onStepHit(event:ConductorScriptEvent) {}

	public function onBeatHit(event:ConductorScriptEvent)
	{
		bop();
	}

	public function onSongLoaded(event:SongLoadScriptEvent) {}

	public function onSongStart(event:ScriptEvent) {}

	public function onSongEnd(event:ScriptEvent) {}

	public function onSongRetry(event:ScriptEvent) {}

	public function onSongEvent(event:SongEventScriptEvent) {}

	public function onCountdownStart(event:CountdownScriptEvent) {}

	public function onCountdownStep(event:CountdownScriptEvent) {}

	public function onPause(event:ScriptEvent) {}

	public function onResume(event:ScriptEvent) {}

	public function onGameOverStart(event:ScriptEvent) {}

	public function onGameOverLoop(event:ScriptEvent) {}

	public function onGameOverRetry(event:ScriptEvent) {}
}

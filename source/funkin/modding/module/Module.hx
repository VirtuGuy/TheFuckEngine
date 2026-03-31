package funkin.modding.module;

import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.play.components.Countdown;

/**
 * A class that serves as an advanced script class for mods.
 * Unlike any scripted class, this runs globally.
 */
class Module implements IPlayStateScriptedClass
{
    public final id:String;
    
    public var active:Bool = true;

    /**
     * Disabling this means that only updates when the game isn't paused.
     * Disable this if you want it to pause with the current state.
     */
    public var alwaysUpdate:Bool = true;
    
    public function new(id:String)
    {
        this.id = id;
    }

    public function onCreate(event:ScriptEvent) {}
    public function onUpdate(event:UpdateScriptEvent) {}
    public function onDestroy(event:ScriptEvent) {}

    public function onNoteHit(event:NoteScriptEvent) {}
    public function onNoteMiss(event:NoteScriptEvent) {}
    public function onHoldNoteHold(event:HoldNoteScriptEvent) {}
    public function onHoldNoteDrop(event:HoldNoteScriptEvent) {}
    public function onGhostMiss(event:GhostMissScriptEvent) {}

    public function onStepHit(event:ConductorScriptEvent) {}
    public function onBeatHit(event:ConductorScriptEvent) {}
    public function onSectionHit(event:ConductorScriptEvent) {}

    public function onSongLoaded(event:SongLoadScriptEvent) {}
    public function onSongStart(event:ScriptEvent) {}
    public function onSongEnd(event:ScriptEvent) {}
    public function onSongRetry(event:ScriptEvent) {}
    public function onCountdownStart(event:CountdownScriptEvent) {}
    public function onCountdownStep(event:CountdownScriptEvent) {}
    public function onPause(event:ScriptEvent) {}
    public function onGameOver(event:ScriptEvent) {}

    public function toString():String
        return '$id | $active';
}
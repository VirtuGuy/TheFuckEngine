package funkin.modding.event;

import funkin.modding.IScriptedClass;

/**
 * A class for dispatching script events.
 */
class ScriptEventDispatcher
{
    public static function dispatch(target:Null<IScriptedClass>, event:ScriptEvent)
    {
        // Can't dispatch an event when the target's null
        // Especially when the event itself is null
        if (target == null || event == null) return;

        //
        // BASIC
        //

        switch (event.type)
        {
            case Create:
                target.onCreate(event);
            case Update:
                target.onUpdate(cast event);
            case Destroy:
                target.onDestroy(event);
            default:
                // Does literally nothing
        }

        //
        // NOTE
        //

        if (Std.isOfType(target, INoteScriptedClass))
        {
            var target:INoteScriptedClass = cast target;

            switch (event.type)
            {
                case NoteHit:
                    target.onNoteHit(cast event);
                case NoteMiss:
                    target.onNoteMiss(cast event);
                case HoldNoteHold:
                    target.onHoldNoteHold(cast event);
                case HoldNoteDrop:
                    target.onHoldNoteDrop(cast event);
                case GhostMiss:
                    target.onGhostMiss(cast event);
                default:
                    // Does literally nothing
            }
        }

        //
        // CONDUCTOR
        //

        if (Std.isOfType(target, IConductorScriptedClass))
        {
            var target:IConductorScriptedClass = cast target;

            switch (event.type)
            {
                case StepHit:
                    target.onStepHit(cast event);
                case BeatHit:
                    target.onBeatHit(cast event);
                case SectionHit:
                    target.onSectionHit(cast event);
                default:
                    // Does literally nothing
            }
        }

        //
        // PLAYSTATE
        //

        if (Std.isOfType(target, IPlayStateScriptedClass))
        {
            var target:IPlayStateScriptedClass = cast target;

            switch (event.type)
            {
                case SongLoad:
                    target.onSongLoaded(cast event);
                case SongStart:
                    target.onSongStart(event);
                case SongEnd:
                    target.onSongEnd(event);
                case SongRetry:
                    target.onSongRetry(event);
                case SongEvent:
                    target.onSongEvent(cast event);
                case CountdownStart:
                    target.onCountdownStart(cast event);
                case CountdownStep:
                    target.onCountdownStep(cast event);
                case Pause:
                    target.onPause(event);
                case GameOver:
                    target.onGameOver(event);
                default:
                    // Does literally nothing
            }
        }
    }
}
package funkin.modding.event;

import funkin.data.event.EventData;
import funkin.data.song.SongData.SongNoteData;
import funkin.play.note.HoldNoteSprite;
import funkin.play.note.NoteDirection;
import funkin.play.note.NoteSprite;

/**
 * The base class for all the engine's script events.
 */
class ScriptEvent
{
    public var type(default, null):ScriptEventType;
    public var cancelled(default, null):Bool = false;

    public function new(type:ScriptEventType)
    {
        this.type = type;
    }

    public function cancel()
        cancelled = true;
}

/**
 * A script event that runs for every game update.
 */
class UpdateScriptEvent extends ScriptEvent
{
    public var elapsed(default, null):Float;

    public function new(elapsed:Float)
    {
        super(Update);

        this.elapsed = elapsed;
    }
}

/**
 * A script event that runs for the conductor.
 */
class ConductorScriptEvent extends ScriptEvent
{
    public var step(default, null):Int;
    public var beat(default, null):Int;
    public var section(default, null):Int;

    public function new(type:ScriptEventType, step:Int, beat:Int, section:Int)
    {
        super(type);

        this.step = step;
        this.beat = beat;
        this.section = section;
    }
}

/**
 * A script event that runs when the song is loaded.
 */
class SongLoadScriptEvent extends ScriptEvent
{
    public var notes:Array<SongNoteData>;
    public var events:Array<EventData>;

    public function new(notes:Array<SongNoteData>, events:Array<EventData>)
    {
        super(SongLoad);

        this.notes = notes;
        this.events = events;
    }
}

/**
 * The base script event that runs for regular notes.
 * 
 * This event is cancelable.
 */
class NoteScriptEvent extends ScriptEvent
{
    public var note(default, null):NoteSprite;

    public function new(type:ScriptEventType, note:NoteSprite)
    {
        super(type);

        this.note = note;
    }
}

/**
 * The base script event that runs for hold notes.
 * 
 * This event is cancelable.
 */
class HoldNoteScriptEvent extends ScriptEvent
{
    public var holdNote(default, null):HoldNoteSprite;

    public function new(type:ScriptEventType, holdNote:HoldNoteSprite)
    {
        super(type);

        this.holdNote = holdNote;
    }
}

/**
 * A script event that runs when a song event occurs.
 * 
 * This event is cancelable.
 */
class SongEventScriptEvent extends ScriptEvent
{
    public var kind:String;
    public var value:Dynamic;

    public function new(kind:String, value:Dynamic)
    {
        super(SongEvent);

        this.kind = kind;
        this.value = value;
    }
}

/**
 * A script event that runs when a ghost miss occurs.
 * 
 * This event is cancelable.
 */
class GhostMissScriptEvent extends ScriptEvent
{
    public var direction(default, null):NoteDirection;

    public function new(direction:NoteDirection)
    {
        super(GhostMiss);

        this.direction = direction;
    }
}

/**
 * A script event that runs for the countdown.
 * 
 * This event is cancelable.
 */
class CountdownScriptEvent extends ScriptEvent
{
    public var step(default, null):Int;

    public function new(type:ScriptEventType, step:Int)
    {
        super(type);

        this.step = step;
    }
}
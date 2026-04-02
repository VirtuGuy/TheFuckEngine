package funkin.modding.event;

/**
 * An enum of the different script event types.
 */
enum ScriptEventType
{
    Create;
    Update;
    Destroy;
    NoteHit;
    NoteMiss;
    HoldNoteHold;
    HoldNoteDrop;
    GhostMiss;
    StepHit;
    BeatHit;
    SectionHit;
    SongLoad;
    SongStart;
    SongEnd;
    SongRetry;
    SongEvent;
    CountdownStart;
    CountdownStep;
    Pause;
    GameOver;
}
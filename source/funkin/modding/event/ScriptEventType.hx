package funkin.modding.event;

/**
 * An enum of the different script event types.
 */
enum ScriptEventType
{
	//
	// BASIC
	//
	Create;
	Update;
	Destroy;

	//
	// NOTE
	//
	NoteHit;
	NoteMiss;
	HoldNoteHold;
	HoldNoteDrop;
	GhostMiss;

	//
	// CONDUCTOR
	//
	StepHit;
	BeatHit;
	SectionHit;

	//
	// PLAYSTATE
	//
	SongLoad;
	SongStart;
	SongEnd;
	SongRetry;
	SongEvent;
	CountdownStart;
	CountdownStep;
	Pause;
	GameOver;

	//
	// FREEPLAY
	//
	FreeplayEnter;
	FreeplayExit;
	FreeplayIntro;
	FreeplayOutro;
	FreeplayIntroDone;
	FreeplayOutroDone;
	FreeplaySongSelected;
	FreeplaySongFavorited;
}

package funkin.play.note.strum;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSort;
import funkin.data.song.SongData;
import funkin.play.note.hold.HoldNoteCover;
import funkin.play.note.hold.HoldNoteSprite;
import funkin.util.RhythmUtil;
import funkin.util.SortUtil;

/**
 * An `FlxGroup` containing strums and notes.
 */
class Strumline extends FlxGroup
{
	public var isPlayer:Bool;

	public var data:Array<SongNoteData> = [];
	public var speed(default, set):Float;

	public var x(get, set):Float;

	public var strums:FlxTypedSpriteGroup<StrumSprite>;
	public var notes:FlxTypedGroup<NoteSprite>;
	public var holdNotes:FlxTypedGroup<HoldNoteSprite>;
	public var noteSplashes:FlxTypedGroup<NoteSplash>;
	public var holdCovers:FlxTypedGroup<HoldNoteCover>;

	var nextNoteIndex:Int;
	var style:Style;

	public function new(style:Style, isPlayer:Bool)
	{
		super();

		this.style = style;
		this.isPlayer = isPlayer;

		strums = new FlxTypedSpriteGroup<StrumSprite>();
		add(strums);

		noteSplashes = new FlxTypedGroup<NoteSplash>();
		add(noteSplashes);

		holdNotes = new FlxTypedGroup<HoldNoteSprite>();
		add(holdNotes);

		holdCovers = new FlxTypedGroup<HoldNoteCover>();
		add(holdCovers);

		notes = new FlxTypedGroup<NoteSprite>();
		add(notes);

		buildStrums();
	}

	public function process()
	{
		// Spawns the notes
		for (i in nextNoteIndex...data.length)
		{
			final noteData:SongNoteData = data[i];

			// Skip the note if it's null
			if (noteData == null)
			{
				nextNoteIndex = i + 1;
				continue;
			}

			final time:Float = noteData.t;
			final direction:NoteDirection = NoteDirection.fromInt(noteData.d);
			final kind:String = noteData.k;
			final length:Float = noteData.l;

			// Skip the note if it's in the past
			if (RhythmUtil.getDistance(time, speed) < 0)
			{
				nextNoteIndex = i + 1;
				continue;
			}

			// The note is too far away to spawn
			if (RhythmUtil.getDistance(time, speed) > FlxG.height)
				break;

			// Creates a note
			var note:NoteSprite = notes.recycle(NoteSprite);

			if (note.graphic == null)
				note.buildSprite(style);

			note.strum = getStrum(direction);

			note.time = time;
			note.direction = direction;
			note.kind = kind;

			note.data = noteData;
			note.speed = speed;

			// Creates a hold note
			// However, its length has to be lengthy enough to be considered length
			if (length > 25)
			{
				var holdNote:HoldNoteSprite = holdNotes.recycle(HoldNoteSprite);

				if (holdNote.graphic == null)
					holdNote.buildSprite(style);

				holdNote.strum = note.strum;

				holdNote.time = time;
				holdNote.direction = direction;
				holdNote.kind = kind;
				holdNote.length = length;
				holdNote.fullLength = length;

				holdNote.data = noteData;
				holdNote.speed = speed;

				note.holdNote = holdNote;
			}

			// Sorts the notes
			// Not doing this will mess up the input
			notes.sort((i, a, b) -> return SortUtil.byTime(FlxSort.ASCENDING, a.data, b.data));
			holdNotes.sort((i, a, b) -> return SortUtil.byTime(FlxSort.ASCENDING, a.data, b.data));

			nextNoteIndex = i + 1;
		}

		// Note processing
		notes.forEachAlive(note ->
		{
			final isOffscreen:Bool = Preferences.downscroll ? note.y > FlxG.height : note.y < -note.height;

			if (isOffscreen && note.wasMissed)
				note.kill();

			RhythmUtil.processHitWindow(note, isPlayer);
		});

		// Hold note processing
		holdNotes.forEachAlive(holdNote ->
		{
			if (holdNote.wasHit)
			{
				getStrum(holdNote.direction).playConfirm();

				if (holdNote.length <= 10)
					holdNote.kill();
			}

			final isOffscreen:Bool = Preferences.downscroll ? holdNote.y > FlxG.height : holdNote.y < -holdNote.height;

			if (isOffscreen)
				holdNote.kill();
		});
	}

	public function buildStrums()
	{
		for (direction in 0...Constants.NOTE_COUNT)
		{
			var strum:StrumSprite = new StrumSprite(direction);

			strum.buildSprite(style);
			strum.x = (direction - Constants.NOTE_COUNT / 2) * strum.width;

			strums.add(strum);
		}
	}

	public function updateScroll()
	{
		strums.y = 60;

		if (Preferences.downscroll)
			strums.y = FlxG.height - strums.height - strums.y;
	}

	public function load(notes:Array<SongNoteData>, speed:Float)
	{
		// Notes NEED to be sorted
		notes.sort(SortUtil.byTime.bind(FlxSort.ASCENDING));

		nextNoteIndex = 0;

		this.data = notes;
		this.speed = speed;
	}

	public function hitNote(note:NoteSprite)
	{
		getStrum(note.direction).playConfirm();

		if (note.holdNote != null)
		{
			note.holdNote.wasHit = true;

			// Plays the hold cover here because this runs once
			playHoldCover(note.holdNote);
		}

		note.kill();
	}

	public function playSplash(direction:NoteDirection)
	{
		var splash:NoteSplash = noteSplashes.recycle(NoteSplash);
		var strum:StrumSprite = getStrum(direction);

		if (splash.graphic == null)
			splash.buildSprite(style);

		splash.play(strum);
	}

	public function playHoldCover(holdNote:HoldNoteSprite)
	{
		var cover:HoldNoteCover = holdCovers.recycle(HoldNoteCover);
		var strum:StrumSprite = getStrum(holdNote.direction);

		if (cover.graphic == null)
			cover.buildSprite(style);

		cover.play(holdNote, strum);
	}

	public function clean()
	{
		// Kill instead of destroy because of recycling
		notes.killMembers();
		holdNotes.killMembers();
		noteSplashes.killMembers();
		holdCovers.killMembers();

		// Clears the note data because we're cleaning, aren't we?
		data = [];
		speed = 0;

		nextNoteIndex = -1;
	}

	public function getCurrentNotes():Array<NoteSprite>
	{
		return notes.members.filter(note -> return note.alive);
	}

	public function getMayHitNotes():Array<NoteSprite>
	{
		return notes.members.filter(note -> return note.alive && note.mayHit && !note.willMiss);
	}

	public function getHeldHoldNotes():Array<HoldNoteSprite>
	{
		return holdNotes.members.filter(holdNote -> return holdNote.alive && holdNote.wasHit);
	}

	public function getMissedNotes():Array<NoteSprite>
	{
		return notes.members.filter(note -> return note.alive && note.willMiss && !note.wasMissed);
	}

	public function getStrum(direction:NoteDirection):StrumSprite
	{
		return strums.members[direction];
	}

	@:noCompletion
	function set_speed(value:Float):Float
	{
		value = Math.max(0, value);

		if (this.speed == value)
			return value;
		this.speed = value;

		notes.forEachAlive(note -> note.speed = value);
		holdNotes.forEachAlive(holdNote -> holdNote.speed = value);

		return value;
	}

	@:noCompletion
	inline function set_x(value:Float):Float
	{
		return strums.x = value;
	}

	@:noCompletion
	inline function get_x():Float
	{
		return strums.x;
	}
}

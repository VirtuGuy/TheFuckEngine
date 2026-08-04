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
	public var speed:Float;

	public var x(get, set):Float;

	public var strums:FlxTypedSpriteGroup<StrumSprite>;
	public var notes:FlxTypedGroup<NoteSprite>;
	public var holdNotes:FlxTypedGroup<HoldNoteSprite>;
	public var noteSplashes:FlxTypedGroup<NoteSplash>;
	public var holdCovers:FlxTypedGroup<HoldNoteCover>;

	var nextNoteIndex:Int;
	var style:NoteStyle;

	public function new(style:NoteStyle, isPlayer:Bool)
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
			final distance:Float = RhythmUtil.getDistance(noteData?.t, speed);

			// Skip the note if it's null
			if (noteData == null || distance < 0)
			{
				nextNoteIndex = i + 1;
				continue;
			}

			// The note is too far away to spawn
			if (distance > FlxG.height)
				break;

			var note:NoteSprite = buildNote(noteData);

			if (noteData.l > 25)
				note.holdNote = buildHoldNote(noteData);

			nextNoteIndex = i + 1;
		}

		// Note processing
		notes.forEachAlive(note ->
		{
			final strum:StrumSprite = getStrum(note.direction);
			final distance:Float = RhythmUtil.getDistance(note.time, speed);

			note.x = strum.x;
			note.y = strum.y + distance * (Preferences.downscroll ? -1 : 1);

			final isOffscreen:Bool = Preferences.downscroll ? note.y > FlxG.height : note.y < -note.height;

			if (isOffscreen && note.wasMissed)
				note.kill();

			RhythmUtil.processHitWindow(note, isPlayer);
		});

		// Hold note processing
		holdNotes.forEachAlive(holdNote ->
		{
			final strum:StrumSprite = getStrum(holdNote.direction);
			final distance:Float = RhythmUtil.getDistance(holdNote.time, speed);

			holdNote.x = strum.x + (strum.width - holdNote.width) / 2;
			holdNote.y = strum.middle + distance * (Preferences.downscroll ? -1 : 1);

			holdNote.flipY = Preferences.downscroll;
			holdNote.speed = speed;

			if (holdNote.wasHit)
			{
				holdNote.y = strum.middle;
				holdNote.length = holdNote.time - Conductor.instance.time + holdNote.fullLength;

				getStrum(holdNote.direction).playConfirm();

				if (holdNote.length <= 10)
					holdNote.kill();
			}

			final isOffscreen:Bool = Preferences.downscroll ? holdNote.y > FlxG.height + holdNote.height : holdNote.y < -holdNote.height;

			if (isOffscreen && holdNote.wasMissed)
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

		process();
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

	public function missNote(note:NoteSprite)
	{
		note.wasMissed = true;

		if (note.holdNote != null)
			note.holdNote.wasMissed = true;
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

	function buildNote(data:SongNoteData):NoteSprite
	{
		var note:NoteSprite = notes.recycle(NoteSprite);

		if (note.graphic == null)
			note.buildSprite(style);

		note.y = 9999;
		note.data = data;

		notes.sort((i, a, b) -> return SortUtil.byTime(FlxSort.ASCENDING, a.data, b.data));

		return note;
	}

	function buildHoldNote(data:SongNoteData):HoldNoteSprite
	{
		var holdNote:HoldNoteSprite = holdNotes.recycle(HoldNoteSprite);

		if (holdNote.graphic == null)
			holdNote.buildSprite(style);

		holdNote.y = 9999;
		holdNote.data = data;
		holdNote.speed = speed;

		holdNotes.sort((i, a, b) -> return SortUtil.byTime(FlxSort.ASCENDING, a.data, b.data));

		return holdNote;
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

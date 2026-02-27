package funkin.play.note;

import flixel.group.FlxGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSort;
import funkin.data.song.SongData;
import funkin.util.RhythmUtil;

/**
 * An `FlxGroup` containing strums and notes.
 */
class Strumline extends FlxGroup
{
    public var data:Array<SongNoteData> = [];
    public var speed(default, set):Float;

    public var offset(default, set):Float = 0.5;
    public var spacing(default, set):Float = 0;

    public var strums:FlxTypedGroup<StrumSprite>;
    public var notes:FlxTypedGroup<NoteSprite>;
    public var holdNotes:FlxTypedGroup<HoldNoteSprite>;
    public var noteSplashes:FlxTypedGroup<NoteSplash>;
    public var holdCovers:FlxTypedGroup<HoldNoteCover>;

    public var noteHit(default, null) = new FlxTypedSignal<NoteSprite->Void>();
    public var noteMiss(default, null) = new FlxTypedSignal<NoteSprite->Void>();
    public var holdNoteHit(default, null) = new FlxTypedSignal<HoldNoteSprite->Void>();
    public var holdNoteDrop(default, null) = new FlxTypedSignal<HoldNoteSprite->Void>();

    public function new()
    {
        super();

        strums = new FlxTypedGroup<StrumSprite>();
        add(strums);

        noteSplashes = new FlxTypedGroup<NoteSplash>(Constants.NOTE_COUNT);
        add(noteSplashes);

        holdNotes = new FlxTypedGroup<HoldNoteSprite>();
        add(holdNotes);

        holdCovers = new FlxTypedGroup<HoldNoteCover>(Constants.NOTE_COUNT);
        add(holdCovers);

        notes = new FlxTypedGroup<NoteSprite>();
        add(notes);

        // Builds the strums
        for (direction in 0...Constants.NOTE_COUNT)
        {
            var strum:StrumSprite = new StrumSprite(direction);
            strum.y = 60;

            if (Preferences.downscroll) strum.y = FlxG.height - strum.height - strum.y;

            strums.add(strum);
        }

        positionStrums();
    }

    public function process(isPlayer:Bool)
    {
        // Spawns the notes
        while (data[0] != null)
        {
            final noteData:SongNoteData = data[0];
            final time:Float = noteData.t;
            final direction:NoteDirection = NoteDirection.fromInt(noteData.d);
            final length:Float = noteData.l;

            if (RhythmUtil.getDistance(time, speed) > FlxG.height) break;

            // Skip the note if it's in the past
            if (RhythmUtil.getDistance(time, speed) < 0)
            {
                data.shift();
                break;
            }

            // Creates a note
            var note:NoteSprite = notes.recycle(NoteSprite);

            note.time = time;
            note.direction = direction;

            // Creates a hold note
            // However, its length has to be lengthy enough to be considered length
            if (length > 25)
            {
                var holdNote:HoldNoteSprite = holdNotes.recycle(HoldNoteSprite);

                holdNote.time = time;
                holdNote.direction = direction;
                holdNote.speed = speed;

                holdNote.fullLength = length;
                holdNote.length = length;
                holdNote.flipY = Preferences.downscroll;

                note.holdNote = holdNote;
            }

            data.shift();

            // Sorts the notes
            // Not doing this will mess up the input
            notes.sort((i, note1, note2) -> return FlxSort.byValues(FlxSort.ASCENDING, note1.time, note2.time));
            holdNotes.sort((i, note1, note2) -> return FlxSort.byValues(FlxSort.ASCENDING, note1.time, note2.time));
        }

        // Note processing
        notes.forEachAlive(note -> {
            final strum:StrumSprite = getStrum(note.direction);
            final distance:Float = RhythmUtil.getDistance(note.time, speed);

            // Positions the note
            note.x = strum.x;
            note.y = strum.y + distance * (Preferences.downscroll ? -1 : 1);

            if (distance <= -strum.y - note.height) note.kill();

            RhythmUtil.processHitWindow(note, isPlayer);

            // Miss the note if the note misses
            // No shit lol
            if (note.willMiss && !note.wasMissed)
            {
                note.wasMissed = true;
                noteMiss.dispatch(note);
            }
        });

        // Hold note processing
        holdNotes.forEachAlive(holdNote -> {
            final strum:StrumSprite = getStrum(holdNote.direction);  
            final distance:Float = RhythmUtil.getDistance(holdNote.time, speed);
            final y:Float = strum.y + strum.height / 2;

            // Positions the hold note
            holdNote.x = strum.x + (strum.width - holdNote.width) / 2;
            holdNote.y = y + distance * (Preferences.downscroll ? -1 : 1);

            if (distance <= -y - holdNote.height && !holdNote.wasHit) holdNote.kill();

            // Hold note input
            if (holdNote.wasHit)
            {
                if (!holdNote.direction.pressed && isPlayer)
                {
                    // Drops the hold note
                    holdNote.kill();
                    holdNoteDrop.dispatch(holdNote);

                    return;
                }

                playConfirm(holdNote.direction);

                holdNote.length = holdNote.time - Conductor.instance.time + holdNote.fullLength;
                holdNote.y = y;

                holdNoteHit.dispatch(holdNote);

                // Kill the hold note if it's short enough
                if (holdNote.length <= 10) holdNote.kill();
            }
        });

        // Strum processing
        strums.forEachAlive(strum -> {
            final pressed:Bool = strum.direction.pressed;

            if (strum.confirmTime > 0 && (pressed || !isPlayer))
                strum.playAnimation('confirm');
            else if (pressed && isPlayer)
                strum.playAnimation('press');
            else
                strum.playAnimation('static');
        });
    }

    public function hitNote(note:NoteSprite)
    {
        playConfirm(note.direction);

        if (note.holdNote != null)
        {
            note.holdNote.wasHit = true;

            // Plays the hold cover here because this runs once
            playHoldCover(note.holdNote);
        }

        note.kill();
        noteHit.dispatch(note);
    }

    public function playConfirm(direction:NoteDirection)
        getStrum(direction).confirmTime = 1;

    public function playSplash(direction:NoteDirection)
    {
        final splash:NoteSplash = noteSplashes.recycle(NoteSplash);
        final strum:StrumSprite = getStrum(direction);

        splash.play(strum);
    }

    public function playHoldCover(holdNote:HoldNoteSprite)
    {
        final cover:HoldNoteCover = holdCovers.recycle(HoldNoteCover);
        final strum:StrumSprite = getStrum(holdNote.direction);

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
    }

    public function getMayHitNotes():Array<NoteSprite>
        return notes.members.filter(note -> return note.alive && note.mayHit && !note.willMiss);

    public function getStrum(direction:NoteDirection):StrumSprite
        return strums.members[direction];

    function positionStrums()
    {
        strums.forEach(strum -> {
            final off:Float = (strum.direction - Constants.NOTE_COUNT / 2);

            strum.x = FlxG.width * offset + off * (strum.width + spacing);
            strum.x += spacing / 2;
        });
    }

    function set_speed(speed:Float):Float
    {
        speed = Math.max(0, speed);

        if (this.speed == speed) return speed;
        this.speed = speed;

        holdNotes.forEachAlive(holdNote -> holdNote.speed = speed);

        return speed;
    }

    function set_offset(offset:Float):Float
    {
        if (this.offset == offset) return offset;
        this.offset = offset;

        positionStrums();

        return offset;
    }

    function set_spacing(spacing:Float):Float
    {
        if (this.spacing == spacing) return spacing;
        this.spacing = spacing;

        positionStrums();

        return spacing;
    }
}
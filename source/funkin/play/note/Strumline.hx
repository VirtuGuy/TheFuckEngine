package funkin.play.note;

import flixel.FlxG;
import flixel.group.FlxGroup;
import funkin.data.song.SongData.SongNoteData;
import funkin.util.SortUtil;

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

    var isPlayer:Bool;
    var songTime(get, never):Float;

    public function new()
    {
        super();

        strums = new FlxTypedGroup<StrumSprite>();
        notes = new FlxTypedGroup<NoteSprite>();
        holdNotes = new FlxTypedGroup<HoldNoteSprite>();
        noteSplashes = new FlxTypedGroup<NoteSplash>(Constants.NOTE_COUNT);
        holdCovers = new FlxTypedGroup<HoldNoteCover>(Constants.NOTE_COUNT);

        // Order:
        // Strums, note splashes, hold notes, hold covers, and notes
        add(strums);
        add(noteSplashes);
        add(holdNotes);
        add(holdCovers);
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
        this.isPlayer = isPlayer;

        // Spawns the notes
        while (data.length > 0)
        {
            var noteData:SongNoteData = data[0];

            var time:Float = noteData.t;
            var direction:NoteDirection = NoteDirection.fromInt(noteData.d);
            var length:Float = noteData.l;

            if (getDistance(time) > FlxG.height) break;

            // Creates a note
            var note:NoteSprite = notes.recycle(NoteSprite);

            note.time = time;
            note.direction = direction;

            // Creates a hold note
            if (length > 0)
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
        }

        // Note processing
        notes.forEachAlive(note -> {
            var strum:StrumSprite = getStrum(note.direction);
            var distance:Float = getDistance(note.time);

            // Positions the note
            note.x = strum.x;
            note.y = strum.y + distance * (Preferences.downscroll ? -1 : 1);

            if (distance <= -strum.y - note.height) missNote(note);

            // Checks if the note can be hit
            var hitStart:Float = note.time;
            var hitEnd:Float = note.time + Constants.HIT_WINDOW_MS;

            // Give the player some extra time to hit the note
            // Not having this line will create something known as FNF EXTREME DIFFICULTY
            if (isPlayer) hitStart -= Constants.HIT_WINDOW_MS;

            if (songTime >= hitEnd) note.tooLate = true;
            if (songTime >= hitStart) note.mayHit = true;
        });

        // Hold note processing
        holdNotes.forEachAlive(holdNote -> {
            var strum:StrumSprite = getStrum(holdNote.direction);  
            var distance:Float = getDistance(holdNote.time);
            var y:Float = strum.y + strum.height / 2;

            // Positions the hold note
            holdNote.x = strum.x + (strum.width - holdNote.width) / 2;
            holdNote.y = y + distance * (Preferences.downscroll ? -1 : 1);

            if (distance <= -y - holdNote.height && !holdNote.wasHit) dropHoldNote(holdNote);

            // Hold note input
            if (holdNote.wasHit)
            {
                if (!holdNote.direction.pressed && isPlayer)
                {
                    dropHoldNote(holdNote);
                    return;
                }

                playConfirm(holdNote.direction);

                holdNote.length = holdNote.time - songTime + holdNote.fullLength;
                holdNote.y = y;

                // Kill the hold note if it's short enough
                if (holdNote.length <= 10) holdNote.kill();
            }
        });

        // Strum processing
        strums.forEachAlive(strum -> {
            var pressed:Bool = strum.direction.pressed;

            if (strum.confirmTime > 0 && (pressed || !isPlayer))
                strum.animation.play('confirm');
            else if (pressed && isPlayer)
                strum.animation.play('press');
            else
                strum.animation.play('static');
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
    }

    public function missNote(note:NoteSprite)
    {
        // TODO: Note miss stuff
        note.kill();
    }

    public function dropHoldNote(holdNote:HoldNoteSprite)
    {
        // TODO: Hold note drop stuff
        holdNote.kill();
    }

    public function playConfirm(direction:NoteDirection)
        getStrum(direction).confirmTime = 1;

    public function playSplash(direction:NoteDirection)
    {
        var splash:NoteSplash = noteSplashes.recycle(NoteSplash);
        var strum:StrumSprite = getStrum(direction);

        splash.play(strum);
    }

    public function playHoldCover(holdNote:HoldNoteSprite)
    {
        var cover:HoldNoteCover = holdCovers.recycle(HoldNoteCover);
        var strum:StrumSprite = getStrum(holdNote.direction);

        cover.play(holdNote, strum);
    }

    public function getMayHitNotes():Array<NoteSprite>
        return SortUtil.sortNotes(notes.members.filter(note -> return note.alive && note.mayHit && !note.tooLate));

    public function getStrum(direction:NoteDirection):StrumSprite
        return strums.members[direction];

    function getDistance(time:Float):Float
    {
        return (time - songTime) * Constants.PIXELS_PER_MS * speed;
    }

    function positionStrums()
    {
        strums.forEach(strum -> {
            var off:Float = (strum.direction - Constants.NOTE_COUNT / 2);

            strum.x = FlxG.width * offset + off * (strum.width + spacing);
            strum.x += spacing / 2;
        });
    }

    function set_speed(speed:Float):Float
    {
        speed = Math.max(0, speed);

        if (this.speed == speed) return this.speed;
        this.speed = speed;

        holdNotes.forEachAlive(holdNote -> holdNote.speed = this.speed);

        return this.speed;
    }

    function set_offset(offset:Float):Float
    {
        if (this.offset == offset) return this.offset;
        this.offset = offset;

        positionStrums();

        return this.offset;
    }

    function set_spacing(spacing:Float):Float
    {
        if (this.spacing == spacing) return this.spacing;
        this.spacing = spacing;

        positionStrums();

        return this.spacing;
    }

    inline function get_songTime():Float
        return Conductor.instance.time;
}
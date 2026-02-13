package funkin.play.note;

import flixel.FlxG;
import flixel.group.FlxGroup;
import funkin.data.song.SongData.SongNoteData;

/**
 * An `FlxGroup` containing strums and notes.
 */
class Strumline extends FlxGroup
{
    public var data:Array<SongNoteData> = [];
    public var speed:Float;

    public var offset(default, set):Float = 0.5;
    public var spacing(default, set):Float = 0;

    public var strums:FlxTypedGroup<StrumSprite>;
    public var notes:FlxTypedGroup<NoteSprite>;

    public function new()
    {
        super();

        strums = new FlxTypedGroup<StrumSprite>();
        add(strums);

        notes = new FlxTypedGroup<NoteSprite>();
        add(notes);

        // Builds the strums
        for (direction in 0...Constants.NOTE_COUNT)
        {
            var strum:StrumSprite = new StrumSprite(direction);
            strum.y = 60;
            strums.add(strum);
        }

        positionStrums();
    }

    public function process(isPlayer:Bool)
    {
        var songTime:Float = Conductor.instance.time;

        // Spawns the notes
        // TODO: Make notes spawn based on its distance
        // TODO: Add hold notes
        while (data.length > 0)
        {
            var noteData:SongNoteData = data.shift();
            var time:Float = noteData.t;
            var direction:NoteDirection = NoteDirection.fromInt(noteData.d);

            var note:NoteSprite = notes.recycle(NoteSprite);

            note.time = time;
            note.direction = direction;
        }

        // Note processing
        notes.forEachAlive(note -> {
            var strum:StrumSprite = getStrum(note.direction);
            var distance:Float = (note.time - songTime) * Constants.PIXELS_PER_MS * speed;

            // Positions the note
            note.x = strum.x;
            note.y = strum.y + distance;

            note.active = distance < FlxG.height;
            note.visible = note.active;

            // Check if the note can be hit
            var hitStart:Float = note.time;
            var hitEnd:Float = note.time + Constants.HIT_WINDOW_MS;

            // Give the player some extra time to hit the note
            // Not having this line will create something known as FNF EXTREME DIFFICULTY
            if (isPlayer) hitStart -= Constants.HIT_WINDOW_MS;

            if (songTime >= hitEnd) note.tooLate = true;
            if (songTime >= hitStart) note.mayHit = true;

            // TODO: Offscreen note killing
            // Because the line below isn't good enough
            // if (distance <= 0) note.kill();
        });
    }

    public function hitNote(note:NoteSprite)
    {
        var strum:StrumSprite = getStrum(note.direction);

        strum.confirmTime = 1;
        note.kill();
    }

    public function getMayHitNotes():Array<NoteSprite>
        return notes.members.filter(note -> return note.alive && note.mayHit && !note.tooLate);

    public function getStrum(direction:NoteDirection):StrumSprite
        return strums.members[direction];

    function positionStrums()
    {
        strums.forEach(strum -> {
            var off:Float = (strum.direction - Constants.NOTE_COUNT / 2);

            strum.x = FlxG.width * offset + off * (strum.width + spacing);
            strum.x += spacing / 2;
        });
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
}
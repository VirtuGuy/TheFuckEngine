package funkin.util;

import funkin.play.note.NoteSprite;

/**
 * An enum abstract of the possible judgements.
 */
enum abstract Judgement(String) to String from String
{
    var SICK = 'sick';
    var GOOD = 'good';
    var BAD = 'bad';
    var SHIT = 'shit';
}

/**
 * A utility class for handling rhythm game stuff.
 */
class RhythmUtil
{
    public static function processHitWindow(note:NoteSprite, isPlayer:Bool)
    {
        final songTime:Float = Conductor.instance.time;

        var hitStart:Float = note.time;
        var hitEnd:Float = note.time + Constants.HIT_WINDOW_MS;

        // Give the player some extra time to hit the note
        // Not having this line will create something known as FNF EXTREME DIFFICULTY
        if (isPlayer) hitStart -= Constants.HIT_WINDOW_MS;

        if (songTime >= hitEnd) note.tooLate = true;
        if (songTime >= hitStart) note.mayHit = true;
    }

    public static function judgeNote(note:NoteSprite):Judgement
    {
        final songTime:Float = Conductor.instance.time;
        final timing:Float = note.time - songTime;

        var judgement:Judgement = SHIT;

        if (timing <= Constants.SICK_WINDOW_MS)
            judgement = SICK;
        else if (timing <= Constants.GOOD_WINDOW_MS)
            judgement = GOOD;
        else if (timing <= Constants.BAD_WINDOW_MS)
            judgement = BAD;

        return judgement;
    }
}
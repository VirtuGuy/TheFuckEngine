package funkin.play.character;

import funkin.data.character.CharacterData;
import funkin.graphics.FunkinSprite;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.play.note.NoteDirection;

/**
 * A `FunkinSprite` that sings and bops and all that.
 */
class Character extends FunkinSprite implements IPlayStateScriptedClass
{
    public var id:String;
    public var meta:CharacterData;
    public var isPlayer:Bool;

    var singTimer:Float;

    public function new(id:String)
    {
        super();

        this.id = id;
    }

    public function buildSprite()
    {
        if (meta == null) return;

        // Loads the image
        var image:String = meta.image ?? id;

        loadSprite('play/characters/$image/image', meta.scale, meta.frameWidth, meta.frameHeight);

        // Adds the animations
        for (anim in meta.animations)
            addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);

        flipX = meta.flipX != isPlayer;
        flipY = meta.flipY;

        offset.set(-meta.globalOffset[0] ?? 0, -meta.globalOffset[1] ?? 0);

        resetSingTimer();
        dance(true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        singTimer = Math.min(1, singTimer + elapsed * (Conductor.instance.quaver / 10 / meta.singDuration));
    }

    public function dance(force:Bool = false)
    {
        if ((Conductor.instance.beat % meta.danceEvery == 0 && singTimer == 1) || force)
            playAnimation('idle', true);
    }

    public function sing(direction:NoteDirection)
        playAnimation(direction.name, true);

    public function miss(direction:NoteDirection)
        playAnimation('${direction.name}-miss', true);

    public function resetSingTimer()
        singTimer = 0;

    public function buildHealthIcon():HealthIcon
    {
        // Return null if icon data is lacking
        // The god damn errors this would give >:(
        if (meta.icon == null)
            return null;
        return new HealthIcon(id, meta.icon, isPlayer);
    }

    override public function playAnimation(name:String, force:Bool = false)
    {
        super.playAnimation(name, force);

        // Resets the sing timer
        if (name != 'idle')
            resetSingTimer();
    }

    public function onCreate(event:ScriptEvent) {}
    public function onUpdate(event:UpdateScriptEvent) {}
    public function onDestroy(event:ScriptEvent) {}

    public function onNoteHit(event:NoteScriptEvent) {}
    public function onNoteMiss(event:NoteScriptEvent) {}
    public function onHoldNoteHold(event:HoldNoteScriptEvent) {}
    public function onHoldNoteDrop(event:HoldNoteScriptEvent) {}
    public function onGhostMiss(event:GhostMissScriptEvent) {}

    public function onStepHit(event:ConductorScriptEvent) {}
    public function onBeatHit(event:ConductorScriptEvent) {}
    public function onSectionHit(event:ConductorScriptEvent) {}

    public function onSongLoaded(event:SongLoadScriptEvent) {}
    public function onSongStart(event:ScriptEvent) {}
    public function onSongEnd(event:ScriptEvent) {}
    public function onSongRetry(event:ScriptEvent) {}
    public function onSongEvent(event:SongEventScriptEvent) {}
    public function onCountdownStart(event:CountdownScriptEvent) {}
    public function onCountdownStep(event:CountdownScriptEvent) {}
    public function onPause(event:ScriptEvent) {}
    public function onGameOver(event:ScriptEvent) {}
}
package funkin.play;

import funkin.data.character.CharacterData;
import funkin.graphics.FunkinSprite;
import funkin.play.note.NoteDirection;

/**
 * A `FunkinSprite` that sings and bops and all that.
 */
class Character extends FunkinSprite
{
    public var id:String;
    public var meta:CharacterData;
    public var isPlayer:Bool;

    var singTimer:Float;

    public function new(id:String, meta:CharacterData, isPlayer:Bool)
    {
        super();

        this.id = id;
        this.meta = meta;
        this.isPlayer = isPlayer;

        // Loads the image
        var image:String = meta.image ?? id;

        loadSprite('play/characters/$image/image', meta.scale, meta.frameWidth, meta.frameHeight);

        // Adds the animations
        for (anim in meta.animations)
            addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);

        flipX = meta.flipX != isPlayer;
        offset.set(0, height);

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
    {
        playAnimation(direction.name, true);
        resetSingTimer();
    }

    public function miss(direction:NoteDirection)
    {
        playAnimation('${direction.name}-miss', true);
        resetSingTimer();
    }

    public function resetSingTimer()
        singTimer = 0;
}
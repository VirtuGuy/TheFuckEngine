package funkin.play;

import funkin.data.character.CharacterData;
import funkin.graphics.FunkinSprite;
import funkin.graphics.shaders.Rimlight;
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
    var danced:Bool = false;

    public function new(id:String, meta:CharacterData, isPlayer:Bool)
    {
        super();

        this.id = id;
        this.meta = meta;
        this.isPlayer = isPlayer;

        // Loads the image
        final image:String = meta.image ?? id;

        loadSprite('play/characters/$image/image', meta.scale, meta.frameWidth, meta.frameHeight);

        // Adds the animations
        for (anim in meta.animations)
            addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);

        flipX = meta.flipX != isPlayer;
        offset.set(0, height);

        resetSingTimer();
        dance(true);

        var rimlight:Rimlight = new Rimlight();
        rimlight.rimColor = 0xFFFFFF;
        rimlight.distance = 10;
        rimlight.direction = 180;
        rimlight.brightness = 0.7;

        shader = rimlight.shader;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        singTimer = Math.min(1, singTimer + elapsed * (Conductor.instance.quaver / 10 / meta.singDuration));
    }

    public function dance(force:Bool = false)
    {
        if ((Conductor.instance.beat % meta.danceEvery == 0 && singTimer == 1) || force)
        {
            var anim:String = 'idle';

            // Deals with idle up and down animations
            danced = !danced;

            if (danced && hasAnimation('idle-up'))
                anim = 'idle-up';
            else if (!danced && hasAnimation('idle-down'))
                anim = 'idle-down';

            playAnimation(anim, true);
        }
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
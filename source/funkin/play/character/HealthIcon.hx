package funkin.play.character;

import funkin.data.character.CharacterData.CharacterIconData;
import funkin.graphics.FunkinSprite;
import funkin.util.MathUtil;

/**
 * A `FunkinSprite` that helps indicate whoever is winning or losing.
 */
class HealthIcon extends FunkinSprite
{
    public var id:String;
    public var meta:CharacterIconData;
    public var isPlayer:Bool;

    public var isDead(default, set):Bool;

    var baseScale:Float;

    public function new(id:String, meta:CharacterIconData, isPlayer:Bool = false)
    {
        super();

        this.id = id;
        this.meta = meta;
        this.isPlayer = isPlayer;

        var image:String = meta.image ?? id;
        var path:String = 'play/characters/$image/icon';
        var size:Int = 100;

        // Death icon check
        loadSprite(path, meta.scale);

        if (graphic?.width > size)
        {
            loadSprite(path, meta.scale, size, size);

            addAnimation('icon', [0, 1], 0);
            playAnimation('icon');
        }

        flipX = meta.flipX != isPlayer;
        flipY = meta.flipY;
        baseScale = scale.x;

        isDead = false;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Lerps the scale back to its base value
        scale.x = scale.y = MathUtil.lerp(scale.x, baseScale, 0.15);
        angle = MathUtil.lerp(angle, 0, 0.15);
    }

    public function bop()
    {
        // Don't bop the icon if it's not the right beat
        if (Conductor.instance.beat % meta.bopEvery != 0) return;

        scale.x = scale.y = baseScale + 0.35;

        if (meta.bopAngle != null)
            angle = meta.bopAngle;
    }

    function set_isDead(isDead:Bool):Bool
    {
        if (this.isDead == isDead) return isDead;
        this.isDead = isDead;

        animation.frameIndex = isDead ? 1 : 0;

        return isDead;
    }
}
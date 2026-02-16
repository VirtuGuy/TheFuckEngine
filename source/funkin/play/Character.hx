package funkin.play;

import funkin.data.character.CharacterData;
import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` that sings and bops and all that.
 */
class Character extends FunkinSprite
{
    public var id:String;
    public var meta:CharacterData;

    public function new(id:String, meta:CharacterData)
    {
        super();

        this.id = id;
        this.meta = meta;

        // Loads the image
        loadSprite('play/characters/$id/image');
        setGraphicSize(Std.int(width * meta.scale));
        updateHitbox();
    }
}
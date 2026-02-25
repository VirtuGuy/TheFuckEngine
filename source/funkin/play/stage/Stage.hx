package funkin.play.stage;

import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import funkin.data.character.CharacterRegistry;
import funkin.data.stage.StageData;
import funkin.graphics.FunkinSprite;

/**
 * A group containing stage props and characters.
 */
class Stage extends FlxGroup
{
    public var id:String;
    public var meta:StageData;

    public var player:Character;
    public var opponent:Character;
    public var gf:Character;

    public function new(id:String, meta:StageData)
    {
        super();

        this.id = id;
        this.meta = meta;

        buildProps();
    }

    public function buildProps()
    {
        if (meta?.props == null) return;

        for (prop in meta.props)
        {
            if (prop == null) continue;

            var pos:Array<Float> = [0, 0];
            var scroll:Array<Float> = [1, 1];

            if (prop.position != null)
            {
                pos[0] = prop.position[0] ?? 0;
                pos[1] = prop.position[1] ?? 0;
            }
            if (prop.scroll != null)
            {
                scroll[0] = prop.scroll[0] ?? 1;
                scroll[1] = prop.scroll[1] ?? 1;
            }

            var sprite:FunkinSprite = new FunkinSprite();
            sprite.loadSprite('play/stages/${this.id}/props/${prop.id}', prop.scale);
            sprite.setPosition(pos[0], pos[1]);

            sprite.scrollFactor.set(scroll[0], scroll[1]);
            sprite.flipX = prop.flipX;
            sprite.flipY = prop.flipY;
            sprite.zIndex = prop.zIndex;

            // No point of the prop being active (for now)
            sprite.active = false;

            add(sprite);
        }

        // Refreshes to properly sort props
        refresh();
    }

    public function setPlayer(id:String)
    {
        player?.destroy();

        player = CharacterRegistry.instance.fetchCharacter(id, true);
        player?.setPosition(300, 350);

        if (player != null)
        {
            player.zIndex = 200;

            add(player);
            refresh();
        }
    }

    public function setOpponent(id:String)
    {
        opponent?.destroy();

        opponent = CharacterRegistry.instance.fetchCharacter(id);
        opponent?.setPosition(-300, 350);

        if (opponent != null)
        {
            opponent.zIndex = 200;

            add(opponent);
            refresh();
        }
    }

    public function setGF(id:String)
    {
        gf?.destroy();

        gf = CharacterRegistry.instance.fetchCharacter(id);
        gf?.setPosition(0, 300);

        if (gf != null)
        {
            gf.zIndex = 150;

            add(gf);
            refresh();
        }
    }
}
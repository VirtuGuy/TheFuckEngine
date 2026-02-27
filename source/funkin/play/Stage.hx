package funkin.play;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import funkin.data.character.CharacterRegistry;
import funkin.data.stage.StageData;
import funkin.graphics.FunkinSprite;
import funkin.util.MathUtil;

/**
 * A group containing stage props and characters.
 */
class Stage extends FlxGroup
{
    public var id:String;
    public var meta:StageData;

    public var zoom(get, never):Float;

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

            final position:FlxPoint = MathUtil.arrayToPoint(prop.position);
            final scroll:FlxPoint = MathUtil.arrayToPoint(prop.scroll, 1);

            var sprite:FunkinSprite = new FunkinSprite();
            sprite.loadSprite('play/stages/${this.id}/props/${prop.id}', prop.scale);

            sprite.setPosition(position.x, position.y);
            sprite.scrollFactor.copyFrom(scroll);

            sprite.flipX = prop.flipX;
            sprite.flipY = prop.flipY;
            sprite.zIndex = prop.zIndex;

            // No point of the prop being active (for now)
            sprite.active = false;

            // We're done with the points
            position.put();
            scroll.put();

            add(sprite);
        }

        // Refreshes to properly sort props
        refresh();
    }

    public function setPlayer(id:String)
    {
        final position:FlxPoint = MathUtil.arrayToPoint(meta?.player?.position);
        final scroll:FlxPoint = MathUtil.arrayToPoint(meta?.player?.scroll, 1);

        player?.destroy();
        player = CharacterRegistry.instance.fetchCharacter(id, true);

        if (player != null)
        {
            player.setPosition(position.x, position.y);
            player.scrollFactor.copyFrom(scroll);
            player.zIndex = meta?.player?.zIndex ?? 200;

            add(player);
            refresh();
        }

        position.put();
        scroll.put();
    }

    public function setOpponent(id:String)
    {
        final position:FlxPoint = MathUtil.arrayToPoint(meta?.opponent?.position);
        final scroll:FlxPoint = MathUtil.arrayToPoint(meta?.opponent?.scroll, 1);

        opponent?.destroy();
        opponent = CharacterRegistry.instance.fetchCharacter(id);

        if (opponent != null)
        {
            opponent.setPosition(position.x, position.y);
            opponent.scrollFactor.copyFrom(scroll);
            opponent.zIndex = meta?.opponent?.zIndex ?? 200;

            add(opponent);
            refresh();
        }

        position.put();
        scroll.put();
    }

    public function setGF(id:String)
    {
        final position:FlxPoint = MathUtil.arrayToPoint(meta?.gf?.position);
        final scroll:FlxPoint = MathUtil.arrayToPoint(meta?.gf?.scroll, 1);

        gf?.destroy();
        gf = CharacterRegistry.instance.fetchCharacter(id);

        if (gf != null)
        {
            gf.setPosition(position.x, position.y);
            gf.scrollFactor.copyFrom(scroll);
            gf.zIndex = meta?.gf?.zIndex ?? 150;

            add(gf);
            refresh();
        }

        position.put();
        scroll.put();
    }

    function get_zoom():Float
        return meta?.zoom ?? Constants.DEFAULT_CAMERA_ZOOM;
}
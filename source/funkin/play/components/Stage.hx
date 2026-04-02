package funkin.play.components;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import funkin.data.character.CharacterRegistry;
import funkin.data.stage.StageData;
import funkin.graphics.FunkinSprite;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.modding.event.ScriptEventDispatcher;
import funkin.play.character.Character;
import funkin.util.MathUtil;

/**
 * A group containing stage props and characters.
 */
class Stage extends FlxGroup implements IPlayStateScriptedClass
{
    public var id:String;
    public var meta:StageData;

    public var zoom(get, never):Float;

    public var player:Character;
    public var opponent:Character;
    public var gf:Character;

    public function new(id:String)
    {
        super();

        this.id = id;
    }

    public function buildProps()
    {
        if (meta?.props == null) return;

        for (prop in meta.props)
        {
            if (prop == null) continue;

            var position:FlxPoint = MathUtil.arrayToPoint(prop.position);
            var scroll:FlxPoint = MathUtil.arrayToPoint(prop.scroll, 1);

            var image:String = 'play/stages/${this.id}/props/${prop.id}';
            var sprite:FunkinSprite = FunkinSprite.create(position.x, position.y, image, prop.scale);

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
        var position:FlxPoint = MathUtil.arrayToPoint(meta?.player?.position);
        var scroll:FlxPoint = MathUtil.arrayToPoint(meta?.player?.scroll, 1);

        player?.destroy();
        player = CharacterRegistry.instance.fetchCharacter(id, true);

        if (player != null)
        {
            player.setPosition(position.x, position.y);
            player.scrollFactor.copyFrom(scroll);
            player.zIndex = meta?.player?.zIndex ?? 2;

            add(player);
            refresh();
        }

        position.put();
        scroll.put();
    }

    public function setOpponent(id:String)
    {
        var position:FlxPoint = MathUtil.arrayToPoint(meta?.opponent?.position);
        var scroll:FlxPoint = MathUtil.arrayToPoint(meta?.opponent?.scroll, 1);

        opponent?.destroy();
        opponent = CharacterRegistry.instance.fetchCharacter(id);

        if (opponent != null)
        {
            opponent.setPosition(position.x, position.y);
            opponent.scrollFactor.copyFrom(scroll);
            opponent.zIndex = meta?.opponent?.zIndex ?? 2;

            add(opponent);
            refresh();
        }

        position.put();
        scroll.put();
    }

    public function setGF(id:String)
    {
        var position:FlxPoint = MathUtil.arrayToPoint(meta?.gf?.position);
        var scroll:FlxPoint = MathUtil.arrayToPoint(meta?.gf?.scroll, 1);

        gf?.destroy();
        gf = CharacterRegistry.instance.fetchCharacter(id);

        if (gf != null)
        {
            gf.setPosition(position.x, position.y);
            gf.scrollFactor.copyFrom(scroll);
            gf.zIndex = meta?.gf?.zIndex ?? 1;

            add(gf);
            refresh();
        }

        position.put();
        scroll.put();
    }

    function get_zoom():Float
        return meta?.zoom ?? Constants.DEFAULT_CAMERA_ZOOM;

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
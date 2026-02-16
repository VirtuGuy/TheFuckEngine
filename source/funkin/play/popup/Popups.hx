package funkin.play.popup;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.util.RhythmUtil.Judgement;

/**
 * An `FlxGroup` containing sprites that popup during gameplay.
 * 
 * TODO: Add combo numbers.
 */
class Popups extends FlxGroup
{
    public var judgements:FlxTypedGroup<FlxSprite>;

    public function new()
    {
        super();

        judgements = new FlxTypedGroup<FlxSprite>();
        add(judgements);
    }

    public function playJudgement(judgement:Judgement)
    {
        var sprite:FlxSprite = judgements.recycle(FlxSprite, constructJudgement);

        sprite.animation.play(judgement);
        sprite.screenCenter();

        sprite.acceleration.x = FlxG.random.int(-10, 10);
        sprite.velocity.y = -250;
        sprite.alpha = 1;

        // Ensure that the sprite is on top
        // TODO: Implement a better way to reorder this
        judgements.remove(sprite, true);
        judgements.add(sprite);

        new FlxTimer().start(0.5, _ -> {
            FlxTween.tween(sprite, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut, onComplete: _ -> sprite.kill() });
        }); 
    }

    function constructJudgement():FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite();

        sprite.moves = true;
        sprite.scrollFactor.set();
        sprite.acceleration.y = 600;

        sprite.loadGraphic(Paths.image('play/ui/judgements'), true, 192, 96);
        sprite.setGraphicSize(Std.int(sprite.width * Constants.ZOOM));
        sprite.updateHitbox();

        sprite.animation.add(Judgement.SICK, [0]);
        sprite.animation.add(Judgement.GOOD, [1]);
        sprite.animation.add(Judgement.BAD, [2]);
        sprite.animation.add(Judgement.SHIT, [3]);

        return sprite;
    }
}
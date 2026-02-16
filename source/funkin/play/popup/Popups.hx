package funkin.play.popup;

import flixel.group.FlxGroup;
import funkin.util.RhythmUtil.Judgement;

/**
 * An `FlxGroup` containing sprites that popup during gameplay.
 * 
 * TODO: Add combo numbers.
 */
class Popups extends FlxGroup
{
    public var judgements:FlxTypedGroup<JudgementSprite>;

    public function new()
    {
        super();

        judgements = new FlxTypedGroup<JudgementSprite>();
        add(judgements);
    }

    public function playJudgement(judgement:Judgement)
    {
        var sprite:JudgementSprite = judgements.recycle(JudgementSprite);
        sprite.popup(judgement);
        sprite.screenCenter();

        // Ensure that the sprite is on top
        // TODO: Implement a better way to reorder this
        judgements.remove(sprite, true);
        judgements.add(sprite);
    }
}
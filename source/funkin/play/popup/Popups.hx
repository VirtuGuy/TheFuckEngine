package funkin.play.popup;

import flixel.group.FlxGroup;
import funkin.util.RhythmUtil.Judgement;

/**
 * An `FlxGroup` containing popup sprites that appear when hitting notes.
 * 
 * TODO: Add combo numbers.
 */
class Popups extends FlxGroup
{
    public var judgements:PopupGroup;

    public function new()
    {
        super();

        judgements = new PopupGroup();
        add(judgements);
    }

    public function playJudgement(judgement:Judgement)
    {
        var sprite:PopupSprite = judgements.popup(80, 80);

        if (sprite.graphic == null)
        {
            sprite.loadSprite('play/ui/judgements', 1, 123, 56);
            
            sprite.addAnimation(Judgement.SICK, [0]);
            sprite.addAnimation(Judgement.GOOD, [1]);
            sprite.addAnimation(Judgement.BAD, [2]);
            sprite.addAnimation(Judgement.SHIT, [3]);
        }

        sprite.playAnimation(judgement);
    }
}
package funkin.play.event;

/**
 * An event that plays an animation for a character.
 */
class PlayAnimationEvent extends BaseEvent
{
    public function new()
    {
        super('play-animation');
    }

    override public function handle(value:Dynamic)
    {
        super.handle(value);

        getCharacter('c')?.playAnimation(getString('a'), getBool('f'));
    }
}
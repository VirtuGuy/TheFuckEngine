package funkin.play.song.event;

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

        getCharacter(value.c)?.playAnimation(value.a, value.f);
    }
}
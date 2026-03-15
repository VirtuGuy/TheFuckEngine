package funkin.play.song.event;

import funkin.play.character.Character;

/**
 * An event that focuses the camera onto a character.
 */
class FocusCameraEvent extends BaseEvent
{
    public function new()
    {
        super('focus-camera');
    }

    override public function handle(value:Dynamic)
    {
        super.handle(value);

        var target:Character = getCharacter(value.c);
        var instant:Bool = value.i;

        PlayState.instance.setCameraTarget(target, instant);
    }
}
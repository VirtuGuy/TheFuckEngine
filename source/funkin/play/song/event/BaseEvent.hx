package funkin.play.song.event;

import funkin.play.character.Character;

/**
 * The base class for the engine's song events.
 */
class BaseEvent
{
    public var id:String;

    public function new(id:String)
    {
        this.id = id;
    }

    public function handle(value:Dynamic)
    {
        // Override type shit
    }

    function getCharacter(x:Int):Character
    {
        return switch (x)
        {
            case 0:
                PlayState.instance.stage.opponent;
            case 1:
                PlayState.instance.stage.player;
            case 2:
                PlayState.instance.stage.gf;
            default:
                null;
        }
    }
}
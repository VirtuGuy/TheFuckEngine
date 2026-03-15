package funkin.data.event;

import funkin.play.event.BaseEvent;
import funkin.play.event.FocusCameraEvent;
import funkin.play.event.PlayAnimationEvent;

/**
 * A registry class for loading song events.
 */
class EventRegistry extends BaseRegistry<BaseEvent>
{
    public static var instance:EventRegistry;

    // TODO: Make this build automatically
    final DEFAULT_EVENTS:Array<Class<BaseEvent>> = [FocusCameraEvent, PlayAnimationEvent];

    public function new()
    {
        super('events');
    }

    override public function load()
    {
        super.load();

        // Loads the engine's hardcoded events
        for (event in DEFAULT_EVENTS)
        {
            var event:BaseEvent = Type.createInstance(event, []);

            register(event.id, event);
        }
    }

    public function handleEvent(event:String, value:Dynamic)
    {
        // Don't handle an event that doesn't exist
        if (!exists(event)) return;

        fetch(event).handle(value);
    }
}
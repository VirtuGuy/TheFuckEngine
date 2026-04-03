package funkin.ui;

/**
 * An enum of the different possible UI states.
 */
enum State
{
	Idle;
	Transitioning;
	Interacting;
}

/**
 * The engine's UI state machine class.
 */
class StateMachine
{
	var currentState(default, null):State = Idle;
	var previousState(default, null):State = Idle;

	public function new() {}

	public function transition(state:State):Bool
	{
		// Can't transition if the state isn't Idle
		if (!canInteract())
			return false;

		previousState = currentState;
		currentState = state;

		// trace('Transitioned from $previousState to $currentState.');

		return true;
	}

	public function reset()
	{
		previousState = currentState;
		currentState = Idle;
	}

	public function is(state:State):Bool
		return currentState == state;

	public function canInteract():Bool
		return currentState == Idle;

	public function transitioning():Bool
		return currentState == Transitioning;
}

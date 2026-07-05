package funkin.ui.charselect;

import funkin.audio.FunkinSound;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * A menu where the player is able to select a character to play as.
 */
class CharacterSelectState extends FunkinState
{
	override public function create()
	{
		super.create();

		FunkinSound.playMusic('menu/charselect/music');
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			exit();
	}

	function exit()
	{
		FlxG.switchState(() -> FreeplaySubState.build());
	}
}

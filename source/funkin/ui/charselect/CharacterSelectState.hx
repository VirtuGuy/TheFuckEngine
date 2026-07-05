package funkin.ui.charselect;

import flixel.FlxCamera;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * A menu where the player is able to select a character to play as.
 */
class CharacterSelectState extends FunkinState
{
	public static var instance:CharacterSelectState;

	var camHUD:FlxCamera;

	var crowd:FunkinSprite;

	override public function create()
	{
		super.create();

		instance = this;

		FunkinSound.playMusic('menu/charselect/music');

		conductor.reset(90);

		//
		// HUD
		//

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x0;
		FlxG.cameras.add(camHUD, false);

		var hud:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/hud', 1.5);
		hud.active = false;
		hud.camera = camHUD;
		hud.screenCenter(X);
		add(hud);

		//
		// PROPS
		//

		var back:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/back', 1.5);
		back.scrollFactor.set();
		back.active = false;
		back.screenCenter(X);
		add(back);

		crowd = FunkinSprite.create(0, 0, 'menu/charselect/crowd', 1.5, 594, 129);
		crowd.scrollFactor.set(0.35, 0.35);
		crowd.y = FlxG.height - crowd.height * 2;
		crowd.addAnimation('idle', [0, 1, 2], 10, false);
		crowd.screenCenter(X);
		add(crowd);

		var floor:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/floor', 1.5);
		floor.scrollFactor.set(0.3, 0.3);
		floor.active = false;
		floor.y = FlxG.height - floor.height;
		floor.screenCenter(X);
		add(floor);

		var curtain1:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/curtain', 1.5);
		curtain1.scrollFactor.set(0.2, 0.2);
		curtain1.active = false;
		add(curtain1);

		var curtain2:FunkinSprite = curtain1.clone();
		curtain2.flipX = true;
		curtain2.x = FlxG.width - curtain2.width;
		add(curtain2);

		var front1:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/front', 1.5);
		front1.scrollFactor.set(0.1, 0.1);
		front1.active = false;
		front1.y = FlxG.height - front1.height;
		add(front1);

		var front2:FunkinSprite = front1.clone();
		front2.flipX = true;
		front2.x = FlxG.width - front2.width;
		front2.y = front1.y;
		add(front2);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		conductor.time = FunkinSound.music.time;
		conductor.update();

		if (controls.BACK)
			exit();
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		// Make the crowd bop
		// :whatthehappy:
		crowd.playAnimation('idle', true);
	}

	function exit()
	{
		FlxG.switchState(() -> FreeplaySubState.build());
	}

	override public function destroy()
	{
		super.destroy();

		instance = null;
	}
}

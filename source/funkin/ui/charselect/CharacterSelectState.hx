package funkin.ui.charselect;

import flixel.FlxCamera;
import flixel.FlxObject;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * A menu where the player is able to select a character to play as.
 */
class CharacterSelectState extends FunkinState
{
	public static var instance:CharacterSelectState;

	static var selected:Int = 4;

	var camFollow:FlxObject;

	var crowd:FunkinSprite;

	var icons:IconGroup;
	var cursor:CursorSprite;

	override public function create()
	{
		super.create();

		instance = this;

		FunkinSound.playMusic('menu/charselect/music');

		conductor.reset(90);

		//
		// PROPS
		//

		var back:FunkinSprite = FunkinSprite.create(0, -5, 'menu/charselect/props/back', 1.5);
		back.scrollFactor.set(0.06, 0.06);
		back.active = false;
		back.screenCenter(X);
		add(back);

		crowd = FunkinSprite.create(0, 0, 'menu/charselect/props/crowd', 1.5, 594, 129);
		crowd.scrollFactor.set(0.05, 0.05);
		crowd.y = FlxG.height - crowd.height * 2;
		crowd.addAnimation('idle', [0, 1, 2], 10, false);
		crowd.screenCenter(X);
		add(crowd);

		var floor:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/props/floor', 1.5);
		floor.scrollFactor.set(0.04, 0.04);
		floor.active = false;
		floor.y = FlxG.height - floor.height + 5;
		floor.screenCenter(X);
		add(floor);

		var curtain1:FunkinSprite = FunkinSprite.create(-5, -5, 'menu/charselect/props/curtain', 1.5);
		curtain1.scrollFactor.set(0.03, 0.03);
		curtain1.active = false;
		add(curtain1);

		var curtain2:FunkinSprite = curtain1.clone();
		curtain2.flipX = true;
		curtain2.x = FlxG.width - curtain2.width + 5;
		add(curtain2);

		var front1:FunkinSprite = FunkinSprite.create(-5, 0, 'menu/charselect/props/front', 1.5);
		front1.scrollFactor.set(0.02, 0.02);
		front1.active = false;
		front1.y = FlxG.height - front1.height + 5;
		add(front1);

		var front2:FunkinSprite = front1.clone();
		front2.flipX = true;
		front2.x = FlxG.width - front2.width + 5;
		front2.y = front1.y;
		add(front2);

		//
		// HUD
		//

		var hud:FunkinSprite = FunkinSprite.create(0, 0, 'menu/charselect/hud', 1.5);
		hud.scrollFactor.copyFrom(floor.scrollFactor);
		hud.active = false;
		hud.screenCenter(X);
		add(hud);

		icons = new IconGroup(selected);
		icons.x = (FlxG.width - icons.width) / 2;
		icons.y = 135;
		icons.onChanged.add(scroll);
		icons.scrollFactor.copyFrom(floor.scrollFactor);
		add(icons);

		cursor = new CursorSprite();
		cursor.scrollFactor.copyFrom(floor.scrollFactor);
		add(cursor);

		//
		// SETUP
		//

		camFollow = new FlxObject();

		scroll(selected);

		cursor.snap();

		FlxG.camera.follow(camFollow, null, 0.015);
		FlxG.camera.snapToTarget();
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

	function scroll(index:Int)
	{
		selected = index;

		final icon:FunkinSprite = icons.icon;
		final x:Float = icon.x + icon.width / 2;
		final y:Float = icon.y + icon.height / 2;

		cursor.targetX = x - cursor.width / 2;
		cursor.targetY = y - cursor.height / 2;

		camFollow.setPosition(x, y);
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

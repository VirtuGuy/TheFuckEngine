package funkin.ui.menus;

import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.data.character.CharacterRegistry;
import funkin.graphics.FunkinSprite;
import funkin.play.Character;
import funkin.play.PlayState;

class TitleScreen extends FunkinState
{
	var titleGF:Character;
	var logo:FunkinSprite;

	var camZoom:Float = 1.15;

	var transitioning:Bool = false;

	override function create()
	{
		super.create();

		titleGF = CharacterRegistry.instance.fetchCharacter('title-gf');
		add(titleGF);

		titleGF.dance();
		titleGF.updateHitbox();

		titleGF.screenCenter();

		logo = new FunkinSprite(0, 0, Paths.image('menus/logo'));
		logo.screenCenter();
		add(logo);

		titleGF.y += titleGF.height / 4;
		logo.y -= logo.height * 0.75;

		conductor.bpm = 102;
		conductor.time = 0;
		FlxG.sound.playMusic(Paths.sound('menus/freakyMenu'), 1, true);

		FlxG.camera.zoom = camZoom;
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		titleGF.dance();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		conductor.time += elapsed * Constants.MS_PER_SEC;
		conductor.update();

		if (controls.ACCEPT && !transitioning)
		{
			var confirmMenuSound = new FlxSound().loadEmbedded(Paths.sound('menus/confirmMenu'));
			confirmMenuSound.play();

			var tweenLengths = (confirmMenuSound.length / 1000) * 1.1;

			FlxTween.tween(titleGF, {alpha: 0, y: FlxG.height + titleGF.height * 2}, tweenLengths, {
				ease: FlxEase.quadInOut
			});
			FlxTween.tween(logo, {alpha: 0, y: logo.height * -2}, tweenLengths, {
				ease: FlxEase.quadInOut
			});

			FlxTimer.wait(tweenLengths + .1, function()
			{
				FlxG.switchState(() -> new PlayState());
			});
		}
	}
}

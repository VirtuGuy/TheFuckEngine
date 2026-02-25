package funkin.ui.menus;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.data.character.CharacterRegistry;
import funkin.graphics.FunkinSprite;
import funkin.play.Character;
import funkin.play.PlayState;
import funkin.util.FileUtil;
import funkin.util.MathUtil;

class TitleScreen extends FunkinState
{
	var wackyText:String = '';
	var wackyTexttext:FlxText;

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
		add(logo);

		titleGF.y += titleGF.height / 4;
		logo.y -= logo.height * 0.9;

		var trueWackyTexts:Array<String> = FileUtil.getText(Paths.text('menus/titleTexts')).split('\n');

		wackyText = trueWackyTexts[FlxG.random.int(0, trueWackyTexts.length - 1)] ?? 'null object reference reference!';

		wackyTexttext = new FlxText(0, 0, FlxG.width, wackyText, 24);
		wackyTexttext.alignment = CENTER;
		// wackyTexttext.antialiasing = true; // illegal
		add(wackyTexttext);

		wackyTexttext.scale.set(
			1.4,
			1.4
		);
		wackyTexttext.updateHitbox();
		wackyTexttext.screenCenter();
		wackyTexttext.y -= logo.height * 0.5;

		conductor.bpm = 102;
		conductor.time = 0;
		FlxG.sound.playMusic(Paths.sound('menus/tracks/freakyMenu'), 1, true);

		FlxG.camera.zoom = camZoom;
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		titleGF.dance();
		logo.scale.add(.2,.2);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		conductor.time += elapsed * Constants.MS_PER_SEC;
		conductor.update();

		logo.scale.x = MathUtil.lerp(logo.scale.x, 1, 0.15);
		logo.scale.y = MathUtil.lerp(logo.scale.y, 1, 0.15);
		logo.updateHitbox();
		logo.screenCenter();

		if (controls.ACCEPT && !transitioning)
		{
			trace('LEAVE!');
			transitioning = true;

			var confirmMenuSound = new FlxSound().loadEmbedded(Paths.sound('menus/sounds/confirmMenu'));
			confirmMenuSound.play();

			var tweenLengths = (confirmMenuSound.length / 1000);
			var verticalOffset = 1.5;
			var tweenEase = FlxEase.smootherStepInOut;

			FlxTween.tween(titleGF, {alpha: 0, y: titleGF.y * (1 + verticalOffset)}, tweenLengths, {
				ease: tweenEase,
				startDelay: tweenLengths * 0.1,
			});
			FlxTween.tween(logo, {alpha: 0, y: logo.y - (logo.y * verticalOffset)}, tweenLengths, {
				ease: tweenEase,
				startDelay: tweenLengths * 0.1,
			});

			FlxTimer.wait(tweenLengths * 1.1, function()
			{
				FlxG.switchState(() -> new PlayState());
			});
		}
	}
}

package funkin.ui.title;

import flixel.FlxG;
import funkin.data.character.CharacterRegistry;
import funkin.graphics.FunkinSprite;
import funkin.play.Character;

class TitleScreen extends FunkinState
{
	var titleGF:Character;
	var logo:FunkinSprite;

	var camZoom:Float = 1.15;

	override function create()
	{
		super.create();

		titleGF = CharacterRegistry.instance.fetchCharacter('title-gf');
		add(titleGF);

		titleGF.dance();
		titleGF.updateHitbox();
		 
		titleGF.screenCenter();

		logo = new FunkinSprite(0, 0, Paths.image('title/logo'));
		
		logo.scale.set(2,2);
		logo.updateHitbox();
		logo.screenCenter();

		add(logo);

		titleGF.y += titleGF.height / 3.8;
		logo.y -= logo.height / 3;

		conductor.bpm = 102;
		conductor.time = 0;
		FlxG.sound.playMusic(Paths.sound('music/freakyMenu'), 1, true);

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
	}
}

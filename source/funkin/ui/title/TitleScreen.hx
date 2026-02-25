package funkin.ui.title;

import flixel.FlxG;
import funkin.data.character.CharacterRegistry;
import funkin.play.Character;

class TitleScreen extends FunkinState
{
	var titleGF:Character;

	override function create()
	{
		super.create();

		titleGF = CharacterRegistry.instance.fetchCharacter('title-gf');
		add(titleGF);
		titleGF.screenCenter();

		conductor.bpm = 102;
		conductor.time = 0;
		FlxG.sound.playMusic(Paths.sound('music/freakyMenu'), 1, true);
		
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		titleGF.dance();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

package funkin.play;

import flixel.tweens.FlxTween;
import funkin.audio.FunkinSound;
import funkin.data.character.CharacterRegistry;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.modding.event.ScriptEvent;
import funkin.play.character.Character;
import funkin.play.song.Song;
import funkin.ui.FunkinSubState;
import funkin.ui.MenuList;
import funkin.ui.options.OptionsSubState;

/**
 * The game's pause menu sub state.
 */
class PauseSubState extends FunkinSubState
{
	public static var instance:PauseSubState;

	final DEFAULT_ENTRIES:Array<String> = ['resume', 'restart', 'options', 'botplay', 'exit to menu'];

	var song(get, never):Song;
	var difficulty(get, never):String;
	var instrumental(get, never):String;
	var deaths(get, never):Int;

	var justOpened:Bool = true;
	var mode:PauseMode = DEFAULT;

	var music:FunkinSound;

	var bg:FunkinSprite;
	var songText:FunkinText;
	var menuList:MenuList;

	override public function create()
	{
		super.create();

		instance = this;

		if (song.getDifficulties(false).length > 1)
			DEFAULT_ENTRIES.insert(2, 'difficulty');
		if (song.getInstrumentals().length > 0)
			DEFAULT_ENTRIES.insert(3, 'instrumental');

		final player:Character = PlayState.instance.stage.player;
		final musicPath:String = '${CharacterRegistry.instance.path}/${player?.meta?.pause ?? player?.id}/pause';

		music = FunkinSound.load(musicPath, 0);
		music.fadeIn(2);

		bg = FunkinSprite.createSolidColor(0, 0, FlxG.width, FlxG.height, 0xFF000000);
		bg.alpha = 0;
		bg.active = false;
		add(bg);

		songText = new FunkinText(0, 20);
		songText.size = 24;
		songText.alignment = RIGHT;
		add(songText);

		menuList = new MenuList(DEFAULT_ENTRIES);
		menuList.onSelected.add(select);
		add(menuList);

		updateSongText();

		FlxTween.tween(bg, {alpha: 0.8}, 0.15);

		#if HAS_DISCORD_RPC
		DiscordRPC.updatePresence(null, 'Paused');
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		justOpened = false;
	}

	function updateSongText()
	{
		// Updates the song text
		// Display some cool info
		songText.text = song.name;
		songText.text += '\ndifficulty: $difficulty';
		songText.text += '\nartist: ${song.artist}';
		songText.text += '\ncharter: ${song.charter}';
		songText.text += '\n$deaths blue ball';

		if (deaths != 1)
			songText.text += 's';
		if (Preferences.botplay)
			songText.text += '\nbotplay';

		songText.x = FlxG.width - songText.width - 20;
	}

	function select(item:String)
	{
		if (justOpened)
			return;

		switch (mode)
		{
			case DIFFICULTY | INSTRUMENTAL:
				// Checks if back was pressed
				if (menuList.selected == menuList.size - 1)
				{
					menuList.entries = DEFAULT_ENTRIES;
					mode = DEFAULT;
				}
				else
				{
					if (mode == INSTRUMENTAL)
						PlayState.instance.instrumental = item;
					else
						PlayState.instance.difficulty = item;

					PlayState.instance.loadSong();

					close();
				}
			default:
				switch (item)
				{
					case 'resume':
						var event:ScriptEvent = new ScriptEvent(RESUME);
						dispatch(event);

						if (!event.cancelled) close();
					case 'restart':
						PlayState.instance.loadSong();
						close();
					case 'options':
						openSubState(new OptionsSubState());
					case 'exit to menu':
						PlayState.instance.exit();
					case 'difficulty':
						var entries:Array<String> = song.getDifficulties(false);

						entries.remove(difficulty);
						entries.push('back');

						menuList.entries = entries;

						mode = DIFFICULTY;
					case 'instrumental':
						var entries:Array<String> = song.getInstrumentals();

						entries.insert(0, Constants.DEFAULT_VARIATION);

						entries.remove(instrumental);
						entries.push('back');

						menuList.entries = entries;

						mode = INSTRUMENTAL;
					case 'botplay':
						Preferences.botplay = !Preferences.botplay;
						updateSongText();
				}
		}
	}

	override public function close()
	{
		super.close();

		#if HAS_DISCORD_RPC
		DiscordRPC.updatePresence();
		#end
	}

	override public function destroy()
	{
		super.destroy();

		instance = null;

		music.destroy();
	}

	@:noCompletion
	inline function get_song():Song
	{
		return PlayState.instance.song;
	}

	@:noCompletion
	inline function get_difficulty():String
	{
		return PlayState.instance.difficulty;
	}

	@:noCompletion
	inline function get_instrumental():String
	{
		return PlayState.instance.instrumental;
	}

	@:noCompletion
	inline function get_deaths():Int
	{
		return PlayState.instance.deaths;
	}
}

/**
 * An enum used for determining the entries displayed in the pause menu.
 */
enum PauseMode
{
	DEFAULT;
	DIFFICULTY;
	INSTRUMENTAL;
}

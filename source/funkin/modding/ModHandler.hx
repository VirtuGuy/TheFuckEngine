package funkin.modding;

import funkin.data.character.CharacterRegistry;
import funkin.data.event.EventRegistry;
import funkin.data.song.SongRegistry;
import funkin.data.stage.StageRegistry;
import funkin.data.sticker.StickerRegistry;
import funkin.data.story.LevelRegistry;
import funkin.modding.module.ModuleHandler;
import funkin.play.PlayState;
import funkin.play.Playlist;
import funkin.play.song.Song;
import funkin.util.WindowUtil;
import polymod.Polymod;
import sys.FileSystem;

/**
 * A class for handling the engine's mod support.
 */
class ModHandler
{
	static final MOD_FOLDER:String = 'mods';
	static final API_VERSION_RULE:String = '>=0.1.0';

	public static function init()
	{
		// Creates the mod folder
		if (!FileSystem.exists(MOD_FOLDER))
			FileSystem.createDirectory(MOD_FOLDER);

		// Initializes Polymod and its imports
		buildImports();

		Polymod.init({
			modRoot: MOD_FOLDER,
			dirs: [],
			framework: OPENFL,
			errorCallback: onError,
			apiVersionRule: API_VERSION_RULE,
			skipDependencyErrors: true,
			useScriptedClasses: true
		});

		#if HAS_MODDING
		for (meta in Polymod.scan())
			Polymod.loadMod(meta.dirName);
		#end
	}

	public static function reload()
	{
		Polymod.clearCache();
		Polymod.clearScripts();
		Polymod.reload();

		// Reloads the registries
		// Not having this would ruin the point of hot-reloading
		CharacterRegistry.instance.load();
		StageRegistry.instance.load();
		SongRegistry.instance.load();
		LevelRegistry.instance.load();
		EventRegistry.instance.load();
		StickerRegistry.instance.load();

		// Reload all the modules
		ModuleHandler.load();

		// Reload the current song and level
		// This is so dumb
		if (PlayState.song != null)
		{
			var variation:String = PlayState.song.variation;
			var song:Song = SongRegistry.instance.fetch(PlayState.song.id);

			PlayState.song = song.getVariation(variation);
		}
		if (Playlist.level != null)
			Playlist.level = LevelRegistry.instance.fetch(Playlist.level.id);
	}

	static function buildImports()
	{
		// Imports Funkin' classes
		Polymod.addDefaultImport(Constants);
		Polymod.addDefaultImport(Conductor);
		Polymod.addDefaultImport(FunkinMemory);
		Polymod.addDefaultImport(Paths);
		Polymod.addDefaultImport(Preferences);

		// Imports Flixel classes
		Polymod.addDefaultImport(FlxG);
	}

	static function onError(e:PolymodError)
	{
		// Trace the message because why the hell not
		// Only the good errors though
		// No one cares about framework and missing icons
		if (e.code == FRAMEWORK_INIT || e.code == MOD_MISSING_ICON || e.code == MOD_MISSING_DIRECTORY)
			return;

		trace(e.message);

		// Only alert the player of errors because no one cares about the other stuff
		// Though the player should be aware of dependency problems as well
		if (e.severity == ERROR || e.code == MOD_DEPENDENCY_UNMET)
			WindowUtil.alert(e.message);
	}
}

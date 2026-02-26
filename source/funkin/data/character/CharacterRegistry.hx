package funkin.data.character;

import funkin.play.Character;
import funkin.util.FileUtil;
import json2object.JsonParser;

/**
 * A registry class for loading characters.
 */
class CharacterRegistry extends BaseRegistry<CharacterData>
{
    public static var instance:CharacterRegistry;

    public function new()
    {
        super('characters', 'play/characters');
    }

    override public function load()
    {
        super.load();

        // This json parser MIGHT come in handy
        final parser:JsonParser<CharacterData> = new JsonParser<CharacterData>();

        // Loads the entries
        for (id in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$id/meta');

            // Skip the character if it doesn't have metadata
            if (!Paths.exists(metaPath)) continue;

            register(id, parser.fromJson(FileUtil.getText(metaPath)));
        }
    }

    public function fetchCharacter(id:String, isPlayer:Bool = false):Character
    {
        // Return null if the character doesn't exist
        if (!exists(id)) return null;
        return new Character(id, fetch(id), isPlayer);
    }
}
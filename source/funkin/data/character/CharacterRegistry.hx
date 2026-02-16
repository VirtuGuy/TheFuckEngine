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
        for (characterId in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$characterId/meta');
            final imagePath:String = Paths.image('$path/$characterId/image');

            // Skip the character if it doesn't have metadata or an image
            if (!Paths.exists(metaPath) || !Paths.exists(imagePath)) continue;

            final meta:CharacterData = parser.fromJson(FileUtil.getText(metaPath));

            register(characterId, meta);
        }
    }

    public function fetchCharacter(id:String):Character
    {
        // Wow no way!
        return new Character(id, fetch(id));
    }
}
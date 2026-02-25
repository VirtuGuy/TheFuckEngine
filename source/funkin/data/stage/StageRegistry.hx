package funkin.data.stage;

import funkin.play.stage.Stage;
import funkin.util.FileUtil;
import json2object.JsonParser;

/**
 * A registry class for loading stages.
 */
class StageRegistry extends BaseRegistry<StageData>
{
    public static var instance:StageRegistry;

    public function new()
    {
        super('stages', 'play/stages');
    }

    override public function load()
    {
        super.load();

        // This json parser MIGHT come in handy
        final parser:JsonParser<StageData> = new JsonParser<StageData>();

        // Loads the entries
        for (stageId in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$stageId/meta');

            // Skip the character if it doesn't have metadata
            if (!Paths.exists(metaPath)) continue;

            final meta:StageData = parser.fromJson(FileUtil.getText(metaPath));

            register(stageId, meta);
        }
    }

    public function fetchStage(id:String):Stage
    {
        return new Stage(id, fetch(id));
    }
}
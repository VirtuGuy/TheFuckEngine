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
        for (id in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$id/meta');

            // Skip the stage if it doesn't have metadata
            if (!Paths.exists(metaPath)) continue;

            register(id, parser.fromJson(FileUtil.getText(metaPath)));
        }
    }

    public function fetchStage(id:String):Stage
    {
        return new Stage(id, fetch(id));
    }
}
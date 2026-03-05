package funkin.data.song;

import funkin.data.song.SongData;
import funkin.play.song.Song;
import funkin.util.FileUtil;
import json2object.JsonParser;

/**
 * A registry class for loading songs.
 */
class SongRegistry extends BaseRegistry<Song>
{
    public static var instance:SongRegistry;

    var metaParser(default, null) = new JsonParser<SongMetadata>();
    var chartParser(default, null) = new JsonParser<SongChartData>();

    public function new()
    {
        super('songs', 'play/songs');
    }

    override public function load()
    {
        super.load();

        // Loads the entries
        for (id in FileUtil.listFolders(path))
        {
            var metaPath:String = Paths.json('$path/$id/meta');
            var chartPath:String = Paths.json('$path/$id/chart');

            // Skip the song if it doesn't have a chart or metadata file
            if (!Paths.exists(metaPath) || !Paths.exists(chartPath)) continue;

            var meta:SongMetadata = metaParser.fromJson(FileUtil.getText(metaPath));
            var chart:SongChartData = chartParser.fromJson(FileUtil.getText(chartPath));
            var song:Song = new Song(id, meta, chart);

            register(id, song);
        }
    }
}
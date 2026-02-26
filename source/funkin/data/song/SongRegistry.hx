package funkin.data.song;

import funkin.data.song.SongData;
import funkin.play.song.Song;
import funkin.util.FileUtil;
import haxe.ds.StringMap;
import json2object.JsonParser;

/**
 * A registry class for loading songs.
 */
class SongRegistry extends BaseRegistry<Song>
{
    public static var instance:SongRegistry;

    public function new()
    {
        super('songs', 'play/songs');
    }

    override public function load()
    {
        super.load();

        // Some pretty useful json parsers
        // Might come in handy maybe
        final metaParser:JsonParser<SongMetadata> = new JsonParser<SongMetadata>();
        final chartParser:JsonParser<SongChartData> = new JsonParser<SongChartData>();

        // Loads the entries
        for (id in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$id/meta');

            // Skip the song if it doesn't have metadata
            if (!Paths.exists(metaPath)) continue;

            var song:Song = new Song(id, metaParser.fromJson(FileUtil.getText(metaPath)));

            for (diff in song.difficulties)
            {
                final chartPath:String = Paths.json('$path/$id/charts/$diff');

                // Skips the chart if it doesn't exist
                if (!Paths.exists(chartPath)) continue;

                song.charts.set(diff, chartParser.fromJson(FileUtil.getText(chartPath)));
            }

            register(id, song);
        }
    }
}
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

    public function new()
    {
        super('songs');
    }

    override public function load()
    {
        super.load();

        // Some pretty useful json parsers
        // Might come in handy maybe
        final metaParser:JsonParser<SongMetadata> = new JsonParser<SongMetadata>();
        final chartParser:JsonParser<SongChartData> = new JsonParser<SongChartData>();

        // Loads the entries
        for (songId in FileUtil.listFolders(path))
        {
            final metaPath:String = Paths.json('$path/$songId/meta');
            final chartPath:String = Paths.json('$path/$songId/chart');

            // Skip the song if it doesn't have metadata
            if (!Paths.exists(metaPath)) continue;

            final meta:SongMetadata = metaParser.fromJson(FileUtil.getText(metaPath));
            final chart:SongChartData = chartParser.fromJson(FileUtil.getText(chartPath));
            final song:Song = new Song(songId, meta, chart);

            register(songId, song);
        }
    }
}
#if !interp
package scripts;
#end

import haxe.Json;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * A class for converting a V-Slice song to a song that the engine can take.
 * This is kinda taken from Funkin'.
 * 
 * TODO: Remove this once V-Slice songs can be converted.
 * 
 * Usage: Run `haxe --run SongConverter` from `scripts`.
 */
class SongConverter
{
    static function main()
    {
        Sys.stdout().writeString('Song directory: ');
        Sys.stdout().flush();

        final songDir:String = Sys.stdin().readLine();

        // Retrieves the song id
        var songName:String = songDir;

        songName = songName.replace('\\', '/');
        songName = songName.substr(songName.lastIndexOf('/') + 1);

        // Converts the song
        final metaPath:String = '$songDir/$songName-metadata.json';
        final chartPath:String = '$songDir/$songName-chart.json';

        if (!FileSystem.exists(metaPath) || !FileSystem.exists(chartPath))
        {
            trace('Failed to convert song. Chart or metadata is missing!');
            return;
        }

        var meta:Dynamic = Json.parse(File.getContent(metaPath));
        var chart:Dynamic = Json.parse(File.getContent(chartPath));

        var wtfMeta:Dynamic = {}
        var wtfChart:Dynamic = {}

        wtfMeta.name = meta.songName;
        wtfMeta.bpm = meta.timeChanges[0].bpm;
        wtfMeta.artist = meta.artist;
        wtfMeta.difficulties = meta.playData.difficulties;
        wtfMeta.stage = meta.playData.stage;
        wtfMeta.player = meta.playData.characters.player;
        wtfMeta.opponent = meta.playData.characters.opponent;
        wtfMeta.gf = meta.playData.characters.girlfriend;

        wtfChart.speed = chart.scrollSpeed;
        wtfChart.notes = chart.notes;

        // Saves the final song
        final output:String = '../assets/play/songs/$songName';

        FileSystem.createDirectory(output);

        File.saveContent('$output/meta.json', Json.stringify(wtfMeta, '\t'));
        File.saveContent('$output/chart.json', Json.stringify(wtfChart, '\t'));

        trace('Done converting song $songName.');
    }
}
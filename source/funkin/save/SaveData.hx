package funkin.save;

import haxe.ds.StringMap;

/**
 * A structure object used for save data.
 */
typedef SaveData = {
    var song: {
        var scores:StringMap<Int>;
        var favorites:StringMap<Bool>;
    }
}
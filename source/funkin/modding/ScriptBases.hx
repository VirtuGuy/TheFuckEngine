package funkin.modding;

import polymod.hscript.HScriptedClass;

//
// SCRIPTED
//

@:hscriptClass
class ScriptedLevel extends funkin.ui.story.Level implements HScriptedClass {}

@:hscriptClass
class ScriptedSong extends funkin.play.song.Song implements HScriptedClass {}

@:hscriptClass
class ScriptedCharacter extends funkin.play.character.Character implements HScriptedClass {}

@:hscriptClass
class ScriptedStage extends funkin.play.stage.Stage implements HScriptedClass {}

@:hscriptClass
class ScriptedSongEvent extends funkin.play.song.SongEvent implements HScriptedClass {}

@:hscriptClass
class ScriptedNoteKind extends funkin.play.note.NoteKind implements HScriptedClass {}

@:hscriptClass
class ScriptedNoteStyle extends funkin.play.note.NoteStyle implements HScriptedClass {}

@:hscriptClass
class ScriptedStickerPack extends funkin.ui.sticker.StickerPack implements HScriptedClass {}

@:hscriptClass
class ScriptedAlbum extends funkin.ui.freeplay.album.Album implements HScriptedClass {}

@:hscriptClass
class ScriptedModule extends funkin.modding.module.Module implements HScriptedClass {}

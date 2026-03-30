package funkin.modding;

import polymod.hscript.HScriptedClass;

@:hscriptClass
class ScriptedLevel extends funkin.ui.story.Level implements HScriptedClass {}

@:hscriptClass
class ScriptedSong extends funkin.play.song.Song implements HScriptedClass {}

@:hscriptClass
class ScriptedCharacter extends funkin.play.character.Character implements HScriptedClass {}

@:hscriptClass
class ScriptedStage extends funkin.play.components.Stage implements HScriptedClass {}

@:hscriptClass
class ScriptedSongEvent extends funkin.play.song.SongEvent implements HScriptedClass {}
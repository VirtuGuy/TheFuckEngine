package funkin.graphics.shader;

import flixel.addons.display.FlxRuntimeShader;
import funkin.util.FileUtil;
import openfl.filters.ShaderFilter;

/**
 * The base class for all the game's shaders.
 */
class FunkinShader extends FlxRuntimeShader
{
	public final id:String;

	public var filter(default, null):ShaderFilter;

	public function new(id:String)
	{
		super(FileUtil.getText(Paths.frag('general/shaders/$id')));

		this.id = id;

		filter = new ShaderFilter(this);
	}
}

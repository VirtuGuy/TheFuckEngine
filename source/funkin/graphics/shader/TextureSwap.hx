package funkin.graphics.shader;

/**
 * A shader for swapping a texture with another texture.
 */
class TextureSwap extends FunkinShader
{
	public function new(id:String)
	{
		super('texture-swap');

		load(id);
	}

	public function load(id:String)
	{
		setBitmapData('texture', FlxG.assets.getBitmapData(Paths.image(id)));
	}
}

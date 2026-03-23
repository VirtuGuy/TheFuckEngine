package funkin.graphics.shader;

import flixel.system.FlxAssets.FlxShader;
import openfl.utils.Assets;

/**
 * A shader for swapping a texture with another texture.
 */
class TextureSwap extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform sampler2D uTexture;

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec4 color = flixel_texture2D(bitmap, uv);
            vec4 texColor = flixel_texture2D(uTexture, uv);

            if (color.a > 0.0)
            {
                color.rgb = texColor.rgb;
            }

            gl_FragColor = color;
        }
    ')

    public function new(id:String)
    {
        super();

        loadTexture(id);
    }

    public function loadTexture(id:String)
        uTexture.input = Assets.getBitmapData(Paths.image(id));
}
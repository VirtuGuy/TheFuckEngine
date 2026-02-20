package funkin.graphics.shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class Rimlight
{
    public var shader(default, null) = new RimlightShader();

    public var rimColor(default, set):FlxColor;
    public var distance(default, set):Float;
    public var direction(default, set):Float;
    public var brightness(default, set):Float;

    public function new() {}

    function set_rimColor(rimColor:FlxColor):FlxColor
    {
        this.rimColor = rimColor;
        shader.uRimColor.value = [rimColor.redFloat, rimColor.greenFloat, rimColor.blueFloat];
        return rimColor;
    }

    function set_distance(distance:Float):Float
    {
        this.distance = distance;
        shader.uDistance.value = [distance];
        return distance;
    }

    function set_direction(direction:Float):Float
    {
        this.direction = direction;
        shader.uDirection.value = [direction];
        return direction;
    }

    function set_brightness(brightness:Float):Float
    {
        this.brightness = brightness;
        shader.uBrightness.value = [brightness];
        return brightness;
    }
}

class RimlightShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform vec3 uRimColor;
        uniform float uDistance;
        uniform float uDirection;
        uniform float uBrightness;

        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
	
            vec2 pixelDist = 1.0 / openfl_TextureSize * uDistance;
            vec2 rimUV = openfl_TextureCoordv;
            
            rimUV.x += sin(radians(uDirection)) * pixelDist.x;
            rimUV.y += cos(radians(uDirection)) * pixelDist.y;
            
            vec4 rim = flixel_texture2D(bitmap, rimUV);
            
            float sub = rim.a * (1.0 - uBrightness);
            float average = (color.r + color.g + color.b) / 3.0;
            
            color.rgb -= sub;
            color.b += sub * 0.5;
            
            // Rim
            color.rgb += uRimColor * (1.0 - rim.a) * average * 2.0;
            
            gl_FragColor = color;
        }
    ')

    public function new()
    {
        super();
    }
}
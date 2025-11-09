package;

/**
 * https://www.ohsat.com/tutorial/flixel/pixel-perfect-water-shader/
 */
class WaterShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float waves;
        uniform float uTime;

        void main()
        {
            //Calculate the size of a pixel (normalized)
            vec2 pixel = vec2(1.0,1.0) / openfl_TextureSize;
			
            //Grab the current position (normalized)
            vec2 p = openfl_TextureCoordv;
            
            //Create the effect using sine waves
            p.x += sin( p.y*waves+uTime*2.0 )*pixel.x;
            
            //Apply
            vec4 source = flixel_texture2D(bitmap, p);
            gl_FragColor = source;

        }'
    )

    public function new(Waves:Float)
    {
        super();
        this.waves.value = [Waves];
    }
    
    var _waveTimer:Float = 0;
    
    public function update(elapsed:Float):Void{
        _waveTimer += elapsed;
        if (_waveTimer > Math.PI)
            _waveTimer -= Math.PI;
        uTime.value = [_waveTimer];
    }
}
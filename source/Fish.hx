package;

class Fish extends FlxSprite
{
    var swimRange:Float = 0;
	public var name:String = '';
    
	// how fast the fish moves. higher is slowly
	var moveSpeed:Float = 1;

	public function new(name:String, y:Float, swimRange:Float, moveSpeed:Float):Void
	{
        super();
        
		this.name = name;

		this.moveSpeed = moveSpeed;
        
		if (Assets.exists('assets/images/fish/$name.png'))
		{
			loadGraphic('assets/images/fish/$name.png');
		}
		else
		{
			loadGraphic('assets/images/fish/funny.png');
		}
        
		setPosition(FlxMath.bound((FlxG.random.float(FlxG.width / 2 - swimRange, FlxG.width / 2 + swimRange) - (width / 2)), 0, (FlxG.width - width)
			- 100), y);
        
        startSwim();
    }
    
    function startSwim():Void{   
		new FlxTimer().start(FlxG.random.float(1, 4) * moveSpeed, function(f):Void
		{                     
            var middle = FlxG.width / 2 - width / 2;
            
            var left:Bool = FlxG.random.bool(50);
                    
            if(x >= middle + swimRange) left = true; else if(x <= middle - swimRange) left = false;
            
            flipX = left;

			var moveTo:Float = FlxMath.bound(x + (left ? FlxG.random.float(-100, -10) : FlxG.random.float(10, 100)), 0, (FlxG.width - width) - 100);
                    
			FlxTween.tween(this, {x: moveTo}, FlxG.random.float(1, 4) * moveSpeed, {
				ease: FlxEase.cubeInOut,
				onComplete: function(f):Void
				{
                startSwim();
            }});
        });
    }
}
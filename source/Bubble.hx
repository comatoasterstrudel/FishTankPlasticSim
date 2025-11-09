package;

class Bubble extends FlxParticle{
	var velocY:Float = 0;
	var velocX:Float = 0;
	
	public function new():Void
	{
        super();
		
		loadGraphic('assets/images/bubble.png');
		velocityRange.active = false;
		alphaRange.active = false;
		scaleRange.set(new FlxPoint(.5, .5), new FlxPoint(2, 2));		
		blend = MULTIPLY;
		lifespan = 200;
    }
	
	override function update(elapsed:Float):Void{		
		super.update(elapsed);
		
		alpha = .5 - (percent * .5);
		velocity.x = velocX;
		velocity.y = velocY;
	}
	
	override function onEmit():Void{
		var size = FlxG.random.float(.6, 1.4);
		scale.set(size,size);
		velocX = FlxG.random.float(-30, 30);
		velocY = FlxG.random.float(-20, -70);
	}
}
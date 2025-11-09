package;

class Fish extends FlxSprite
{
    var swimRange:Float = 0;
	public var name:String = '';
    
	// how fast the fish moves. higher is slowly
	var moveSpeed:Float = 1;

	var bubbles:FlxEmitter;
	
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
		bubbles = new FlxEmitter();
		bubbles.blend = MULTIPLY;
		bubbles.start(false, 0.2 * moveSpeed);
		FlxG.state.add(bubbles);

		for (i in 0...Std.int(300 / moveSpeed))
		{
			var bubble:Bubble = new Bubble();
			bubbles.add(bubble);
		}

		var trail = new FlxTrail(this, null, 10, 3, 0.2);
		FlxG.state.add(trail);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var particleOffsetX:Float = 0;
		var particleOffsetY:Float = 0;

		switch (name)
		{
			case 'sad':
				particleOffsetX = 15;
			case 'observing':
				particleOffsetX = 20;
			case 'nerd':
				particleOffsetX = 15;
				particleOffsetY = 20;
			case 'chef':
				particleOffsetX = 15;
			case 'pessimistic':
				particleOffsetX = 70;
			case 'weird':
				particleOffsetX = 40;
				particleOffsetY = -40;
			case 'preventative':
				particleOffsetX = 15;
			case 'hopeful':
				particleOffsetX = 30;
			default:
				//
		}

		particleOffsetY += FlxG.random.float(-5, 5);

		bubbles.setPosition(!flipX ? (x + particleOffsetX) : ((x + width) - particleOffsetX), y + (height / 2) + particleOffsetY);
	}
	
    function startSwim():Void{   
		new FlxTimer().start(FlxG.random.float(1, 4) * moveSpeed, function(f):Void
		{                     
            var middle = FlxG.width / 2 - width / 2;
            
            var left:Bool = FlxG.random.bool(50);
                    
            if(x >= middle + swimRange) left = true; else if(x <= middle - swimRange) left = false;
            
            flipX = left;

			var moveTo:Float = FlxMath.bound(x + (left ? FlxG.random.float(-100, -10) : FlxG.random.float(10, 100)), 0, (FlxG.width - width) - 100);
                    
			var timeToMove = FlxG.random.float(1, 4) * moveSpeed;

			new FlxTimer().start(timeToMove * .2, function(t:FlxTimer):Void
			{
				bubbles.emitting = true;
			});

			new FlxTimer().start(timeToMove * .8, function(t:FlxTimer):Void
			{
				bubbles.emitting = false;
			});

			FlxTween.tween(this, {x: moveTo}, timeToMove, {
				ease: FlxEase.cubeInOut,
				onComplete: function(f):Void
				{
                startSwim();
            }});
        });
    }
}
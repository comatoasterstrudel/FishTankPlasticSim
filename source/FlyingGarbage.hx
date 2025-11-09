package;

class FlyingGarbage extends FlxSpriteGroup
{
    var garbage:FlxSprite;
    
    var starty:Float;
    var endy:Float;
    
	var garbagedone:Bool = false;
	var particlesdone:Bool = false;
    
    public function new(starty:Float, endy:Float):Void{
        super();
        
        this.starty = starty;
        this.endy = endy;
        
		garbage = new FlxSprite().loadGraphic('assets/images/garbage_${FlxG.random.int(1, 4)}.png');
        add(garbage);
        
        garbage.x = FlxG.random.float(0, (FlxG.width - 105) - width);
        garbage.y = starty;
        
        garbage.angle = FlxG.random.int(-350, 350);
        garbage.alpha = 0;
        
        FlxTween.tween(garbage, {alpha: 1}, .5);
        FlxTween.tween(garbage, {angle: FlxG.random.float(-350, 350), y: endy}, FlxG.random.float(1, 4), {onComplete: function(F):Void{
				makeParticles();
				FlxTween.tween(garbage, {
					alpha: 0,
					"scale.x": 0,
					"scale.y": 0,
					y: endy + FlxG.random.float(50, 400)
				}, FlxG.random.float(.2, 4), {
					onComplete: function(F):Void
					{
						garbagedone = true;
            }});
        }});
    }
	function makeParticles():Void
	{
		remove(garbage);

		for (i in 0...5)
		{
			var particle = new FlxSprite().loadGraphic('assets/images/bubble.png');
			var size:Float = FlxG.random.float(.4, .8);
			particle.scale.set(size, size);
			particle.updateHitbox();
			particle.alpha = .5;
			particle.setPosition(garbage.x + garbage.width / 2 - particle.width / 2, garbage.y + garbage.height / 2 - particle.height / 2);
			add(particle);

			particle.velocity.x = switch (i)
			{
				case 0:
					-120;
				case 1:
					-60;
				case 3:
					60;
				case 4:
					120;
				default:
					0;
			}

			particle.x += FlxG.random.float(-20, 20);

			FlxTween.tween(particle, {alpha: 0, "velocity.y": FlxG.random.float(650, 700)}, .5, {
				ease: FlxEase.backIn,
				onComplete: function(F):Void
				{
					particlesdone = true;
				}
			});
		}

		add(garbage);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (particlesdone && garbagedone)
		{
			particlesdone = false;
			garbagedone = false;
			destroy();
		}
	}
}
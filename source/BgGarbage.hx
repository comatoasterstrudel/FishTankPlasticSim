package;

class BgGarbage extends FlxSprite{
	var lower:Float;
	var upper:Float;
	
	public function new(path:String, lower:Float, upper:Float):Void
	{
        super();

		this.lower = lower;
		this.upper = upper;
		
		loadGraphic(path);
		setGraphicSize(600, FlxG.height);
		updateHitbox();
		scrollFactor.set(0,0);
		alpha = 0;
		
		blend = MULTIPLY;
    }
	
	public function updateValue(val:Float):Void
	{
		var difference = (upper - lower);
				
		alpha = FlxMath.bound((val - lower) / difference, 0, 1);
	}
}
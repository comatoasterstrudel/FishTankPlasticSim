package;

class PlayState extends FlxState
{
	var bg:FlxSprite;

	var depthSlider:FlxSlider;

	var depth:Float = 0;
	
	override public function create()
	{
		super.create();
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height * 4, 0xFFCAFFF3);
		add(bg);

		for (i in 0...10)
		{
			var funnyFish = new Fish('funny', 100 + (200 * i), FlxG.width / 1.5);
			add(funnyFish);
		}

		depthSlider = new FlxSlider(this, "depth", 20, 3, 0, 1, FlxG.width - 40, 40, 10);
		depthSlider.scrollFactor.set(0, 0);
		depthSlider.maxLabel.visible = false;
		depthSlider.minLabel.visible = false;
		depthSlider.nameLabel.visible = false;
		depthSlider.valueLabel.visible = false;
		add(depthSlider);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.scroll.y = ((FlxG.height * 3) * depth);
	}
}

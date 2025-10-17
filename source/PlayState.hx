package;

class PlayState extends FlxState
{
	var bg:FlxSprite;

	var depthSlider:FlxSlider;

	var depth:Float = 0;
	
	var dialogueBox:CtDialogueBox;

	var dialogueX:Float = 0;

	var currentFish:Fish;

	var fishes:Array<Fish> = [];
	
	var fishToAdd:Array<String> = ['funny', 'funny', 'funny', 'funny'];
	var gameHeight:Float = 0;
	
	override public function create()
	{
		super.create();
		bg = new FlxSprite();
		add(bg);
		//		FlxColor.gradient(0xFFCFF9F2, 0xFF26394A, FlxG.height * 4, FlxEase.quartOut);

		gameHeight = FlxG.height;

		for (i in 0...fishToAdd.length)
		{
			gameHeight += FlxG.height / 1.5;
			var funnyFish = new Fish(fishToAdd[i], 200 + (400 * i), FlxG.width / 1.5);
			add(funnyFish);
			fishes.push(funnyFish);
		}
		bg.makeGraphic(FlxG.width, FlxG.height + Std.int(gameHeight), 0xFFCFF9F2);

		depthSlider = new FlxSlider(this, "depth", FlxG.width - 100, 30, 0, 1, 50, 371, 10);
		depthSlider.body.loadGraphic('assets/images/slide_bar.png');
		depthSlider.handle.loadGraphic('assets/images/slide_handle.png');
		depthSlider.scrollFactor.set(0, 0);
		depthSlider.maxLabel.visible = false;
		depthSlider.minLabel.visible = false;
		depthSlider.nameLabel.visible = false;
		depthSlider.valueLabel.visible = false;
		add(depthSlider);
		CtDialogueBox.preloadFont();
		dialogueBox = new CtDialogueBox({
			pressedAcceptFunction: function():Bool
			{
				return (FlxG.mouse.justReleased && FlxG.mouse.overlaps(dialogueBox.dialogueBox));
			},
			onComplete: function():Void
			{
				currentFish = null;
			},
			onLineAdvance: function(data):Void
			{
				dialogueBox.dialogueBox.x = dialogueX;
			}
		});
		add(dialogueBox);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.scroll.y = lerpThing(FlxG.camera.scroll.y, (gameHeight - (FlxG.height / 2)) * depth, FlxG.elapsed, 6);
		if (currentFish == null)
		{
			for (fish in fishes)
			{
				if (FlxG.mouse.overlaps(fish) && FlxG.mouse.justReleased)
				{
					currentFish = fish;
					dialogueBox.loadDialogueFiles(['fish_${currentFish.name}']);
					dialogueBox.openBox();
					setDialogueBoxPosition(true);
					break;
				}
			}
		}
		else
		{
			setDialogueBoxPosition();
		}
	}

	function setDialogueBoxPosition(?force:Bool = false):Void
	{
		var targetedX:Float = FlxMath.bound(currentFish.x
			+ currentFish.width / 2
			- dialogueBox.dialogueBox.width / 2, 5,
			FlxG.width
			- 105
			- dialogueBox.dialogueBox.width);

		if (force)
			dialogueBox.dialogueBox.x = targetedX;
		else
			dialogueBox.dialogueBox.x = lerpThing(dialogueBox.dialogueBox.x, targetedX, FlxG.elapsed, 2);

		dialogueBox.dialogueBox.x = dialogueBox.textbox.x = dialogueBox.dialogueBox.x;

		dialogueBox.dialogueBox.y = currentFish.y - 120;

		dialogueBox.textbox.y = dialogueBox.dialogueBox.y;

		dialogueX = dialogueBox.dialogueBox.x;
	}

	public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
	}
}

package;


class PlayState extends FlxState
{
	public static final RIGHT_SIDE_MARGIN:Int = 100;
	
	var bg:FlxSprite;

	var sliderbg:FlxSprite;
	var depthSlider:FlxSlider;

	var depth:Float = 0;
	
	var dialogueBox:CtDialogueBox;

	var dialogueX:Float = 0;

	var currentFish:Fish;

	var fishes:Array<Fish> = [];
	
	var fishToAdd:Array<String> = ['', '', '', 'sad', 'funny'];
	var gameHeight:Float = 0;
	
	var watertop:FlxBackdrop;
	var sky:FlxSprite;

	var text1:FlxText;
	var text2:FlxText;
	var text3:FlxText;

	var garbagegroup:FlxTypedGroup<FlyingGarbage>;
	
	override public function create()
	{
		super.create();
		bgColor = 0xFF454545;

		sky = new FlxSprite().loadGraphic('assets/images/sky.png');
		sky.scale.y = 2.2;
		sky.scrollFactor.set(.5, .5);
		sky.alpha = .7;
		add(sky);

		text1 = new FlxText(0, 70, 0, 'Welcome to', 30);
		add(text1);

		text2 = new FlxText(0, 200, 0, 'FishTankPlasticSim', 65);
		add(text2);

		text3 = new FlxText(0, 350, 0, 'Drag the arrow on the right to move through the ocean!\nClick on fish to talk to them!', 20);
		add(text3);

		for (i in [text1, text2, text3])
		{
			i.setFormat('assets/fonts/andy.ttf', i.size, FlxColor.WHITE, CENTER);
			i.screenCenter(X);
			i.x -= 25;
		}
		
		bg = new FlxSprite();
		add(bg);
		//		FlxColor.gradient(0xFFCFF9F2, 0xFF26394A, FlxG.height * 4, FlxEase.quartOut);

		gameHeight = FlxG.height;

		watertop = new FlxBackdrop('assets/images/water.png', X);
		watertop.y = 1000;
		watertop.velocity.x = 50;
		add(watertop);

		garbagegroup = new FlxTypedGroup<FlyingGarbage>();
		add(garbagegroup);

		new FlxTimer().start(FlxG.random.float(1, 3), function(t):Void
		{
			var garbage = new FlyingGarbage(600, watertop.y);
			garbagegroup.add(garbage);
			t.reset();
		});
		
		for (i in 0...fishToAdd.length)
		{
			gameHeight += FlxG.height / 1.5;

			if (fishToAdd[i] == '')
				continue;
			
			var moveSpeed:Float = 1;

			switch (fishToAdd[i])
			{
				case 'sad':
					moveSpeed = .75;
				default:
					moveSpeed = 1;
			}

			var funnyFish = new Fish(fishToAdd[i], (400 * i), FlxG.width / 1.5, moveSpeed);
			add(funnyFish);
			fishes.push(funnyFish);
		}
		#if tenthousandfish
		for (i in 0...10000)
		{
			var funnyFish = new Fish('funny', FlxG.random.int(0, 2000), FlxG.width / 1.5, .2);
			add(funnyFish);
			fishes.push(funnyFish);
		}
		#end
		
		bg.makeGraphic(FlxG.width, FlxG.height + Std.int(gameHeight), 0xFF99DCFB);
		bg.y = watertop.y + watertop.height;
		watertop.color = 0xFF99DCFB;

		sliderbg = new FlxSprite().loadGraphic('assets/images/slide_bg.png');
		sliderbg.screenCenter();
		sliderbg.scrollFactor.set(0, 0);
		add(sliderbg);

		depthSlider = new FlxSlider(this, "depth", FlxG.width - 70, 30, 0, 1, 80, 409, 10);
		depthSlider.hoverAlpha = 1;
		depthSlider.body.loadGraphic('assets/images/slide_bar.png');
		depthSlider.handle.loadGraphic('assets/images/slide_handle.png');
		depthSlider.handle.x = depthSlider.body.x + depthSlider.body.width / 2 - depthSlider.handle.width / 2;
		depthSlider.scrollFactor.set(0, 0);
		depthSlider.maxLabel.visible = false;
		depthSlider.minLabel.visible = false;
		depthSlider.nameLabel.visible = false;
		depthSlider.valueLabel.visible = false;
		add(depthSlider);
		CtDialogueBox.preloadFont('assets/fonts/andy.ttf', 25);
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
			},
			boxImgPath: 'diaBox',
			textFieldWidth: 250,
			textRows: 3,
			font: 'assets/fonts/andy.ttf',
			fontSize: 25
		});
		add(dialogueBox);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.scroll.y = lerpThing(FlxG.camera.scroll.y, (gameHeight - (FlxG.height / 1.5)) * depth, FlxG.elapsed, 6);
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
		sky.alpha = FlxMath.bound((FlxG.camera.scroll.y / 500), .5, 1);
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

		dialogueBox.textbox.x += 50;

		dialogueBox.dialogueBox.y = currentFish.y - 200;

		dialogueBox.textbox.y = dialogueBox.dialogueBox.y + 35;

		dialogueX = dialogueBox.dialogueBox.x;
	}

	public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
	}
}

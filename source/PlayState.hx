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
	
	var fishToAdd:Array<String> = [
		'',
		'',
		'',
		'sad', // frowning fish
		'observing', // fish with a monocle
		'collector', // turtle
		'nerd', // shrimp
		'chef', // squid
		'historic', // blue crab
		'pessimistic', // huge fucking shark
		'weird', // angler fish
		'preventative', // jellyfish
		'hopeful', // smiling but fucked up fish
		'',
		'',
	];
	var gameHeight:Float = 0;
	
	var watertop:FlxBackdrop;

	var sky:FlxSprite;
	var clouds:FlxSprite;

	var bottomBg:FlxSprite;
	var bottomBg2:FlxSprite;
	var bottomBg3:FlxSprite;

	var text1:FlxText;
	var text2:FlxText;
	var text3:FlxText;

	var text4:FlxText;
	var text5:FlxText;

	var garbagegroup:FlxTypedGroup<FlyingGarbage>;

	var bgGarbage:Array<BgGarbage> = [];
	
	var watershaders:Array<WaterShader> = [];
	
	override public function create()
	{
		super.create();
		bgColor = 0xFF454545;

		sky = new FlxSprite().loadGraphic('assets/images/sky.png');
		sky.scale.y = 2.2;
		sky.scrollFactor.set(.5, .5);
		sky.alpha = .7;
		add(sky);

		clouds = new FlxSprite().loadGraphic('assets/images/clouds.png');
		clouds.scale.y = 1.5;
		clouds.updateHitbox();
		clouds.y = 0;
		clouds.scrollFactor.set(.4, .4);
		clouds.alpha = .2;
		clouds.antialiasing = true;
		add(clouds);

		text1 = new FlxText(0, 40, 0, 'Welcome to', 30);
		add(text1);

		text2 = new FlxText(0, 170, 0, 'FishTankPlasticSim', 65);
		add(text2);

		text3 = new FlxText(0, 310, 0, 'Drag the arrow on the right to move through the ocean!\n
			Click on fish to talk to them!\n
			Click on text boxes to advance them!', 20);
		add(text3);

		bg = new FlxSprite();
		add(bg);
		//		FlxColor.gradient(0xFFCFF9F2, 0xFF26394A, FlxG.height * 4, FlxEase.quartOut);

		gameHeight = FlxG.height + 100;

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
				case 'collector':
					moveSpeed = 4;
				case 'nerd':
					moveSpeed = .5;
				case 'weird':
					moveSpeed = .25;
				case 'historic':
					moveSpeed = 10;
				default:
					moveSpeed = 1;
			}

			var funnyFish = new Fish(fishToAdd[i], (400 * i) + 100, FlxG.width / 1.5, moveSpeed);
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
		gameHeight += 200;

		bottomBg3 = new FlxSprite().loadGraphic('assets/images/bottomgarbage3.png');
		bottomBg3.scrollFactor.set(1, 0.1);
		add(bottomBg3);

		bottomBg2 = new FlxSprite().loadGraphic('assets/images/bottomgarbage2.png');
		bottomBg2.scrollFactor.set(1, 0.2);
		add(bottomBg2);

		bottomBg = new FlxSprite().loadGraphic('assets/images/bottomgarbage.png');
		bottomBg.scrollFactor.set(1, 0.4);
		add(bottomBg);

		var garbageLayer3 = new BgGarbage('assets/images/garbageBg_3.png', 900, 2200);
		add(garbageLayer3);

		var garbageLayer2 = new BgGarbage('assets/images/garbageBg_2.png', 2800, 3500);
		add(garbageLayer2);

		var garbageLayer1 = new BgGarbage('assets/images/garbageBg_1.png', 3700, 4300);
		add(garbageLayer1);

		bgGarbage = [garbageLayer1, garbageLayer2, garbageLayer3];

		for (i in fishes)
		{
			add(i);
		}
		
		var trueheight = FlxG.height + Std.int(gameHeight);

		bg.loadGraphic(FlxGradient.createGradientBitmapData(FlxG.width, trueheight, FlxColor.gradient(0xFF99DCFB, 0xFF050708, 200)));
		bg.y = watertop.y + watertop.height;

		watertop.color = 0xFF99DCFB;

		text4 = new FlxText(0, gameHeight - 200, 0, 'Thank you for playing!', 50);
		add(text4);

		text5 = new FlxText(0, text4.y + 150, 0, 'I hope you learned something!!', 30);
		add(text5);

		for (i in [text1, text2, text3, text4, text5])
		{
			i.setFormat('assets/fonts/andy.ttf', i.size, FlxColor.WHITE, CENTER, SHADOW, 0xFF043544);
			i.borderSize = 4;
			i.screenCenter(X);
			i.x -= 25;
		}

		bottomBg.y = (text4.y - 50) * bottomBg.scrollFactor.y;
		bottomBg2.y = (text4.y - 50) * bottomBg2.scrollFactor.y;
		bottomBg3.y = (text4.y - 50) * bottomBg3.scrollFactor.y;

		CtDialogueBox.preloadFont('assets/fonts/andy.ttf', 21);

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
			textFieldWidth: 360,
			textRows: 4,
			font: 'assets/fonts/andy.ttf',
			fontSize: 21,
		});
		add(dialogueBox);
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

		addWaterShader(garbageLayer3, 30);
		addWaterShader(garbageLayer2, 60);
		addWaterShader(garbageLayer1, 100);
		addWaterShader(bottomBg, 80);
		addWaterShader(garbageLayer1, 50);
		addWaterShader(garbageLayer1, 30);

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.scroll.y = lerpThing(FlxG.camera.scroll.y, FlxMath.bound((gameHeight - (FlxG.height / 1.5)) * depth, 0, null), FlxG.elapsed, 6);
		for (i in bgGarbage)
		{
			i.updateValue(FlxG.camera.scroll.y);
		}
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
		clouds.alpha = FlxMath.bound((FlxG.camera.scroll.y / 500), .1, .2);
		for (i in watershaders)
		{
			i.update(elapsed);
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

		dialogueBox.textbox.x += 50;

		dialogueBox.dialogueBox.y = currentFish.y - 200;

		dialogueBox.textbox.y = dialogueBox.dialogueBox.y + 50;

		dialogueX = dialogueBox.dialogueBox.x;
	}

	public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
	}
	function addWaterShader(sprite:FlxSprite, intensity:Int):Void
	{
		var shader = new WaterShader(intensity);
		sprite.shader = shader;
		watershaders.push(shader);
	}
}

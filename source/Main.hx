package;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState, 30, 30));
		FlxG.mouse.useSystemCursor = true;
	}
}

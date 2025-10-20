package;

class FlyingGarbage extends FlxSpriteGroup
{
    var garbage:FlxSprite;
    
    var starty:Float;
    var endy:Float;
    
    public function new(starty:Float, endy:Float):Void{
        super();
        
        this.starty = starty;
        this.endy = endy;
        
        garbage = new FlxSprite().loadGraphic('assets/images/garbage_${FlxG.random.int(1,3)}.png');
        add(garbage);
        
        garbage.x = FlxG.random.float(0, (FlxG.width - 105) - width);
        garbage.y = starty;
        
        garbage.angle = FlxG.random.int(-350, 350);
        garbage.alpha = 0;
        
        FlxTween.tween(garbage, {alpha: 1}, .5);
        FlxTween.tween(garbage, {angle: FlxG.random.float(-350, 350), y: endy}, FlxG.random.float(1, 4), {onComplete: function(F):Void{
            FlxTween.tween(garbage, {alpha: 0, "scale.x": 0, "scale.y": 0, y: endy + FlxG.random.float(10, 50)}, FlxG.random.float(.2, 2), {onComplete: function(F):Void{
                destroy();
            }});
        }});
    }
}
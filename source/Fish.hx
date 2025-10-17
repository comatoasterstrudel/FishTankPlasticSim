package;

class Fish extends FlxSprite
{
    var swimRange:Float = 0;
    
    public function new(name:String, y:Float, swimRange:Float):Void{
        super();
        
        loadGraphic('assets/images/fish/$name.png');
        
        setPosition((FlxG.random.float(FlxG.width / 2 - swimRange, FlxG.width / 2 + swimRange) - (width / 2)), y);
        
        startSwim();
    }
    
    function startSwim():Void{   
        new FlxTimer().start(FlxG.random.float(1, 4), function(f):Void{                     
            var middle = FlxG.width / 2 - width / 2;
            
            var left:Bool = FlxG.random.bool(50);
                    
            if(x >= middle + swimRange) left = true; else if(x <= middle - swimRange) left = false;
            
            flipX = left;

            var moveTo:Float = FlxMath.bound(x + (left ? FlxG.random.float(-100, -10) : FlxG.random.float(10, 100)), 0, FlxG.width - width);
                    
            FlxTween.tween(this, {x: moveTo}, FlxG.random.float(1, 4), {onComplete: function(f):Void{
                startSwim();
            }});
        });
    }
}
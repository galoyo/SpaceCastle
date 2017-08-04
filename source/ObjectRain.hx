package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class ObjectRain extends FlxSprite
{
	private var _level:Int = 0;
	private var _initialized:Bool = false;
	
	public function new(Level:Int = 0) 
	{
		super();
		
		pixelPerfectPosition = false;
		
		_level = Level;
		var size = Std.int(FlxMath.bound(_level / 2, 2, 4));
		var color = FlxColor.BLUE.getDarkened(.5 - (_level * .06));
		makeGraphic(size, size * 2, color);
		revive();
		_initialized = true;
	}
	
	override public function revive():Void 
	{
		super.revive();
		alpha = 1;
		if (_initialized)
		{
			x = FlxG.random.int(0, FlxG.width * 4 * _level);
			y = FlxG.random.int( -5, -10);
		}
		else
		{
			x = FlxG.random.int(0, FlxG.width * 4 * _level);
			y = FlxG.random.int( -10, FlxG.height);
		}
		scrollFactor.set(.7 + (_level * .1), 0);
		velocity.y = FlxG.random.int(340, 480) * ((_level+1) * .4);
		velocity.x = FlxG.random.int( -50, -100) * ((_level+1) * .2);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (velocity.y == 0)
			alpha -= elapsed * .5;
		else
		{
			if (x < 0 || y > FlxG.height || alpha <= 0)
			{
				revive();
			}
			else if (y >= FlxG.height - 64 && _level <= 3)
			{
				if (_level == 3)
				{
					scrollFactor.x = 1;
					velocity.set();
					y = FlxG.height - 65;
				}
				else
					revive();
			}
		}
		super.update(elapsed);
	}
}
package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class ObjectLaserBeam extends FlxSprite
{
	// movement speed.
	private var maxSpeed:Int = 600;	
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);

		_startx = x;
		_starty = y ;
		
		loadGraphic("assets/images/objectLaserBeam.png", false, 24, 24);	
		
		velocity.y = - maxSpeed;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{			
			if (justTouched(FlxObject.ANY))
			{
				visible = false;
				reset(_startx, _starty);
				
				// reset the laser beam after the laser beam hits the receiving laser block.
				new FlxTimer().start(0.25, onTimer, 1);				
			}
			super.update(elapsed);
		}		
	}
	
	private function onTimer(Timer:FlxTimer):Void
	{		
		velocity.y = -maxSpeed;
		visible = true;
	}
}
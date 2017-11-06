package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class ObjectLaserBeam extends FlxSprite
{
	/**
	 * The X and/or Y velocity of this mob. Must be in integers of 32.
	 */
	private var maxSpeed:Int = 608;	
	
	/**
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/**
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);

		_startX = x;
		_startY = y ;
		
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
				reset(_startX, _startY);
				
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
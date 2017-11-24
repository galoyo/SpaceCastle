package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class ObjectLaserBeam extends FlxSprite
{
	/*******************************************************************************************************
	 * Used at the velocity Y. 
	 */
	private var maxSpeed:Int = 600;	
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);

		_startX = x;
		_startY = y ;
		
		loadGraphic("assets/images/objectLaserBeam.png", false, 24, 24);		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen() && Reg._update == true)
		{			
			velocity.y = - maxSpeed;
			
			if (justTouched(FlxObject.ANY)) reset(_startX, _startY); // At playState.hx there is a collide check between this object and the player / laser parameter. When that collision happens then the laser will be reset back to the start Y location.
			super.update(elapsed);
		}		
	}	
}
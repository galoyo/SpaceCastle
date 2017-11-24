package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectPlatformMoving extends FlxSprite
{
	/*******************************************************************************************************
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	/*******************************************************************************************************
	 * The X and/or Y velocity of this mob. Must be in integers of 32.
	 */	
	public var maxSpeed:Int = 320;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);		
		
		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		if (ID == 1)	 loadGraphic("assets/images/objectPlatformMovingLeftAndRight1.png", false, Reg._tileSize, Reg._tileSize);	
		else if(ID == 2) loadGraphic("assets/images/objectPlatformMovingLeftAndRight2.png", false, 32, 96); // moving object with spikes.
		else if(ID == 3) loadGraphic("assets/images/objectPlatformMovingUpAndDown.png", false, Reg._tileSize, Reg._tileSize);		
			
		immovable = false;	
		pixelPerfectPosition = true;
		
		if (id != 3)
		{
			velocity.x = -maxSpeed;
			maxVelocity.x = maxSpeed;
		}
		else
		{
			velocity.y = -maxSpeed;
			maxVelocity.y = maxSpeed;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{		
		if(ID == 1)
		{							
			immovable = true; // if bumping into this object, this object will not alter its path.
			
			if (overlapsAt(x - 5, y, Reg.state.tilemap) || overlapsAt(x - 12, y, Reg.state._objectPlatformParameter)) {velocity.x = maxSpeed * 1.7; }
			else if (overlapsAt(x + 5, y, Reg.state.tilemap) || overlapsAt(x + 12, y, Reg.state._objectPlatformParameter)) {velocity.x = -maxSpeed * 1.7; }
			
			// move the object if object stops moving.
			if (velocity.x == 0)
				velocity.x = -maxSpeed * 1.5;
				
			// set y motion to zero.
			velocity.y = acceleration.y = 0;
			y = _startY;
		} 
		else if(ID == 2)
		{			

			allowCollisions = FlxObject.ANY;
						
			immovable = true;
			
			if (overlapsAt(x - 5, y, Reg.state.tilemap) || overlapsAt(x - 12, y, Reg.state._objectPlatformParameter)) {velocity.x = maxSpeed * 1.7; }
			else if (overlapsAt(x + 5, y, Reg.state.tilemap) || overlapsAt(x + 12, y, Reg.state._objectPlatformParameter)) {velocity.x = -maxSpeed * 1.7; }
			
			// moving the object if object stops moving.
			if (velocity.x == 0)
				velocity.x = -maxSpeed * 1.5;
				
			// set y motion to zero.
			velocity.y = acceleration.y = 0;
			y = _startY;
		} 
		
		else if(ID == 3)
		{
			if(Reg._antigravity == false) allowCollisions = FlxObject.UP;
				else allowCollisions = FlxObject.DOWN;
				
			immovable = true; // if bumping into this object, this object will not alter its path.
			
			if (overlapsAt(x, y - 5, Reg.state.tilemap) || overlapsAt(x, y - 5, Reg.state._objectPlatformParameter)) {velocity.y = maxSpeed * 1.7; }
			else if (overlapsAt(x, y + 5, Reg.state.tilemap) || overlapsAt(x, y + 5, Reg.state._objectPlatformParameter)) {velocity.y = -maxSpeed * 1.7; }
			
			// moving the object if object stops moving.
			if (velocity.y == 0)
				velocity.y = -maxSpeed * 1.5;
			
			// keep the player with this up and down moving platform. _inair is used to stop a small jump on this platform.
			if (FlxG.overlap(this, Reg.state.player) && Reg.state.player._inAir == false) Reg.state.player.velocity.y = velocity.y;
			
			// set x motion to zero.
			velocity.x = acceleration.x = 0;
			x = _startX;
		}
		
		super.update(elapsed);
	}	
	
}
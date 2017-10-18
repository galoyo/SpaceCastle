package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectPlatformMoving extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public var maxSpeed:Int = 300;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		_starty = y;
		_startx = x;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		// id 1: horizontal platform that moves hoizontal.
		if(ID == 1)
			loadGraphic("assets/images/objectPlatformMovingHorizontal1.png", false, Reg._tileSize, Reg._tileSize);	
		else if(ID == 2) // moving object with spikes.
			loadGraphic("assets/images/objectPlatformMovingVertical1.png", false, 32, 96);
		else loadGraphic("assets/images/objectPlatformMovingHorizontal2.png", false, Reg._tileSize, Reg._tileSize);		
			
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
			
			// moving the object if object stops moving.
			if (velocity.x == 0)
				velocity.x = -maxSpeed * 1.5;
				
			// set y motion to zero.
			velocity.y = acceleration.y = 0;
			y = _starty;
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
			y = _starty;
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
				
			// set x motion to zero.
			velocity.x = acceleration.x = 0;
			x = _startx;
		}
		
		super.update(elapsed);
	}	
	
}
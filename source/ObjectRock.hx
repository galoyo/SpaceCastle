package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * @author galoyo
 */

class ObjectRock extends FlxSprite
{	
	/**
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/**
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		if ( id == 1 || id == 2)
			loadGraphic("assets/images/objectRock"+id+".png", false, 32, 32);	
		else if (id == 3) loadGraphic("assets/images/objectRock3.png", false, 32, 22);
		else if (id == 4) loadGraphic("assets/images/objectRock4.png", false, 32, 8);
		else if (id == 5) loadGraphic("assets/images/objectRock5.png", false, 32, 20);
		else if (id == 6) loadGraphic("assets/images/objectRock6.png", false, 32, 15);
	
		pixelPerfectPosition = false;	

		immovable = true;
		
		allowCollisions = FlxObject.UP + FlxObject.LEFT + FlxObject.RIGHT; // stop player and mobs from getting stuck in the seam of a rock over top of another rock.
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		reset(_startX, _startY);
			
		super.update(elapsed);
	}
	
}
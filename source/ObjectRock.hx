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
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		_startx = x;
		_starty = y;
		
		if ( id == 1 || id == 2)
			loadGraphic("assets/images/objectRock"+id+".png", false, 32, 32);	
		else if (id == 3) loadGraphic("assets/images/objectRock3.png", false, 32, 22);
		else if (id == 4) loadGraphic("assets/images/objectRock4.png", false, 32, 8);
		else if (id == 5) loadGraphic("assets/images/objectRock5.png", false, 32, 20);
		else if (id == 6) loadGraphic("assets/images/objectRock6.png", false, 32, 15);
	
		pixelPerfectPosition = false;		
		ID = id;
		immovable = true;
		
		allowCollisions = FlxObject.UP + FlxObject.LEFT + FlxObject.RIGHT; // stop player and mobs from getting stuck in the seam of a rock over top of another rock.
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		reset(_startx, _starty);
			
		super.update(elapsed);
	}
	
}
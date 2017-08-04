package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectGrassWeed extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);

		_startx = x;
		_starty = y;
		
		loadGraphic("assets/images/objectGrassWeed" + id + ".png", false, 32, 32);	
		
		ID = id;
		
		immovable = true;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectLadder extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		loadGraphic("assets/images/objectLadder.png", true, 4, Reg._tileSize);	

		immovable = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectLaserParameter extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y + 39);

		loadGraphic("assets/images/objectLaserParameter.png", false, Reg._tileSize, 1);
	
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectPlatformParameter extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);

		loadGraphic("assets/images/objectPlatformParameter.png", true, 1, Reg._tileSize);
	
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
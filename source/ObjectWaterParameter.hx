package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectWaterParameter extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y + 40);

		loadGraphic("assets/images/objectWaterParameter.png", true, Reg._tileSize, 1);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
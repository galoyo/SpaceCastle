package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayWater extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);
		
		loadGraphic("assets/images/overlayWater.png", true, Reg._tileSize, Reg._tileSize);	

	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
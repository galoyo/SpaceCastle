package ;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayAirBubble extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);

		loadGraphic("assets/images/overlayAirBubble.png", true, Reg._tileSize, Reg._tileSize);
	
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
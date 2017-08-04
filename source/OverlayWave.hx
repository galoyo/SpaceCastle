package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayWave extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	public static var FLOOR:Int;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y + 8);

		loadGraphic("assets/images/overlayWave.png", true, Reg._tileSize, 24);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
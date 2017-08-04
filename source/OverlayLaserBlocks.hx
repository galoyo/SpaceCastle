package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayLaserBlocks extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		loadGraphic("assets/images/overlayLaserBlock" + id + ".png", true, Reg._tileSize, Reg._tileSize);	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
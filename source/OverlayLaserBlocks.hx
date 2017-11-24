package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayLaserBlocks extends FlxSprite
{
	/*******************************************************************************************************
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
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
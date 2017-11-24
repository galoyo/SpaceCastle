package ;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class OverlayWave extends FlxSprite
{
	/*******************************************************************************************************
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
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
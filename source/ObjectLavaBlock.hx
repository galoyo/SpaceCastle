package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectLavaBlock extends FlxSprite
{
	/**
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/**
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	public function new(x:Float, y:Float) 
	{		
		super(x, y);
		
		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/objectLavaBlock.png", true, Reg._tileSize, Reg._tileSize);	
		animation.add("anim", [0, 1, 2, 3, 3, 2, 1], 5);
		animation.play("anim");
		
		allowCollisions = FlxObject.ANY;
		immovable = true;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		reset(_startX, _startY);
		
		super.update(elapsed);
	}
}
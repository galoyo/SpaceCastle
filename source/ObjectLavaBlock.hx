package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectLavaBlock extends FlxSprite
{
	private var _startX:Float;
	private var _startY:Float;
	
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
		
		//FlxG.collide(this, Reg.state.player, playerCollide);
		
		super.update(elapsed);
	}
}
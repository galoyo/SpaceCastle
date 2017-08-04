package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectCage extends FlxSprite
{
	private var _startX:Float;
	private var _startY:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		loadGraphic("assets/images/objectCage"+id+".png", false, Reg._tileSize, Reg._tileSize);	

		if (id > -1 && id < 5) allowCollisions = FlxObject.UP;
		else allowCollisions = FlxObject.NONE;
		
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxG.collide(this, Reg.state.player);
		FlxG.collide(this, Reg.state.enemies);
		
		super.update(elapsed);
	}
	
}
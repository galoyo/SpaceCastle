package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectJumpingPad extends FlxSprite 
{
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectJumpingPad"+id+".png", false);
		
		immovable = true;
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
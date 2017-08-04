package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectDoorHouse extends FlxSprite 
{	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/objectDoorHouse.png", true, Reg._tileSize, Reg._tileSize);

		immovable = true;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
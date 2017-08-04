package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectDoor extends FlxSprite 
{	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/objectDoor"+id+".png", true, Reg._tileSize, Reg._tileSize);
		
		immovable = true;
		
		// this id gets used to know which door you're at
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
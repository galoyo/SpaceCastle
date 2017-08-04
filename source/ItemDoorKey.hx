package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemDoorKey extends FlxSprite 
{
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/itemDoorKey"+id+".png", true, Reg._tileSize, Reg._tileSize);
		
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
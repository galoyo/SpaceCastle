package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectTreasureChest extends FlxSprite 
{	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
				
		loadGraphic("assets/images/objectTreasureChest.png", true, 60, 48);
		
		immovable = true;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
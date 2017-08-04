package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemHeartContainer extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/itemHeartContainer.png", true, Reg._tileSize, Reg._tileSize);
	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
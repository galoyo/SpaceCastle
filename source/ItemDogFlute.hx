package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemDogFlute extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/itemDogFlute.png", true, Reg._tileSize, Reg._tileSize);
		
		solid = false;
		visible = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
package;

import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ItemGunFlame extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/itemGunFlame.png", true, Reg._tileSize, Reg._tileSize);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
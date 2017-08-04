package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemGunRapidFire extends FlxSprite 
{	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/itemGunRapidFire.png", false, Reg._tileSize, Reg._tileSize);
	}
	
	override public function update(elapsed:Float):Void 
	{				
		super.update(elapsed);
	}
	
}
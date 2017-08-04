package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class NpcWateringCan extends FlxSprite 
{	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/npcWateringCan.png", false, 56, 28);		
		visible = false;
		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		super.update(elapsed);
	}
	
}
package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemSuperBlock extends FlxSprite 
{
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/itemSuperBlock"+id+".png", false);
		
		if (id == 2 && Reg.mapXcoords == 15 && Reg.mapYcoords == 15)
		{
			solid = false;
			visible = false;
		}
		
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
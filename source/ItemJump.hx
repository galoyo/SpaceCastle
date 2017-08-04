package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ItemJump extends FlxSprite 
{
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/itemJump"+id+".png", true, Reg._tileSize, Reg._tileSize);
		
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
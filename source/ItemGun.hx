package;

import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ItemGun extends FlxSprite 
{	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/itemGun"+id+".png", false, Reg._tileSize, Reg._tileSize);		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		super.update(elapsed);
	}
	
}
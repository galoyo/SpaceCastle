package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectComputer extends FlxSprite 
{	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
				
		loadGraphic("assets/images/objectComputer.png", true, Reg._tileSize, Reg._tileSize);
		
		immovable = true;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
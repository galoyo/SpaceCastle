package;

import flixel.FlxG;
import flixel.FlxSprite;


/**
 * @author galoyo
 */

class ObjectTube extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectTube.png", false, 160, 64);
		
		immovable = true; 
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	
}
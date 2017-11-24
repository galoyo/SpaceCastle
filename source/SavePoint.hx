package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSave;

/**
 * @author galoyo
 */

class SavePoint extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/savePoint.png", true, Reg._tileSize, Reg._tileSize);
	
		animation.add("play", [0,2,4,6], 15, true);
		animation.play("play");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}	
}
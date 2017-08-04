package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class OverlayPipe1 extends OverlayPipeChildClass 
{		
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y, id);
		
		loadGraphic("assets/images/overlayPipe" + id + ".png", true, 32, 32);	
		color = FlxColor.GREEN;
	}	
	
}
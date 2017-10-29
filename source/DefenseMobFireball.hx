package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * @author galoyo. Currently, this fireball is used to circle the mobBubble.
 */

class DefenseMobFireball extends FlxSprite 
{	
	private var _tween:FlxTween;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);		
	
		loadGraphic("assets/images/objectFireball.png", false, 16, 16);					
	
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
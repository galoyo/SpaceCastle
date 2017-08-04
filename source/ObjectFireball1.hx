package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * @author galoyo
 */

class ObjectFireball1 extends FlxSprite 
{	
	private var _tween:FlxTween;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);		
	
		loadGraphic("assets/images/objectFireball.png", false, 16, 16);		
				
		_tween = FlxTween.circularMotion(this,
		x+8, 
		y+8,
		36, Reg.state._fireballPositionInDegrees,
		true, Reg.fireballRandom, true, { type: FlxTween.LOOPING });			
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

/**
 * @author galoyo
 */

class ObjectVineMoving extends FlxSprite 
{		
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectVineMoving.png", true, 16, 16);	
		
		var _tween:FlxTween;
		
		if(id == 2)
		{
				// x is center of object. x -5 to 5 + 5 will make the rope move to and from those values. the value of y mades the dip in the half circle movement.
			var _tween = FlxTween.cubicMotion(this,
				x - 5, y,
				x - 5, y + 2.5,
				x + 5, y + 5,
				x + 5, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		
		if(id == 3)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 11, y,
				x - 11, y + 5,
				x + 11, y + 7.5,
				x + 11, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		
		if(id == 4)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 18, y,
				x - 18, y + 7.5,
				x + 18, y + 10,
				x + 18, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		
		if(id == 5)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 26, y,
				x - 26, y + 10,
				x + 26, y + 12.5,
				x + 26, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}			
		
		if(id == 6)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 35, y,
				x - 35, y + 12.5,
				x + 35, y + 15,
				x + 35, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		if(id == 7)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 45, y,
				x - 45, y + 15,
				x + 45, y + 17.5,
				x + 45, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		if(id == 8)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 56, y,
				x - 56, y + 17.5,
				x + 56, y + 20,
				x + 56, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		if(id == 9)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 68, y,
				x - 68, y + 20,
				x + 68, y + 22.5,
				x + 68, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
		if(id == 10)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 81, y,
				x - 81, y + 22.5,
				x + 81, y + 25,
				x + 81, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}	
			
	}
		
}
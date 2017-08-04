package;

import flixel.ui.FlxBar;

/**
 * @author galoyo
 */

class HealthBar extends FlxBar
{
	public function new(x:Float = 0, y:Float = 0, ?direction:FlxBarFillDirection, width:Int = 100, height:Int = 10, ?parentRef:Dynamic, variable:String = "", min:Float = 0, max:Float = 100, showBorder:Bool = false)
	{
		super(x, y, direction, width, height, parentRef, variable, min, max, showBorder);
	
		createFilledBar(0xFF8f0f0f, 0xFF0000FF);
		trackParent(0, Std.int(Reg._tileSize)); // below mob.
	}
	
	override public function update(elapsed:Float):Void
	{
		if (parent != null)
		{
			if (parent.alive && !alive)        // only happens once until next reset()
			{
				reset(0, 0);
				visible = true;
			}
			else if (!parent.alive && alive)   // only happens once until next kill()
			{
				kill();
				exists = true; 
				visible = false;
			}
			
			super.update(elapsed);
		}
	}
}
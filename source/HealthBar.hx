package;

import flixel.ui.FlxBar;

/**
 * @author galoyo
 */

class HealthBar extends FlxBar
{
	/**
	 * @param	x				The x location of the button on the screen?
	 * @param	y				The y location of the button on the screen?
	 * @param	direction		eg, FlxBarFillDirection.LEFT_TO_RIGHT
	 * @param	width			The width of this FlxBar?
	 * @param	height			The height of this FlxBa?
	 * @param	parentRef		The class that will be using this. The attach this FlxBar to the player, use Reg.state.player.
	 * @param	variable		The classes var to display. To display the player's health, use "health".
	 * @param	min				The minimum var of the classes var to display?
	 * @param	max				The maximum var of the classes var to display? Eg, Reg.state.player.health
	 * @param	showBorder		Show a border for this FlxBar?
	 */
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

package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterWaterSplash extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/emitterWaterSplash.png", false, 4, 4);
		
		exists = false;
	}
	
	override public function onEmit():Void
	{
		// this will give an effect of water splash. the graphics will move in an downward direction.
		var xx = FlxG.random.int( -250, 250); var yy = FlxG.random.int( -30, 120);		
		velocity.set(xx, yy);
	}
}
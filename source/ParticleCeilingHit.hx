package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class ParticleCeilingHit extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/particleCeilingHit.png", false, 16, 16);

		exists = false;
	}
	
	override public function onEmit():Void
	{
		// this will give an effect of banging the ceiling. the graphics will float in an upward direction.
		var xx = FlxG.random.int( -120, 120); var yy = FlxG.random.int( 50, 120);		
		velocity.set(xx, -yy);
	}
}
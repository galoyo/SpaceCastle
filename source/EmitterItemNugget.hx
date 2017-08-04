package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * @author galoyo
 */

class EmitterItemNugget extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 2000)
        {
        	var p = new FlxParticle();

			p.loadRotatedGraphic("assets/images/itemNugget.png", 32, -1, true, true);
							
			p.animation.add("animated", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], 30, true);
			p.animation.play("animated");
			p.exists = false;

        	add(p);
        }
        
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(-40, -250, 40, 150);

		acceleration.start.min.y = 800;
		acceleration.start.max.y = 1000;
		acceleration.end.min.y = 800;
		acceleration.end.max.y = 1000;
		
		// hit the floor then bounce. min refers to how much bounce in a percentage from 0 to 1 (float) that is lost or gained when the object bounces down, and max refers to a gain or lost when bouncing up.
		elasticity.set(0.4, 0.4, 1, 1);
		
		// slowly fade the delete the particle.
		alpha.set(1,1,0,0);
		allowCollisions = FlxObject.ANY;
		
		lifespan.set(2);
	}	
}
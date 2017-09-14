package;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterItemHeart extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 15)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/itemHeartRefill.png", false,32, 28);
        	p.exists = false;
        	add(p);
        }
        
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(0);
		
		// set to 0 so no gravity.
		acceleration.set(0);
		allowCollisions = FlxObject.ANY;
		
		// slowly fade the delete the particle.
		alpha.set(1,1,0,0);
		
		lifespan.set(2);
	}	
}
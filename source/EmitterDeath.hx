package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterDeath extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 50)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/emitterDeath.png", true, 32, 32);
        	p.animation.add("death", [0,1,2,3], 15, false);
        	p.animation.play("death");
        	p.exists = false;
        	add(p);
        }
        
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(0);
		
		// set to 0 so no gravity.
		acceleration.set(0);
 
        // Set particle to fade opacity.
        // alpha.set(1, 1, 0, 0);
 
		lifespan.set(0.2);
		
        start(false, 10, 0);
	}	
}
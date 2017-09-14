package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterMobsDamage extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 120)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/emitterMobsDamage.png", true, 32, 32);
			p.animation.add("play", [0,1,2,3,4], 30, false);
			p.animation.play("play");
        	p.exists = false;
        	add(p);
        }
        
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(-200, -200, 200, 200);
		
		// set to 0 so no gravity.
		acceleration.set(0);
 
        // Set particle to fade opacity.
        // alpha.set(2, 2, 1, 1);
 
		lifespan.set(0.2);
		
		// Start emitting at 1 particle per 0.02 seconds
        start(false, 0.2, 0);
	}	
}
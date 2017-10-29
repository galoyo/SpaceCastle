package;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * @author galoyo
 */

class EmitterItemPowerUp extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 70)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/itemPowerUp.png", true, 23, 22);
        	p.animation.add("star", [0,1,2,1], 15, false);
        	p.animation.play("star");
        	p.exists = false;
        	add(p);
        }
        
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(0);
		
		allowCollisions = FlxObject.ANY;
		
		// Set particle to fade opacity.
        alpha.set(1, 1, 0, 0);
 
		lifespan.set(1);
	}	
}
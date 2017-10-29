package;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * @author galoyo
 */

class EmitterBulletFlame extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 400)
        {
        	var p = new FlxParticle();
        	p.makeGraphic(5, 5, 0xFFFFFFFF);
        	p.exists = false;
        	add(p);
        }
        
		// Set radius around origin where particles will appear
        setSize(12, 12);
		
		// this line is needed for the velocity code to work.
		launchMode = FlxEmitterMode.SQUARE;
		
		// set to 0 so no gravity.
		acceleration.set(0);
		
		allowCollisions = FlxObject.ANY;
 
        // Set particle to fade opacity as it goes upwards
        alpha.set(1, 1, 0, 0);

        color.set(0xFFFFFFFF, 0xFF000000);
 
        // Set particle size (scale) range, and grow larger as it fades
        scale.set(0.5, 1, 2, 2.5);
		
		lifespan.set(0.7,0.9);
    }
}
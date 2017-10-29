package;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * @author galoyo
 */

class EmitterItemDiamond extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 50)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/itemDiamondSmall.png", true);
        	p.animation.add("diamondSmall", [0,1,2], 15, false);
        	p.animation.play("diamondSmall");
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
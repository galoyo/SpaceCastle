package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * @author galoyo
 */

class EmitterSkillDash extends FlxEmitter 
{
	public function new() 
	{
		super();
	        
		for (i in 0... 25)
        {
        	var p = new FlxParticle();
        	p.loadGraphic("assets/images/player.png", true, 28, 28);
			p.animation.add("dash", [13], 15);
        	p.animation.play("dash");
        	p.exists = false;
        	add(p);
        }
		
		launchMode = FlxEmitterMode.SQUARE;
		velocity.set(0);
		acceleration.set(0);
		alpha.set(1, 1, 0, 0);
		
		
		lifespan.set(0.2);

	}	
	
}
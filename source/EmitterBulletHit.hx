package;

import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterBulletHit extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/bulletHit.png", true, Reg._tileSize, Reg._tileSize);
		
		// the animation frames. currently, width 32 x height of 128 pixels.
		animation.add("animated", [0, 1, 2, 3], 12, false);
		exists = false;
	}
	
	override public function onEmit():Void
	{
		// when this class is emitted, this animation first defined at this class new() constructor will play.
		animation.play("animated");
		
		velocity.set(0);
		acceleration.y = 0;
	}
}
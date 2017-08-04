package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterAirBubble extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/emitterSmoke.png", false, 10, 10);

		exists = false;
		allowCollisions = FlxObject.ANY;
	}
	
	override public function onEmit():Void
	{
		var yy = FlxG.random.int( 0, 10);
		
		var xxMove = FlxG.random.int( -40, 40);	// random value used for the x velocity.
		var yyMove = FlxG.random.int( 0, -80); 		
		velocity.set(xxMove, yyMove);
		
		// position this partical just behide the mobbullet.
		y = y + yy;
	}
}
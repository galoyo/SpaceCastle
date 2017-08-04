package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterSmokeRight  extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/emitterSmoke.png", false, 12, 12);

		exists = false;
	}
	
	override public function onEmit():Void
	{
		var xx = FlxG.random.int( 0, 15);
		var xxMove = FlxG.random.int( 5, 25); 	// random value used for the x velocity.	
		var yyMove = FlxG.random.int( -65, 75);		
		velocity.set(xxMove, yyMove);
		
		// position this partical just behide the mobbullet.
		x = x + xx;
	}
}
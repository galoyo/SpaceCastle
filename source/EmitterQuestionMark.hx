package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

/**
 * @author galoyo
 */

class EmitterQuestionMark extends FlxParticle 
{
	public function new() 
	{
		super();
		
		// load image of pixels size;
		loadGraphic("assets/images/emitterQuestionMark.png", false, 32, 32);

		setPosition(0, -32);
		exists = false;
	}
	
	override public function onEmit():Void
	{
		velocity.set(0, -80);
	}
}
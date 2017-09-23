package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class BulletObject extends FlxSprite 
{	
	private var _particleBulletHit:FlxEmitter;
	private var _particleBulletMiss:FlxEmitter;
	
	public function new(particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{		
		super();
		
		_particleBulletHit = particleBulletHit;	
		_particleBulletMiss = particleBulletMiss;
		
		loadGraphic("assets/images/objectFireball.png", true, 16, 16);
		color = FlxColor.LIME;		
	
		exists = false; // we don't want this to exist yet.				
	}
	
	override public function update(elapsed:Float):Void 
	{
		// if bullet exists.
		if (isOnScreen())
		{
			if (isTouching(FlxObject.FLOOR) || isTouching(FlxObject.WALL) || isTouching(FlxObject.CEILING) || velocity.x == 0 && velocity.y == 0)
			{
				_particleBulletMiss.focusOn(this);
				_particleBulletMiss.start(true, 0.2, 1);
				
				kill();
			}
		}
	
		if(isOnScreen() == false) 
		{
			kill();
		}	
		
		super.update(elapsed);
	}
	
	public function shoot(x:Int, y:Int, gravity:Float, velocityX:Int, velocityY:Int, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter):Void
	{
		_particleBulletHit = particleBulletHit;
		_particleBulletMiss = particleBulletMiss;
		
		// used to reset the bullet to its default position.
		super.reset(x, y);  
		
		// gravity.
		if (gravity > 0) acceleration.y = gravity;
		
		// they are not the same cade.
		velocity.x = velocityX;
		velocity.y = velocityY;
		
	}
	
}
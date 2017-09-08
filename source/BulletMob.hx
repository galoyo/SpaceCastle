package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

/**
 * @author galoyo
 */

class BulletMob extends FlxSprite 
{	
	private var _emitterBulletHit:FlxEmitter;
	private var _emitterBulletMiss:FlxEmitter;
	
	public function new(emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{		
		super();
		
		_emitterBulletHit = emitterBulletHit;	
		_emitterBulletMiss = emitterBulletMiss;
		
		loadGraphic("assets/images/bulletMob.png", true, 24, 24);
		
		// uncomment if sprite has animation frames. 
		animation.add("shoot", [0, 1], 40);
		animation.play("shoot");	
		
		exists = false; // we don't want this to exist yet.				
	}
	
	override public function update(elapsed:Float):Void 
	{
		// if bullet exists.
		if (isOnScreen())
		{
			// if bullet exists.
			if (this != null)
			{
				if (isTouching(FlxObject.FLOOR) || isTouching(FlxObject.WALL) || isTouching(FlxObject.CEILING) || velocity.x == 0 && velocity.y == 0)
					{
					_emitterBulletMiss.focusOn(this);
					_emitterBulletMiss.start(true, 0.2, 1);
					
					kill();
				}
			}
		}
		
		if(isOnScreen() == false) 
		{
			kill();
		}	
		
		super.update(elapsed);
	}
	
	public function shoot(x:Int, y:Int, velocityX:Int, velocityY:Int, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter):Void
	{	
		if (Reg._bulletSize == 0) loadGraphic("assets/images/bulletMob.png", true, 24, 24);
		else loadGraphic("assets/images/bulletSmallMob.png", true, 14, 14);
		
		// uncomment if sprite has animation frames. 
		animation.add("shoot", [0, 1], 40);
		animation.play("shoot");
		
		_emitterBulletHit = emitterBulletHit;
		_emitterBulletMiss = emitterBulletMiss;
		
		// used to reset the bullet to its default position.
		super.reset(x, y);  
		
		// they are not the same cade.
		velocity.x = velocityX;
		velocity.y = velocityY;
		
	}
	
}
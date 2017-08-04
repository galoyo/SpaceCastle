package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class ObjectChildClass extends FlxSprite 
{
	public var _bulletsObject:FlxTypedGroup<BulletObject>;
	private var _bulletObject:BulletObject;
	private var _bulletSpeed:Int = 450;
	private var _emitterBulletHit:FlxEmitter;
	private var _emitterBulletMiss:FlxEmitter;	
		
	private var _gunDelay:Float;
	private var _cooldown:Float;
	private var _bulletFireFormation:Int; 
	
	private var _startX:Float;
	private var _startY:Float;
	
	var ticks:Int = 0; // used to handle game loops.
	private var ticksWalkAnyDirection:Int = 0;
		
	private var player:Player;
	
	public function new(x:Float, y:Float, bulletsObject:FlxTypedGroup<BulletObject>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y);
		
		_startX = x;
		_startY = y;
		
		_bulletsObject = bulletsObject;
		_emitterBulletHit = emitterBulletHit;
		_emitterBulletMiss = emitterBulletMiss;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{
			super.update(elapsed);
		}
	}		
	
	override public function kill():Void 
	{	
		super.kill();
		
	}
	
private function shoot():Void 
	{		
		// this gives a recharge effect.
		if (_cooldown >= _gunDelay)
		{				
			_bulletObject = _bulletsObject.recycle(BulletObject);
			_bulletObject.exists = true; 						
			
			// can shoot bullet if have the normal gun (1).
			if (_bulletObject != null )
			{
				var bulletX:Int = 0;
				var bulletY:Int = 0;
				
				// position of the bullet at the mob before the bullet starts moving.
				if (_bulletFireFormation == 0) bulletX = Std.int(x);
				if (_bulletFireFormation == 0) bulletY = Std.int(y) - 10;
				
				var bYVeloc:Int = 0;
				var bXVeloc:Int = 0;
				var gravity:Float = 0;
				
				//####################################################
				// fire two bullets east and west when facing at any of those directions.				
				if (_bulletFireFormation == 0)
				{
					gravity = 2500;
					
					// not holding up key. both anti and non-antigravity
					if (facing == FlxObject.LEFT)
					{
						bulletX -= 12; // move bullet to the left side of the player
						bXVeloc = -_bulletSpeed;
						bYVeloc = -_bulletSpeed;
					}
					else // facing right
					{
						bulletX += 40; // move bullet to the right side of the player
						bXVeloc = _bulletSpeed;
						bYVeloc = -_bulletSpeed;
					}
					
					_bulletObject.shoot(bulletX, bulletY, gravity, bXVeloc, bYVeloc, _emitterBulletHit, _emitterBulletMiss);
					
					acceleration.y = 0;
				}
				
				if (Reg._soundEnabled == true) FlxG.sound.play("cannon", 1, false);
		
				_cooldown = 0;	// reset the shot clock
				// emit it
				_emitterBulletHit.focusOn(_bulletObject);
				_emitterBulletHit.start(true, 0.05, 1);
			}
			else
			{
				trace("BULLET NULL");
			}
		}
	}
}
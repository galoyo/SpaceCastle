package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

/**
 * @author galoyo
 */

class Bullet extends FlxSprite 
{	
	/*******************************************************************************************************
	 * Used to store the distance away fron the gun that the particleBulletHit will emit from.
	 */
	private var	_bulletStar:Float = 0;
	
	/*******************************************************************************************************
	 * Distance the bulletStar animation is from the gun.
	 */ 
	private var	_bulletStarDistance:Int = 30;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when the bullet reaches its maximum distance or when the bullet hits a mob.
	 */
	private var _particleBulletHit:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when a bullet from the normal gun hits a tile. 
	 */
	private var _particleBulletMiss:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. Used to display a gun pointing in upward direction or fire a bullet in an upward direction. If anti-gravity is true then the gun will be pointing down and its bullet will travel southward.
	 */
	private var _holdingUpKey:Bool = false;
	
	public function new(particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{		
		super();
		
		_particleBulletHit = particleBulletHit;	
		_particleBulletMiss = particleBulletMiss;
		
		// load a different graphic depending on the value of reg._gunPower.
		loadNewBulletImage();
			
		exists = false; // we don't want this to exist yet.				
	}
	
	private function loadNewBulletImage():Void
	{
		if(Reg._typeOfGunCurrentlyUsed == 2)
			loadGraphic("assets/images/bulletFreeze.png", false, 16, 16);
		else 
		{	
			if(Reg._gunPower == 1)
			loadGraphic("assets/images/bullet1.png", false, Reg._tileSize, 4);
			else if(Reg._gunPower == 2)
			loadGraphic("assets/images/bullet2.png", false, Reg._tileSize, 12);
			else if(Reg._gunPower == 3)
			loadGraphic("assets/images/bullet3.png", false, Reg._tileSize, 20);
		}
	}
	

	override public function update(elapsed:Float):Void 
	{
		// if bullet exists.
		if (this != null)
		{
			loadNewBulletImage();
			trace("a", _holdingUpKey);
			// when the bullet is at the distance of the _bullterStar, emit the _particleBulletHit so that the _bulletStar animation can be seen. Then destroy the animation.
			if (Reg._typeOfGunCurrentlyUsed == 0)
			{
				if (_holdingUpKey == true )
				{	if (Reg._antigravity == false && _bulletStar > y)
					{
						_particleBulletHit.focusOn(this);
						_particleBulletHit.start(true, 0.2, 1);
						kill();
					}
					if (Reg._antigravity == true && _bulletStar < y)
					{
						_particleBulletHit.focusOn(this);
						_particleBulletHit.start(true, 0.2, 1);
						kill();
					}
				}	
				else if (_holdingUpKey == false)
				{
					if((Reg.state.player.facing == FlxObject.RIGHT && x > _bulletStar) || (Reg.state.player.facing == FlxObject.LEFT && x < _bulletStar))
					{	
						_particleBulletHit.focusOn(this);
						_particleBulletHit.start(true, 0.2, 1);
						kill();
					}
				}
			}
			
			if (isTouching(FlxObject.FLOOR) || isTouching(FlxObject.WALL) || isTouching(FlxObject.CEILING))
			{
				_particleBulletMiss.focusOn(this);
				_particleBulletMiss.start(true, 0.2, 1);
				kill();
			}
		}
		
		if(isOnScreen() == false || touching != 0) 
		{
			kill();
		}	
		
		super.update(elapsed);
	}
	
	public function shoot(x:Int, y:Int, velocityX:Int, velocityY:Int, holdingUpKey:Bool, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter):Void
	{
		_holdingUpKey = holdingUpKey; // This code is needed.
		
		if (Reg._playerCanShootAndMove == false) return;
		
		_particleBulletHit = particleBulletHit;
		_particleBulletMiss = particleBulletMiss;
	
		// set the distance the bullet can travel when shooting in the up direction.
		if (_holdingUpKey == true)
		{
			if(Reg._antigravity == false)
			{
				if (Reg.state.player.y > y) _bulletStar = y - (_bulletStarDistance) - ((Reg._gunPower + 1) * 50); 
			}
			else 
			{
				if (Reg.state.player.y <- y) _bulletStar = y + (_bulletStarDistance) + ((Reg._gunPower + 1) * 50);
			}
		}
		else
		{
			if (Reg.state.player.x <= x) {_bulletStar = x + _bulletStarDistance + ((Reg._gunPower + 1) * 50); }
			if (Reg.state.player.x > x) {_bulletStar = x - _bulletStarDistance - ((Reg._gunPower + 1) * 50); }
		}
		
		// used to reset the bullet to its default position.
		super.reset(x, y);
		
		// they are not the same cade.
		velocity.x = velocityX;
		velocity.y = velocityY;
		
		if(Reg._typeOfGunCurrentlyUsed == 2)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreeze", 1, false);
		}
			
		else if (Reg._gunPower == 1)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet", 1, false);
		}
		
		else if(Reg._gunPower == 2)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet2", 1, false);
		}
			
		else if (Reg._gunPower == 3)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet3", 1, false);
		}
	}
	
}
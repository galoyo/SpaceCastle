package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class EnemyChildClass extends FlxSprite 
{
	public var _bulletsMob:FlxTypedGroup<BulletMob>;
	private var _bulletMob:BulletMob;
	private var _bulletSpeed:Int = 350;
	private var _particleBulletHit:FlxEmitter;
	private var _particleBulletMiss:FlxEmitter;	
		
	private var _gunDelay:Float;
	private var _cooldown:Float;
	private var _bulletFireFormation:Int; 
	
	private var _startX:Float;
	private var _startY:Float;
	
	private var velocityXOld:Float; // used to store the direction that the mob was moving.
	private var velocityYOld:Float; // used to address a bug in the code;

	public var _newX:Float = 0;
	public var _newY:Float = 0;
	
	private var _tileX:Int; // the tile, the x coords number not in pixels.
	private var _tileY:Int;
	
	private var _spriteIsMoving:Bool = false; // when the x or y value is changing in value.
	private var _directionMobIsMoving:String;
	
	private var ticks:Float = 0; // used to handle game loops.
	private var ticksWalkAnyDirection:Int = 0;
	public var ticksFrozen:Float = 0; // used to unthaw a mob.
	private var ticksGame:Float = 0; // used when ticks is being used in the loop.
	private var ticksStandingStill:Float = 0;	
	private var ticksMobDelay:Float = 0;
	
	private var mobHit:Bool = false;
	private var _extraSpeed:Int;
	private var _range:Bool = true; // used to determine if the mob and player are within range. if not when reset the mob.
		
	public var _player:Player;
	private var _spawnTimeElapsed:Float = 0;	
	private var _emitterMobsDamage:FlxEmitter;
	private var _emitterDeath:FlxEmitter;
	private var _emitterItemTriangle:FlxEmitter;
	private var _emitterItemDiamond:FlxEmitter;
	private var _emitterItemPowerUp:FlxEmitter;
	private var _emitterItemNugget:FlxEmitter;
	private var _emitterItemHeart:FlxEmitter;
	private var _particleSmokeRight:FlxEmitter;
	private var _particleSmokeLeft:FlxEmitter;
	
	public var _mobStandingOnFireBlockTimer = new FlxTimer();
	
	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y);
		
		_startX = x;
		_startY = y;
		
		_player = player;
		_emitterMobsDamage = emitterMobsDamage;
		_emitterDeath = emitterDeath;
		_emitterItemTriangle = emitterItemTriangle;
		_emitterItemDiamond = emitterItemDiamond;
		_emitterItemPowerUp = emitterItemPowerUp;
		_emitterItemNugget = emitterItemNugget;
		_emitterItemHeart = emitterItemHeart;
		_particleSmokeRight = particleSmokeRight;
		_particleSmokeLeft = particleSmokeLeft;
		_bulletsMob = bulletsMob;
		_particleBulletHit = particleBulletHit;
		_particleBulletMiss = particleBulletMiss;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (inRange(_range))
		{
			// check if the mob is in water.
			if ( Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 15) EnemyCastSpriteCollide.waterEnemy(this);
			//################### LAVA BLOCK.
			// take damage if on the fire block. 1 damage every 1 second.			
			if ( Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) >= 233 && Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) <= 238 || FlxG.collide(this, Reg.state._objectLavaBlock))
			{
				if (_mobStandingOnFireBlockTimer.finished == true) hurt(1);
				
				if (_mobStandingOnFireBlockTimer.active == false)
				_mobStandingOnFireBlockTimer.start(1, null, 1);			
			}
			//################### END LAVA BLOCK.
		
			super.update(elapsed);
		}
	}		
	
	public function inRange(_range):Bool
	{
		// get the distance between the mob and the player.
		var distance = FlxMath.distanceBetween(this, Reg.state.player);
		if ( distance < Reg._distanceBetweenMaximum) return true;
			else return false;
	}
	
	override public function kill():Void 
	{	
		super.kill();
		
		if (isOnScreen())
		{			
			FlxSpriteUtil.stopFlickering(this);		
			
			_emitterDeath.focusOn(this);
			_emitterDeath.start(true, 20, 1);		
			
			var randShowTriangleOrNuggetEmitter = FlxG.random.int(0, 12);
			var randShowHeartEmitter = FlxG.random.int(0, 4);
			
			var ra = FlxG.random.int(1, 18); 
			if (Reg._soundEnabled == true) FlxG.sound.play("hitMonster" + Std.string(ra), 1, false);
			
			if (visible == true)
			{
				if (randShowHeartEmitter == 4) // drop a health heart.
				{
					_emitterItemHeart.focusOn(this);
					_emitterItemHeart.start(false, Reg._mobDropItemDelay, 1);
				}
				
				//############################################
				//######## drop a powerUp.
				if (ra == 5)
				{
					if (Reg.state.player.facing == FlxObject.LEFT)
					{
						_emitterItemPowerUp.acceleration.start.min.x = 300;
						_emitterItemPowerUp.acceleration.start.max.x = 500;
						_emitterItemPowerUp.acceleration.end.min.x = 300;
						_emitterItemPowerUp.acceleration.end.max.x = 500;
					}
					else
					{
						_emitterItemPowerUp.acceleration.start.min.x = -300;
						_emitterItemPowerUp.acceleration.start.max.x = -500;
						_emitterItemPowerUp.acceleration.end.min.x = -300;
						_emitterItemPowerUp.acceleration.end.max.x = -500;
					}
					_emitterItemPowerUp.focusOn(this);
					_emitterItemPowerUp.start(false, Reg._mobDropItemDelay, 1);
				}
				//########## END POWERUP.
				
				// drop a small diamond.
				if (ra == 10 || ra == 20 || ra == 30)
				{
					if (Reg.state.player.facing == FlxObject.LEFT)
					{
						_emitterItemDiamond.acceleration.start.min.x = -300;
						_emitterItemDiamond.acceleration.start.max.x = -500;
						_emitterItemDiamond.acceleration.end.min.x = -300;
						_emitterItemDiamond.acceleration.end.max.x = -500;
					}
					else
					{
						_emitterItemDiamond.acceleration.start.min.x = 300;
						_emitterItemDiamond.acceleration.start.max.x = 500;
						_emitterItemDiamond.acceleration.end.min.x = 300;
						_emitterItemDiamond.acceleration.end.max.x = 500;
					}
					_emitterItemDiamond.focusOn(this);
					_emitterItemDiamond.start(false, Reg._mobDropItemDelay, 1);
				}
				
				// drop triangle. once enought is collected then the power of the gun will increase.
				if (Reg._itemGotGun == true || Reg._itemGotGunFlame == true || Reg._itemGotGunFreeze == true)
				{
					if (randShowTriangleOrNuggetEmitter <= 4)
					{
						// how many trianles to display.
						var randAmountofTrianglesEmitted = FlxG.random.int(1, 3);
							
						// after mob death drops items.
						_emitterItemTriangle.focusOn(this);
						_emitterItemTriangle.start(false, Reg._mobDropItemDelay, randAmountofTrianglesEmitted);
					}
					else if (randShowTriangleOrNuggetEmitter > 4 && randShowTriangleOrNuggetEmitter <= 7)
					{
						// how many nugget to display.
						var randAmountofNuggetsEmitted = FlxG.random.int(1, 7);
							
						// after mob death drops items.
						_emitterItemNugget.focusOn(this);
						_emitterItemNugget.start(false, Reg._mobDropItemDelay, randAmountofNuggetsEmitted);
					}
				}
			}
		}
	
		// wait until the timer is finished then set the mob at the top left corner of screen and hide it, to prepare it for a respawn.
		new FlxTimer().start(Reg._mobsDelayAfterDeath, onTimer, 1);
	}
	
	private function onTimer(Timer:FlxTimer):Void
	{	
		allowCollisions = FlxObject.NONE;
		
		alive = false;			// set the mob as not alive then it can be rotated at death.
		exists = true;			// set exists back on for the respawn timer after super.kill()
		visible = false;		// male sure it's not visible
		setPosition(0, 0);
		
		mobHit = false;			// needed to stop the mob from moving.
	}
	
	public function bounce():Void
	{
		// move the object in an upward direction and push the object in its backward direction.
		velocity.y = -300;		
		if (facing == FlxObject.LEFT)
			velocity.x = -drag.x * 2;
		else velocity.x = drag.x * 2;	
	}
	
	override public function hurt(damage:Float):Void 
	{
	//	if (FlxSpriteUtil.isFlickering(this) == false)
	//	{
		if (Reg._playerCanShootOrMove == true)
		{
			if (damage > 0)
			{
				FlxSpriteUtil.flicker(this, Reg._mobHitFlicker, 0.04);
				
				// set ticks to 5 so that at update() stuff can be updated.
				ticks = 5;
				
				scale.set(1.2, 1.2);
				new FlxTimer().start(0.05, hitOnTimer, 1);

				// normal damage is the gun and that is all hurt(?) values for mobs. if the type of gun used is not the normal first gun found then times the value of the gun currently used by the gun power obtained by getting triangles. 
				damage = damage + (Reg._typeOfGunCurrentlyUsed * Reg._gunPower);
				
				super.hurt(damage);
				
				if (health > 0)
				{
					mobHit = true;
					
					_emitterMobsDamage.focusOn(this);
					_emitterMobsDamage.start(true, 0.1, 2);
				}
			}
	//	}
		}
	}
	
	// when mob is hit, this function sets the mob to its default size.
	private function hitOnTimer(Timer:FlxTimer):Void
	{	
		scale.set(1, 1);
	}
	
private function shoot():Void 
	{		
		// this gives a recharge effect.
		if (_cooldown >= _gunDelay)
		{				
			// if mob can fire a bullet.
			if (_bulletFireFormation > -1)
			{
				_bulletMob = _bulletsMob.recycle(BulletMob);
				_bulletMob.exists = true; 						
			}

			// can shoot bullet if have the normal gun (1).
			if (_bulletMob != null )
			{
				// position of the bullet at the mob before the bullet starts moving.
				var bulletX:Int = Std.int(x);
				var bulletY:Int = Std.int(y);
				
				var bYVeloc:Int = 0;
				var bXVeloc:Int = 0;
				
				//####################################################
				// fire two bullets east and west directions.				
				if (_bulletFireFormation == 0)
				{
					bYVeloc = 0; 				// do not move up or down.
					bXVeloc = -_bulletSpeed;	// move left.
					
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					//###########################
					// this must be after bulletMob.shoot(), but not after the last one in this "if code block", for the next bulletMob.shoot() to work.
					_bulletMob = _bulletsMob.recycle(BulletMob);

					bYVeloc = 0; 				// do not move up or down.
					bXVeloc = _bulletSpeed; 	// move right.

					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
				
				// fires two bullets up and down at the same time.
				else if (_bulletFireFormation == 1)
				{
					bXVeloc = 0;
					bYVeloc = -_bulletSpeed;
					
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
					
					bXVeloc = 0;
					bYVeloc = _bulletSpeed;
					
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
				
				
				//################################################
				// fire four bullets at north, east, west and south.
				else if (_bulletFireFormation == 2)
				{
					// up.
					bXVeloc = 0; 
					bYVeloc = -_bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
					
					// right.
					bXVeloc = _bulletSpeed; 
					bYVeloc = 0; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);	
					_bulletMob = _bulletsMob.recycle(BulletMob);
			
					// down 
					bXVeloc = 0; 
					bYVeloc = _bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);

					// left.
					bXVeloc = -_bulletSpeed; 
					bYVeloc = 0; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
					
				//##################################################
				// fire four bullets at north-east, east-south, south-west, west-north.
				else if (_bulletFireFormation == 3)
				{
					// north-east.
					bXVeloc = _bulletSpeed; 
					bYVeloc = -_bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// south-east.
					bXVeloc = _bulletSpeed; 
					bYVeloc = _bulletSpeed; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);	
					_bulletMob = _bulletsMob.recycle(BulletMob);
			
					// south-west 
					bXVeloc = -_bulletSpeed; 
					bYVeloc = _bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);

					// west-north
					bXVeloc = -_bulletSpeed; 
					bYVeloc = -_bulletSpeed; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
					
				//##############################################
				// fire all bullets at north, north-east, east, east-south, south, west-south, west, west-north.
				else if (_bulletFireFormation == 4)
				{
					// up.
					bXVeloc = 0; 
					bYVeloc = -_bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// 10 o-clock.						
					bXVeloc = _bulletSpeed; 
					bYVeloc = -_bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// right.
					bXVeloc = _bulletSpeed; 
					bYVeloc = 0; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// 20 o-clock.
					bXVeloc = _bulletSpeed; 
					bYVeloc = _bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
												
					// down 
					bXVeloc = 0; 
					bYVeloc = _bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// 40 0-clock
					bXVeloc = -_bulletSpeed; 
					bYVeloc = _bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// left.
					bXVeloc = -_bulletSpeed; 
					bYVeloc = 0; 
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
						
					// 50 o-clock
					bXVeloc = -_bulletSpeed; 
					bYVeloc = -_bulletSpeed;
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
				// fires two bullets at 20 and 40 minutes of a clock.
				else if (_bulletFireFormation == 5)
				{
					bXVeloc = -_bulletSpeed;
					bYVeloc = _bulletSpeed;
					
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
					_bulletMob = _bulletsMob.recycle(BulletMob);
					
					bXVeloc = _bulletSpeed;
					bYVeloc = _bulletSpeed;
					
					_bulletMob.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _particleBulletHit, _particleBulletMiss);
				}
				
				if (Reg._soundEnabled == true) FlxG.sound.play("bulletMob", 0.30, false);
		
				_cooldown = 0;	// reset the shot clock
				// emit it
				_particleBulletHit.focusOn(_bulletMob);
				_particleBulletHit.start(true, 0.05, 1);
			}
		//	else
		//	{
		//		trace("BULLET NULL");
		//	}
		}
	}
	
	function playBossMusic():Void
	{
		// play random music.
		
		var _randomMusicNumber:Int = FlxG.random.int(1, 3); // random var for random music.

		if ( _randomMusicNumber == 1 && Reg._musicEnabled == true) 
		if (Reg._soundEnabled == true) FlxG.sound.playMusic("boss1", 0.80, true);
		if ( _randomMusicNumber == 2 && Reg._musicEnabled == true) 
		FlxG.sound.playMusic("boss2", 0.80, true);
		if ( _randomMusicNumber == 3 && Reg._musicEnabled == true) 
		FlxG.sound.playMusic("boss3", 0.80, true);		
	}
	
	function flyUpThenDown(maxXSpeed:Int, maxYSpeed:Int):Void
	{
		//############# FLY UP/DOWN IN THE AIR WHILE SWAY. ###########
				
		// the mob moves in the direction of this var. if the var is a nagative value then the mob will walk in the direction of left.
		velocity.x = velocityXOld;
		velocity.y = velocityYOld;
				
		// vertical movement.
		if ( x <= (_startX - 16) && velocity.x <= 0 ) {velocity.x = maxYSpeed; velocityXOld = velocity.x; }
		else if ( x >= (_startX + 16) && velocity.x >= 0 ) {velocity.x = -maxXSpeed; velocityXOld = velocity.x; }
		if (velocity.x == 0 && velocityXOld < 0) velocity.x = maxXSpeed;
		else if (velocity.x == 0 && velocityXOld > 0) velocity.x = -maxXSpeed;
		
		// set basic object speed based on conditions.
		if (justTouched(FlxObject.FLOOR) || velocity.y >= 0 && _startY + 96 < y) 
		{
			facing = FlxObject.LEFT;
			velocity.y = -maxYSpeed; 
		
			velocityYOld = velocity.y;
		}
		else if (justTouched(FlxObject.CEILING) || velocity.y < 0 && _startY - 96 > y)
		{
			facing = FlxObject.RIGHT;
			velocity.y = maxYSpeed; 				
		
			velocityYOld = velocity.y;
		}
		//################# END OF FLY UP/DOWN #################
	}
	
	function stopAtLaserBeam():Bool
	{
	// ###################################################
	// AI - stopping at laser beam
	// ###################################################
	// for example, if the mob is facing left and there is a laser beam directly in front of the mob or directly in front but one tile down then stop the mob and wait for the laser beam to be less than the mobs y coords (that is one tile above the head but one tile in front of the mob) so that the laser beam will not collide with the mob when the mob begins to walk again.
		if (facing == FlxObject.LEFT && !overlapsAt(x, y + 23, Reg.state._overlayLaserBeam) && isTouching(FlxObject.FLOOR) && overlapsAt(x - 18, y - 5, Reg.state._objectBeamLaser) || facing == FlxObject.LEFT && !overlapsAt(x, y + 15, Reg.state._overlayLaserBeam) && isTouching(FlxObject.FLOOR) && overlapsAt(x - 18, y + 15, Reg.state._objectBeamLaser) ||
		facing == FlxObject.RIGHT && !overlapsAt(x, y + 23, Reg.state._overlayLaserBeam) && isTouching(FlxObject.FLOOR) && overlapsAt(x + 18, y - 5, Reg.state._objectBeamLaser) || facing == FlxObject.RIGHT && !overlapsAt(x, y + 15, Reg.state._overlayLaserBeam) && isTouching(FlxObject.FLOOR) && overlapsAt(x + 18, y + 15, Reg.state._objectBeamLaser)
		)
		{
			// stop the mob from moving horizontal but store the direction that the mob was moving.
			if(velocity.x != 0)
				velocityXOld = velocity.x;
			
			var xx = FlxG.random.int( 0, 5);
			
			// should the mob stop before the laser beam?
			if (xx < 4) velocity.x = 0;
			
			return true;
		} else return false;
	}
	
	function jumpOverEmptyTile(_YjumpingDelay:Float, _mobIsSwimming:Bool):Void
	{
		//################ JUMP OVER EMPTY TILE ##################
		var jj = FlxG.random.int( 0, 5);
		var moveSpeed = FlxG.random.int(150, 400);					
					
		if (jj <= 2)
		{
			if (acceleration.y < 80000)
			{
				if (isTouching(FlxObject.FLOOR) && facing == FlxObject.LEFT && !overlapsAt(x - 28, y + 28, Reg.state.tilemap) || isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT && !overlapsAt(x + 15, y + 15, Reg.state.tilemap))
				{
					if(_mobIsSwimming == false) {velocity.x = -600 - moveSpeed; velocity.y = -700;}
					else {velocity.x = -600 - moveSpeed / Reg._swimmingDelay; velocity.y = - 700 - -_YjumpingDelay;} 
				}			
			}
		} 
		//############### END JUMP OVER EMPTY TILE ################
	}
	
	function walkButCannotFallInHole(maxXSpeed:Int, _mobIsSwimming:Bool, offset:Int = 0):Void
	{
		// ##################################################
		// ##################################################
		// WALKING THEN REVERSE DIRECTION WHEN TOUCHING WALL OR NEAR HOLE.
		// ##################################################
		if (justTouched(FlxObject.LEFT) && facing == FlxObject.LEFT || isTouching(FlxObject.FLOOR) && facing == FlxObject.LEFT && !overlapsAt(x - 27 - offset, y + 28, Reg.state.tilemap) && facing == FlxObject.LEFT && !overlapsAt(x - 27, y + 15, Reg.state._objectQuickSand))
		{
			facing = FlxObject.RIGHT;
			if(_mobIsSwimming == false) {velocity.x = maxXSpeed; }
			else {velocity.x = maxXSpeed / Reg._swimmingDelay;} 
		}
					
		if (justTouched(FlxObject.RIGHT) && facing == FlxObject.RIGHT ||isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT && !overlapsAt(x + 27 + offset, y + 28, Reg.state.tilemap) && facing == FlxObject.RIGHT && !overlapsAt(x + 27, y + 15, Reg.state._objectQuickSand))
		{
			facing = FlxObject.LEFT;
			if(_mobIsSwimming == false) {velocity.x = -maxXSpeed;}
			else {velocity.x = -maxXSpeed / Reg._swimmingDelay;} 
		}			
		//######### END WALKING THEN REVERSE DIRECTION ##########
		
		if (!overlapsAt(x, y, Reg.state._objectQuickSand))
		{
			if (velocity.x == 0)
			{
				if (x <= Reg.state.player.x) 
				{
					velocity.x = maxXSpeed;
					facing = FlxObject.RIGHT;
					
				}
				else {
					velocity.x = -maxXSpeed;
					facing = FlxObject.LEFT;			
				}
			}
		}
	}

	
	function walkButCanFallInHole(maxXSpeed:Int, _mobIsSwimming:Bool):Void
	{
		//################# WALK BUT CAN FALL IN HOLE ##################
					
					// the mob moves in the direction of this var. if the var is a nagative value then the mob will walk in the direction of left.
					velocity.x = velocityXOld;
					
					// set basic object speed based on conditions.
					if (justTouched(FlxObject.RIGHT)) 
					{
						facing = FlxObject.LEFT;
					}
					else if (justTouched(FlxObject.LEFT))
					{
						facing = FlxObject.RIGHT;
					}
					
					if (facing == FlxObject.LEFT && !overlapsAt(x, y + 28, Reg.state._objectQuickSand) && facing == FlxObject.LEFT && !overlapsAt(x - 27, y + 15, Reg.state._objectQuickSand))
					{
						if(_mobIsSwimming == false)	{velocity.x = -maxXSpeed; }
							else {velocity.x = -maxXSpeed / Reg._swimmingDelay; } 
					
						velocityXOld = velocity.x;
					}
				
					else if (facing == FlxObject.RIGHT && !overlapsAt(x, y + 28, Reg.state._objectQuickSand) && facing == FlxObject.RIGHT && !overlapsAt(x + 27, y + 15, Reg.state._objectQuickSand))
					{
						if (_mobIsSwimming == false) {velocity.x = maxXSpeed;}
							else {velocity.x = maxXSpeed / Reg._swimmingDelay; }				
					
						velocityXOld = velocity.x;
					}					
	}
	//################ END WALK BUT CAN FALL IN HOLE ################

	function freezeMob(_gravity:Int):Void
	{
		//####################### FREEZE MOB #######################
		if (animation.paused == true)
		{ 				
			if (Reg._mobIsFrozenFor + ticksFrozen > 30 && Reg._mobIsFrozenFor + ticksFrozen < 40 ||  Reg._mobIsFrozenFor + ticksFrozen > 50 && Reg._mobIsFrozenFor + ticksFrozen < 60 || Reg._mobIsFrozenFor + ticksFrozen > 68 && Reg._mobIsFrozenFor + ticksFrozen < 75)
			{
				setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
			else
			{
				setColorTransform(0, 1, 1, 1, 0, 0, 0, 0);
			}					
							
			if (Reg._mobIsFrozenFor + ticksFrozen > 80) 
			{
				animation.paused = false; 
				setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				ticksFrozen = 0;
				
				acceleration.y = _gravity;		
			} else {velocity.y = 0; acceleration.y = 0; drag.y = 50000; }
			
			ticksFrozen = Reg.incrementTicks(ticksFrozen, 60 / Reg._framerate);	
			x = _newX; y = _newY; 
			
			if (FlxG.collide(this, _player))
			{
				if (_player._newY != 0 && isTouching(FlxObject.CEILING)) 
				{ 						
					 y = _newY;
					 _player.y = _newY - 25;							 					
				}
			} 
		}
		//##################### END FREEZE MOB #####################
	}
	
	function fishSwim(maxXSpeed:Int, maxYSpeed:Int):Void
	{
		//################## SWIM BACK AND FORTH ##################
		velocity.x = velocityXOld;
		velocity.y = velocityYOld;
			
		// vertical movement.
		if ( y <= (_startY - 16) && velocity.y <= 0 ) {velocity.y = maxYSpeed * (ID / 1.25);velocityYOld = velocity.y; }
		else if ( y >= (_startY + 16) && velocity.y >= 0 ) {velocity.y = -maxYSpeed * (ID / 1.25); velocityYOld = velocity.y; }
		if (velocity.y == 0 && velocityYOld < 0) velocity.y = maxYSpeed;
		else if (velocity.y == 0 && velocityYOld > 0) velocity.y = -maxYSpeed;
		
		// set basic object speed based on conditions.
		if (justTouched(FlxObject.RIGHT)) 
		{
			facing = FlxObject.LEFT;
			velocity.x = -maxXSpeed / Reg._swimmingDelay * (ID / 1.25); 
		
			velocityXOld = velocity.x;
		}
		else if (justTouched(FlxObject.LEFT))
		{
			facing = FlxObject.RIGHT;
			velocity.x = maxXSpeed / Reg._swimmingDelay * (ID / 1.25); 				
			
			velocityXOld = velocity.x;
		}
		//################# END SWIM BACK AND FORTH #################
	}
	
	function walkAnyDirection():Void
	{
		ticksMobDelay = Reg.incrementTicks(ticksMobDelay, 60 / Reg._framerate); // delay the movement of a mob.
		
		if (ticksMobDelay >= 1)
		{
			ticksMobDelay = 0;
			//###########################################################
			//######## Walk any direction, upside down, right-left, ect
			//###########################################################
			
			//#################### MOVING THE SPRITE ####################
			if (_spriteIsMoving == true){				
				
				if (overlapsAt(x, y - 23, Reg.state.tilemap)) angle = 180; // up
				if (overlapsAt(x + 23, y, Reg.state.tilemap)) angle = 270; // right
				if (overlapsAt(x, y + 23, Reg.state.tilemap)) angle = 0;   // down
				if (overlapsAt(x - 23, y, Reg.state.tilemap)) angle = 90;  // left				
				
				// this is used to move the sprite.
				ticksWalkAnyDirection = ticksWalkAnyDirection + 4;				
				
				if (_directionMobIsMoving == "left" ){
					x = x - 4;
					facing = FlxObject.LEFT;
				}
				
				if (_directionMobIsMoving == "down" ){
					y = y + 4;
				}
				
				if (_directionMobIsMoving == "right" ){
					x = x + 4;
					facing = FlxObject.RIGHT;
				}
				
				if (_directionMobIsMoving == "up" ){
					y = y - 4;
				}
				
				// sprite has moved a full tile. now set the var so that the sprite can no longer be moved.
				if (ticksWalkAnyDirection >= 32) { ticksWalkAnyDirection = 0; _spriteIsMoving = false;}
			}
			//################## END MOVING THE SPRITE ###################
			
			//################## FIND TILE TO MOVE TO ####################
			if (_spriteIsMoving == false)
			{
				// convert pixels to tiles. used to find the next tile.
				_tileX = Std.int(x / 32);		
				_tileY = Std.int(y / 32);
				
				//######### LEFT				
				// if to the left of the mob there is an overlay tile then set the vars so that the mob can walk to it.
				if (Reg.state.overlays.getTile(_tileX - 1, _tileY) == 6 && _directionMobIsMoving == "left" || Reg.state.underlays.getTile(_tileX - 1, _tileY) == 38 && _directionMobIsMoving == "left") 
				{
					_spriteIsMoving = true;
				}
				
				// if there are no more left tiles
				else if (Reg.state.overlays.getTile(_tileX - 1, _tileY) != 6 && _directionMobIsMoving == "left" || Reg.state.underlays.getTile(_tileX - 1, _tileY) != 38 && _directionMobIsMoving == "left") 
				{
					// determine if there is a down tile to move to.
					if (Reg.state.overlays.getTile(_tileX, _tileY + 1) == 6 && _directionMobIsMoving == "left" || Reg.state.underlays.getTile(_tileX, _tileY + 1) == 38 && _directionMobIsMoving == "left") 
					{ 
						_directionMobIsMoving = "down";
						_spriteIsMoving = true;
					}
					
					// determine if there is a up tile to move to.
					else if (Reg.state.overlays.getTile(_tileX, _tileY - 1) == 6 && _directionMobIsMoving == "left" || Reg.state.underlays.getTile(_tileX, _tileY - 1) == 38 && _directionMobIsMoving == "left") 
					{ 
						_directionMobIsMoving = "up";
						_spriteIsMoving = true;
						
					}

					else {_directionMobIsMoving = "right"; _spriteIsMoving = true;}
				}	
				
				//######### DOWN				
				// if down from the mob there is an overlay tile then set the vars so that the mob can walk to it.
				if (Reg.state.overlays.getTile(_tileX, _tileY + 1) == 6 && _directionMobIsMoving == "down" || Reg.state.underlays.getTile(_tileX, _tileY + 1) == 38 && _directionMobIsMoving == "down") 
				{
					_spriteIsMoving = true;
					
				}
				
				// if there are no more down tiles
				else if (Reg.state.overlays.getTile(_tileX, _tileY + 1) != 6 && _directionMobIsMoving == "down" || Reg.state.underlays.getTile(_tileX, _tileY + 1) != 38 && _directionMobIsMoving == "down") 
				{
					// determine if there is a left tile to move to.
					if (Reg.state.overlays.getTile(_tileX - 1, _tileY) == 6 && _directionMobIsMoving == "down" || Reg.state.underlays.getTile(_tileX - 1, _tileY) == 38 && _directionMobIsMoving == "down") 
					{ 
						_directionMobIsMoving = "left";
						_spriteIsMoving = true;
						
					}
					
					// determine if there is a right tile to move to.
					else if (Reg.state.overlays.getTile(_tileX + 1, _tileY) == 6 && _directionMobIsMoving == "down" || Reg.state.underlays.getTile(_tileX + 1, _tileY) == 38 && _directionMobIsMoving == "down") 
					{ 
						_directionMobIsMoving = "right";
						_spriteIsMoving = true;
						
					}
					
					else {_directionMobIsMoving = "up"; _spriteIsMoving = true;}
				}	
				
				//######### RIGHT				
				// if to the right of the mob there is an overlay tile then set the vars so that the mob can walk to it.
				if (Reg.state.overlays.getTile(_tileX + 1, _tileY) == 6 && _directionMobIsMoving == "right" || Reg.state.underlays.getTile(_tileX + 1, _tileY) == 38 && _directionMobIsMoving == "right") 
				{
					_spriteIsMoving = true;
					
				}
				
				// if there are no more right tiles
				else if (Reg.state.overlays.getTile(_tileX + 1, _tileY) != 6 && _directionMobIsMoving == "right" || Reg.state.underlays.getTile(_tileX + 1, _tileY) != 38 && _directionMobIsMoving == "right") 
				{
					// determine if there is a down tile to move to.
					if (Reg.state.overlays.getTile(_tileX, _tileY + 1) == 6 && _directionMobIsMoving == "right" || Reg.state.underlays.getTile(_tileX, _tileY + 1) == 38 && _directionMobIsMoving == "right") 
					{ 
						_directionMobIsMoving = "down";
						_spriteIsMoving = true;
						
					}
					
					// determine if there is a up tile to move to.
					else if (Reg.state.overlays.getTile(_tileX, _tileY - 1) == 6 && _directionMobIsMoving == "right" || Reg.state.underlays.getTile(_tileX, _tileY - 1) == 38 && _directionMobIsMoving == "right") 
					{ 
						_directionMobIsMoving = "up";
						_spriteIsMoving = true;
						
					}
					else {_directionMobIsMoving = "left"; _spriteIsMoving = true;}
				}	
				
		//######### UP				
				// if up from the mob there is an overlay tile then set the vars so that the mob can walk to it.
				if (Reg.state.overlays.getTile(_tileX, _tileY - 1) == 6 && _directionMobIsMoving == "up" || Reg.state.underlays.getTile(_tileX, _tileY - 1) == 38 && _directionMobIsMoving == "up")  
				{
					_spriteIsMoving = true;
					
				}
				
				// if there are no more up tiles
				else if (Reg.state.overlays.getTile(_tileX, _tileY - 1) != 6 && _directionMobIsMoving == "up" || Reg.state.underlays.getTile(_tileX, _tileY - 1) != 38 && _directionMobIsMoving == "up") 
				{
					// determine if there is a left tile to move to.
					if (Reg.state.overlays.getTile(_tileX - 1, _tileY) == 6 && _directionMobIsMoving == "up" || Reg.state.underlays.getTile(_tileX - 1, _tileY) == 38 && _directionMobIsMoving == "up") 
					{ 
						_directionMobIsMoving = "left";
						_spriteIsMoving = true;
						
					}
					
					// determine if there is a right tile to move to.
					else if (Reg.state.overlays.getTile(_tileX + 1, _tileY) == 6 && _directionMobIsMoving == "up" || Reg.state.underlays.getTile(_tileX + 1, _tileY) == 38 && _directionMobIsMoving == "up") 
					{ 
						_directionMobIsMoving = "right";
						_spriteIsMoving = true;
						
					}
					else {_directionMobIsMoving = "down"; _spriteIsMoving = true;}
				}	
			}
			//############### END FIND TILE TO MOVE TO #################
		}
	}
	
	function continueToJumpTowardsPlayer(_YjumpingDelay:Float, _mobIsSwimming:Bool):Void
	{
		//############ CONTINUE TO JUMP TOWARDS PLAYER. #############
		// animate the player based on conditions.
		if (isTouching(FlxObject.FLOOR))
		{
			animation.play("standing");
			
			ticksGame = Reg.incrementTicks(ticksGame, 60 / Reg._framerate);
		
			if (ticksGame > 2)
			{
				ticksGame = 0;	
				
				var moveSpeed = FlxG.random.int(150, 400);			
				var moveDistance = FlxG.random.int(-50, 50);		


				if (y - Reg.state.player.y < 128 && y - Reg.state.player.y > -128 || y == Reg.state.player.y)
				{
					// player is at the left side of the mob and within the distance that the mob will start moving...
					if (mobHit == true || Reg.state.player.x < x && x - Reg.state.player.x < 120 + moveDistance)
					{
						if (!overlapsAt(x, y + 14, Reg.state._objectQuickSand))
						{
							// if mob with id 2 then increase the move speed.
							if(_mobIsSwimming == false)	{velocity.x = -_extraSpeed - moveSpeed; velocity.y = -_extraSpeed; }
							else 
							{
								velocity.x = -_extraSpeed - moveSpeed / Reg._swimmingDelay; velocity.y = - _extraSpeed - -_YjumpingDelay;							
							}
						
							animation.play("jumping");
							if (Reg._soundEnabled == true) FlxG.sound.play("jumpMob", 0.50, false);
									
							acceleration.x = -50000;
									
							mobHit = false;
						}
					}
					else if (mobHit == true || Reg.state.player.x > x && Reg.state.player.x - x < 120 + moveDistance)
					{		
						if (!overlapsAt(x, y + 14, Reg.state._objectQuickSand))
						{
							// if mob with id 2 then increase the move speed.
							if (_mobIsSwimming == false)	
							{
								velocity.x = -_extraSpeed + moveSpeed; velocity.y = -_extraSpeed;
							}
							else {velocity.x = -_extraSpeed + moveSpeed / Reg._swimmingDelay; velocity.y = -_extraSpeed - -_YjumpingDelay;} 
							
							animation.play("jumping");	
							if (Reg._soundEnabled == true) FlxG.sound.play("jumpMob", 0.50, false);
									
							acceleration.x = 50000;
									
							mobHit = false;
						}
					} 
				}
				// stop the mob if not within the move distance, the distance between the player and mob.
			}	else {velocity.x = 0; acceleration.x = 0; }
		}
		// mob is in the air so play the "landing" anaimation.
		else if (justTouched(FlxObject.FLOOR)) animation.play("landing");
		else animation.play("walking");
		//############ END CONTINUE TO JUMP TOWARDS PLAYER #############
	}
	
	function jumpHappyIgnorePlayer(_mobIsSwimming:Bool):Void
	{
		//################ JUMP HAPPY IGNORE PLAYER. ################
		var moveSpeed = FlxG.random.int(850, 1100);	
		
		if (isTouching(FlxObject.FLOOR))
		{
			if(_mobIsSwimming == false) {velocity.x = - moveSpeed; velocity.y = -moveSpeed / 1.5;}
			else {velocity.x = - moveSpeed / Reg._swimmingDelay; } // does not jump in water.
		}
		//############## END JUMP HAPPY IGNORE PLAYER. ##############
	}
	
	function seekPlayerAfterTouchingTile(maxSpeed:Int, _mobIsSwimming:Bool):Void
	{
		//############# SEEK PLAYER AFTER TOUCHING TILE. ##############
		
		var xdistance:Float = Reg.state.player.x - x;
		var ydistance:Float = Reg.state.player.y - y;
		var distancesquared:Float = xdistance * xdistance + ydistance * ydistance;			
			
		if (distancesquared < Math.pow(24, 4)) // 12 tile radius away
		{
			// warp to player if mob is standing still.
			if ( velocity.x == 0 && velocity.y == 0 && !overlapsAt(x + 32, y, Reg.state.player) && !overlapsAt(x - 32, y, Reg.state.player) && !overlapsAt(x, y + 32, Reg.state.player) && !overlapsAt(x, y - 32, Reg.state.player) && ticks > 0 || ticksStandingStill == 0) 
			{
				if (ticksStandingStill > 50)
				{
					allowCollisions = FlxObject.ANY;
					this.alpha = 1;
					ticksStandingStill = 0;
				}
				
				else if (ticksStandingStill > 40)
				{		
					allowCollisions = FlxObject.NONE; 
					this.alpha = 0.80;
					
					if(!overlapsAt(x + 32,y, Reg.state.tilemap))//if nothing right side of player.
					{						
						x = Reg.state.player.x + 32;
						y = Reg.state.player.y;
					}
					else if(!overlapsAt(x - 32,y, Reg.state.tilemap))//if nothing left side of player.
					{						
						x = Reg.state.player.x - 32;
						y = Reg.state.player.y;
					}
					else if(!overlapsAt(x,y -32, Reg.state.tilemap))//if nothing up from player.
					{						
						x = Reg.state.player.x;
						y = Reg.state.player.y - 32;
					}
					else if(!overlapsAt(x,y +32, Reg.state.tilemap))//if nothing down from player.
					{						
						x = Reg.state.player.x;
						y = Reg.state.player.y + 32;
					}
						
										
					FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
						
					if (Reg._soundEnabled == true) FlxG.sound.play("ghost", 1, false);
				}
				
				else if (ticksStandingStill > 20) 
				{
					allowCollisions = FlxObject.NONE; 
					this.alpha = 0.60;
					
				}
				else if (ticksStandingStill > 15) 
				{
					allowCollisions = FlxObject.NONE; 
					this.alpha = 0.40; 
					
				}
				else if (ticksStandingStill > 10) 
				{	
					allowCollisions = FlxObject.NONE; 
					this.alpha = 0.20;
					
				}
				else if (ticksStandingStill > 5) 
				{
					allowCollisions = FlxObject.NONE; 
					this.alpha = 0;
					
				}
				
				ticksStandingStill = Reg.incrementTicks(ticksStandingStill, 60 / Reg._framerate);
			}			
				
			else
			{
				if (!FlxSpriteUtil.isFlickering(this))
				{
					allowCollisions = FlxObject.ANY;
					this.alpha = 1;
				}
				
				// move mob only when not in the coord of the player. if player is underneath of this mob, then the mob will only stop its horizontal movement towards player when both x coords are within 10 pixels of each other.
				if (x -Reg.state.player.x> 10)
				{
					if (_mobIsSwimming == false) {velocity.x = -maxSpeed; }	
					else {velocity.x = -maxSpeed / Reg._swimmingDelay; }
				}
				else if (Reg.state.player.x - x > 10)
				{					
					if (_mobIsSwimming == false) {velocity.x = maxSpeed; }	
					else {velocity.x = maxSpeed / Reg._swimmingDelay; }
				} else velocity.x = 0;
					
				if (y - Reg.state.player.y > 10)
				{
					if (_mobIsSwimming == false) {velocity.y = -maxSpeed; }	
					else {velocity.y = -maxSpeed / Reg._swimmingDelay; }
				}
				else if (Reg.state.player.y - y > 10)
				{
					if (_mobIsSwimming == false) {velocity.y = maxSpeed; }	
					else {velocity.y = maxSpeed / Reg._swimmingDelay; }
				} else velocity.y = 0;
			}			
		}
		//########### END SEEK PLAYER AFTER TOUCHING TILE. #############
	}
	
	function flyBackAndForth(maxXSpeed:Int):Void
	{
		//################## FLY BACK AND FORTH. #################
		// the mob moves in the direction of this var. if the var is a nagative value then the mob will fly in the direction of left.
		velocity.x = velocityXOld;
					
		// set basic object speed based on conditions.
		if (justTouched(FlxObject.RIGHT)) 
		{
			facing = FlxObject.LEFT;
			velocity.x = -maxXSpeed; 
				
			velocityXOld = velocity.x;
		}
		else if (justTouched(FlxObject.LEFT))
		{
			facing = FlxObject.RIGHT;
			velocity.x = maxXSpeed; 				
				
			velocityXOld = velocity.x;
		}
		//################### END FLY BACK AND FORTH ###################
	}
	
	
}
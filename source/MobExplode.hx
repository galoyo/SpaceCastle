package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class MobExplode extends EnemyChildClass 
{
	/**
	 * Time it takes for this mob to fire another bullet.
	 */
	private var _bulletTimeForNextFiring:Float = 1;
	
	/**
	 * -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	 */	
	private var _bulletFormationNumber:Int = 5;
	
	private var ra:Int; // distance from player.
	private var ra2:Int; // how many pixels in an update elapsed this mob can move towards the player.
	private var raSpeed:Int; // how much additional speed is added to velocity.y
	private var ticksMove:Float = 0;
	private var ticksExplode:Float = 0;
	
	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */	
	public var defaultHealth:Int = 2;
	
	/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 280;
	
	/**
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */public var _gravity:Int = -4200;
	 
	/**
	  * When reset(), this will be the _gravity value.
	  */
	private var _gravityResetToThisValue:Int = -4200;
	
	/**
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/**
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;	
	
	private var _fixedDirection:Int = 0; //  0 = this mob does not have a fixed direction. 1 = left. 2 = right.
	
	/**
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Float = 0; 
	
	/**
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 80;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 80; 
	
	public function new(x:Float, y:Float, player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		_startX = x;
		_startY = y;		
		
		loadGraphic("assets/images/mobExplode.png", true, 35, 45);
		
		animation.add("falled", [0,1], 20, true);			
		
		pixelPerfectPosition = true;
		allowCollisions = FlxObject.ANY;		
		
		properties();
	}
	
	override public function update(elapsed:Float):Void 
	{		
		if (visible == false)
		{
			_spawnTimeElapsed += elapsed;
			
			if (_spawnTimeElapsed >= Reg._spawnTime)
				reset(_startX, _startY);	
			
			return;
		}
		
		if (isOnScreen() == true)
		{
			
			// make the spike fall if spike is within the x range of the player.
			if (ticks == 0 && Reg.state.player.x > x - ra && Reg.state.player.x < x + ra && !overlapsAt(x + 14, y + 14, Reg.state._objectQuickSand)) 
			{
				velocity.y = 1450 + raSpeed;
				
				ticksMove = Reg.incrementTicks(ticksMove, 60 / Reg._framerate);
				solid = true;				
			
				if (!isTouching(FlxObject.FLOOR)) 
				{
					// move this mob in the x direction towards the player.
					if (_fixedDirection == 1) x = _startX - (ticksMove * ra2);
					else if (_fixedDirection == 2) x = _startX + (ticksMove * ra2);
					
					else if (x >= Reg.state.player.x)
					{
						x = _startX - (ticksMove * ra2);
						facing = FlxObject.LEFT;
						_fixedDirection = 1;
					}
					else 
					{
						x = _startX + (ticksMove * ra2);
						facing = FlxObject.RIGHT;
						_fixedDirection = 2;
					}
				}
			}
			
			// mob not yet fallen to the ground.
			if (ticks == 0)
			{
				// player and enemy damage taken, if spike hits them.
				if (FlxG.overlap(Reg.state.player, this))
				{
					Reg.state.player.hurt(3);		
					
				}
				FlxG.overlap(Reg.state.enemies, this, spikeFallingEnemy);
			}
								
			// stop the spike if collides with tilemap, then play the animation that it appears that the spike is goes into the tilemap just a bit.
			if (isTouching(FlxObject.FLOOR))
			{
				
				if (ticks == 0) 
				{ 
					// if mob collides with slope then set mob offset so that the bottom tip of this mob stops at the slope not above the slope.
					if ( Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 22
						|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 30
						|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 38 
						|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 46)
					{					
						offset.set(0, -20);
					}	
				
					velocity.y = 0;
					animation.play("falled"); 
					ticks = 1; 
					alpha = 0.5;				
				}
			}
			
			if (ticks == 1)
			{
				ticksExplode = Reg.incrementTicks(ticksExplode, 60 / Reg._framerate);
				if (ticksExplode == 20) {visible = false; animation.reset(); super.kill();}
			}
			
			// bullet
			_cooldown += elapsed;
			Reg._bulletSize = 2; // shoot a small bullet.
			if (isOnScreen()) shoot();
			super.update(elapsed);
		}
	}	
	
	// enemy hurt damage if hit by this mob
	private function spikeFallingEnemy(e:FlxSprite, s:FlxSprite):Void
	{
		if (FlxSpriteUtil.isFlickering(e) == false)
		{
			e.hurt(3);
		}

	}
	
	override public function reset(x:Float, y:Float):Void 
	{
		super.reset(x, y);
		allowCollisions = FlxObject.ANY;
		properties();
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
	
	private function properties():Void
	{
		// bullet.
		_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
		_cooldown = FlxG.random.float(0.10, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
		_gravity = _gravityResetToThisValue;
		velocity.y = 0;
		health = defaultHealth;
		ticks = 0;
		ticksMove = 0;
		ticksExplode = 0;
		_fixedDirection = 0;
		visible = true;
		ra = FlxG.random.int(80, 110);	
		ra2 = FlxG.random.int(2, 8);
		raSpeed = FlxG.random.int(1, 300);
		
	}
}
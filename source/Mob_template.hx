package ;
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

class Mob_template extends EnemyParentClass
{
	/**
	 * Time it takes for this mob to fire another bullet.
	 */
	private var _bulletTimeForNextFiring:Float = 1;
	
	/**
	 * -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	 */
	private var _bulletFormationNumber:Int = -1;
	
	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth1:Int = 1;
	
	/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 300;
	
	/**
	 * The X and/or Y velocity of this mob. Must be in integers of 32.
	 */
	private var maxSpeed:Int = 256;
	
	/**
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	public var _gravity:Int = 4400;	
	
	/**
	  * When reset(), this will be the _gravity value.
	  */
	private var _gravityResetToThisValue:Int = 4400;
	
	/**
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/**
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;
	
	/**
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Int = 0; 
	
	/**
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 100;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 100; 
	
	public function new(x:Float, y:Float, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mob_template.png", true, Reg._tileSize, Reg._tileSize);
		
		_startX = x; // used when resetting mob
		_startY = y;
		
		// uncomment if sprite has animation frames. 
		//animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 12);
		//animation.play("walk");	

		pixelPerfectPosition = false;
				
		properties(); // gravity, direction facing, is alive, ect and health vars.		

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
		
		if(isOnScreen())
		{
			if (justTouched(FlxObject.FLOOR)) 
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
				_inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) _inAir = true;			
				
						//--------------------------------slopes
			if ( Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 22
				|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 30
				|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 38 
				|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 46)
			{					
				if( Reg._antigravity == false) acceleration.y = Reg._gravityOnSlopes;
				else acceleration.y = -Reg._gravityOnSlopes;
			}	
			// if player in not in the air oris not standing on the slope then player is standing on a tile. set gravity to normal.
			else
			{
				if (Reg._antigravity == false) acceleration.y = _gravity;
				else acceleration.y = -_gravity;
			}
			
			//------------------ WALK BUT CANNOT FALL IN HOLE
			walkButCannotFallInHole(maxXSpeed, _mobInWater);

			//------------------ FLY UP/DOWN IN THE AIR WHILE SWAY.
			flyUpThenDown(maxXSpeed, maxYSpeed);

			//------------------ STOP AT LASER BEAM.
			// NOTE: THIS FUNCTION CALL NEEDS TO BE PLACED LAST. Place it just before the "ticks = 1;" code.
			stopAtLaserBeam();	

			//------------------ JUMP OVER EMPTY TILE.	HOLE MUST BE 2 TILES DEEP.
			jumpOverEmptyTile(_slowJumpingInWater, _mobInWater);

			//------------------ WALK BUT CAN FALL IN HOLE
			walkButCanFallInHole(maxXSpeed, _mobInWater);

			//------------------ FISH SWIMMING BACK AND FORTH.
			fishSwim(maxXSpeed, maxYSpeed);

			//------------------ MOB WALK ANY DIRECTION
			walkAnyDirection();

			//------------------ CONTINUE TO JUMP TOWARDS PLAYER
			continueToJumpTowardsPlayer(_slowJumpingInWater, _mobInWater);


			//------------------ JUMP HAPPY IGNORE PLAYER.
			jumpHappyIgnorePlayer(_mobInWater);


			//------------------ SEEK PLAYER AFTER TOUCHING TILE.
			seekPlayerAfterTouchingTile(maxSpeed, _mobInWater);

			//------------------ FLY BACK AND FORTH.
			flyBackAndForth(maxXSpeed);

			if (velocity.x == 0) velocity.x = velocityXOld;			
			ticks = 1;
		} else if (ticks > 0) reset(_startX, _startY);
		
		if (isOnScreen())
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
		//------------------ FREEZE MOB.
			// place this code outside of the `animation.paused == false` loop.
			// and put this inside that loop... if (velocity.x == 0) velocity.x = velocityXOld;
			// just above ticks = 1;
			freezeMob(_gravity);
				
			// bullet
			_cooldown += elapsed;
			Reg._bulletSize = 0; // 0 = large. 1 = medium. 2 = small.
			if (isOnScreen()) shoot();
		
			super.update(elapsed);
		}
		
		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
	override public function reset(xx:Float, yy:Float):Void 
	{		
		super.reset(x, y);
		allowCollisions = FlxObject.ANY;
		properties();
		
		_spawnTimeElapsed = 0;	// this is the amount of time that the mob cannot be hit by the player.
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
	
	public function properties():Void 
	{
		alive = true;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		if (x <= Reg.state.player.x) 
		{
			velocity.x = maxXSpeed;
			facing = FlxObject.RIGHT;
			
		}
		else {
			velocity.x = -maxXSpeed;
			facing = FlxObject.LEFT;			
		}
		
		maxVelocity.x = maxXSpeed;
		velocityXOld = velocity.x;
		
		// used with jumping ability.
		_gravity = _grav
		acceleration.y = _gravity;	
		
		angle = 0;
		health = defaultHealth1;
		visible = true;
		
		// bullet.
		_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
		_cooldown = FlxG.random.float(0.10, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
		
	}
}
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

class MobCutter extends EnemyParentClass
{
	/**
	 * Used to slow the mobs jumping when in water.
	 */ 
	private var _slowJumpingInWater:Float = 100;
	
	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth:Int = 3;
	
	/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 400;
	
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
	public var airTimerTicks:Float = 0; 
	
	/**
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 70;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 70; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/mobCutter.png", true, 28, 28);
		
		if (id == 1) animation.add("walk", [0, 1, 2, 1], 12);
		if (id == 2) animation.add("walk", [3, 4, 5, 4], 12);
		if (id == 3) animation.add("walk", [6, 7, 8, 7], 12);
		animation.play("walk");	
		
		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
				
		_gravity = _gravityResetToThisValue;
		velocity.y = 0;
		alive = true;
		angle = 0;
		_mobInWater = false;
		visible = true;	
		
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
		
		angle = 0;
		health = (defaultHealth * ID) * Reg._difficultyLevel;
		visible = true;
		
		_airLeftInLungs = _airLeftInLungsMaximum;
		acceleration.y = _gravity;	
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
		
		if (isOnScreen())
		{
			if (animation.paused == false)
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
					acceleration.y = Reg._gravityOnSlopes;
				}	
				// if player in not in the air oris not standing on the slope then player is standing on a tile. set gravity to normal.
				else acceleration.y = _gravity;
				//--------------------------------------				
											

				// ----------------- JUMP OVER EMPTY TILE. HOLE MUST BE 2 TILES DEEP.	
				jumpOverEmptyTile(_slowJumpingInWater, _mobInWater);
							
				//------------------ WALK BUT CAN FALL IN HOLE
				walkButCanFallInHole(maxXSpeed, _mobInWater);
				
				if (velocity.x == 0) velocity.x = velocityXOld;
				
				//------------------ STOP AT LASER BEAM.
				// NOTE: THIS FUNCTION CALL NEEDS TO BE PLACED LAST.
				stopAtLaserBeam();
								
				ticks = 1;
			}
		} else if (ticks > 0) reset(_startX, _startY);
		
		if (inRange(_range))
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;		
					
			//------------------ FREEZE MOB.
			// place this code outside of the `animation.paused == false` loop.
			// and put this inside that loop... if (velocity.x == 0) velocity.x = velocityXOld;
			// just above ticks = 1;
			freezeMob(_gravity);
			
			super.update(elapsed);
		}
		
		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
	override public function reset(x:Float, y:Float):Void 
	{
		super.reset(x, y);
		allowCollisions = FlxObject.ANY;
		properties();
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
	
	
}
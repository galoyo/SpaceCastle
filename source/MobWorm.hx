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

class MobWorm extends EnemyChildClass
{
	/**
	 * how fast the horizontal movement of this mob is.
	 */
	private var maxXSpeed:Int = 400;

	/**
	 * init the gravity.
	 */
	private var _gravity:Int = 0;

	/**
	 * the default health.
	 */
	public var defaultHealth:Int = 4;
	
	/**
	 * the object does not start in the air.
	 */
	public var inAir:Bool = false;
	
	/**
	 * this object does not start swimming.
	 */
	public var _mobIsSwimming:Bool = false;
	
	/**
	 * used to store the last known direction that the mob was moving.
	 */
	private var velocityOld:Float;	
	
	/**
	 *  used to delay the decreasing of the _airLeftInLungs var.
	 */
	public var airTimerTicks:Int = 0; 
	
	/**
	 * total air left in the lungs of this mob.
	 */
	public var _airLeftInLungs:Int = 90;
	
	/**
	 * this var is used to reset _airLeftInLungs when jumping out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 90; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, emitterSmokeRight:FlxEmitter, emitterSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, emitterSmokeRight, emitterSmokeLeft, bulletsMob, emitterBulletHit, emitterBulletMiss);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobWorm.png", true, 50, 37);
		
		// uncomment if sprite has animation frames. 
		if (id == 1) animation.add("flying", [0, 1, 0, 2], 32);
		if (id == 2) animation.add("flying", [3, 4, 3, 5], 32);
		if (id == 3) animation.add("flying", [6, 7, 6, 8], 32);
		
		animation.play("flying");	

		ID = id;
		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		alive = true;
		angle = 0;
		_mobIsSwimming = false;
		visible = true;	
		
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
		
		health = (defaultHealth * ID) * Reg._differcuityLevel;
		_airLeftInLungs = _airLeftInLungsMaximum;
		acceleration.y = 0; drag.y = 50000;	
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
		
		if (inRange(_range))
		{
			if(animation.paused == false)
			{
					//------------------ FLY BACK AND FORTH.
					flyBackAndForth(maxXSpeed);
					
					if (velocity.x == 0) velocity.x = velocityXOld;
					ticks = 1;
			}
		} else if (ticks > 0 && Reg._trackerInUse == false) reset(_startX, _startY);
		
		if (inRange(_range))
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
			//------------------ FREEZE MOB.
			// place this code outside of the `animation.paused == false` loop.
			// and put this inside that loop... if (velocity.x == 0) velocity.x = velocityXOld;
			// just above ticks = 1;
			freezeMob(_gravity);
			
			y = _startY;
			
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
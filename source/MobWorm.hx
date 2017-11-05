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

class MobWorm extends EnemyParentClass
{
/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 400;

	/**
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	private var _gravity:Int = 0;

	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth:Int = 4;
	
	/**
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;
	
	/**
	 * used to store the last known direction that the mob was moving.
	 */
	private var velocityOld:Float;	
	
	/**
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Float = 0; 
	
	/**
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 90;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 90; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobWorm.png", true, 50, 37);
		
		// uncomment if sprite has animation frames. 
		if (id == 1) animation.add("flying", [0, 1, 0, 2], 32);
		if (id == 2) animation.add("flying", [3, 4, 3, 5], 32);
		if (id == 3) animation.add("flying", [6, 7, 6, 8], 32);
		
		animation.play("flying");	

		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		alive = true;
		angle = 0;
		_mobInWater = false;
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
		
		health = (defaultHealth * ID) * Reg._difficultyLevel;
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
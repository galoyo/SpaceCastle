package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class MobGlob extends EnemyParentClass 
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
	public var defaultHealth:Int = 2; 
	
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
	public var _airLeftInLungs:Int = 60;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 60; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
			
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/mobGlob.png", true, 32, 32);		
		
		if (id == 1) animation.add("walk", [0, 1, 2, 2, 1], 16);
		if (id == 2) animation.add("walk", [3, 4, 5, 5, 4], 16);
		if (id == 3) animation.add("walk", [6, 7, 8, 8, 7], 16);
		animation.play("walk");
		
		// freeze the mob. change its color to blue.
		setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		
		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		alive = true;
		angle = 0;
		_mobInWater = false;
		visible = true;	
		
		immovable = true;
	
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, true);
		
		// mob starts moving in direction of the player.
		if (x <= Reg.state.player.x) 
		{
			facing = FlxObject.RIGHT;
			_directionMobIsMoving = "right";
		}
		else 
		{
			facing = FlxObject.LEFT;		
			_directionMobIsMoving = "left";
		}
		
		health = (defaultHealth * ID) * Reg._difficultyLevel; 
		allowCollisions = FlxObject.ANY;
		_airLeftInLungs = _airLeftInLungsMaximum;
		_totalPixelsWalked = 0;
		
		// bullet.
		_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
		_cooldown = FlxG.random.float(0.10, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		
		if(ID == 1) _bulletFireFormation = _bulletFormationNumber;	
	}
	override public function update(elapsed:Float):Void 
	{
		immovable = true;
		
		if (visible == false)
		{
			_spawnTimeElapsed += elapsed;
			
			if (_spawnTimeElapsed >= Reg._spawnTime)
				reset(_startX, _startY);	
			
			return;
		}
		
		//------------------ MOB WALK ANY DIRECTION
		walkAnyDirection();

		// rotate mob when not alive.
		if (!alive) angle += Reg._angleDefault;
		
		// bullet
		_cooldown += elapsed;
		Reg._bulletSize = 0;
		if(isOnScreen()) shoot();
			
		super.update(elapsed);
	
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
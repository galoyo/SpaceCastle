package;

import flixel.addons.util.FlxFSM;
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

class MobSlime extends EnemyParentClass
{
	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth:Int = 2;
	
	/**
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	public var _gravity:Float = 3000;
	
	/**
	  * When reset(), this will be the _gravity value.
	  */
	private var _gravityResetToThisValue:Int = 3000;

	/**
	 * The X velocity of this mob. 
	 */
	private var _maxXspeed:Float = 130;
	
	/**
	 * The X and/or Y velocity of this mob. Must be in integers of 32.
	 */
	private var maxSpeed:Int = 480;
	
	private var _mobVelocityY:Float = 740;
	
	public var _mobAccelY:Float = 6000; // this var should be gravity.
	
	/**
	 * Used to slow the mobs jumping when in water.
	 */ 
	private var _slowJumpingInWater:Float = 100;
	
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
	public var _airLeftInLungs:Int = 40;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 40; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter)
	{
		super(x + 10, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);		
	
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		// id 1 is the easy green mob while 2 is the hard red mob.
		loadGraphic("assets/images/mobSlime.png", true, 28, 28);
		
		// the animations used for this mob.
		if (id == 1)
		{
			animation.add("standing", [0, 1], 3);
			animation.add("walking", [0, 1, 2, 1, 0, 1, 2, 1], 24);
			animation.add("jumping", [0, 2, 1]);
			animation.add("landing", [0, 1, 2, 1, 0, 1, 2, 1], 8, false);	
		}
		
		if (id == 2)
		{
			animation.add("standing", [3, 4], 3);
			animation.add("walking", [3, 4, 5, 4, 3, 4, 5, 4], 24);
			animation.add("jumping", [3, 5, 4]);
			animation.add("landing", [3, 4, 5, 4, 3, 4, 5, 4], 8, false);	
		}
		
		if (id == 3)
		{
			animation.add("standing", [6, 7], 3);
			animation.add("walking", [6, 7, 8, 7, 6, 7, 8, 7], 24);
			animation.add("jumping", [6, 8, 7]);
			animation.add("landing", [6, 7, 8, 7, 6, 7, 8, 7], 8, false);	
		}		
		pixelPerfectPosition = false;		
	
		properties(ID);
	}
	
	public function properties(ID:Int):Void 
	{				
		// the mob image only has right facing frame. this code flips the image when facing in the direction of left.
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		_gravity = _gravityResetToThisValue;
		velocity.y = 0;
		
		// set the image to face in the right direction.
		facing = FlxObject.RIGHT;
		
		alive = true;
		velocity.x = -maxSpeed;
		angle = 0;
		_mobInWater = false;
		visible = true;
		health = (defaultHealth * ID) * Reg._difficultyLevel;
		_airLeftInLungs = _airLeftInLungsMaximum;
		
		// when this mob is placed somewhere on the map loaded at PlayState (addMobSlime(x, y, 1), its id, the last value, such as 1 is passed to this classe and used here to set the properties of the mob.  
		acceleration.y = _mobAccelY;
		maxVelocity.set(_maxXspeed, _mobVelocityY);			
		_extraSpeed = Std.int(_mobVelocityY);	
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
			if (justTouched(FlxObject.FLOOR)) 
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
				_inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) _inAir = true;
		
				
			//------------------ CONTINUE TO JUMP TOWARDS PLAYER
			continueToJumpTowardsPlayer(_slowJumpingInWater, _mobInWater);
		
			
			ticks = 1;
		} else if (ticks > 0) reset(_startX, _startY);
		
		if (inRange(_range))
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
			super.update(elapsed);
		}
		
		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();		
	}
	
	override public function reset(x:Float, y:Float):Void 
	{
		super.reset(x, y);
		allowCollisions = FlxObject.ANY;
		properties(ID);			
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}
	
	override public function kill():Void 
	{
		super.kill();
	}
}
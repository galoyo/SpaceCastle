package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class MobBat extends EnemyParentClass
{	
	/*******************************************************************************************************
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 50; 
	
	/*******************************************************************************************************
	 * The Y velocity of this mob. 
	 */
	private var maxYSpeed:Int = 200;
	
	/*******************************************************************************************************
	 * This is the default health when mob is first displayed or reset on a map.
	 */	
	public var defaultHealth:Int = 4;
	
	/*******************************************************************************************************
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/*******************************************************************************************************
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;

	/*******************************************************************************************************
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Float = 0; 
	
	/*******************************************************************************************************
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 130;
	
	/*******************************************************************************************************
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 130; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobBat.png", true, 36, 33);
				
		// uncomment if sprite has animation frames. 
		if (id == 1) animation.add("fly", [0, 1, 2, 3, 4, 3, 2, 1], 55);
		if (id == 2) animation.add("fly", [7, 8, 9, 10, 11, 10, 9, 8], 55);
		if (id == 3) animation.add("fly", [14, 15, 16, 17, 18, 17, 16, 15], 55);
		animation.play("fly");	

		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
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
		velocity.y = maxYSpeed;
		
		velocityXOld = velocity.x;		
		velocityYOld = velocity.y;	
		
		_airLeftInLungs = _airLeftInLungsMaximum;
		health = (defaultHealth * ID) * Reg._difficultyLevel;
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
		
		if(inRange(_range))
		{			
			//------------------ FLY UP/DOWN IN THE AIR WHILE SWAY.
			flyUpThenDown(maxXSpeed, maxYSpeed);
				
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
		properties();
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
}
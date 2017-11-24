package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class MobSaw extends EnemyParentClass
{	
	/*******************************************************************************************************
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth:Int = 99999;
	
	/*******************************************************************************************************
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 320;
	
	/*******************************************************************************************************
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	public var _gravity:Int = 4200;
	
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
	public var _airLeftInLungs:Int = 0;
	
	/*******************************************************************************************************
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 0; 
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x-1, y+2, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		_startX = x;
		_startY = y;		
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		if (id == 1) loadGraphic("assets/images/mobSaw1.png", true, 64, 64);	
		else loadGraphic("assets/images/mobSaw2.png", true, 64, 32);
		
		pixelPerfectPosition = false;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);			
		
		// setup the animation for this mob.
		animation.add("saw", [0, 1, 2, 3, 4, 5, 6, 7], 30);
		animation.play("saw");		
		
		properties();
	}
	
	public function properties():Void 
	{				

		
		alive = true;		
		angle = 0;
		_mobInWater = false;
		visible = true;				
		
		if (ID == 2) acceleration.y = _gravity;	
		else immovable = true;
		
		health = (defaultHealth * ID) * Reg._difficultyLevel;
		_airLeftInLungs = _airLeftInLungsMaximum;
		
		// mob starts moving in direction of the player.
		if (ID == 2)
		{
			maxVelocity.x = maxXSpeed;
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
			else if(!isTouching(FlxObject.FLOOR)) _inAir = true;
			
			//------------------ WALK BUT CANNOT FALL IN HOLE
			if (ID == 2) walkButCannotFallInHole(maxXSpeed, _mobInWater, 32);
			
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
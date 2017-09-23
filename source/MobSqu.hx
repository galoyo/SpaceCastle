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

class MobSqu extends EnemyChildClass
{
	public var defaultHealth:Int = 3;
	private var maxXSpeed:Int = 300;
	
	// how fast the object can fall.
	public var _gravity:Int = 4400;	

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 50;
	public var _airLeftInLungsMaximum:Int = 50; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		loadGraphic("assets/images/mobSqu.png", true, 28, 28);
		
		if (id == 1) animation.add("jump", [0, 1, 2, 1], 12);
		if (id == 2) animation.add("jump", [3, 4, 5, 4], 12);
		if (id == 3) animation.add("jump", [6, 7, 8, 7], 12);
		animation.play("jump");	
		
		ID = id;
		pixelPerfectPosition = false;
		
			properties();		
	}
	
	public function properties():Void 
	{				
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		alive = true;
		angle = 0;
		_mobIsSwimming = false;
		visible = true;	
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		if (x <= Reg.state.player.x) 
		{
			velocity.x = maxXSpeed;
			facing = FlxObject.RIGHT;
			
		}
		else {
			velocity.x = -maxXSpeed;
			facing = FlxObject.LEFT;			
		}
		
		velocityXOld = velocity.x;
		maxVelocity.x = maxXSpeed;
		
		acceleration.y = _gravity;		
		_airLeftInLungs = _airLeftInLungsMaximum;
		health = (defaultHealth * ID) * Reg._differcuityLevel;	
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
			if (justTouched(FlxObject.FLOOR)) 
			{
				if (Reg._soundEnabled == true) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
				}
				inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) inAir = true;			
				
			//------------------ JUMP HAPPY IGNORE PLAYER.
			jumpHappyIgnorePlayer(_mobIsSwimming);
			
			//------------------ WALK BUT CAN FALL IN HOLE
			walkButCanFallInHole(maxXSpeed, _mobIsSwimming);

			ticks = 1;
		} else if (ticks > 0 && Reg._trackerInUse == false) reset(_startX, _startY);
		
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
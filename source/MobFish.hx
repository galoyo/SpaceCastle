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

class MobFish extends EnemyChildClass
{
	public var defaultHealth:Int = 2;
	var maxXSpeed:Int = 350; // horizontal movement of fish.
	var maxYSpeed:Int = 70; // as the fish moves horizontal, it moves a bit up and down.
	
	public var _mobIsSwimming:Bool = false;
	
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 0; // unlimited = 0;
	public var _airLeftInLungsMaximum:Int = 0; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		loadGraphic("assets/images/mobFish.png", true, 36, 20);

		if (id == 1) animation.add("swim", [0, 1, 2, 1], 15);
		if (id == 2) animation.add("swim", [3, 4, 5, 4], 15);
		if (id == 3) animation.add("swim", [6, 7, 8, 4], 15);
		animation.play("swim");	
		
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
			velocity.x = maxXSpeed * (ID / 1.25);
			facing = FlxObject.RIGHT;
			
		}
		else {
			velocity.x = -maxXSpeed * (ID / 1.25);
			facing = FlxObject.LEFT;			
		}

		maxVelocity.x = maxXSpeed * (ID / 1.25);
		velocity.y = maxYSpeed * (ID / 1.25);
		
		velocityXOld = velocity.x;		
		velocityYOld = velocity.y;
		
		// used to stop the fish from falling.
		acceleration.y = 0;		
		
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
			//------------------ FISH SWIMMING BACK AND FORTH.
			fishSwim(maxXSpeed, maxYSpeed);
					
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
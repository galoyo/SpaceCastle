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

class MobApple extends EnemyChildClass
{	
	public var defaultHealth:Int = 2;
	// How fast the object is moving.
	var maxXSpeed:Int = 280;
	public var _gravity:Int = 4200;
	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;	
	
	// speed is used as maxXSpeed or maxXSpeed * 2 when the player is within the horizontal view of this mob.
	var speed:Float;
	
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 80; // total air in mob without air items.		
	public var _airLeftInLungsMaximum:Int = 80; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, emitterSmokeRight:FlxEmitter, emitterSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, emitterSmokeRight, emitterSmokeLeft, bulletsMob, emitterBulletHit, emitterBulletMiss);
		
		_startX = x;
		_startY = y;		
		
		loadGraphic("assets/images/mobApple.png", true, 28, 28);	
		
		ID = id;
		pixelPerfectPosition = false;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);			
		
		// setup the animation for this mob.
		if (id == 1) animation.add("walk", [0, 1, 2, 1], 20);
		if (id == 2) animation.add("walk", [3, 4, 5, 4], 20);
		if (id == 3) animation.add("walk", [6, 7, 8, 7], 20);
		animation.play("walk");		
		
		properties();
	}
	
	public function properties():Void 
	{				
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		alive = true;
		maxVelocity.x = maxXSpeed;
		angle = 0;
		_mobIsSwimming = false;
		visible = true;				
		acceleration.y = _gravity;		
		health = (defaultHealth * ID) * Reg._differcuityLevel;
		_airLeftInLungs = _airLeftInLungsMaximum;
		
		// mob starts moving in direction of the player.
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
				inAir = false;
			} 
			else if(!isTouching(FlxObject.FLOOR)) inAir = true;
			
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
				
			//------------------ WALK BUT CANNOT FALL IN HOLE
			walkButCannotFallInHole(maxXSpeed, _mobIsSwimming);
			
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
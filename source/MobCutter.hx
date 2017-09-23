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

class MobCutter extends EnemyChildClass
{
	// used with jumping ability.
	private var _YjumpingDelay:Float = 100;
	
	public var defaultHealth:Int = 3;
	var maxXSpeed:Int = 400;
	
	// how fast the object can fall.
	public var _gravity:Int = 4400;	

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 70;
	public var _airLeftInLungsMaximum:Int = 70; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		//########################################################
		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/mobCutter.png", true, 28, 28);
		
		if (id == 1) animation.add("walk", [0, 1, 2, 1], 12);
		if (id == 2) animation.add("walk", [3, 4, 5, 4], 12);
		if (id == 3) animation.add("walk", [6, 7, 8, 7], 12);
		animation.play("walk");	

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
		health = (defaultHealth * ID) * Reg._differcuityLevel;
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
					inAir = false;
				} 
				else if (!isTouching(FlxObject.FLOOR)) inAir = true;			
					
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
				jumpOverEmptyTile(_YjumpingDelay, _mobIsSwimming);
							
				//------------------ WALK BUT CAN FALL IN HOLE
				walkButCanFallInHole(maxXSpeed, _mobIsSwimming);
				
				if (velocity.x == 0) velocity.x = velocityXOld;
				
				//------------------ STOP AT LASER BEAM.
				// NOTE: THIS FUNCTION CALL NEEDS TO BE PLACED LAST.
				stopAtLaserBeam();
								
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
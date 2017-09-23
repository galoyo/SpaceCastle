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

class Mob_template extends EnemyChildClass
{
	private var _bulletTimeForNextFiring:Float = 1; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = -1; // -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	
	public var defaultHealth1:Int = 1;
	private var maxXSpeed:Int = 300;
	private var maxSpeed:Int = 250;
	
	// how fast the object can fall.
	var _gravity:Int = 4400;	

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;
	private var velocityXOld:Float; // used to store the direction that the mob was moving.	
	
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 100; // total air in mob without air items.
	// this value must be higher that the _areLeftInLungs var. this value can be any value. the higher the value the longer the mob can stay in the water. 100 = player. most mobs are around 40 - 70 but can have a value of about 200. 
	public var _airLeftInLungsMaximum:Int = 100;
	
	public function new(x:Float, y:Float, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mob_template.png", true, Reg._tileSize, Reg._tileSize);
		
		_startX = x; // used when resetting mob
		_startY = y;
		
		// uncomment if sprite has animation frames. 
		//animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 12);
		//animation.play("walk");	

		pixelPerfectPosition = false;
				
		properties(); // gravity, direction facing, is alive, ect and health vars.		

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
		
		if(isOnScreen())
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
				if( Reg._antigravity == false) acceleration.y = Reg._gravityOnSlopes;
				else acceleration.y = -Reg._gravityOnSlopes;
			}	
			// if player in not in the air oris not standing on the slope then player is standing on a tile. set gravity to normal.
			else
			{
				if (Reg._antigravity == false) acceleration.y = _gravity;
				else acceleration.y = -_gravity;
			}
			
			//------------------ WALK BUT CANNOT FALL IN HOLE
			walkButCannotFallInHole(maxXSpeed, _mobIsSwimming);

			//------------------ FLY UP/DOWN IN THE AIR WHILE SWAY.
			flyUpThenDown(maxXSpeed, maxYSpeed);

			//------------------ STOP AT LASER BEAM.
			// NOTE: THIS FUNCTION CALL NEEDS TO BE PLACED LAST. Place it just before the "ticks = 1;" code.
			stopAtLaserBeam();	

			//------------------ JUMP OVER EMPTY TILE.	HOLE MUST BE 2 TILES DEEP.
			jumpOverEmptyTile(_YjumpingDelay, _mobIsSwimming);

			//------------------ WALK BUT CAN FALL IN HOLE
			walkButCanFallInHole(maxXSpeed, _mobIsSwimming);

			//------------------ FISH SWIMMING BACK AND FORTH.
			fishSwim(maxXSpeed, maxYSpeed);

			//------------------ MOB WALK ANY DIRECTION
			walkAnyDirection();

			//------------------ CONTINUE TO JUMP TOWARDS PLAYER
			continueToJumpTowardsPlayer(_YjumpingDelay, _mobIsSwimming);


			//------------------ JUMP HAPPY IGNORE PLAYER.
			jumpHappyIgnorePlayer(_mobIsSwimming);


			//------------------ SEEK PLAYER AFTER TOUCHING TILE.
			seekPlayerAfterTouchingTile(maxSpeed, _mobIsSwimming);

			//------------------ FLY BACK AND FORTH.
			flyBackAndForth(maxXSpeed);

			if (velocity.x == 0) velocity.x = velocityXOld;			
			ticks = 1;
		} else if (ticks > 0 && Reg._trackerInUse == false) reset(_startX, _startY);
		
		if (isOnScreen())
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
		//------------------ FREEZE MOB.
			// place this code outside of the `animation.paused == false` loop.
			// and put this inside that loop... if (velocity.x == 0) velocity.x = velocityXOld;
			// just above ticks = 1;
			freezeMob(_gravity);
				
			// bullet
			_cooldown += elapsed;
			Reg._bulletSize = 0; // 0 = large. 1 = medium. 2 = small.
			if (isOnScreen()) shoot();
		
			super.update(elapsed);
		}
		
		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
	override public function reset(xx:Float, yy:Float):Void 
	{		
		super.reset(x, y);
		allowCollisions = FlxObject.ANY;
		properties();
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
	
	public function properties():Void 
	{
		alive = true;
		
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
		
		// used with jumping ability.
		acceleration.y = _gravity;	
		
		angle = 0;
		health = defaultHealth1;
		visible = true;
		
		// bullet.
		_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
		_cooldown = FlxG.random.float(0.10, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
		
	}
}
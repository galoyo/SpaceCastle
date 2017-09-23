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

class MobSlime extends EnemyChildClass
{
	// health of the mob when mob is created;
	public var defaultHealth:Int = 2;
	
	public var _gravity:Float = 3000;
	
	// this var must be in integers of 32.
	var maxSpeed:Int = 480;	

	private var _maxXspeed:Float = 130; // this var should be maxXspeed.
	private var _mobVelocityY:Float = 740;
	
	public var _mobAccelY:Float = 6000; // this var should be gravity.
	private var _YjumpingDelay:Float = 100;
	
	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;
	
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 40; // total air in mob without air items.
	public var _airLeftInLungsMaximum:Int = 40; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter)
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);		
	
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
	
		ID = id;
		properties(ID);
	}
	
	public function properties(ID:Int):Void 
	{				
		// the mob image only has right facing frame. this code flips the image when facing in the direction of left.
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		// set the image to face in the right direction.
		facing = FlxObject.RIGHT;
		
		alive = true;
		velocity.x = -maxSpeed;
		angle = 0;
		_mobIsSwimming = false;
		visible = true;
		health = (defaultHealth * ID) * Reg._differcuityLevel;
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
				inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) inAir = true;
		
				
			//------------------ CONTINUE TO JUMP TOWARDS PLAYER
			continueToJumpTowardsPlayer(_YjumpingDelay, _mobIsSwimming);
		
			
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
		properties(ID);			
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}
	
	override public function kill():Void 
	{
		super.kill();
	}
}
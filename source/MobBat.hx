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

class MobBat extends EnemyChildClass
{
	private var maxXSpeed:Int = 50; 
	private var maxYSpeed:Int = 200;
	
	public var defaultHealth:Int = 4;
	
	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 130; // total air in mob without air items.
	public var _airLeftInLungsMaximum:Int = 130; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	private var velocityDifference:Int = 200; // used for random movement.
	
	public var ra:Int;
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobBat.png", true, 28, 28);
				
		// uncomment if sprite has animation frames. 
		if (id == 1) animation.add("walk", [0, 1, 2, 3, 4, 3, 2, 1], 60);
		if (id == 2) animation.add("walk", [5, 6, 7, 8, 9, 8, 7, 6], 60);
		if (id == 3) animation.add("walk", [10, 11, 12, 13, 14, 13, 12, 11], 60);
		animation.play("walk");	

		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
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
			
			/*if (ID == 1 || ra == 1)
			{
				ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
				
				// do not fly through walls.
				if (isTouching(FlxObject.CEILING)) velocity.y = velocityDifference;
				if (isTouching(FlxObject.FLOOR)) velocity.y = -velocityDifference;
				
				
				// bats move randomly
				
				if (ticks > 5)
				{
					var move = FlxG.random.int(0, 5);
					
					if (move >= 3)
					{
						var xx = FlxG.random.int( -velocityDifference, velocityDifference); var yy = FlxG.random.int( -velocityDifference, velocityDifference);		
						velocity.set(xx, yy);
					} else velocity.set(0, 0);
					
					ticks = 1;
				}	
			}*/
			
			//------------------ FLY UP/DOWN IN THE AIR WHILE SWAY.
			flyUpThenDown(maxXSpeed, maxYSpeed);
				
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
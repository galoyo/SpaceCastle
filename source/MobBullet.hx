package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class MobBullet extends EnemyChildClass
{
	public var defaultHealth1:Int = 50000; // not possible to kill this mob. 
	var maxXSpeed:Int = 800;

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	private var _timerparticleSmokeRight:FlxTimer;
	private var _timerparticleSmokeLeft:FlxTimer;
	
	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobBullet.png", false, 30, 30);

		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
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

		acceleration.y = 0; drag.y = 50000;
		velocity.y = 0;		
		health = defaultHealth1;	
	}
	
	override public function update(elapsed:Float):Void 
	{	
		if (visible == false)
		{
			_spawnTimeElapsed += elapsed;
				
			if (_spawnTimeElapsed >= 2)
				reset(_startX, _startY);	
				
			return;
		}
		
		if (inRange(_range) && ticks == 0) 
		{			
			ticks = 1;
		
			if (facing == FlxObject.RIGHT)
			{
				if (ticks == 1)
				{
					_particleSmokeRight.focusOn(this);				
					_particleSmokeRight.start(false, 0.006, 9);
				}
			}
			else if (ticks == 1)
			{
				_particleSmokeLeft.focusOn(this);
				_particleSmokeLeft.start(false, 0.006, 9);
			}
		}
		else if (!inRange(_range) && ticks > 0 && Reg._trackerInUse == false) kill();
			
		if (ticks == 1)
		{
			ticks = 2;
			if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
		}
		
		if (inRange(_range))
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
			super.update(elapsed);
		}
		
	}
	
	override public function reset(x:Float, y:Float):Void 
	{
		super.reset(x, y);
		ticks = 0;
		allowCollisions = FlxObject.ANY;
		properties();
		
		_spawnTimeElapsed = 0;	// reset the spawn timer
		FlxSpriteUtil.flicker(this, (Reg._mobResetFlicker / 2), 0.02, true);
	}	
}
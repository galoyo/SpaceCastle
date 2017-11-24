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

class MobTube extends EnemyParentClass
{
	/*******************************************************************************************************
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth1:Int = 1;
	
	/*******************************************************************************************************
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 1200;

	/*******************************************************************************************************
	 * Used to delay the movement of this mob.
	 */
	private var ticksMovement:Float = 0;
	
	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/mobTube.png", true, 79, 64);

		animation.add("fly", [0,1,2,1], 20);
		animation.play("fly");	
		
		pixelPerfectPosition = false;
		
		properties();		
	}
	
	public function properties():Void 
	{				
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		alive = true;
		angle = 0;
		visible = true;		
		solid = false;
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
				
			if (_spawnTimeElapsed >= Reg._spawnTime)
				reset(_startX, _startY);	
				
			return;
		}
		
		if (isOnScreen() && ticks == 0) 
		{			
			// make the mob exit the tube only if the player is not standing on the tube.
			if (!overlapsAt(x, y - 10, Reg.state.player) && !overlapsAt(x + 10, y - 10, Reg.state.player) || y != _startY)
			{
				ticksMovement = Reg.incrementTicks(ticksMovement, 60 / Reg._framerate);
				solid = true;
				
				// Mob is now shown outside of the tube.
				if ((ticksMovement + ticksMovement + ticksMovement + ticksMovement) > 64)
				{
					ticks = 1;
					
					// move this mob in the x direction towards the player.
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
				else
				{
					// mob is moving in an upward direction until mob is fully displayed out of the tube.
					y = _startY - (ticksMovement + ticksMovement + ticksMovement + ticksMovement);
					
				}
			}
		}
		else if (!isOnScreen() && ticks > 0) kill();
			
		if (ticks == 1)
		{
			ticks = 2;
			if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
		}
		
		if (isOnScreen())
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
		ticksMovement = 0;
		_spawnTimeElapsed = 0;	// reset the spawn timer
	}	
}
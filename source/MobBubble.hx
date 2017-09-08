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
import flixel.math.FlxMath;

/**
 * @author galoyo
 */

class MobBubble extends EnemyChildClass
{
	private var _bulletTimeForNextFiring:Float; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = 4; // -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	
	// used with jumping ability.
	private var _YjumpingDelay:Float = 100;
	private var _displayDialogDoOnlyOnce:Int = 0;
	public var defaultHealth1:Int = 5;
	var maxXSpeed:Int = 350;
	public var _bubbleMoved:Bool = false;
	private var ticksFireballMoved:Float = 0;
	private var ticksMobFireBullets:Float = 0;
	private var _oldYValue:Float = 0; // used to keep this mob above the player head when mob fires bullets.
	private var ra:Int = 2; // random number.
	
	// how fast the object can fall.
	public var _gravity:Int = 4400;	

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 170;
	public var _airLeftInLungsMaximum:Int = 170; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	public var ticksTween:Int = 0;
	private var ticksBubble:Float = 0;
	private var _tween1:FlxTween;
	private var _tween2:FlxTween;
	private var _tween3:FlxTween;
	private var _tween4:FlxTween;
	

	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, emitterSmokeRight:FlxEmitter, emitterSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, emitterSmokeRight, emitterSmokeLeft, bulletsMob, emitterBulletHit, emitterBulletMiss);
		
		loadGraphic("assets/images/mobBubble.png", true, 28, 28);
		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 12);
		animation.play("walk");	

		pixelPerfectPosition = false;
		
		immovable = true;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		velocityXOld = velocity.x;
		maxVelocity.x = maxXSpeed;		
		
		acceleration.y = 0;		
		health = defaultHealth1 * Reg._differcuityLevel;
		
		if (Reg._boss1BDefeated == false) visible = false; 
		allowCollisions = FlxObject.ANY;
		
		// bullet.
		_bulletTimeForNextFiring = FlxG.random.float(0.20, 0.40);
		_cooldown = FlxG.random.float(0.10, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		
		_bulletFireFormation = _bulletFormationNumber;	
		
		_oldYValue = y;
		
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
			if (animation.paused == false)
			{ 
				if (justTouched(FlxObject.FLOOR)) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
					inAir = false;
				} 
				else if (!isTouching(FlxObject.FLOOR)) inAir = true;			
					
				//########################## TWEEN ############################
				// if player is standing still then curcle the fireball around this mob.
				if (velocity.x == 0 && velocity.y == 0 && ticksTween == 0 && Reg._boss1BDefeated == true)
				{
					if (Reg._boss1BDefeated == true) 
					{
						visible = true; 
						Reg.state._bubbleHealthBar.visible = true;
					}
					
					y = _oldYValue;
		
					_tween1 = FlxTween.circularMotion(Reg.state._defenseMobFireball1,
					x+6, 
					y+6,
					36, 0,
					true, Reg.fireballRandom, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut});
					
					_tween2 = FlxTween.circularMotion(Reg.state._defenseMobFireball2,
					x+6, 
					y+6,
					36, 90,
					false, Reg.fireballRandom, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut });
					
					_tween3 = FlxTween.circularMotion(Reg.state._defenseMobFireball3,
					x+6, 
					y+6,
					36, 180,
					true, Reg.fireballRandom, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut});
					_tween4 = FlxTween.circularMotion(Reg.state._defenseMobFireball4,
					x+6, 
					y+6,
					36, 270,
					false, Reg.fireballRandom, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut });
				
					ticksTween = 1;
					ra = FlxG.random.int(0, 2);
				}					
			}
		} 
		//####################### END TWEEN #########################
		
		//################## FIREBALL MOVE TO THE GROUND #################
		// if player is near underneath or directly underneath the mob.
		if (Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && Reg.state.player.x - 32 < x && Reg.state.player.x + 32 > x || Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && _bubbleMoved == true)
		{	
			if (ticksTween == 1)
			{
				// shoot the fireball in a downward direction.
				if (ticksBubble == 5)
				{
					_tween1.destroy(); // destroy the tween so that the fireball can be free to move.
					// position the fireball left side of the mob if the player is facing left.
					if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball1.x = x - 32;
					if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT) Reg.state._defenseMobFireball1.x = x + 32;
					
					// shoot fireball downward.
					Reg.state._defenseMobFireball1.velocity.y = 1500;
					if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
				}
				
				if (ticksBubble == 8)
				{
					_tween2.destroy();
					if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball2.x = x - 32;
					if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT) Reg.state._defenseMobFireball2.x = x + 32;
					Reg.state._defenseMobFireball2.velocity.y = 1500;
					if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
				}
				
				if (ticksBubble == 13)
				{

					_tween3.destroy();
					if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball3.x = x - 32;
					if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT)	Reg.state._defenseMobFireball3.x = x + 32;
					Reg.state._defenseMobFireball3.velocity.y = 1500;
					if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
				}
				
				
				if (ticksBubble == 18)
				{
					_tween4.destroy();
					if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball4.x = x - 32;
					if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT)	Reg.state._defenseMobFireball4.x = x + 32;
					Reg.state._defenseMobFireball4.velocity.y = 1500;
					if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
				}
				
				
				if (ticksBubble > 0) 
				{
					// follow the player if will not collide with a tile.
					if( !overlapsAt(Reg.state.player.x, y, Reg.state.tilemap)) x = Reg.state.player.x;													
				} 
				
				// all the fireballs have moved in a downward direction. 30 is used for a short delay
				if ( ticksBubble > 30)
				{
					ticksFireballMoved = Reg.incrementTicks(ticksFireballMoved, 60 / Reg._framerate);
					velocity.set(0, 0);
					
					if (ticksFireballMoved <= ra) ticksTween = 0;
					else {ticksTween = 2; ticksFireballMoved = 0;}
					
					ticksBubble = 1;
					_bubbleMoved = false;
					
					_tween1.destroy();
					_tween2.destroy();
					_tween3.destroy();
					_tween4.destroy();
					
					// stop the velocity so that the fireballs can be tweened.
					Reg.state._defenseMobFireball1.velocity.y = 0;
					Reg.state._defenseMobFireball2.velocity.y = 0;
					Reg.state._defenseMobFireball3.velocity.y = 0;
					Reg.state._defenseMobFireball4.velocity.y = 0;
				} else _bubbleMoved = true;
				
				if (Reg.state.player.velocity.x == 0)
				{
					ticksTween = 3;
					ticksBubble = 1;					
				}
				
				ticksBubble = Reg.incrementTicks(ticksBubble, 60 / Reg._framerate);
			}			

		} 
		//############### END FIREBALL MOVES TO THE GROUND ##############
		
		//####################### MOB FIRE BULLETS ######################
		if (ticksTween == 2 && Reg.mapXcoords == 25 && Reg.mapYcoords == 20)
		{
			if (ticksMobFireBullets == 20)
			{
				x = 128;
				_cooldown = _gunDelay;
				_bulletFormationNumber = 4;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 40)
			{
				x = 384;
				_cooldown = _gunDelay;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 60)
			{
				x = 640;
				_cooldown = _gunDelay;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 80)
			{
				x = 128;
				_cooldown = _gunDelay;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 100)
			{
				x = 384;
				_cooldown = _gunDelay;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 120)
			{
				x = 640;
				_cooldown = _gunDelay;
				_bulletFormationNumber -1;
				Reg._bulletSize = 0;
				shoot();			 
			}
			
			if (ticksMobFireBullets == 170)
			{
				ticksTween = 0;
				ticksMobFireBullets = 0;

				x = Reg.state.player.x;
			}
			
			ticksMobFireBullets = Reg.incrementTicks(ticksMobFireBullets, 60 / Reg._framerate);
		}
		//################### END OF MOB FIRE BULLETS ###################

		// ######################### STRIFE #############################
		if (ticksTween == 3 && Reg.mapXcoords == 25 && Reg.mapYcoords == 20)
		{
			velocity.y = 1300;
			
			if (overlapsAt(x, y, Reg.state.player) || overlapsAt(x, y, Reg.state.tilemap))
			{
				ticksTween = 0;
				velocity.y = 0;				
				
				if (Reg._soundEnabled == true) FlxG.sound.play("hitBounce", 0.50, false);
				
				_tween1.destroy();
				_tween2.destroy();
				_tween3.destroy();
				_tween4.destroy();
				
				Reg.state._defenseMobFireball1.velocity.y = 0;
				Reg.state._defenseMobFireball2.velocity.y = 0;
				Reg.state._defenseMobFireball3.velocity.y = 0;
				Reg.state._defenseMobFireball4.velocity.y = 0;	
				
				y = _oldYValue;
			}
		}
		

		//###################### END OF STRIFE ###########################
		
		if(Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && Reg.state.player.x > 96 && _displayDialogDoOnlyOnce == 0)	
		{
			Reg.dialogIconFilename = "";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/boss3-Map25-20.txt").split("#");
							
			Reg.dialogCharacterTalk[0] = "talkMobBubble.png";
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());
			//Reg._talkedToMalaAtWaitingRoom[0] = true;
			_displayDialogDoOnlyOnce = 1;
			
			playBossMusic();
			FlxSpriteUtil.stopFlickering(Reg.state.player);
		}
		
		// rotate mob when not alive.
		if (!alive) angle += Reg._angleDefault;

		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();

		super.update(elapsed);
	}

	override public function kill():Void 
	{
		Reg._playerCanShootOrMove = false;
		
		super.kill();
		new FlxTimer().start(0.50, Reg.state.winState, 1);		
	}
	
	override public function hurt(damage:Float):Void 
	{
		if (ticksTween == 1) x = Reg.state.player.x;
		
		super.hurt(damage);
		
		if (health <= 0)
		{
			kill();

		}
		
	}
	
}
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

class MobBubble extends EnemyParentClass
{
	/*******************************************************************************************************
	 * First fireball that rotates around this mob. 
	 */
	private var _tween1:FlxTween;
	
	/*******************************************************************************************************
	 * Second fireball that rotates around this mob. 
	 */
	private var _tween2:FlxTween;
	
	/*******************************************************************************************************
	 * Third fireball that rotates around this mob. 
	 */
	private var _tween3:FlxTween;
	
	/*******************************************************************************************************
	 * Forth fireball that rotates around this mob. 
	 */
	private var _tween4:FlxTween;
	
	/*******************************************************************************************************
	 * Time it takes for this mob to fire another bullet.
	 */
	private var _bulletTimeForNextFiring:Float =1;

	/*******************************************************************************************************
	 * -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	 */	
	private var _bulletFormationNumber:Int = 4; 
	
	/*******************************************************************************************************
	 * This mob will start talking when player enters map 25-20 for the first time. This var stops the dialog from displaying the second time.
	 */
	private var _displayDialogDoOnlyOnce:Int = 0;
	
	/*******************************************************************************************************
	 * This is the default health when mob is first displayed or reset on a map.
	 */	
	public var defaultHealth1:Int = 5;
	
	/*******************************************************************************************************
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 350;
	
	/*******************************************************************************************************
	 * Delay all mobs fireball from moving to the ground.
	 * 
	 */
	public var _bubbleMoved:Bool = false;
	
	/*******************************************************************************************************
	 * Used to keep this mob above the player head when mob fires bullets.
	 */
	private var _oldYValue:Float = 0;
	
	/*******************************************************************************************************
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	public var _gravity:Int = 4400;	
	
	/*******************************************************************************************************
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/*******************************************************************************************************
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;

	/*******************************************************************************************************
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Float = 0; 
	
	/*******************************************************************************************************
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 170;
	
	/*******************************************************************************************************
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 170; 
	
	/*******************************************************************************************************
	 * 0 = fireballs rotate around this mob. 1 = mob shoots those rotated fireballs to the ground. 2 = Shoots a burst of bullets at every 10 minutes of a clock. 4 = strife.
	 */
	public var ticksTween:Int = 0;
	
	/*******************************************************************************************************
	 * This var stops the initial player attack.
	 */
	public var ticksDelay:Float = 0;
	
	/*******************************************************************************************************
	 * Used to time the movement of the fireballs so that each fireball in turn will travel to the ground.
	 */
	private var ticksBubble:Float = 0;
	
	/*******************************************************************************************************
	 * Used with another var to determine if this mob should do ticksTween formation 0 or 2. See var ticksTween for more information.
	 */
	private var ticksFireballMoved:Float = 0;
	
	/*******************************************************************************************************
	 * Used to fire bullets when this tick is at certain values.
	 */
	private var ticksMobFireBullets:Float = 0;
	
	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
		
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
		health = defaultHealth1 * Reg._difficultyLevel;
		
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
					_inAir = false;
				} 
				else if (!isTouching(FlxObject.FLOOR)) _inAir = true;			
					
				//########################## TWEEN ############################
				// if player is standing still then curcle the fireball around this mob.
				if (velocity.x == 0 && velocity.y == 0 && ticksTween == 0 && Reg._boss1BDefeated == true)
				{
					if (Reg._boss1BDefeated == true) 
					{
						visible = true; 
						Reg.state._healthBarMobBubble.visible = true;
					}
					
					y = _oldYValue;
		
					_tween1 = FlxTween.circularMotion(Reg.state._defenseMobFireball1,
					x+6, 
					y+6,
					36, 0,
					true, Reg.fireballSpeed, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut});
					
					_tween2 = FlxTween.circularMotion(Reg.state._defenseMobFireball2,
					x+6, 
					y+6,
					36, 90,
					false, Reg.fireballSpeed, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut });
					
					_tween3 = FlxTween.circularMotion(Reg.state._defenseMobFireball3,
					x+6, 
					y+6,
					36, 180,
					true, Reg.fireballSpeed, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut});
					_tween4 = FlxTween.circularMotion(Reg.state._defenseMobFireball4,
					x+6, 
					y+6,
					36, 270,
					false, Reg.fireballSpeed, true, { type: FlxTween.LOOPING, ease: FlxEase.backInOut });
				
					ticksTween = 1;					
				}					
			}
		} 
		//####################### END TWEEN #########################
		
		//################## FIREBALL MOVE TO THE GROUND #################
		// if player is near underneath or directly underneath the mob.
		if (Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && _displayDialogDoOnlyOnce == 1 || Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && _bubbleMoved == true)
		{	
			// This var stops the initial player attack.
			ticksDelay = Reg.incrementTicks(ticksDelay, 60 / Reg._framerate);
			
			if (ticksDelay > 30)
			{
				if (ticksTween == 1)
				{
					// Keep the fireballs X position the same a this mobBubble x position when shooting the fireballs at the player.
					if (Reg.state._defenseMobFireball1.velocity.y == 0)
					{
						Reg.state._defenseMobFireball1.x = x + 4;
						Reg.state._defenseMobFireball1.y = y + 14;
					}
					if (Reg.state._defenseMobFireball2.velocity.y == 0)
					{
						Reg.state._defenseMobFireball2.x = x + 4;
						Reg.state._defenseMobFireball2.y = y + 14;
					}
					if (Reg.state._defenseMobFireball3.velocity.y == 0)
					{
						Reg.state._defenseMobFireball3.x = x + 4;
						Reg.state._defenseMobFireball3.y = y + 14;
					}
					if (Reg.state._defenseMobFireball4.velocity.y == 0)
					{
						Reg.state._defenseMobFireball4.x = x + 4;
						Reg.state._defenseMobFireball4.y = y + 14;
					}
					
					// shoot the fireball in a downward direction.
					if (ticksBubble == 5)
					{
						_tween1.destroy(); // destroy the tween so that the fireball can be free to move.
						_tween2.destroy();
						_tween3.destroy();
						_tween4.destroy();					
						
						// position the fireball left side of the mob if the player is facing left.
						if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT) Reg.state._defenseMobFireball1.x = x - 32;
						if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT) Reg.state._defenseMobFireball1.x = x + 32;
						
						// shoot fireball downward.
						Reg.state._defenseMobFireball1.velocity.y = 1500;
						if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
					}
					
					if (ticksBubble == 8)
					{
						if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball2.x = x - 32;
						if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT) Reg.state._defenseMobFireball2.x = x + 32;
						Reg.state._defenseMobFireball2.velocity.y = 1500;
						if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
					}
					
					if (ticksBubble == 13)
					{
						if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball3.x = x - 32;
						if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT)	Reg.state._defenseMobFireball3.x = x + 32;
						Reg.state._defenseMobFireball3.velocity.y = 1500;
						if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
					}
					
					
					if (ticksBubble == 18)
					{
						if (x > Reg.state.player.x && Reg.state.player.facing == FlxObject.LEFT)	Reg.state._defenseMobFireball4.x = x - 32;
						if (x <= Reg.state.player.x && Reg.state.player.facing == FlxObject.RIGHT)	Reg.state._defenseMobFireball4.x = x + 32;
						Reg.state._defenseMobFireball4.velocity.y = 1500;
						if (Reg._soundEnabled == true) FlxG.sound.play("mobBullet", 1, false);
					}
					
					
					if (ticksBubble > 0) 
					{
						// follow the player if will not collide with a tile.
						if ( !overlapsAt(Reg.state.player.x, y, Reg.state.tilemap)) 
							x = Reg.state.player.x;													
					}
					
					// all the fireballs have moved in a downward direction.
					if ( ticksBubble > 30)
					{
						ticksFireballMoved = Reg.incrementTicks(ticksFireballMoved, 60 / Reg._framerate);
						velocity.set(0, 0);
						
						var ra = FlxG.random.int(0, 2);
						
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
						
						ticksDelay = 0;
						
					} else _bubbleMoved = true;
					
					if (Reg.state.player.velocity.x == 0)
					{
						ticksTween = 3;
						ticksBubble = 1;					
					}
					
					ticksBubble = Reg.incrementTicks(ticksBubble, 60 / Reg._framerate);
				}	
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
		Reg._playerCanShootAndMove = false;
		
		super.kill();
		new FlxTimer().start(0.50, PlayStateMiscellaneous.winState, 1);		
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
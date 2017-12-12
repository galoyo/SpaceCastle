package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import haxe.Timer;

/**
 * @author galoyo
 */

class Player extends FlxSprite
{
	/*******************************************************************************************************
	 * The normal gun's bullet speed.
	 */
	private var _bulletSpeed:Int = 1000;
	
	/*******************************************************************************************************
	 * This is the player's default walking speed.
	 */
	public var _defaultWalkingSpeed:Int = 630;
	
	/*******************************************************************************************************
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	public var _gravity:Int = 3500;
		
	/*******************************************************************************************************
	 * How fast the object accelerates horizontally when the X value of the object is changed.
	 */
	private var _maxXacceleration:Int = 50000;
	
	/*******************************************************************************************************
	 * How fast the object accelerates vertically when the Y value of the object is changed.
	 */
	public var _maxYacceleration:Int = 1000;
	
	/*******************************************************************************************************
	 * Used to change the _maxXacceleration var from a positive to negative or negative to positive value.
	 */
	public var _xForce:Float = 0;
	
	/*******************************************************************************************************
	 * Used to change the _maxYacceleration var from a positive to negative or negative to positive value.
	 */
	public var _yForce:Float = 0; 
	
	/*******************************************************************************************************
	 * Slow the object before stopping it. More like deceleration. The higher the value, the faster the object stops.
	 */
	public var _drag:Int = 50000;
	
	/*******************************************************************************************************
	 * Speed of the horizontal dash.
	 */
	private var _velocityX = 1200;	
	
	/*******************************************************************************************************
	 * This value is the maximum trail of gray players seen behind the player when player does a skill dash.
	 */
	private var _skillDashMaximumGrayPlayers:Int = 8;
	
	/*******************************************************************************************************
	 * Must be a bit bugger than _maxFallSpeed. This var is 140 in value greater than _maxFallSpeed which will lift the player off the ground about 20 pixels when doing a dash attach.
	 */
	private var _velocityY = 53140;
	
	/*******************************************************************************************************
	 * Maximum acceleration speed for this player.
	 */
	public var _maxFallSpeed:Int = 53000;
	
	//##################################################################
	//################ These values must NOT be changed. ###############
	//##################################################################
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when the bullet reaches its maximum distance or when the bullet hits a mob.
	 */
	private var _particleBulletHit:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when a bullet from the normal gun hits a tile. 
	 */
	private var _particleBulletMiss:FlxEmitter;
	
	/*******************************************************************************************************
	 *  DO NOT change the value of this var. This emitter of colorful square particles will continue through its straight path hitting anything in its way.
	 */
	private var _emitterBulletFlame:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. When the emitter emits, the player will quickly dash to the left or to the right while the player is rising in the air. At that time, a trail of gray players will be behind the player creating an effect that the player is moving so quickly that many of players can be seen.
	 */
	private var _emitterSkillDash:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. Used with the skill dash to only allow one dash per jump.
	 */
	private var _jumping:Bool = false;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This is needed so that a bullet can be recycled. No need to new the class everytime a bullet is fired.
	 */
	public var _bullets:FlxTypedGroup<Bullet>;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. A single bullet sprite.
	 */
	private var _bullet:Bullet;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. The gun delay between bullets fired.
	 */
	private var _gunDelay:Float = 0;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. The shot clock. When this value is equal or greater than _gunDelay then the bullet can be fired.
	 */
	private var _cooldown:Float = 0;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This mob may either be swimming or walking in the water. In elther case, if this value is true then this player is in the water.
	 */
	public var _mobInWater:Bool = false;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. When not doing a dash attack the value will be zero. When doing a dash attack the velocityX will be its value. 
	 */
	private var _skillDashX = 0;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;	
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. The last calulation before player jumps. Determines if _jumpForce will be a negative or positive value. Velocity.y will equal this value.
	 */
	public var _finalJumpForce:Float;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. Used to display a gun pointing in upward direction or fire a bullet in an upward direction. If anti-gravity is true then the gun will be pointing down and its bullet will travel southward.
	 */
	public var _holdingUpKey:Bool = false;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. A timer used to stop rapid swimming.
	 */
	private var _swimmingTimer:FlxTimer;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. If this value if true then make the player swim in the water for a short lenght of time.
	 */
	private var _swimmingTimerIsComplete:Bool = true;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This var will stop the player's head from displaying above a T junction pipe when the player had moved through the pipe in an upward direction and then stopped at the T junction pipe. 
	 */
	public var _setPlayerOffset:Bool = false; // 
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This timer is triggered when player is standing on a lava tile. When the timer is finished and player is still standing on a lava tile then player's health will decrease. 
	 */
	public var _playerStandingOnFireBlockTimer = new FlxTimer();	

	/*******************************************************************************************************
	 * DO NOT change the value of this var. When not doing a dash attack the value will be zero. When doing a dash attack the velocityY will be its value. 
	 */
	private var _skillDashY = 0;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. As this var increases so does the amount of fading skill dash gray players seen. A trail of gray players will be behind the player creating an effect that the player is moving so quickly that many of players can be seen.
	 */
	private var _ticksSkilLDash:Float  = 0;	
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. Is the player doing a skill dash which is a fast horizontal attack.
	 */
	private var _playerIsDashing:Bool = false;
	
	public function new(x:Float, y:Float, bullets:FlxTypedGroup<Bullet>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter, emitterBulletFlame:FlxEmitter, emitterSkillDash:FlxEmitter) 
	{
		// position player sprite at this coor. x and y values are from the cvs file multiplied
		// by the with / height of the tileset.
		super(x, y);

		if (Reg._playerFeelsWeak == false) loadGraphic("assets/images/player.png", true, 28, 28);		
			else loadGraphic("assets/images/playerWeak.png", true, 28, 28);		
			
		collisonXDrag = true;
		pixelPerfectPosition = true;
		
		_inAir = false;
		offset.set(0, 0);
		
		_bullets = bullets;
		_particleBulletHit = particleBulletHit;
		_particleBulletMiss = particleBulletMiss;
		_emitterBulletFlame = emitterBulletFlame;
		_emitterSkillDash = emitterSkillDash;
		
		_cooldown = _gunDelay = 0.15;	// Initialize the cooldown so weapon can fire at this time.
		
		// flip the players sprite when player is moving at the left driection of screen.
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);	
			
		if (Reg.facingDirectionRight == false)
			facing = FlxObject.LEFT;
			
		// The next several lines of code set up all of the animations for the character - 
		// giving each animation a name, a set of frames, the speed at which to play, and 
		// whether to loop it or not. Notice the first Array - it includes a few cool tricks. 
		// We want our idle animation to hold on frame 0 for a long time, and then play 
		// frame 8 so it looks like our character is blinking. 
		
		// normal gravity animation.
		animation.add("walk", [11, 6, 7, 8, 9, 10], 40);
		animation.add("walkOnLadder", [12, 13, 14, 15, 16, 14], 40);
		animation.add("jump", [5], 25);
		animation.add("changedToItemFlyingHat", [18, 19, 20, 21], 40, false);
		animation.add("flyingHat", [22, 23], 20, true);
		animation.add("idle", [11], 25);
		animation.add("idleOnLadder", [14], 25);
		
		// antigravity animation.
		animation.add("walk2", [11, 6, 7, 8, 9, 10], 40, true, false, true);
		animation.add("walkOnLadder2", [12, 13, 14, 15, 16, 14], 40, true, false, true);
		animation.add("jump2", [5], 25, true, false, true);
		animation.add("changedToItemFlyingHat2", [18, 19, 20, 21], 40, false, false, true);
		animation.add("flyingHat2", [22, 23], 20, true, false, true);
		animation.add("idle2", [11], 25, true, false, true);
		animation.add("idleOnLadder2", [14], 25, true, false, true);
		
		// max movement speed.
		maxVelocity.y = _maxFallSpeed;
		
		// how fast the speed of the object is changed in pixels per second.
		acceleration.y = _gravity;
		
		drag.x = _drag;	 // Deceleration.
		
		health = Reg._healthCurrent;
		FlxSpriteUtil.flicker(this, Reg._mobHitFlicker, 0.04, true); // no damage given when starting at a level.
		
		_swimmingTimer = new FlxTimer();
		
		visible = true; 
	}
	
	public function shoot(_holdingUpKey:Bool):Void 
	{	
		if(Reg._itemGotGunRapidFire == true && Reg._typeOfGunCurrentlyUsed == 0)
			_cooldown = _gunDelay;
			
		// this gives a recharge effect.
		if (_cooldown >= _gunDelay && Reg._playerCanShoot == true)
		{
			_emitterBulletFlame.focusOn(this);
			
			// flame gun. the flame will only fire if the player does not press the button rapidly. there needs to be a short delay inbetween key presses.
			if (Reg._typeOfGunCurrentlyUsed == 1 && _cooldown >= _gunDelay * 3)
			{	
				// position the bullets vertically at the tip of the gun.
				if (Reg._antigravity == false)
				{
					Reg.state._emitterBulletFlame.y = Std.int(y) + 16;
				}
				else
				{
					Reg.state._emitterBulletFlame.y = Std.int(y) + 8;
				}
				
				if (_holdingUpKey == true)
				{
					
					if(Reg._antigravity == false) Reg.state._emitterBulletFlame.y -= 30;
						else Reg.state._emitterBulletFlame.y += 30;
						
						// position the bullets horizontally at the tip of the gun.	
					if (Reg._gunPower == 1) 
						Reg.state._emitterBulletFlame.x = Std.int(x);
						
					if (facing == FlxObject.LEFT)	// facing left
						Reg.state._emitterBulletFlame.x += 1; 
					if (facing == FlxObject.RIGHT)	// facing right
						Reg.state._emitterBulletFlame.x += 24; 
				}
				else
				{
					// not holding up key. both anti and non-antigravity
					if (facing == FlxObject.LEFT)
					{
						Reg.state._emitterBulletFlame.x -= 30; // move bullet to the left side of the player
					}
					else // facing right
					{
						Reg.state._emitterBulletFlame.x += 43; // move bullet to the right side of the player
					}
				}		
				
				if (_holdingUpKey == true)
					{
						if (Reg._antigravity == false) _emitterBulletFlame.velocity.set( -2, -1000, 2, -1200);
							else _emitterBulletFlame.velocity.set( -2, 1000, 2, 1200);
					}
				else if (facing == FlxObject.LEFT)	// facing right
					_emitterBulletFlame.velocity.set(-1000, -2, -1200, 2);
				else if (facing == FlxObject.RIGHT)	// facing right
					_emitterBulletFlame.velocity.set(1000, -2, 1200, 2);
												
				_emitterBulletFlame.start(false, 0.005, 7);
					
				if (Reg._soundEnabled == true) FlxG.sound.play("flameGun", 0.50, false);
				
				_cooldown = 0;
				return;
			}
		
			if (Reg._typeOfGunCurrentlyUsed == 0)
			{
				var bYVeloc:Int = 0;
				_bullet = _bullets.recycle(Bullet);
				_bullet.exists = true; 						
				
				// can shoot bullet if have the normal gun (1).
				if (_bullet != null && Reg._itemGotGun == true)
				{
					var bulletX:Int = Std.int(x);
					var bulletY:Int = Std.int(y);
					
					// position the bullets vertically at the tip of the gun.
					if (Reg._antigravity == false)
					{
						if (Reg._gunPower == 1) 
						bulletY = Std.int(y) + 16;
						if (Reg._gunPower == 2) 
						bulletY = Std.int(y) + 11;
						if (Reg._gunPower == 3) 
						bulletY = Std.int(y) + 8;
					}
					else
					{
						if (Reg._gunPower == 1) 
						bulletY = Std.int(y) + 8;
						if (Reg._gunPower == 2) 
						bulletY = Std.int(y) + 3;
						if (Reg._gunPower == 3) 
						bulletY = Std.int(y);
					}
					var bXVeloc:Int = 0;
					
					if (_holdingUpKey == true)
					{
						
						if(Reg._antigravity == false) bulletY -= 30;
							else bulletY -= 2;
							
						if(Reg._antigravity == false) bYVeloc = -_bulletSpeed;					
							else bYVeloc = _bulletSpeed;	
							
						// position the bullets horizontally at the tip of the gun.	
						if (Reg._gunPower == 1) 
							bulletX = Std.int(x);
						if (Reg._gunPower == 2) 
							bulletX = Std.int(x) - 4;
						if (Reg._gunPower == 3) 
							bulletX = Std.int(x) - 8;
						
						if (facing == FlxObject.LEFT)	// facing left
							bulletX += 1; 
						if (facing == FlxObject.RIGHT)	// facing right
							bulletX += 24; 
					}
					else
					{
						// not holding up key. both anti and non-antigravity
						if (facing == FlxObject.LEFT)
						{
							bulletX -= 30; // move bullet to the left side of the player
							bXVeloc = -_bulletSpeed;
						}
						else // facing right
						{
							bulletX += 43; // move bullet to the right side of the player
							bXVeloc = _bulletSpeed;
						}
					}


					_bullet.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _holdingUpKey, _particleBulletHit, _particleBulletMiss);		
					_cooldown = 0;	// reset the shot clock
					// emit it
					_particleBulletHit.focusOn(_bullet);
					_particleBulletHit.start(true, 0.05, 1);
				}
			}
		
		
		//###################### FREEZE GUN ############################
			if (Reg._typeOfGunCurrentlyUsed == 2)
			{
				var bYVeloc:Int = 0;
				_bullet = _bullets.recycle(Bullet);
				_bullet.exists = true; 						
				
				// can shoot bullet if have the normal gun (1).
				if (_bullet != null && Reg._itemGotGunFreeze == true)
				{
					var bulletX:Int = Std.int(x);
					var bulletY:Int = Std.int(y);
					
					// position the bullets vertically at the tip of the gun.
					if (Reg._antigravity == false)
						bulletY = Std.int(y) + 8;
					else
						bulletY = Std.int(y) + 3;

					var bXVeloc:Int = 0;
					
					if (_holdingUpKey == true)
					{
						
						if(Reg._antigravity == false) bulletY -= 30;
							else bulletY += 30;
							
						if(Reg._antigravity == false) bYVeloc = -_bulletSpeed;					
							else bYVeloc = _bulletSpeed;	
							
						// position the bullets horizontally at the tip of the gun.	
							bulletX = Std.int(x);
						
						if (facing == FlxObject.LEFT)	// facing left
							bulletX += -5; 
						if (facing == FlxObject.RIGHT)	// facing right
							bulletX += 17; 
					}
					else
					{
						// not holding up key. both anti and non-antigravity
						if (facing == FlxObject.LEFT)
						{
							bulletX -= 30; // move bullet to the left side of the player
							bXVeloc = -_bulletSpeed;
						}
						else // facing right
						{
							bulletX += 43; // move bullet to the right side of the player
							bXVeloc = _bulletSpeed;
						}
					}


					_bullet.shoot(bulletX, bulletY, bXVeloc, bYVeloc, _holdingUpKey, _particleBulletHit, _particleBulletMiss);		
					_cooldown = 0;	// reset the shot clock
					// emit it
					_particleBulletHit.focusOn(_bullet);
					_particleBulletHit.start(true, 0.05, 1);
				}				
			}
		}
	}
	
	public function getCoords():Void 
	{
		if (Reg._playerInsideCar == false)
		{
			Reg.playerXcoords = this.x / Reg._tileSize;
			Reg.playerYcoords = this.y / Reg._tileSize;
		}
		else
		{
			if (Reg.state._objectCar != null && Reg.state._objectCar.facing == FlxObject.RIGHT) Reg.playerXcoords = Reg.state._objectCar.x + 116 / Reg._tileSize;
			else Reg.playerXcoords = Reg.state._objectCar.x / Reg._tileSize;
			Reg.playerYcoords = Reg.state._objectCar.y / Reg._tileSize;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{	
		// display the light at center of the player.
		if (Reg._darkness == true && Reg._inHouse == "" && Reg.state._light != null)
		{
			Reg.state._light.setPosition(( -FlxG.width + (width / 2)) + x, (( -FlxG.height + (height / 2)) + y + 57));
		}
		
		if (Reg._playerInsideCar == true)
		{
			if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19 // parallax car scene. if true, // player not in use. therefore, don't do player things in this update(). 
			 || Reg.mapXcoords == 24 && Reg.mapYcoords == 19 // ""
			 || Reg.mapXcoords == 25 && Reg.mapYcoords == 19 // ""
			 || Reg.mapXcoords == 26 && Reg.mapYcoords == 19 // ""
			)
			{
				Reg.state.warningFallLine.visible = false;
				Reg.state.deathFallLine.visible = false;
				Reg.state.maximumJumpLine.visible = false;
			} 
			
			Reg.state.player.velocity.x = 400;
		}
		
		else
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used. This line is needed for the keys/buttons to work.		
			InputControls.checkInput();

			if (overlapsAt(x, y - 15, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x, y - 45, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
			Reg._lastArrowKeyPressed = "up";
			if (overlapsAt(x + 15, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x + 45, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
			Reg._lastArrowKeyPressed = "right";
			if (overlapsAt(x, y + 15, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x, y + 45, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
			Reg._lastArrowKeyPressed = "down";
			if (overlapsAt(x - 15, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x - 45, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
			Reg._lastArrowKeyPressed = "left";
			
			// hide players healthbar if overlays are in front of player. we do not want the player to be seen or known where player is located at.
			if ( overlapsAt(x, y, Reg.state.overlays) || Reg.mapXcoords == 23 && Reg.mapYcoords == 19) Reg.state._healthBarPlayer.visible = false;
				else Reg.state._healthBarPlayer.visible = true;
			
			// bullet
			_cooldown += elapsed;
			
			if (alive && Reg._playerCanShootAndMove == true ) controls();
			animate();
			levelConstraints();	
			
			//######################### CHEAT MODE #########################
			// ----------------- toggle cheat on / off -------------
			#if !FLX_NO_KEYBOARD  
				if (FlxG.keys.anyJustReleased(["T"]) && Reg._cheatModeEnabled == true)
				{
					Reg._cheatModeEnabled = false;
					if (Reg._soundEnabled == true) FlxG.sound.play("switchOff", 1, false);
				} 
				else if (FlxG.keys.anyJustReleased(["T"])  && Reg._cheatModeEnabled == false)
				{
					Reg._cheatModeEnabled = true;
					if (Reg._soundEnabled == true) FlxG.sound.play("switchOn", 1, false);
				}
				
				// increase health
				if (FlxG.keys.anyJustReleased(["H"])  && Reg._cheatModeEnabled == true)
				{
					if ((health + 1) <= Reg._healthMaximum)
					{
						health = Std.int(health) + 1;
						Reg._healthCurrent = health;
						
						if (Reg._soundEnabled == true) FlxG.sound.play("switchOn", 1, false);
					} else if (Reg._soundEnabled == true) FlxG.sound.play("switchOff", 1, false);
				} 
				else if (FlxG.keys.anyJustReleased(["H"])  && Reg._cheatModeEnabled == false)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
				}
					
				// increase the air left in players lungs.
				if (FlxG.keys.anyJustReleased(["L"])  && Reg._cheatModeEnabled == true)
				{
					Reg.state._playerAirRemainingTimer.loops += 10; Reg._playerAirLeftInLungsMaximum += 10;
					if (Reg._soundEnabled == true) FlxG.sound.play("switchOn", 1, false);			
				} 
				else if (FlxG.keys.anyJustReleased(["L"]) && Reg._cheatModeEnabled == false)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
				}
			#end
			//####################### END CHEAT MODE #######################

			Reg.state._healthBarPlayer.velocity.x = velocity.x;
			Reg.state._healthBarPlayer.velocity.y = velocity.y;				
		}
	
		super.update(elapsed);
	}
	
	// sets the movement vars for the player based on the keyboard key pressed.
	function controls():Void
	{			
		
		//################### LAVA BLOCK.
		// take damage if on the fire block.		
		if ( Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) >= 233 && Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) <= 238 || FlxG.collide(this, Reg.state._objectLavaBlock))
		{
			if (_playerStandingOnFireBlockTimer.finished == true) hurt(1);
			
			if (_playerStandingOnFireBlockTimer.active == false)
			_playerStandingOnFireBlockTimer.start(0.25, null, 1);			
		}
		//################### END LAVA BLOCK.
		
		//################## ICE BLOCKS
		if ( Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) == 220) drag.x = 3000;
		else drag.x = _drag;	
		
		//################## END ICE BLOCKS.

			
		// play the flute.
		if (Reg._itemGotDogFlute == true)
		{			
			if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Dog Flute."
			 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Dog Flute."
			 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Dog Flute.")
			{
				// if dog exists on map but is not located at top left corner of screen.
				if (Reg.state.npcDog != null && Reg.state.npcDog.x != 0 || Reg._dogCarried == true) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("dogFlute", 1, false);
				}
			
				else if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
			}
		}
		//----------------------------
		
		_xForce = 0; _yForce = 0;		

		// #################### TOGGLE ANTIGRAVITY ####################
		// toggle antigravity.
		if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Antigravity Suit."
		 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Antigravity Suit."
		 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Antigravity Suit.")
		{
			if (_inAir == false && Reg._antigravity == false && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform)) 
			{
				Reg._antigravity = true;
				Reg._playersYLastOnTile = y;
			}
			
			else if(_inAir == false && Reg._antigravity == true)
			{
				Reg._antigravity = false;
				Reg._playersYLastOnTile = y;
			}
		}
		
		if (   InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
		    || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
		{
			Reg._jumpForce = 820; Reg._fallAllowedDistanceInPixels = 96; 
			if (_inAir == false ) _jumping = true;
			
			if (FlxG.overlap(Reg.state._objectQuickSand, this)) Reg._jumpForce = 300;
		}
		
		else if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump.")
		{
			// Reg._itemGotJump[0] refers to the first jump item obtained. which is set to true when the game starts. the _jumpForce is how high the player can jump. in this case, the player can jump up two tiles. the next jump item jumps for 3 items, ect. Since the jump force is set for 2 tiles, the _fallAllowedDistanceInPixels is also 2 tiles totaling 64 pixels.
			Reg._jumpForce = 680; Reg._fallAllowedDistanceInPixels = 64;
			if (_inAir == false ) _jumping = true;
			
			if (FlxG.overlap(Reg.state._objectQuickSand, this)) Reg._jumpForce = 300;
		}
		
		if (Reg._antigravity == false) 
		{
			// vars for a normal jump.
			_finalJumpForce = -(Reg._jumpForce + Math.abs(velocity.y * 0.25));
		}
		else 
		{
			// vars for an anitigravity jump.
			_finalJumpForce = (Reg._jumpForce + Math.abs(velocity.y * 0.25));	
		}
		//################### END TOGGLE ANTIGRAVITY ####################

		//####################### INPORTANT READ ########################
		// when making another object such as antigravity, make a 
		// function to disable all other objects such as the flying hat
		// those object start with a var of _using.
		
		// change to a different item.
			if ( InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Flying Hat."
			  || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Flying Hat."
		      || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Flying Hat.")
			
			{
			if (Reg._itemGotFlyingHat == true && Reg._usingFlyingHat == false && Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) != 15 && overlapsAt(x, y+16, Reg.state._itemFlyingHatPlatform))
			{
				Reg._usingFlyingHat = true;
				animation.play("changedToItemFlyingHat");
			}	
			else if(Reg._itemGotFlyingHat == true && Reg._usingFlyingHat == true)
			{
				Reg._usingFlyingHat = false;
				animation.play("idle");
				
				acceleration.y = _gravity;
				velocity.y = velocity.y * 0.5; // set the gravity in case player is in the air and using the flying hat.
			}
			
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
		}	
		
		if(_mobInWater == false)
		{
			// fire the bullet in the direction of up or down depending if antigravity is used or not.
			if (Reg._antigravity == true && InputControls.down.pressed || Reg._antigravity == false && InputControls.up.pressed)
			{
				_holdingUpKey = true; 
			}	
			else 
			{
				_holdingUpKey = false;  
			}
		} 
				
		if(!FlxG.overlap(Reg.state._overlayPipe, this))
		{
			if ( InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Gun."
			  || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Gun."
		      || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Gun."
			  || InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Flame Gun."
			  || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Flame Gun."
		      || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Flame Gun."
			  || InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Freeze Gun."
			  || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Freeze Gun."
		      || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Freeze Gun.")
		
			{	
				if(_mobInWater == false)
				{
					// fire the bullet in the direction of up or down depending if antigravity is used or not.
					if (Reg._antigravity == true && InputControls.down.pressed || Reg._antigravity == false && InputControls.up.pressed)
					{
						shoot(_holdingUpKey); 						
					}	
					else 
					{
						shoot(_holdingUpKey);
					}
		
				} 
				else if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 0.50, false);

			}
		}
	
		
		if (!FlxG.overlap(Reg.state._objectWaterCurrent, this) && !FlxG.overlap(Reg.state._overlayPipe, this))
		{
			if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Dash Skill."
			 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Dash Skill."
			 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Dash Skill.")
			{							
				if (_playerIsDashing == false && isTouching(FlxObject.FLOOR) || _playerIsDashing == false && isTouching(FlxObject.CEILING) || _jumping == true) 
				{ 
					if (InputControls.left.pressed || InputControls.right.pressed) _playerIsDashing = true;
						
				} 

			}	
			
			//############################## DASH ATTACK 
			// holding an arrow key left or right before jumping is not allowed. the reason is because of a bug. when exiting the map from the right side, if holding the right arrow key and then jumping into the next map, the player will fall straight down at that next map. the player will not continue to move in that same direction if that arrow key is still held down. however, if a jump was made before holding an arrow key then when leaving the map the player will continue to move forward at the next map if that arrow key is still held down. this code address the bug by delaying movement when jump in not allowed.
			
			// when the left or right arrow is pressed and then the jump key is pressed, the player will do a dashed attach. the player will quickly dash to the left or right while the player is rising in the air. 
			if (_playerIsDashing == true)
			{				
				if (InputControls.left.pressed) 
				{ 
					_skillDashX = _velocityX; _xForce--;
					if (Reg._antigravity == false) _skillDashY = -_velocityY;
					else  _skillDashY = _velocityY;
					
				}
				
				else if (InputControls.right.pressed)
				{ 
					_skillDashX = _velocityX; _xForce++;
					if (Reg._antigravity == false) _skillDashY = -_velocityY;
					else  _skillDashY = _velocityY;
				}				
			
				// the player moves so fast that there is a trail of gray players that fade behind the player.
				// when player is dashing, the player will lift from the ground or ceiling. if players velocity.y is in motion then do the following.
				if (_skillDashY != 0)
				{	
					_ticksSkilLDash = Reg.incrementTicks(_ticksSkilLDash, 60 / Reg._framerate);
				
					_emitterSkillDash.focusOn(this);
					_emitterSkillDash.start(true, 0.05, 1);
				}
			}				
	
			if (_ticksSkilLDash >= _skillDashMaximumGrayPlayers) 
			{
				_ticksSkilLDash = 0;
			}

			// Stop the skill dash when the last gray player is displayed. For example, stop when the maximum value of the ticks is true and then the player is dashing. Also stop the dash when the key/button is not pressed. xForce will then equals zero. When one of these conditions are met then the last trail is complete.
			if (_ticksSkilLDash >= _skillDashMaximumGrayPlayers - 1 && _playerIsDashing == true || _xForce == 0 && _playerIsDashing == true)
			{	
				if ( !isTouching(FlxObject.FLOOR) || !isTouching(FlxObject.CEILING))
				{
					_playerIsDashing = false;
					_skillDashX = 0; _skillDashY = 0;
				}
				
				_jumping = false;
			}
			
			//######################### END DASH ATTACK.

			if (_playerIsDashing == false)
			{			
				_ticksSkilLDash = 0;	_skillDashX = 0; _skillDashY = 0;
				
				if (InputControls.left.pressed) 
				{ _xForce--; Reg._guildlineInUseTicks = 0; }
				if (InputControls.right.pressed)
				{ _xForce++; Reg._guildlineInUseTicks = 0; }	
			}
			
			

		}		
		
		// do not run faster then the max speed else set to walk speed.
		if (_mobInWater == false) {maxVelocity.x = _defaultWalkingSpeed + _skillDashX; maxVelocity.y = _maxFallSpeed + _skillDashY;}	
		else {maxVelocity.x = _defaultWalkingSpeed + _skillDashX / Reg._swimmingDelay; maxVelocity.y = _maxFallSpeed + _skillDashY	/ Reg._swimmingDelay; }
		
		//---------------------------
		//########### PLAYER IS JUMPING.
		if (   InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			|| InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
			|| InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
		{
			if (Reg._usingFlyingHat == false && FlxG.overlap(this, Reg.state._objectVineMoving)
			|| Reg._usingFlyingHat == false && FlxG.overlap(this, Reg.state._objectVineMoving))
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("rope", 0.50, false);			

				Reg._antigravity = false; // cannot swing upside down on vine.
				velocity.y = -500; 
				_playerIsDashing = false;
			}
			// normal jump.
			else if ( Reg._usingFlyingHat == false && _inAir == false || Reg._usingFlyingHat == false && FlxG.collide(this, Reg.state._objectJumpingPad)
			|| Reg._usingFlyingHat == false && _inAir == false || Reg._usingFlyingHat == false && FlxG.collide(this, Reg.state._objectJumpingPad))		
			{
				if (_inAir == false)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("jump", 0.50, false);			
						
					_inAir = true;
					velocity.y = _finalJumpForce;	
					_playerIsDashing = false;
				}
			}
		}

		//--------------------------
		// ######################## PLAYER IS SWIMMING. #########################
		else if ( InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Swimming Skill."
			   || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Swimming Skill."
		       || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Swimming Skill.")
		
			{
				if ( Reg._usingFlyingHat == false && Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 15 && Reg._itemGotSwimmingSkill == true
				||  Reg._usingFlyingHat == false && Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 15 && Reg._itemGotSwimmingSkill == true)
			{
				if (_swimmingTimerIsComplete == true)
				{
					if (Reg._soundEnabled == true) 
					{
						if (Reg._soundEnabled == true) FlxG.sound.play("jump", 0.50, false);			
					}
					velocity.y = _finalJumpForce / 1.5;
				}
				
				// stop rapid swimming.
				_swimmingTimerIsComplete = false;
				if (_swimmingTimer.active == false) _swimmingTimer.start(0.12, swimmingOnTimer, 1);
			}		
		}

		if (!FlxG.overlap(Reg.state._overlayPipe, this))
		{
			_xForce = FlxMath.bound(_xForce, -1, 1);		
			if (InputControls.left.pressed || InputControls.right.pressed)
			{
				if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
				 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
				 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
				 || InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
				 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
				 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
					acceleration.x = 0;
				else acceleration.x = _xForce * _maxXacceleration; // How fast the object accelerates horizontally when the X value of the object is changed.
				
			} else if (_skillDashX == 0 ) acceleration.x = 0;		
			
			Reg._dogIsInPipe = false;
		} else Reg._dogIsInPipe = true;
		
		// play a thump sound when mob lands on the floor.
		if (Reg._antigravity == true && justTouched(FlxObject.CEILING) && !overlapsAt(x, y + 16, Reg.state._objectLadders) || Reg._antigravity == false && justTouched(FlxObject.FLOOR) && !overlapsAt(x, y + 16, Reg.state._objectLadders) )
		{
			_inAir = false;
			
			if (Reg._antigravity == false) animation.play("idle"); 
				else animation.play("idle2");			
		} 
		else if(Reg._antigravity == true && !isTouching(FlxObject.CEILING) || Reg._antigravity == false && !isTouching(FlxObject.FLOOR)) _inAir = true;
		
		if (Reg._antigravity == true && _inAir && justTouched(FlxObject.FLOOR) || Reg._antigravity == false && _inAir && justTouched(FlxObject.CEILING)) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("ceilingHit", 1, false);
		}	
		
		//###################################### SET GRAVITY ##########################
		//--------------------------------------------------
		
		// set gravity to normal if jump key is pressed or player is not standing on  tile.
					
		//############################ IMPORTANT.
		//############################ Add flying hat, vine, ladder ect to this line.
		if (!InputControls.left.pressed && !InputControls.right.pressed && !FlxG.overlap(Reg.state._objectVineMoving, this) && !FlxG.overlap(Reg.state._objectLadders, this) &&  Reg._usingFlyingHat == false)
		{
			if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
		   	||  InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			||  InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
			|| InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
		    || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
			{
				acceleration.y = _gravity;
				_playerIsDashing = false;
			} 		
			else if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			|| InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
			|| InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
		    || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
			{
				acceleration.y = -_gravity;
				_playerIsDashing = false;
			} 			
		}
		
		// if player is standing on a slope then set high gravity so that the player will walk down the slope instead of jumping or hopping down.
		else if ( 
			   Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y - 32 / 32)) == 22
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y - 32 / 32)) == 30
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y - 32 / 32)) == 38 
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y - 32 / 32)) == 46
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 22
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 30
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 38 
			|| Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 46)
		{					
			if( Reg._antigravity == false) acceleration.y = Reg._gravityOnSlopes;
			else acceleration.y = -Reg._gravityOnSlopes;
		}	
		// set gravity to normal.
		else if (!isTouching(FlxObject.FLOOR) && Reg._antigravity == false) 
		{
			acceleration.y = _gravity;
		} 
		else if ( !isTouching(FlxObject.CEILING) && Reg._antigravity == true) 
		{
			acceleration.y = -_gravity;
		}
		//-------------------------------------------------------------
		//###################################### END SET GRAVITY ###########################
		
	}

	function animate():Void
	{
		// animate the player based on conditions.
		if (velocity.x > 0) facing = FlxObject.RIGHT;
		else if (velocity.x < 0) facing = FlxObject.LEFT;
		/*if (!alive) animation.play("death");
		else*/ 
		
		if (Reg._antigravity == true && isTouching(FlxObject.CEILING) && Reg._usingFlyingHat == true && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform) || Reg._antigravity == false && isTouching(FlxObject.FLOOR) && Reg._usingFlyingHat == true && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform)) 
		{
			Reg._usingFlyingHat = false;
			if(Reg._antigravity == false) animation.play("idle");
				else animation.play("idle2");
				
			velocity.y = velocity.y * 0.5; // set the gravity in case player is in the air and using the flying hat.				
		}
		
		else if (Reg._antigravity == true && isTouching(FlxObject.FLOOR) && Reg._usingFlyingHat == true && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform) || Reg._antigravity == false && isTouching(FlxObject.CEILING) && Reg._usingFlyingHat == true && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform)) 
		{
			Reg._usingFlyingHat = false;
			if(Reg._antigravity == false) animation.play("idle");
				else animation.play("idle2");

			Reg._guildlineInUseTicks = 0;

			velocity.y = velocity.y * 0.5; // set the gravity in case player is in the air and using the flying hat.
		}
					
		else if (Reg._antigravity == false && !isTouching(FlxObject.FLOOR) && Reg._usingFlyingHat == false)
		{
			if (Reg._antigravity == false && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("jump");
			else 
			if (overlapsAt(x, y, Reg.state._objectLadders))
			{					
				if (velocity.y == 0) 
				{
					animation.play("idleOnLadder");
					acceleration.y = 0;
				}
			}
		}
		else if (Reg._antigravity == true && !isTouching(FlxObject.CEILING) && Reg._usingFlyingHat != false )
		{
			if (Reg._antigravity == true && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("jump2");
			else if (overlapsAt(x, y, Reg.state._objectLadders))
			{					
				if (velocity.y == 0)
				{
					animation.play("idleOnLadder2");
					acceleration.y = 0;
				}
			}			
		}
		else {				
			if (Reg._usingFlyingHat == false)
			{
				if (velocity.x == 0)
				{
					if (Reg._antigravity == false && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("idle");
					else if (!InputControls.up.pressed && !InputControls.down.pressed && Reg._antigravity == false && overlapsAt(x, y, Reg.state._objectLadders)) animation.play("idleOnLadder");
					
					if (Reg._antigravity == true && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("idle2");					
					else if (!InputControls.up.pressed && !InputControls.down.pressed && Reg._antigravity == true && overlapsAt(x, y, Reg.state._objectLadders)) animation.play("idleOnLadder2");
				}

				

				//else if (velocity.x > 0 && acceleration.x < 0 || velocity.x < 0 && acceleration.x > 0) animation.play("skid");
				else 
				{ 
					if (Reg._antigravity == false && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("walk");	
					else if (Reg._antigravity == true && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("walk2");
				}
			}
		}
	}
	
	function levelConstraints():Void
	{
		// if player is at the boundries of the left side of screen then bounce off of
		// screen and then stop.
		if (x < 0) velocity.x = _defaultWalkingSpeed;
		// if player is at the boundries of the right side of screen then bounce off of
		// screen and then stop.
		else if (x > Reg.state.tilemap.width - width) velocity.x = -_defaultWalkingSpeed;
		
		// if player moves in a down direction and leaves the boundries to the screen
		// then the player has died.
		if (alive && y > Reg.state.tilemap.height + 20) kill();
	}
	
	// this function set the var when the player is dying. 
	override public function kill():Void 
	{		
		Reg.state.maximumJumpLine.visible = false;
		Reg.state.warningFallLine.visible = false;
		Reg.state.deathFallLine.visible = false;
		
		velocity.x = acceleration.x = 0; // stop the motion of the player.
		velocity.y = acceleration.y = 0;
		if (Reg.state._objectCar != null) Reg.state._objectCar.velocity.x = 0;
		
		if (alive == true)
		{
			// player in water?
			if( Reg.state.overlays.getTile(Std.int(x / 32), Std.int(y / 32)) == 15) 
			{
				
				if (Reg._soundEnabled == true) FlxG.sound.playMusic("gameover", 1, false);		
		
				color = 0xFF5555FF;				
			}
			else
			{
				FlxTween.tween(scale, { x:1.2, y:1.2 }, 0.7, { ease:FlxEase.elasticOut } );
				if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19) visible = false;
				if (Reg._soundEnabled == true) FlxG.sound.playMusic("gameover", 1, false);
				
				new FlxTimer().start(0.05, killOnTimer,30);
			}	
			
		}
		
		alive = false;
		
		// go to the gameOver state.
		new FlxTimer().start(1.25, PlayStateMiscellaneous.gameOver, 1);

	}
	
	private function swimmingOnTimer(_swimmingTimer:FlxTimer):Void
	{				
		_swimmingTimerIsComplete = true;
	}
	
	// when mob is hit, this function sets the mob to its default size.
	private function killOnTimer(Timer:FlxTimer):Void
	{	
		// rotate object.
		angle += 5;

		if(Reg._itemGotGun)
		Reg.state._gun.visible = false;
	}
	
	override public function hurt(damage:Float):Void 
	{
		if (FlxSpriteUtil.isFlickering(this) == false && Reg._playerInsideCar == false || Reg._playerFallDamage == true && Reg._isFallDamage == true || Reg.state._objectCar != null && FlxSpriteUtil.isFlickering(Reg.state._objectCar) == false && Reg._playerInsideCar == true)
		{
			if (damage > 0)
			{
				Reg._gunHudBoxCollectedTriangles--;
				Reg.state.hud.decreaseGunPowerCollected();
				
				if (Reg._playerInsideCar == true && Reg.state._objectCar != null)
				{
					Reg.state._objectCar.velocity.x = 0; FlxSpriteUtil.flicker(Reg.state._objectCar, Reg._mobHitFlicker / 2, 0.04);
					
				}
				else FlxSpriteUtil.flicker(this, Reg._mobHitFlicker, 0.04);
				
				if (Reg.mapXcoords == 24 && Reg.mapYcoords == 25) {}; // trap
				else FlxG.cameras.shake(0.005, 0.3);
			
				if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels <= 0)
					if (Reg._soundEnabled == true) FlxG.sound.play("hurt", 1, false);
			
				Reg._healthCurrent -= damage;			
			}
			
			Reg._isFallDamage = false;
			super.hurt(damage);	// decrease health.
		}
	}
	
	public function bounce():Void
	{
		// move the object in an upward direction and push the object in its backward direction.
		if (Reg._antigravity == false) velocity.y = -300; else velocity.y = 300;		
		if (facing == FlxObject.LEFT)
			velocity.x = -100;
		else velocity.x = 100;	
		
		EnemyCastSpriteCollide.shoundThereBeFallDamage(this);
	}

}
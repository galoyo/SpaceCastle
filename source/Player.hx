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
	public var xForce:Float = 0;
	public var yForce:Float = 0;
	private var _dogFound:Bool = false;
	private var _ticksNextJump:Float; // as this var increases, so does the amount of fading gray players when the player does the jump.
	private var _playerIsDashing:Bool = false; // is the player doing a skill dash which is a fast horizontal attack.
	
	public var _newY:Float = 0;	// used to keep the player standing still above the mobs head.

	public var _bullets:FlxTypedGroup<Bullet>;
	private var _bullet:Bullet;
	private var _bulletSpeed:Int = 1000;
	private var _particleBulletHit:FlxEmitter;
	private var _particleBulletMiss:FlxEmitter;
	private var _emitterBulletFlame:FlxEmitter;
	private var _emitterSkillDash:FlxEmitter;
	
	public var _maxWalkSpeed:Int = 430;
	public var _maxRunSpeed:Int = 630;
	public var _gravity:Int = 3500;
		
	private var _maxAcceleration:Int = 50000;
	public var _yMaxAcceleration:Int = 1000;
	public var _drag:Int = 50000;
	public var _mobIsSwimming:Bool = false;
	private var _skillDashX = 0; // when not doing a dash attack the value will be zero. when doing a dash attack the velocityX will be its value. 
	private var _velocityX = 1200; // speed of the horizontal dash.
	private var _skillDashY = 0; // when not doing a dash attack the value will be zero. when doing a dash attack the velocityY will be its value. 
	private var _velocityY = 23140; // must be a bit bugger than _maxFallSpeed. this var is 140 in value greater than _maxFallSpeed which will lift the player off the ground about 20 pixels when doing a dash attach.
	public var _maxFallSpeed:Int = 23000;
	
	// is player in the air?
	public var inAir:Bool = false;
	public var hasWon:Bool = false;	
	public var hitEnemy:Bool = false;

	private var _gunDelay:Float;
	private var _cooldown:Float;

	public var finalJumpForce:Float;
	public var holdingUpKey:Bool = false;
	private var running:Bool = false;	
	
	private var _swimming:FlxTimer;
	private var _swimmingTimerIsComplete:Bool = true;
	public var _setPlayerOffset:Bool = false; // used to stop the player from showing its head when stopping at a junction.
	
	public var _playerStandingOnFireBlockTimer = new FlxTimer();
	
	public function new(x:Float, y:Float, bullets:FlxTypedGroup<Bullet>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter, emitterBulletFlame:FlxEmitter, emitterSkillDash:FlxEmitter) 
	{
		// position player sprite at this coor. x and y values are from the cvs file multiplied
		// by the with / height of the tileset.
		super(x, y);

		if (Reg._playerFeelsWeak == false) loadGraphic("assets/images/player.png", true, 28, 28);		
			else loadGraphic("assets/images/playerWeak.png", true, 28, 28);		
			
		collisonXDrag = true;
		pixelPerfectPosition = true;
		
		inAir = false;
		offset.set(0, 0);
		
		_bullets = bullets;
		_particleBulletHit = particleBulletHit;
		_particleBulletMiss = particleBulletMiss;
		_emitterBulletFlame = emitterBulletFlame;
		_emitterSkillDash = emitterSkillDash;
		
		_cooldown = _gunDelay = 0.15;	// Initialize the cooldown so that we can shoot right away.
		
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
		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 16);
		animation.add("walkOnLadder", [3, 4, 5, 4, 3, 4, 5, 4], 16);
		animation.add("run" , [0, 1, 2, 1, 0, 1, 2, 1], 24);
		animation.add("jump", [2], 25);
		animation.add("skid", [2], 25);
		animation.add("death", [2], 25);
		animation.add("changedToItemFlyingHat", [6, 7, 8, 9], 40, false);
		animation.add("changedToNoItem", [8, 7, 6, 0], 40, false);
		animation.add("flyingHat", [10, 11], 20, true);
		animation.add("idle", [2], 25);
		animation.add("idleOnLadder", [3], 25);
		
		// antigravity animation.
		animation.add("walk2", [0, 1, 2, 1, 0, 1, 2, 1], 16, true, false, true);
		animation.add("walkOnLadder2", [3, 4, 5, 4, 3, 4, 5, 4], 16, true, false, true);
		animation.add("run2" , [0, 1, 2, 1, 0, 1, 2, 1], 24, true, false, true);
		animation.add("jump2", [2], 25, true, false, true);
		animation.add("skid2", [2], 25, true, false, true);
		animation.add("death2", [2], 25, true, false, true);
		animation.add("changedToItemFlyingHat2", [6, 7, 8, 9], 40, false, false, true);
		animation.add("changedToNoItem2", [8, 7, 6, 0], 40, false, false, true);
		animation.add("flyingHat2", [10, 11], 20, true, false, true);
		animation.add("idle2", [2], 25, true, false, true);
		animation.add("idleOnLadder2", [3], 25, true, false, true);
		
		// max movement speed.
		maxVelocity.y = _maxFallSpeed;
		
		// how fast the speed of the object is changed in pixels per second.
		acceleration.y = _gravity;
		
		// slow the object before stopping it.		
		drag.x = _drag;		
		
		health = Reg._healthCurrent;
		FlxSpriteUtil.flicker(this, Reg._mobHitFlicker, 0.04, true); // no damage given when starting at a level.
		
		_swimming = new FlxTimer();
		
		visible = true; 
		
	}
	
	public function shoot(holdingUpKey:Bool):Void 
	{	
		// disable tracker when bullet is fired.
		Reg.state._ticksTrackerUp = 0;
		Reg.state._ticksTrackerDown = 0;
		
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
				
				if (holdingUpKey == true)
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
				
				if (holdingUpKey == true)
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
					
					if (holdingUpKey == true)
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


					_bullet.shoot(bulletX, bulletY, bXVeloc, bYVeloc, holdingUpKey, _particleBulletHit, _particleBulletMiss);		
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
					
					if (holdingUpKey == true)
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


					_bullet.shoot(bulletX, bulletY, bXVeloc, bYVeloc, holdingUpKey, _particleBulletHit, _particleBulletMiss);		
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
		Reg.playerXcoords = this.x / Reg._tileSize;
		Reg.playerYcoords = this.y / Reg._tileSize;
	}
	
	override public function update(elapsed:Float):Void 
	{	
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();

		if (overlapsAt(x, y - 15, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x, y - 45, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
		Reg._lastArrowKeyPressed = "up";
		if (overlapsAt(x + 15, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x + 45, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
		Reg._lastArrowKeyPressed = "right";
		if (overlapsAt(x, y + 15, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x, y + 45, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
		Reg._lastArrowKeyPressed = "down";
		if (overlapsAt(x - 15, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe) || overlapsAt(x - 45, y, Reg.state._overlayPipe) && !overlapsAt(x, y, Reg.state._overlayPipe)) 
		Reg._lastArrowKeyPressed = "left";
		
		// hide players healthbar if overlays are in front of player. we don not want the player to be seen or known where player is located at.
		if ( overlapsAt(x, y, Reg.state.overlays)) Reg.state._healthBarPlayer.visible = false;
			else Reg.state._healthBarPlayer.visible = true;
		
		// bullet
		_cooldown += elapsed;
		
		if (alive && !hasWon && Reg._playerCanShootOrMove == true ) controls();
		if (!hasWon) animate();
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
				
		super.update(elapsed);
	}
	
	// sets the movement vars for the player based on the keyboard key pressed.
	function controls():Void
	{			
		
		//################### LAVA BLOCK.
		// take damage if on the fire block. 1 damage every 1 second.			
		if ( Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) >= 233 && Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) <= 238 || FlxG.collide(this, Reg.state._objectLavaBlock))
		{
			if (_playerStandingOnFireBlockTimer.finished == true) hurt(1);
			
			if (_playerStandingOnFireBlockTimer.active == false)
			_playerStandingOnFireBlockTimer.start(1, null, 1);			
		}
		//################### END LAVA BLOCK.
		
		//################## ICE BLOCKS
		if ( Reg.state.tilemap.getTile(Std.int(x / 32), Std.int(y / 32) + 1) == 220) drag.x = 3000;
		else drag.x = _drag;	
		
		//################## END ICE BLOCKS.

			
		// play the flute.
		if (Reg._itemGotDogFlute == true)
		{
			// usewd to hold the location of where the dog was picked up. if this var matches the coords where a dog should exist then the dogFound var will be false.
			var _dogNoLongerAtMap2 = Reg._dogNoLongerAtMap.split(",");			
			
			if (Reg.state.npcDogLady != null) _dogFound = false;
			if (Reg.state.npcDog != null) _dogFound = true;
			
			for (i in 0...4)
			{	
				var temp:String = Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse;

				// was the dog picked up at map
				if (_dogNoLongerAtMap2[i] != null)
				{
					if (_dogNoLongerAtMap2[i] == temp)
					{
						_dogFound = false;
						break;
					}
				}
			}				
			
			if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Dog Flute."
			 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Dog Flute."
			 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Dog Flute.")
			{
				// if dog exists on map but is not located at top left corner of screen.
				if (Reg.state.npcDog != null && Reg.state.npcDog.x != 0) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("dogFlute", 1, false);
				}
			
				else if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
			}
		}
		//----------------------------
		
		xForce = 0; yForce = 0;		

		// #################### TOGGLE ANTIGRAVITY ####################
		// toggle antigravity.
		if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Antigravity Suit."
		 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Antigravity Suit."
		 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Antigravity Suit.")
		{
			if (inAir == false && Reg._antigravity == false && !overlapsAt(x, y + 16, Reg.state._itemFlyingHatPlatform)) 
			{
				Reg._antigravity = true;
				Reg._playersYLastOnTile = y;
				Reg._currentKeyPressed = "NULL";
			}
			
			else if(inAir == false && Reg._antigravity == true)
			{
				Reg._antigravity = false;
				Reg._playersYLastOnTile = y;
				Reg._currentKeyPressed = "NULL";
			}
		}
	
		if (   InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
		    || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
		{
			Reg._jumpForce = 820; Reg._fallAllowedDistanceInPixels = 96;
			
			if (FlxG.overlap(Reg.state._objectQuickSand, this)) Reg._jumpForce = 300;
		}
		
		else if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump.")
		{
			// Reg._itemGotJump[0] refers to the first jump item obtained. which is set to true when the game starts. the _jumpForce is how high the player can jump. in this case, the player can jump up two tiles. the next jump item jumps for 3 items, ect. Since the jump force is set for 2 tiles, the _fallAllowedDistanceInPixels is also 2 tiles totaling 64 pixels.
			Reg._jumpForce = 680; Reg._fallAllowedDistanceInPixels = 64;
			
			if (FlxG.overlap(Reg.state._objectQuickSand, this)) Reg._jumpForce = 300;
		}
		
		if (Reg._antigravity == false) 
		{
			// vars for a normal jump.
			finalJumpForce = -(Reg._jumpForce + Math.abs(velocity.y * 0.25));
		}
		else 
		{
			// vars for an anitigravity jump.
			finalJumpForce = (Reg._jumpForce + Math.abs(velocity.y * 0.25));	
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
				if(_mobIsSwimming == false)
				{
					// fire the bullet in the direction of up or down depending if antigravity is used or not.
					if (Reg._antigravity == true && InputControls.down.justPressed || Reg._antigravity == false && InputControls.up.justPressed)
					{
						holdingUpKey = true; 
						shoot(holdingUpKey); 						
					}	
					else if (Reg._antigravity == true|| Reg._antigravity == false
					|| Reg._antigravity == true || Reg._antigravity == false)
					{
						holdingUpKey = false;  
						shoot(holdingUpKey);
					}
		
				} 
				else if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 0.50, false);

			}
		}
	
		// how fast the player is moving in the y coor. generally moving in a 
		// downward direction.
		if( Reg._playerRunningEnabled == true) running = true;
		
		if (!FlxG.overlap(Reg.state._objectWaterCurrent, this) && !FlxG.overlap(Reg.state._overlayPipe, this))
		{
			if (   InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
				|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
				|| InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
				|| InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
				|| InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
				|| InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
				{
					if (InputControls.left.pressed || InputControls.right.pressed) _playerIsDashing = true;
			}
			
			//############################## DASH ATTACK 
			// holding an arrow key left or right before jumping is not allowed. the reason is because of a bug. when exiting the map from the right side, if holding the right arrow key and then jumping into the next map, the player will fall straight down at that next map. the player will not continue to move in that same direction if that arrow key is still held down. however, if a jump was made before holding an arrow key then when leaving the map the player will continue to move forward at the next map if that arrow key is still held down. this code address the bug by delaying movement when jump in not allowed.
			
			// when the left or right arrow is pressed and then the jump key is pressed, the player will do a dashed attach. the player will quickly dash to the left or right while the player is rising in to the air. 
			if (_playerIsDashing == true)
			{				
				if (InputControls.left.pressed) 
				{ 
					_skillDashX = _velocityX; xForce--;
					if (Reg._antigravity == false) _skillDashY = -_velocityY;
					else  _skillDashY = _velocityY;
					
				}
				
				else if (InputControls.right.pressed)
				{ 
					_skillDashX = _velocityX; xForce++;
					if (Reg._antigravity == false) _skillDashY = -_velocityY;
					else  _skillDashY = _velocityY;
				}				
			
				// the player moves so fast that there is a trail of gray players that fade behind the player.
				// when player is dashing, the player will lift from the ground or ceiling. if players velocity.y is in motion then do the following.
				if (_skillDashY != 0)
				{	_ticksNextJump = Reg.incrementTicks(_ticksNextJump, 60 / Reg._framerate);
				
					_emitterSkillDash.focusOn(this);
					_emitterSkillDash.start(true, 0.03, 1);
				}
			}				
	
			// when this condition is met. the last trail is complete.
			if (_ticksNextJump >= 8) 
			{
				_ticksNextJump = 0;
			}

			// stop when the last gray player is displayed, when then max value of the ticks is true and the player is dashing. also stop the dash when the key/button is not pressed, when that condition is true then xForce equals zero. so stop when the max value of the ticks is reached and when key/button is not pressed anymore.
			if (_ticksNextJump >= 7 && _playerIsDashing == true || xForce == 0 && _playerIsDashing == true)
			{	
				_playerIsDashing = false;
				_skillDashX = 0; _skillDashY = 0;
			}
			
			//######################### END DASH ATTACK.

			if (_playerIsDashing == false)
			{			
				_ticksNextJump = 0;	_skillDashX = 0; _skillDashY = 0;
				
				if (InputControls.left.pressed) 
				{ xForce--; Reg._arrowKeyInUseTicks = 0; }
				if (InputControls.right.pressed)
				{ xForce++; Reg._arrowKeyInUseTicks = 0; }	
			}
			
			

		}		
		
		// if running then do not run faster then the max speed else set to walk speed.
		if (_mobIsSwimming == false) {maxVelocity.x = _maxWalkSpeed + _skillDashX; maxVelocity.y = _maxFallSpeed + _skillDashY;}	
		else {maxVelocity.x = _maxWalkSpeed + _skillDashX / Reg._swimmingDelay; maxVelocity.y = _maxFallSpeed + _skillDashY	/ Reg._swimmingDelay; }
		
		//---------------------------
		//########### PLAYER IS JUMPING.
		if (!InputControls.left.pressed && !InputControls.right.pressed)
		{
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
				else if ( Reg._usingFlyingHat == false && inAir == false || Reg._usingFlyingHat == false && FlxG.collide(this, Reg.state._jumpingPad)
				|| Reg._usingFlyingHat == false && inAir == false || Reg._usingFlyingHat == false && FlxG.collide(this, Reg.state._jumpingPad))		
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("jump", 0.50, false);			
					
					velocity.y = finalJumpForce;	
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
					velocity.y = finalJumpForce / 1.5;
				}
				
				// stop rapid swimming.
				_swimmingTimerIsComplete = false;
				if (_swimming.active == false) _swimming.start(0.12, swimmingOnTimer, 1);
			}		
		}

		if (!FlxG.overlap(Reg.state._overlayPipe, this))
		{
			xForce = FlxMath.bound(xForce, -1, 1);		
			if (InputControls.left.pressed || InputControls.right.pressed)
			{
				if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
				 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
				 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."	
				 || InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
				 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
				 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1.")
					acceleration.x = 0;
				else acceleration.x = xForce * _maxAcceleration; // need this to stop running away player without arrow key press.
				
			} else if (_skillDashX == 0 ) acceleration.x = 0;		
			
			Reg._dogIsInPipe = false;
		} else Reg._dogIsInPipe = true;
		
		// play a thump sound when mob lands on the floor.
		if (Reg._antigravity == true && justTouched(FlxObject.CEILING) && !overlapsAt(x, y + 16, Reg.state._objectLadders) || Reg._antigravity == false && justTouched(FlxObject.FLOOR) && !overlapsAt(x, y + 16, Reg.state._objectLadders) )
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
			inAir = false;
			
			if (Reg._antigravity == false) animation.play("idle"); 
				else animation.play("idle2");
			
			Reg._trackerInUse = false;
			Reg.state._ticksTrackerUp = 0; // if jumping then reset tick.
		} 
		else if(Reg._antigravity == true && !isTouching(FlxObject.CEILING) || Reg._antigravity == false && !isTouching(FlxObject.FLOOR)) inAir = true;
		
		if (Reg._antigravity == true && inAir && justTouched(FlxObject.FLOOR) || Reg._antigravity == false && inAir && justTouched(FlxObject.CEILING)) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("ceilingHit", 1, false);
		}	
		
		if (hitEnemy) hitEnemy = false;

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
			else if (!isTouching(FlxObject.FLOOR) && Reg._antigravity == false) 
			{
				acceleration.y = _gravity;
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
			else if ( !isTouching(FlxObject.CEILING) && Reg._antigravity == true) 
			{
				acceleration.y = -_gravity;
			} 
			else
			{
				// if player is standing on a slope then set high gravity so that the player will walk down the slope instead of jumping or hopping down.
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
			}
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
				
			Reg._trackerInUse = false;
			Reg.state._tracker.y = y;
			Reg._arrowKeyInUseTicks = 0;

			velocity.y = velocity.y * 0.5; // set the gravity in case player is in the air and using the flying hat.
		}
					
		else if (Reg._antigravity == false && !isTouching(FlxObject.FLOOR) && Reg._usingFlyingHat == false)
		{
			if (Reg._antigravity == false && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("jump");
			else if (overlapsAt(x, y, Reg.state._objectLadders))
			{					
				if (velocity.y == 0) animation.play("idleOnLadder");
			}
		}
		else if (Reg._antigravity == true && !isTouching(FlxObject.CEILING) && Reg._usingFlyingHat != false )
		{
			if (Reg._antigravity == true && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("jump2");
			else if (overlapsAt(x, y, Reg.state._objectLadders))
			{					
				if (velocity.y == 0) animation.play("idleOnLadder2");
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
				//else if (Math.abs(velocity.x) > _maxWalkSpeed) animation.play("run");
				else 
				{ 
					if (Reg._antigravity == false && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("walk");	
					else if (Reg._antigravity == true && !overlapsAt(x, y, Reg.state._objectLadders)) animation.play("walk2");
				}
			}
		}
	}
	
	// checks that the walking and running speed of the player never going faster
	// then its constraints and that the player is alive else go to the kill() function.
	function levelConstraints():Void
	{
		// if player is at the boundries of the left side of screen then bounce off of
		// screen and then stop.
		if (x < 0) velocity.x = _maxRunSpeed;
		// if player is at the boundries of the right side of screen then bounce off of
		// screen and then stop.
		else if (x > Reg.state.tilemap.width - width) velocity.x = -_maxRunSpeed;
		
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

				if (Reg._soundEnabled == true) FlxG.sound.playMusic("gameover", 1, false);
				
				new FlxTimer().start(0.05, killOnTimer,30);
			}	
			
		}
		
		alive = false;
		
		// go to the gameOver state.
		new FlxTimer().start(1.25, PlayStateMiscellaneous.gameOver, 1);

	}
	
	private function swimmingOnTimer(_swimming:FlxTimer):Void
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
		if (FlxSpriteUtil.isFlickering(this) == false || Reg._isFallDamage == true)
		{
			if (damage > 0)
			{
				FlxSpriteUtil.flicker(this, Reg._mobHitFlicker, 0.04);
				
				if(Reg.mapXcoords != 24 && Reg.mapYcoords != 25)
					FlxG.cameras.shake(0.005, 0.3);
			
				if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels <= 0)
					if (Reg._soundEnabled == true) FlxG.sound.play("hurt", 1, false);
			
				Reg._healthCurrent -= damage;			
			}
			
			Reg._isFallDamage = false;
			super.hurt(damage);	
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
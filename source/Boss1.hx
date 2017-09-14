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

class Boss1 extends EnemyChildClass
{
	private var _bulletTimeForNextFiring:Float; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = 0; // -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	
	// used with jumping ability.
	private var _YjumpingDelay:Float = 100;
	private var ticksDelay:Float = 0;
	private var ticksDialog:Float = 0;
	
	public var defaultHealth:Int = 8;
	private var maxXSpeed:Int = 415;
	public var inAir:Bool = false;
		
	private var _playedMusic:Bool = false; // play the boss music only once when trying to defeat the boss.
		
	// how fast the object can fall.
	public var _gravity:Int = 4400;	
	
	public function new(x:Float, y:Float, id:Int, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, emitterSmokeRight:FlxEmitter, emitterSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, emitterSmokeRight, emitterSmokeLeft, bulletsMob, emitterBulletHit, emitterBulletMiss);
		
		if(id == 1) loadGraphic("assets/images/boss1A.png", true, 28, 28);
			else loadGraphic("assets/images/boss1B.png", true, 56, 56);

		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 12);
		
		pixelPerfectPosition = false;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);				
		
		ID = id;
		acceleration.y = _gravity;
			
		if(id == 1) health = defaultHealth * Reg._differcuityLevel;
			else health = Std.int((defaultHealth * 2.7) * Reg._differcuityLevel);
		
		ticksDelay = 0;
		ticksDialog = 0;
		_cooldown = FlxG.random.float(0.10, 0.60);	

		if (ID == 1) facing = FlxObject.LEFT;
		else facing = FlxObject.RIGHT;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (alive == true)
		{
			
			//############### PLAYER CHATS WITH MOB ###############
			if (InputControls.down.justReleased && Reg._playerHasTalkedToThisMob == false && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "";
				
				if(Reg.mapXcoords == 17 && Reg.mapYcoords == 22)	
				{
					if (ID == 1)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/boss1A-ID1-Map17-22.txt").split("#");								
						
						Reg.dialogCharacterTalk[0] = "talkBoss1.png";
						Reg._playerHasTalkedToThisMob = true;
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}	
				}
				
				if(Reg.mapXcoords == 12 && Reg.mapYcoords == 19)	
				{
					if (ID == 2)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/boss1B-ID1-Map12-19.txt").split("#");								
							
						Reg.dialogCharacterTalk[0] = "talkBoss1.png";						
						Reg._playerHasTalkedToThisMob = true;
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}	
				}		
				
			}
			
			if (animation.paused == false && health > 2)
			{ 
				if (justTouched(FlxObject.FLOOR)) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
				} 
				else if (!isTouching(FlxObject.FLOOR)) inAir = true;			
						
				if (ID == 1)
				{
					if(Reg._playerHasTalkedToThisMob == true)
					{
						animation.play("walk");	
						
						if (ticksDelay <= 50) ticksDelay = Reg.incrementTicks(ticksDelay, 60 / Reg._framerate);
						if (ticksDelay == 50) 
						{
							// bullet.
							_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
							_cooldown = FlxG.random.float(0.10, 0.60);		
							_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
							_bulletFireFormation = _bulletFormationNumber = -1;	
							
							if (_playedMusic == false)
							{
								playBossMusic();
								FlxSpriteUtil.stopFlickering(Reg.state.player);							
							}
							
							_playedMusic = true;
						}
					
						if (ticksDelay >= 50)
						{
							// see update() function at playState about how this works. 
							Reg._boss1AIsMala = false; // player will now get hurt damage.
							
							//####################
							// jumping.
							// if the mob is about 3 tiles away from the player then able to do a jump more than if farther away. 
							var jump:Int = 0;
							if(facing == FlxObject.RIGHT &&  x - 100 < _player.x || facing == FlxObject.LEFT &&  x + 100 > _player.x)
							jump = FlxG.random.int( 0, 40);
							else jump = FlxG.random.int( 0, 120);
							
							jump = FlxG.random.int( 0, 150);
							var moveSpeed = FlxG.random.int(150, 400);					
								
							if (jump <= 3)
							{
								if (isTouching(FlxObject.FLOOR) && facing == FlxObject.LEFT || isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT)
								{
									velocity.y = -900;
								}
							}
							//####################
							// the mob moves in the direction of this var. if the var is a nagative value then the mob will walk in the direction of left.
							velocity.x = velocityXOld;
							
							// set basic object speed based on conditions.
							if (justTouched(FlxObject.RIGHT)) 
							{
								facing = FlxObject.LEFT;
							}
							else if (justTouched(FlxObject.LEFT))
							{
								facing = FlxObject.RIGHT;
							}
							
							if (facing == FlxObject.LEFT)
							{
								velocity.x = -maxXSpeed - moveSpeed; 				
								velocityXOld = velocity.x;
							}
							
							else if (facing == FlxObject.RIGHT)
							{
								velocity.x = maxXSpeed + moveSpeed;				
								velocityXOld = velocity.x;
							}
						}
					} 
				}	
				
				// same boss but much bigger looking. 
				if (ID == 2)
				{
					if(Reg._playerHasTalkedToThisMob == true)
					{
						animation.play("walk");	

						if (ticksDelay <= 50) ticksDelay = Reg.incrementTicks(ticksDelay, 60 / Reg._framerate);
						if (ticksDelay == 50) 
						{
							// bullet.
							_bulletTimeForNextFiring = FlxG.random.float(0.60, 1.20);
							_cooldown = FlxG.random.float(0.10, 0.60);		
							_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
							_bulletFireFormation = _bulletFormationNumber = 1;	
							
							if(_playedMusic == false)
							{
								playBossMusic();
								FlxSpriteUtil.stopFlickering(Reg.state.player);
							}
							
							_playedMusic = true;
						}
				
						if (ticksDelay >= 50)
						{
							// see update() function at playState about how this works. 
							Reg._boss1BIsMala = false; // player will now get hurt damage.
							
							//####################
							// jumping.
							// if the mob is about 3 tiles away from the player then able to do a jump more than if farther away. 
							var jump:Int = 0;
							if(facing == FlxObject.RIGHT &&  x - 100 < _player.x || facing == FlxObject.LEFT &&  x + 100 > _player.x)
							jump = FlxG.random.int( 0, 40);
							else jump = FlxG.random.int( 0, 120);
							
							jump = FlxG.random.int( 0, 150);
							var moveSpeed = FlxG.random.int(150, 400);					
							if (jump <= 3)
							{
								if (isTouching(FlxObject.FLOOR) && facing == FlxObject.LEFT || isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT)
								{
									velocity.y = -900;
								}
							}
							//####################
							// the mob moves in the direction of this var. if the var is a nagative value then the mob will walk in the direction of left.
							velocity.x = velocityXOld;
							
							// set basic object speed based on conditions.
							if (justTouched(FlxObject.RIGHT) || x - 250 > _player.x && isTouching(FlxObject.FLOOR)) 
							{
								facing = FlxObject.LEFT;
							}
							else if (justTouched(FlxObject.LEFT) || x + 250 < _player.x && isTouching(FlxObject.FLOOR))
							{
								facing = FlxObject.RIGHT;
							}
							
							if (facing == FlxObject.LEFT)
							{
								velocity.x = -maxXSpeed - moveSpeed; 				
								velocityXOld = velocity.x;
							}
							
							else if (facing == FlxObject.RIGHT)
							{
								velocity.x = maxXSpeed + moveSpeed;				
								velocityXOld = velocity.x;
							}
						}
					} 
				}	
				
				if (velocity.x == 0 && Reg._playerHasTalkedToThisMob == true && ticksDelay == 50)
				{
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
				
				// bullet
				_cooldown += elapsed;
				if (Reg._playerHasTalkedToThisMob == true && ID == 2 && _bulletFireFormation == 1)
				{
					Reg._bulletSize = 0;
					shoot();
				}
			
			}

			if (health == (2 * Reg._gunPower))
			{
				velocity.x = velocity.y = 0;
				acceleration.x = 0;
				acceleration.y = 5000;
				allowCollisions = FlxObject.FLOOR;
				Reg._playerCanShootOrMove = false;		
				_bulletFormationNumber = -1; // do not fire bullet when mob is defeated.
				
				if(Reg.mapXcoords == 17 && Reg.mapYcoords == 22)	
				{
					if (ID == 1)
					{						
						Reg.dialogCharacterTalk[0] = "talkBoss1.png";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/boss1A-ID1-Map17-22B.txt").split("#");								
							
						Reg._playerHasTalkedToThisMob = true;
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						
						health = 1;
					}			
					
				}
				
				if(Reg.mapXcoords == 12 && Reg.mapYcoords == 19)	
				{
					if (ID == 2)
					{	
						if (ticksDialog == 0) 
						{							
							if (Reg._soundEnabled == true) 
							{
								FlxG.sound.playMusic("event", 1, false);
							}
							
							Reg._boss1BIsMala = true; // is mala again because of a conversation.
						}
						
						ticksDialog = Reg.incrementTicks(ticksDialog, 60 / Reg._framerate);
		
						if (ticksDialog == 40)
						{
							Reg.dialogIconText = openfl.Assets.getText("assets/text/boss1B-ID1-Map12-19B.txt").split("#");								
							
							Reg.dialogCharacterTalk[0] = "talkBoss1.png";
							Reg._playerHasTalkedToThisMob = true;
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						
							ticksDialog = 0;
							health = (1 * Reg._gunPower);
						}
					}						
				}
			} 
			
			if (health == (1 * Reg._gunPower))
			{				
				if ( ID == 1) 
				{
					Reg._boss1ADefeated = true; 
					
					// remove block so that plater can get item.
					var newindex:Int = 193;
					for (j in 0...Reg.state.tilemap.heightInTiles)
					{
						for (i in 0...Reg.state.tilemap.widthInTiles - 1)
						{
							if (Reg.state.tilemap.getTile(i, j) == 177)
							{
								Reg.state.tilemap.setTile(i, j, newindex, true);
							}	
						}		
					}					
					
					Reg._playerCanShootOrMove = true;	
					Reg._playerHasTalkedToThisMob = false;
					
					PlayStateMiscellaneous.playMusic(); // back to the normal stage music because boss was defeated.
					kill();
				}

				if (ID == 2 ) 
				{
					if (ticksDialog == 0) 
					{										
						Reg._boss1BDefeated = true;
						Reg._boss1BIsMala = true;
					}
					
					if (ticksDialog == 8)
					{
						Reg.state.mobBubble.visible = true;	
					}
					
					ticksDialog = Reg.incrementTicks(ticksDialog, 60 / Reg._framerate);
						
					if (ticksDialog == 15)
					{
						Reg.dialogIconText = openfl.Assets.getText("assets/text/boss1B-ID1-Map12-19C.txt").split("#");								
							
						Reg.dialogCharacterTalk[0] = "talkBoss1.png";
						Reg.dialogCharacterTalk[1] = "talkMobBubble.png";						
						Reg._playerHasTalkedToThisMob = true;
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());									
					}
					
					if (ticksDialog == 30)
					{
						Reg.state.mobBubble.visible = false;
						Reg.state.mobBubble.alive = false;
						Reg.state._bubbleHealthBar.kill();
						Reg.state._defenseMobFireball1.visible = false;
						Reg.state._defenseMobFireball2.visible = false;
						Reg.state._defenseMobFireball3.visible = false;
						Reg.state._defenseMobFireball4.visible = false;
						
						Reg._playerCanShootOrMove = true;
						Reg._playerHasTalkedToThisMob = false;
						
						PlayStateMiscellaneous.playMusic(); // back to the normal stage music because boss was defeated.
						kill();
						
						// remove block barrier so that player can get item.
						var newindex:Int = 193;
						for (j in 0...Reg.state.tilemap.heightInTiles)
						{
							for (i in 0...Reg.state.tilemap.widthInTiles - 1)
							{
								if (Reg.state.tilemap.getTile(i, j) == 177)
								{
									Reg.state.tilemap.setTile(i, j, newindex, true);
								}	
							}		
						}						
					}
				}				
			}			 
		}
		
		super.update(elapsed);		

		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
	
}
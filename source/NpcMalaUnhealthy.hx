package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class NpcMalaUnhealthy extends FlxSprite
{
	/**
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/**
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	private var _talkedToDoctor:Bool = false; // used to display the doctors message once.
	private var _malasTeleported:String = "";
	
	private var ticks:Float = 0;
	private var ticksWalk:Float = 0; // used for the npc that walks back and forth.		
	
	/**
	 * Make the Mala idle for a short random time.
	 */
	private var ticksIdle:Float = 0;
	
	/**
	 * The Mala will stop and be idle if this value is true.
	 */
	private	var _makeMalaIdle:Bool = false;
	
	private var _xLeftBoundry:Float = 0; // npc cannot walk path the x position of this var.
	private var _xRightBoundry:Float = 0;
	private var _isWalking:Bool = false;
	private var _shovelDiggingSpeed:Int;
	private var _usingShovel:Bool = false;
	private var _usingWateringCan:Bool = false;
	private var _walking:Bool = false;	
	
	private var _tileX:Int; // the tile x coords not in pixels.
	private var _tileY:Int;
	
	private var _playerTimeRemainingTimer:FlxTimer;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		//##########################################################################
		//## MOST VARS NEED TO BE FROM REG BECAUSE EACH ID DOES SOMETHING DIFFERENT.
		//##########################################################################

		_startX = x;
		_startY = y;

		_xLeftBoundry = x - 64;
		_xRightBoundry = x + 64;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/npcMalaUnhealthy.png", true, 28, 28);

		_playerTimeRemainingTimer = new FlxTimer();
		
		if (FlxG.random.int(0, 2) == 0) _isWalking = true;
			else _isWalking = false;
			
		_shovelDiggingSpeed = FlxG.random.int(20, 40);
		
		animation.add("idle", [1,1,1,1,1, 12], 10);
		animation.play("idle");
		
		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 16);			

		// boss1b was defeated so remove all unhealthy malas from the screen because the doctor took them all away.
		if (ID == 1 && Reg.mapXcoords == 17 && Reg.mapYcoords == 21 && Reg._boss1BDefeated == true || ID == 2 && Reg.mapXcoords == 17 && Reg.mapYcoords == 21 && Reg._boss1BDefeated == true || ID == 3 && Reg.mapXcoords == 17 && Reg.mapYcoords == 21 && Reg._boss1BDefeated == true || ID == 4 && Reg.mapXcoords == 17 && Reg.mapYcoords == 21 && Reg._boss1BDefeated == true) kill();
			
		if (ID == 1 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1BDefeated == true || ID == 2 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1BDefeated == true || ID == 3 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1BDefeated == true || ID == 8 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1BDefeated == true) kill();	

		
		Reg.ticksDoctor = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{				
		if (isOnScreen())
		{			
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
		
			var ra:Int = FlxG.random.int(0, 25);			
			var ticksRandom:Int = FlxG.random.int(15, 40); // used to delay walking.	
			
			//###################### SHOVEL #######################
			// check if a shovel exists at the left or right side of player. if it does then move player closer to shovel. next: play the animation of the mala digging with the shovel but only once. set _usingShovel to true so that the npc will not walk with the shovel while digging.			
			
			if (overlapsAt(x + 32, y, Reg.state._npcShovel) && ticks == 0)
			{
				if(ticks == 0) loadGraphic("assets/images/npcShovel.png", true, 56, 28);
				x = x + 30;
				animation.add("shovel", [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 4, 4, 3, 2, 1], _shovelDiggingSpeed, true);
				animation.play("shovel");
				_usingShovel = true;
			}
			else if (overlapsAt(x - 32, y, Reg.state._npcShovel) && ticks == 0) 
			{
				if(ticks == 0) loadGraphic("assets/images/npcShovel.png", true, 56, 28);
				x = x - 52;
				animation.add("shovel2", [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 4, 4, 3, 2, 1], _shovelDiggingSpeed, true);
				flipX = true;
				animation.play("shovel2");
				_usingShovel = true;
			}			
			//################### END OF SHOVEL ####################
			
			//################### WATERING CAN #####################
			if (overlapsAt(x + 32, y, Reg.state._npcWateringCan) && ticks == 0)
			{
				if(ticks == 0) loadGraphic("assets/images/npcWateringCan.png", true, 56, 28);
				x = x + 30;
				
				_xLeftBoundry = x; _xRightBoundry = x;
				if (overlapsAt(x + 32, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 32;
				if (overlapsAt(x + 64, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 64;
				if (overlapsAt(x + 96, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 96;
				
				animation.add("watering", [0, 1, 2, 3, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 3, 2, 1], _shovelDiggingSpeed, true);
				animation.play("watering");
				_usingWateringCan = true;
				_isWalking = true;
			}
			else if (overlapsAt(x - 32, y, Reg.state._npcWateringCan) && ticks == 0) 
			{								
				if(ticks == 0) loadGraphic("assets/images/npcWateringCan.png", true, 56, 28);
				x = x - 50;
					
				_xLeftBoundry = x; _xRightBoundry = x;
				if (overlapsAt(x - 38, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 38;
				if (overlapsAt(x - 80, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 80;
				if (overlapsAt(x - 102, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 102;
				
				animation.add("watering", [0, 1, 2, 3, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 5, 6, 5, 4, 3, 2, 1], _shovelDiggingSpeed, true);
				flipX = true;
				animation.play("watering");
				_usingWateringCan = true;
				_isWalking = true;
			}
			//################## END OF WATERING CAN ###############
			 
			//###################### WALKING #######################
			if (_isWalking == true && _usingShovel == false)
			{
				 if (Reg.mapXcoords == 24 && Reg.mapYcoords == 25) return;
				 
				 if (ticksWalk > 10 && ra == 1 || _makeMalaIdle == true)
				{					
					if (ticksIdle == 0) 
					{
						animation.play("idle");
						if (_usingWateringCan == true) animation.pause();						
					}
					
					// do nothing				
					ticksIdle = Reg.incrementTicks(ticksIdle, 60 / Reg._framerate);
					_makeMalaIdle = true;
					
					if (ticksIdle > ticksRandom) // pause walking for a short time.
					{
						ticksIdle = 0;
						_makeMalaIdle = false;
						
						animation.play("walk");
						if (_usingWateringCan == true) animation.play("watering");
					}
				} 
				else
				{				
					// convert pixels to tiles. used to find the next tile.
					if (facing == FlxObject.LEFT)
					{
						_tileX = Std.int((x + 3) / 32);		
						_tileY = Std.int(y / 32);
					}
					else 
					{
						_tileX = Std.int((x - 3) / 32);		
						_tileY = Std.int(y / 32);
					}
					
					if (ticksWalk == 0 && _usingWateringCan == false) animation.play("walk");
					
					if (ticksWalk >= 90) // 90... reset to 0.
					{
						// THIS IS THE SAME CODE AS BELOW.
						if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
						{
							ticksWalk = 0; 
							x = x - 2; 
							_walking = true; 
							
						} // at this line the overlapsAt checks for an empty space underneath the next tile that the mob is walking to.					
					}
					else if (ticksWalk >= 45) // 45 to 90... walk to the right
					{
						if ((x + 2) < _xRightBoundry && overlapsAt(x + 28, y + 28, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 98)
						{
							x = x + 2; 
							_walking = true;							
						}
						
					}
					else if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
					{
						x = x - 2; 
						_walking = true; 						
					} // 0 to 45, walk left.
					
					if (_walking == false) // stop npc animation if object is not moving;
					{
						animation.play("idle");
						if (_usingWateringCan == true) animation.pause();
					} else if (_usingWateringCan == true) animation.play("watering");
					
					ticksWalk = Reg.incrementTicks(ticksWalk, 60 / Reg._framerate);		
					_walking = false;
					
				}	
			}
			//################### END OF WALKING ##################
			
			ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
			
			
			//############### PLAYER CHATS WITH NPC ###############
			if (InputControls.down.justReleased && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "dialogNpcUnhealthy.png";
				
				if (Reg._playerFeelsWeak == true)
				{
					if(Reg.mapXcoords == 18 && Reg.mapYcoords == 15)	
					{
						if (ID == 1 || ID == 2 || ID == 3 || ID == 4)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map18-15-ID"+ID+"A-malaUnhealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				
				else if (Reg._boss1ADefeated == false)
				{
					if(Reg.mapXcoords == 17 && Reg.mapYcoords == 21)	
					{
						if (ID == 1)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID1A-malaUnhealthy.txt").split("#");
										
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
						
						if (ID == 2)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID2A-malaUnhealthy.txt").split("#");
									
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	

						if (ID == 3)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID3A-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
						
						if (ID == 4)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID4A-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
					}
					
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID1A-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 2)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID2A-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 3)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID3A-malaUnhealthy.txt").split("#");
							
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 8)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID8A-malaUnhealthy.txt").split("#");
							
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				//##################### BOSS 1 DEFEATED ###############
				else if (Reg._boss1ADefeated == true)
				{
					if(Reg.mapXcoords == 17 && Reg.mapYcoords == 21)	
					{
						if (ID == 1)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID1B-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
						
						if (ID == 2)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID2B-malaUnhealthy.txt").split("#");
							
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
															
						if (ID == 3)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID3B-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
						
						if (ID == 4)
						{						
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map17-21-ID4B-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}	
					}
					
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID1B-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 2)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID2B-malaUnhealthy.txt").split("#");
								
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 3)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID3B-malaUnhealthy.txt").split("#");
							
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
						
						if (ID == 8)
						{
							Reg.dialogIconFilename = "";
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID8B-malaUnhealthy.txt").split("#");
							
							Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				//################### END BOSS 2 DEFEATED ##################
				
				//###################### WAITING ROOM ######################
				if(Reg.mapXcoords == 24 && Reg.mapYcoords == 25)	
				{
					if (ID == 1)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID1A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[0] = true;
					}
					
					else if (ID == 2)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID2A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[1] = true;
					}
					
					else if (ID == 3)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID3A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[2] = true;
					}
					
					else if (ID == 4)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID4A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[3] = true;
					}
					
					else if (ID == 5)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID5A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[4] = true;
					}
					
					else if (ID == 6)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID6A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[5] = true;
					}
					
					else if (ID == 7)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID7A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[6] = true;
					}
					
					else if (ID == 8)
					{						
						Reg.dialogIconFilename = "";
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-ID8A-malaUnhealthy.txt").split("#");
									
						Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						Reg._talkedToMalaAtWaitingRoom[7] = true;
					}
				}
				
				
				
			}
			//###################### END CHAT #####################
			
			if (Reg._talkToDoctorAt24_25Map == false && Reg.mapXcoords == 24 && Reg.mapYcoords == 25)
			{
				var ii:Int = 8;
				// loop to find the number of remaining malss that player must talk to. need to talk to every mala at 24-25map to trigger event.

				for (i in 0...9)
				{
					if (Reg._talkedToMalaAtWaitingRoom[i] == true)
					{
						ii--;
					}
				}
						
				// display the number of malas that the player still needs to talk to.
				Reg.state._talkToHowManyMoreMalas.text = "Needed: " + Std.string(ii);
				Reg.state._talkToHowManyMoreMalas.visible = true;
				
				if (ii == 0)
				{
					// remove block barrier so that plater can get item.					
					for (j in 0...Reg.state.tilemap.heightInTiles)
					{
						for (i in 0...Reg.state.tilemap.widthInTiles - 1)
						{							
							if (Reg.state.tilemap.getTile(i, j) == 177)
							{
								var newindex:Int = FlxG.random.int(16, 18);
								Reg.state.tilemap.setTile(i, j, newindex, true);
							}	
						}		
					}
					
					if (Reg._soundEnabled == true) FlxG.sound.play("click", 1, false);
					Reg.state._talkToHowManyMoreMalas.visible = false;
					
					// now that the player has talked to the malas, set some var so begin the shaking of the screen and then the countdown.
					Reg._talkToDoctorAt24_25Map = true;
				}
			}
			
			//################## SHAKE SCREEN, PLAY SIREN ###################
			if (Reg.state._talkToHowManyMoreMalas.visible == false && Reg.mapXcoords == 24 && Reg.mapYcoords == 25)
			{		
				
				if (Reg.ticksDoctor == 70)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("siren", 1, true);
					if (Reg._musicEnabled == true) 
					{
						FlxG.sound.playMusic("boss2", 1, true);
						FlxG.sound.music.persist = true;
					}
					FlxG.cameras.shake(0.005, 999999);
				}
			} 
			
			// ############# TALK TO DOCTOR AFTER SHAKE SCREEN ##############
			if (Reg.state._talkToHowManyMoreMalas.visible == false && Reg.mapXcoords == 24 && Reg.mapYcoords == 25)
			{
				Reg.ticksDoctor = Reg.incrementTicks(Reg.ticksDoctor, 60 / Reg._framerate);
				
				if (Reg.ticksDoctor == 450)
				{
					Reg.dialogIconFilename = "";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/Map24-25-doctor.txt").split("#");
					
					Reg.dialogCharacterTalk[0] = "talkDoctor.png";
					Reg.displayDialogYesNo = false;	
					Reg.state.openSubState(new Dialog());							
					
				}
				// Reg._talkToDoctorAt24_25Map = true;
				
				var ex = FlxG.random.int(0, 300); // time it takes the doctor to teleport a mala (extra time).
				
				// doctor is randomly teleporting malas.
				if (Reg.ticksDoctor > 500 && Reg.ticksTeleport == 350 + ex)
				{					
				
					var ra = FlxG.random.int(0, 7);
					var _malasTeleported2 = _malasTeleported.split(",");
					var _thisMalaWasTeleported = false;
					
					for (i in 0...8)
					{	
						if (_malasTeleported2[i] == Std.string(i))
							_thisMalaWasTeleported = true;
					}
					
					if (_thisMalaWasTeleported == false)
					{
						_malasTeleported = _malasTeleported + ra + ",";
					
						if (Reg._totalMalasTeleported < Reg._numberOfMalasToSave)
						{
							if (Reg._soundEnabled == true) FlxG.sound.play("teleport1", 1, false);
							kill();
						}
						Reg._totalMalasTeleported = Reg._totalMalasTeleported + 1;
					}					
					
					Reg.ticksTeleport = FlxG.random.int(0, 75);
				}
				
				Reg.ticksTeleport = Reg.incrementTicks(Reg.ticksTeleport, 60 / Reg._framerate);
				if (Reg.ticksTeleport > 900) Reg.ticksTeleport = 0;
					
				if (Reg.ticksDoctor > 1000) Reg.ticksDoctor = 1000; // keep var under a certain value so that the program will not crash when the limit is reached.
				
			}
		}	

		if (Reg.state._talkToHowManyMoreMalas.visible == false && Reg.mapXcoords == 24 && Reg.mapYcoords >= 21 && Reg.mapYcoords <= 25 && Reg._talkToDoctorAt24_25Map == true)
		{
			//################## Death countdown ###################
			if (_playerTimeRemainingTimer.active == false)
			_playerTimeRemainingTimer.start(0.05, null, Reg._deathWhenReachedZeroCurrent);
			
			// remember how many times the timer has looped through the var.	
			Reg._deathWhenReachedZero = -_playerTimeRemainingTimer.elapsedLoops + Reg._deathWhenReachedZeroCurrent;
			
			// hide the "death text" when player is about to leave the map.
			if (Reg.state.player.y < 2 || Reg.state.player.y > 450)
			{
				Reg.state._timeRemainingBeforeDeath.visible = false;
			}
			
			// display the "death text"
			else if (Reg._deathWhenReachedZero > 1)
			{
				Reg.state._timeRemainingBeforeDeath.text = "Death: " + Std.string(Reg._deathWhenReachedZero);
				Reg.state._timeRemainingBeforeDeath.visible = true;
			}
			
			// hide the text if the timer is 1 or minus 1. zero will not work.
			else if (Reg._deathWhenReachedZero <= 1) 
			{
				Reg.state._timeRemainingBeforeDeath.text = "Death: 0";
				Reg.state.player.kill();
			}		

			//####################################################
		}
		
		super.update(elapsed);	
	}	
}
package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class NpcMalaHealthy extends NpcParent
{
	/*******************************************************************************************************
	 * Used to determine when Stan starts the conversation about giving the phone and air tank to player. The phone, air tank and mobBubble dialog will happen when this value is 1.
	 */
	private var ticksStanStart:Float = 0;
	
	/*******************************************************************************************************
	 * Used to determine when NPC Stan will give phone and air tank items to player. also used to display mobBubble after Stan has given items to player.
	 */
	private var ticksStan:Float = 0;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y, id);

		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		_xLeftBoundry = x - 60;
		_xRightBoundry = x + 60;
		
		loadGraphic("assets/images/npcMalaHealthy.png", true, 28, 28);
		
		if (FlxG.random.int(0, 2) == 0) _isWalking = true;
			else _isWalking = false;
			
		_shovelDiggingSpeed = FlxG.random.int(20, 40);
		
		animation.add("idle", [0], 10);
		animation.play("idle");
		
		animation.add("walk", [11, 6, 7, 8, 9, 10], 16);
		
	}
	
	override public function update(elapsed:Float):Void 
	{				
		if (isOnScreen())
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
			
			if (ID == 10 && Reg.state._exclamationmPoint != null) Reg.state._exclamationmPoint.x = x;
			
			shovel(); //################### SHOVEL #####################	
			wateringCan(); //################### WATERING CAN #####################						 
			walking(); //###################### WALKING #######################				
			
			if (ticks == 1 && _usingWateringCan == false && _usingShovel == false) facing = FlxObject.LEFT;
			
			//############### PLAYER CHATS WITH NPC ###############
			if (InputControls.down.justReleased && Reg._keyOrButtonDown == true)
			{
				Reg._keyOrButtonDown = false;
			}
			
			if (InputControls.down.justPressed && overlapsAt(x, y, Reg.state.player) && Reg._keyOrButtonDown == false)
			{
				Reg._keyOrButtonDown = true;
				Reg.dialogIconFilename = "dialogNpcHealthy.png";
				
				if (Reg._playerFeelsWeak == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"D-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				else if (Reg._boss1BDefeated == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 10 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"C-malaHealthy.txt").split("#");
											
							if (ID == 10) Reg.dialogCharacterTalk[0] = "talkMobStan.png";
							else Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
							
							if (ID == 10)
							{
								var isEvent:Bool = PlayStateMiscellaneous.displayEvent(20, 20, 2);
							
								if (Reg._numberOfBossesDefeated == 2 && isEvent == false)
								{
									Reg._playerCanShootAndMove = false;
									ticksStanStart = 1;
								}
												
								PlayStateMiscellaneous.removeExclamationPointFromMala();
								if (Reg.state._exclamationmPoint != null) Reg.state._exclamationmPoint.kill();
							}
						}
					}
				}
				else if (Reg._boss1ADefeated == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 10 || ID == 3)
						{						
							// returns true if player has talked to exclamation Mala at nao 17-21.
							var isEvent:Bool = PlayStateMiscellaneous.displayEvent(17, 21, 1);
							
							if (ID == 10 && isEvent == true) Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID" + ID + "B2-malaHealthy.txt").split("#");
							else Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"B-malaHealthy.txt").split("#");
											
							if (ID == 10) Reg.dialogCharacterTalk[0] = "talkMobStan.png";
							else Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
							
							if (ID == 10 && isEvent == true)
							{
								PlayStateMiscellaneous.removeExclamationPointFromMala();
								if (Reg.state._exclamationmPoint != null) Reg.state._exclamationmPoint.kill();
							}
						}
					}
				}				
				 
				else if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
				{
					if (ID == 1 || ID == 10)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"A-malaHealthy.txt").split("#");
										
						if (ID == 10) Reg.dialogCharacterTalk[0] = "talkMobStan.png";
							else Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
						
						if (ID == 10)
						{
							PlayStateMiscellaneous.removeExclamationPointFromMala();
							if (Reg.state._exclamationmPoint != null) Reg.state._exclamationmPoint.kill();
						}
					}
				}
			}
			
			if (ticksStanStart == 1)
			{
				ticksStan = Reg.incrementTicks(ticksStan, 60 / Reg._framerate);
				
				// Stan talks about doctor and air tank.
				if (ticksStan == 10)
				{
					Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"C2-malaHealthy.txt").split("#");					
					Reg.dialogCharacterTalk[0] = "talkMobStan.png";		
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());
				}
				
				// Stan gives the air tank to the player.
				if (ticksStan == 25)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
					
					Reg._itemGotAirTank[0] = true;
					
					Reg.dialogIconFilename = "itemAirTank.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/stanAirTank.txt").split("#");					
					PlayStateTouchItems.newInventoryItemAutomatic(Reg.dialogIconFilename);
					
					Reg._playerAirLeftInLungsMaximum = 100;
					Reg._playerAirLeftInLungsCurrent = 100;
					Reg._playerAirLeftInLungs = 100;
					
					Reg.dialogCharacterTalk[0] = "";
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());
				}
				
				// Stan now talks abput the phone item.
				if (ticksStan == 40)
				{
					Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"C3-malaHealthy.txt").split("#");
										
					Reg.dialogCharacterTalk[0] = "talkMobStan.png";						
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());
				}
				
				// Give phone to player.
				if (ticksStan == 55)
				{
					if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
					
					Reg._itemGotPhone = true;
					
					Reg.dialogIconFilename = "itemPhone.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/stanPhone.txt").split("#");					
					PlayStateTouchItems.newInventoryItemAutomatic(Reg.dialogIconFilename);
										
					Reg.dialogCharacterTalk[0] = "";
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());
				}
				
				if (ticksStan == 75) 
				{
					if (Reg._soundEnabled == true) FlxG.sound.playMusic("event", 1, false);
				}
							
				// mobBubble appeas.
				if (ticksStan == 105)
				{
					Reg.state.mobBubble.visible = true;
					Reg.state.mobBubble.alive = true;
					Reg.state._defenseMobFireball1.visible = true;
					Reg.state._defenseMobFireball2.visible = true;
					Reg.state._defenseMobFireball3.visible = true;
					Reg.state._defenseMobFireball4.visible = true;
					FlxG.sound.playMusic("boss3", 0.80, true);
				}
				
				// mobBubble talks to Stan.
				if (ticksStan == 120)
				{
					Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID" + ID + "C4-malaHealthy.txt").split("#");
					
					Reg.dialogCharacterTalk[0] = "talkMobStan.png";
					Reg.dialogCharacterTalk[1] = "talkMobStan2.png";
					Reg.dialogCharacterTalk[2] = "talkMobBubble.png";						

					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());	
				}
					
				// mobBubble takes Stan away.
				if (ticksStan  == 135)
				{				
					Reg.state.mobBubble.visible = false;
					Reg.state.mobBubble.alive = false;
					Reg.state._defenseMobFireball1.visible = false;
					Reg.state._defenseMobFireball2.visible = false;
					Reg.state._defenseMobFireball3.visible = false;
					Reg.state._defenseMobFireball4.visible = false;	
					
					if (ID == 10)
					{
						Reg._playerCanShootAndMove = true;
						if (Reg._musicEnabled == true) FlxG.sound.playMusic("houseOutside", 0.80, false);
						kill(); // Stan at map 20-20 is not longer needed there. exit class.
					}					
				}	
				
			}
			
			//###################### END CHAT #####################
			
			super.update(elapsed);
		}
	}
	
}
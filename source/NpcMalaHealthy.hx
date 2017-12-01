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
		
		animation.add("idle", [1, 1, 1, 1, 1, 12], 10);
		animation.play("idle");
		
		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 16);
		
		// a green mala appears at house only if first boss was defeated.
		if (ID == 3 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1ADefeated == false) kill();
		if (ID == 2 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._playerFeelsWeak == true) kill();
	}
	
	override public function update(elapsed:Float):Void 
	{				
		if (isOnScreen())
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
			
			shovel(); //################### SHOVEL #####################	
			wateringCan(); //################### WATERING CAN #####################						 
			walking(); //###################### WALKING #######################				
			
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
						if (ID == 1 || ID == 2 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"C-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				else if (Reg._boss1ADefeated == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 2 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"B-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}				
				 
				else if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
				{
					if (ID == 1 || ID == 2)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"A-malaHealthy.txt").split("#");
										
						Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}
				}
			}
			
			//###################### END CHAT #####################
			
			super.update(elapsed);
		}
	}
	
}
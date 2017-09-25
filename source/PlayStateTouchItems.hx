package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author galoyo
 */
class PlayStateTouchItems
{
	//##########################################################
	// COLLIDE TOUCH ITEMS
	//##########################################################
	
	/**
	 * @author galoyo
	 * Most of the items that the player picks up are in this function.
	 */
	public static function itemPickedUp(item:FlxSprite, p:Player):Void 
	{
		// ############## ITEM KEY
		if (Std.is(item, ItemDoorKey))
		{
			var i:ItemDoorKey = cast(item, ItemDoorKey);
			
			if (Reg._itemGotKey[i.ID] == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
				i.kill();
				
				if (i.ID == 1)
				{
					Reg.dialogCharacterTalk[0] = "talkMobUnhealthy.png";
					Reg.dialogCharacterTalk[1] = "";
					Reg.dialogCharacterTalk[2] = ""; 
					Reg.dialogIconFilename = "itemDoorKey1.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemDoorKey1.txt").split("#");			
				}
				if (i.ID == 2)
				{
					Reg.dialogIconFilename = "itemDoorKey2.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemDoorKey2.txt").split("#");
					
				}
				
				if (i.ID == 3)
				{
					Reg.dialogIconFilename = "itemDoorKey3.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemDoorKey3.txt").split("#");
					
				}
				
				if (i.ID == 4)
				{
					Reg.dialogIconFilename = "itemDoorKey4.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemDoorKey4.txt").split("#");
					
				}
					
				Reg.dialogCharacterTalk[0] = "";
				// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());		
				
			}
			
			Reg._itemGotKey[i.ID] = true;
	
		}
		
		
		
		//############## ITEM JUMP
		if (Std.is(item, ItemJump))
		{
			var i:ItemJump = cast(item, ItemJump);
					
			if (Reg._itemGotJump[i.ID] == false)
			{
				if (i.ID == 1)
				{
					Reg.dialogIconFilename = "itemJump1.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemJump1.txt").split("#");
					
					Reg.dialogCharacterTalk[0] = "";
					
					// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());	
					
					Reg._itemGotJump[i.ID] = true;					
					newInventoryItem( openfl.Assets.getText("assets/text/touchItemJump1Description.txt"), Reg.dialogIconFilename);
					if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
					i.kill();
				}
			}	
		}
		
		//############## ITEM SWIMMING SKILL.
		if (Std.is(item, ItemSwimmingSkill))
		{
			var i:ItemSwimmingSkill = cast(item, ItemSwimmingSkill);
			
			if (Reg._itemGotSwimmingSkill == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
				i.kill();
				
				Reg.dialogIconFilename = "itemSwimmingSkill.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSwimmingSkill.txt").split("#");
			
				newInventoryItem( openfl.Assets.getText("assets/text/touchItemSwimmingSkillDescription.txt"), Reg.dialogIconFilename);
				Reg.dialogCharacterTalk[0] = "";
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());
				
				Reg._itemGotSwimmingSkill = true;
			}
		}
		
		//############### ITEM GUN RAPID FIRE
		if (Std.is(item, ItemGunRapidFire))
		{				
			var i:ItemGunRapidFire = cast(item, ItemGunRapidFire);
			
			if (Reg._itemGotGunRapidFire == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
				i.kill();
				
				Reg.dialogIconFilename = "itemGunRapidFire.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGunRapidFire.txt").split("#");
					
				Reg.dialogCharacterTalk[0] = "";
				
				// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());	
			}
			
			Reg._itemGotGunRapidFire = true;
		}
		
		
		//################ ITEM HEART CONTAINER
		if (Std.is(item, ItemHeartContainer))
		{				
			var i:ItemHeartContainer = cast(item, ItemHeartContainer);
			
		
			Reg._healthContainerCoords = Reg._healthContainerCoords + Reg.mapXcoords + "-" + Reg.mapYcoords + ",";
		
			Reg._healthMaximum = Reg._healthMaximum + 3;
			Reg.state.player.health = Reg._healthMaximum; 
			Reg._healthCurrent = Reg._healthMaximum;
			Reg.state.hud._healthHudBox.setRange(0, Reg._healthMaximum);
			
			i.kill();	
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
			Reg.dialogIconFilename = "itemHeartContainer.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemHeartContainer.txt").split("#");
					
			Reg.dialogCharacterTalk[0] = "";
			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
		}
		
		//################## ITEM FLYING HAT
		if (Std.is(item, ItemFlyingHat))
		{		
			var i:ItemFlyingHat = cast(item, ItemFlyingHat);
			
			Reg._itemGotFlyingHat = true;
			i.kill();	
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
			Reg.dialogIconFilename = "itemFlyingHat.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemFlyingHat.txt").split("#");
					
			newInventoryItem( openfl.Assets.getText("assets/text/touchItemFlyingHatDescription.txt"), Reg.dialogIconFilename);
			Reg.dialogCharacterTalk[0] = "";
			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
		}	
		
		//################## ITEM DIAMONDS.
		if (Std.is(item, ItemDiamond))
		{		
			var i:ItemDiamond = cast(item, ItemDiamond);
			
			// delete the diamond and plue one to the players diamond total.
			if (i.alive) {
				i.kill();
				Reg.diamondsRemaining--;
				Reg._score++;
				
				if (Reg._soundEnabled == true) FlxG.sound.play("click", 0.25, false);
			}
			
			if (Reg.diamondsRemaining == 0) 
			{
				Reg._diamondCoords = Reg._diamondCoords + Reg.mapXcoords + "-" + Reg.mapYcoords + ",";
				Reg.dialogIconFilename = "itemDiamond.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemDiamond.txt").split("#");
												
				Reg._healthMaximum += 1;
				
				Reg.dialogCharacterTalk[0] = "";
				// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());
				
			}
		
		}		
		
		//############## ITEM SUPER BLOCK
		if (Std.is(item, ItemSuperBlock))
		{		
			var i:ItemSuperBlock = cast(item, ItemSuperBlock);
		
			if (Reg._itemGotSuperBlock[i.ID] == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1 , false);
				i.kill();
				
				if (i.ID == 1)
				{
					Reg.dialogIconFilename = "itemSuperBlock1.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock1.txt").split("#");
				
				}
				if (i.ID == 2)
				{
					Reg.dialogIconFilename = "itemSuperBlock2.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock2.txt").split("#");
					
				}
				
				if (i.ID == 3)
				{
					Reg.dialogIconFilename = "itemSuperBlock3.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock3.txt").split("#");
					
				}
				
				if (i.ID == 4)
				{
					Reg.dialogIconFilename = "itemSuperBlock4.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock4.txt").split("#");
					
				}
				
				if (i.ID == 5)
				{
					Reg.dialogIconFilename = "itemSuperBlock5.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock5.txt").split("#");
					
				}
				
				if (i.ID == 6)
				{
					Reg.dialogIconFilename = "itemSuperBlock6.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock6.txt").split("#");
					
				}
				
				if (i.ID == 7)
				{
					Reg.dialogIconFilename = "itemSuperBlock7.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock7.txt").split("#");
					
				}
				
				if (i.ID == 8)
				{
					Reg.dialogIconFilename = "itemSuperBlock8.png";
					Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSuperBlock8.txt").split("#");
					
				}
					
				Reg.dialogCharacterTalk[0] = "";
				
				// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());		
				
				Reg._itemGotSuperBlock[i.ID] = true;
			}
		}
	
			//############## ITEM ANTIGRAVITY SUIT.
		if (Std.is(item, ItemAntigravitySuit))
		{
			var i:ItemAntigravitySuit = cast(item, ItemAntigravitySuit);
			
			if (Reg._itemGotAntigravitySuit == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
				i.kill();
				
				Reg.dialogIconFilename = "itemAntigravitySuit.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemAntigravity.txt").split("#");
			
				newInventoryItem( openfl.Assets.getText("assets/text/touchItemAntigravitySuitDescription.txt"), Reg.dialogIconFilename);
				Reg.dialogCharacterTalk[0] = "";
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());
				
				Reg._itemGotAntigravitySuit = true;
			}
		}

			//############## ITEM SKILL DASH.
		if (Std.is(item, ItemSkillDash))
		{
			var i:ItemSkillDash = cast(item, ItemSkillDash);
			
			if (Reg._itemGotSkillDash == false)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
				i.kill();
				
				Reg.dialogIconFilename = "itemSkillDash.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemSkillDash.txt").split("#");
			
				newInventoryItem( openfl.Assets.getText("assets/text/touchItemSkillDashDescription.txt"), Reg.dialogIconFilename);
				Reg.dialogCharacterTalk[0] = "";
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());
				
				Reg._itemGotSkillDash = true;
			}
		}
		
	}
	
	/**
	 * This function is called when the player picks up the flame gun. The flame gun is a weapon that hits the mob then continues on through its path.
	 */
	public static function touchItemGunFlame(item:FlxSprite, p:Player):Void 
	{
		if (Reg._itemGotGunFlame == false)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
			item.kill();
			
			Reg.dialogIconFilename = "itemGunFlame.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGunFlame.txt").split("#");
				
			newInventoryItem( openfl.Assets.getText("assets/text/touchItemGunFlameDescription.txt"), Reg.dialogIconFilename);
			Reg.dialogCharacterTalk[0] = "";
			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
			
			Reg._itemGotGunFlame = true;
		}			
		
		// particles of different colored squares for a gun.
		Reg.state._emitterBulletFlame.setPosition(Reg.playerXcoords, Reg.playerYcoords);
		Reg.state.add(Reg.state._emitterBulletFlame);
	}
			
	/**
	 * First gun in the game. normal basic pea shooter gun.
	 */
	public static function touchItemGun(item:FlxSprite, p:Player):Void 
	{
		
		if (Reg._itemGotGun == false)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
			item.kill();
			
			Reg.dialogIconFilename = "itemGun1.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGun.txt").split("#");				
			
			newInventoryItem( openfl.Assets.getText("assets/text/touchItemGunDescription.txt"), Reg.dialogIconFilename);
			Reg.dialogCharacterTalk[0] = "";
			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
			
			Reg._itemGotGun = true;
		}
			
		
	}
	
	
	/**
	 * This function handles the saving of the game.
	 */
	public static function touchSavePoint(item:FlxSprite, p:Player):Void 
	{
		if (Std.is(item, SavePoint))
		{
			var save:SavePoint = cast(item, SavePoint);
			save.saveGame();
			
			Reg.dialogIconText = openfl.Assets.getText("assets/text/gameSaved.txt").split("#");
			
			Reg.dialogCharacterTalk[0] = "";
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());
		}
	}	

	/**
	 * Freeze weapon. When a mob is hit with this weapon, the mob will be frozen for a few seconds. At that time, the player can jump on top of the head of the mob without taking damage. The player can use the mob as a ladder to jump up to the next frozen mob.
	 */
	public static function touchItemGunFreeze(item:FlxSprite, p:Player):Void 
	{
		
		if (Reg._itemGotGunFreeze == false)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("pickup", 1, false);
			item.kill();
			
			Reg.dialogIconFilename = "itemGun2.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGunFreeze.txt").split("#");
				
			newInventoryItem( openfl.Assets.getText("assets/text/touchItemGunFreezeDescription.txt"), Reg.dialogIconFilename);
			Reg.dialogCharacterTalk[0] = "";
			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
			
			Reg._itemGotGunFreeze = true;
		}			
	}

	// when player picks up an item that uses the x or c key, add it to the inventory.
	public static function newInventoryItem(iconName:String, iconFilemame:String):Void
	{	var titleAndDescriptionText = iconName.split("#");
		Reg._inventoryIconName[Reg._inventoryIconNumberMaximum] = titleAndDescriptionText[0];
		Reg._inventoryIconDescription[Reg._inventoryIconNumberMaximum] = titleAndDescriptionText[1];
		Reg._inventoryIconFilemame[Reg._inventoryIconNumberMaximum] = iconFilemame;
		Reg._inventoryIconNumberMaximum++;
	}
}
package;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateDownKey
{
	/**
	 * this function is checked if the down key is pressed or held. pressed down and player talks to npc or goes through doors. If held then tracker will scroll and then player can then look beyond the regions of the currently viewable map.
	 */
	public static function downKeyAndTracker():Void
	{
		//######################## DOWN KEY PRESS #######################
		var	_tileX = Std.int(Reg.state.player.x / 32);		
		var	_tileY = Std.int(Reg.state.player.y / 32);

		// save game is requested when down key is pressed at the save point.		
		if(InputControls.down.pressed && FlxG.overlap(Reg.state.savePoint, Reg.state.player))
		{
			Reg.dialogIconFilename = "savePoint.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/saveTheGame.txt").split("#");
			Reg.dialogCharacterTalk[0] = "";
			Reg.displayDialogYesNo = true;
			Reg.state.openSubState(new Dialog());
		}				
				
		else if(InputControls.down.pressed && FlxG.overlap(Reg.state._objectDoorToHouse, Reg.state.player))
		{
			if (Reg._inHouse == "")
			{
				Reg._inHouse = "-house";
				// remember the players last position on the map befor entering the house.
				Reg.playerXcoordsLast = Reg.state.player.x;
				Reg.playerYcoordsLast = Reg.state.player.y;
			}
			else Reg._inHouse = "";			
			
			Reg._dogOnMap = false;
			FlxG.switchState(new PlayState());
		} 

		else if (InputControls.down.pressed && Reg.state.tilemap.getTile(_tileX, _tileY) == 77
		      || InputControls.down.pressed && Reg.state.tilemap.getTile(_tileX, _tileY) == 78) // teleporter
		{
			Reg.dialogIconFilename = "itemGun1.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGun.txt").split("#");
				
			Reg.dialogCharacterTalk[0] = "";			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());	
		}				
		
		//----------------------- TRACKER ---------------------------
		// emitter the "question mark if there is no action.
		else if (InputControls.up.pressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == true && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player) && !FlxG.overlap(Reg.state.npcs, Reg.state.player) && !FlxG.overlap(Reg.state._objectTeleporter, Reg.state.player) && !FlxG.overlap(Reg.state._objectCar, Reg.state.player)
		      || InputControls.down.pressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == false && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player) && !FlxG.overlap(Reg.state.npcs, Reg.state.player) && !FlxG.overlap(Reg.state._objectTeleporter, Reg.state.player) && !FlxG.overlap(Reg.state._objectSign, Reg.state.player) && !FlxG.overlap(Reg.state._objectCar, Reg.state.player)) // for npcs overlapping, see an npcs class.
		{
			if (Reg.state._ticksTrackerDown == 1)
			{
				Reg.state._particleQuestionMark.focusOn(Reg.state.player);
				Reg.state._questionMark.start(0.15, onTimerQuestionMark, 1);
			}
			/*
			// player looking down. scroll the screen until the player is at the top of the screen.
			if (Reg._inHouse == "" && Reg.state._tracker.y - Reg.state.player.y < 224 && Reg.state._ticksTrackerDown > 25 && Reg.state.player.animation.name == "idle" || Reg._inHouse == "" && Reg.state._tracker.y - Reg.state.player.y < 192 && Reg.state._ticksTrackerDown > 25 && Reg.state.player.animation.name == "idle2") 
			{				
				Reg._trackerInUse = true;
				// move the tracker downward and set camera on it, so the screen scrolls up.
				Reg.state._tracker.velocity.y = 350;
				Reg.state._tracker.x = Reg.state.player.x;
				FlxG.camera.follow(Reg.state._tracker, FlxCameraFollowStyle.NO_DEAD_ZONE);
				
			}
			else Reg.state._tracker.velocity.y = 0; // stop scrolling the screen when player is at the top of the screen.
			*/
			
			Reg._arrowKeyInUseTicks = 0;
			Reg.state._ticksTrackerDown = Reg.incrementTicks(Reg.state._ticksTrackerDown, 60 / Reg._framerate);	
			
		}	

		/*
		else if (InputControls.down.pressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == true && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player) 
		      || InputControls.up.pressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == false && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player))
		{
			
			// player looking down. scroll the screen until the player is at the top of the screen.
			if (Reg._inHouse == "" && Reg.state.player.y - Reg.state._tracker.y < 254 && Reg.state._ticksTrackerUp > 25 && Reg.state.player.animation.name == "idle" || Reg._inHouse == "" &&  Reg.state.player.y - Reg.state._tracker.y < 254 && Reg.state._ticksTrackerUp > 25 && Reg.state.player.animation.name == "idle2" && Reg._usingFlyingHat == false) 
			{				
				Reg._trackerInUse = true;
				
				// move the tracker up and set camera on it, so the screen scrolls up.
				Reg.state._tracker.velocity.y = -350;
				Reg.state._tracker.x = Reg.state.player.x;
				FlxG.camera.follow(Reg.state._tracker, FlxCameraFollowStyle.NO_DEAD_ZONE);				
			}
			else Reg.state._tracker.velocity.y = 0; // stop scrolling the screen when player is at the top of the screen.
			
			Reg._arrowKeyInUseTicks = 0;
			Reg.state._ticksTrackerUp = Reg.incrementTicks(Reg.state._ticksTrackerUp, 60 / Reg._framerate); 			
		} */	
		else 
		{	// no down key is pressed so reset tracker back to the players location.
			Reg.state._ticksTrackerUp = 0;
			Reg.state._ticksTrackerDown = 0;			
			Reg.state._tracker.setPosition(Reg.state.player.x, Reg.state.player.y);	
			
			if(Reg._trackerInUse == true) Reg.state._questionMark.cancel();
			
			/*
			if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19)
			FlxG.camera.follow(Reg.state.player, FlxCameraFollowStyle.NO_DEAD_ZONE);	// make the camera follow the player.	
		else 
			FlxG.camera.follow(Reg.state.player, FlxCameraFollowStyle.SCREEN_BY_SCREEN); // make player walk to sides of screen.
			*/
		}
		
		//---------------------- END OF TRACKER -----------------------
		//###################### END OF DOWN KEY ######################
	}
	
	/**
	 * this down key is pressed and there is nothing to interact with then this function is called.
	 */
	private static function onTimerQuestionMark(_questionMark:FlxTimer):Void
	{	
		Reg.state._particleQuestionMark.start(true, 1, 1);
		if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
	}
}
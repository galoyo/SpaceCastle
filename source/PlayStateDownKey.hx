package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateDownKey extends PlayStateTouchItems
{
	/**
	 * this function is checked if the down key is pressed or held. pressed down and player talks to npc or goes through doors. If held then tracker will scroll and then player can then look beyond the regions of the currently viewable map.
	 */
	public function downKeyAndTracker():Void
	{
		//######################## DOWN KEY PRESS #######################
		var	_tileX = Std.int(player.x / 32);		
		var	_tileY = Std.int(player.y / 32);

		// save game is requested when down key is pressed at the save point.		
		if(FlxG.keys.anyPressed(["DOWN"]) && FlxG.overlap(savePoint, player) || Reg._mouseClickedButtonDown == true && FlxG.overlap(savePoint, player))
		{
			Reg.dialogIconFilename = "savePoint.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/saveTheGame.txt").split("#");
			Reg.dialogCharacterTalk[0] = "";
			Reg.displayDialogYesNo = true;
			openSubState(new Dialog());
		}				
				
		else if(FlxG.keys.anyPressed(["DOWN"]) && FlxG.overlap(_objectDoorToHouse, player) || Reg._mouseClickedButtonDown == true && FlxG.overlap(_objectDoorToHouse, player) )
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

		else if (FlxG.keys.anyPressed(["DOWN"]) && Reg.state.tilemap.getTile(_tileX, _tileY) == 77 || FlxG.keys.anyPressed(["DOWN"]) && Reg.state.tilemap.getTile(_tileX, _tileY) == 78
		|| Reg._mouseClickedButtonDown == true && Reg.state.tilemap.getTile(_tileX, _tileY) == 77 || Reg._mouseClickedButtonDown == true && Reg.state.tilemap.getTile(_tileX, _tileY) == 78) // teleporter
		{
			Reg.dialogIconFilename = "itemGun1.png";
			Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGun.txt").split("#");
				
			Reg.dialogCharacterTalk[0] = "";			
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			openSubState(new Dialog());	
		}				
		
		//----------------------- TRACKER ---------------------------
		// emitter the "question mark if there is no action but only when the player is standing on the ground.
		else if (!FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == true && FlxG.keys.anyPressed(["UP"]) && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) && !FlxG.overlap(npcs, player) && !FlxG.overlap(_objectTeleporter, player) || !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == false && FlxG.keys.anyPressed(["DOWN"]) && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) && !FlxG.overlap(npcs, player) && !FlxG.overlap(_objectTeleporter, player) && !FlxG.overlap(_objectSign, player)
		|| !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == true && Reg._mouseClickedButtonUp == true && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) && !FlxG.overlap(npcs, player) && !FlxG.overlap(_objectTeleporter, player) || !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == false && Reg._mouseClickedButtonDown == true && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) && !FlxG.overlap(npcs, player) && !FlxG.overlap(_objectTeleporter, player) && !FlxG.overlap(_objectSign, player)) // for npcs overlapping, see an npcs class.
		{
			if (_ticksTrackerDown == 1)
			{
				_emitterQuestionMark.focusOn(player);
				_questionMark.start(0.15, onTimerQuestionMark, 1);
			}
			
			// player looking down. scroll the screen until the player is at the top of the screen.
			if (Reg._inHouse == "" && _tracker.y - player.y < 224 && _ticksTrackerDown > 25 && player.animation.name == "idle" || Reg._inHouse == "" && _tracker.y - player.y < 192 && _ticksTrackerDown > 25 && player.animation.name == "idle2") 
			{				
				Reg._trackerInUse = true;
				// move the tracker downward and set camera on it, so the screen scrolls up.
				_tracker.velocity.y = 350;
				_tracker.x = player.x;
				FlxG.camera.follow(_tracker, FlxCameraFollowStyle.NO_DEAD_ZONE);
				
			}
			else _tracker.velocity.y = 0; // stop scrolling the screen when player is at the top of the screen.
			
			Reg._arrowKeyInUseTicks = 0;
			_ticksTrackerDown = Reg.incrementTicks(_ticksTrackerDown, 60 / Reg._framerate);			
		}	

		else if (!FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == true && FlxG.keys.anyPressed(["DOWN"]) && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) || !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == false && FlxG.keys.anyPressed(["UP"]) && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player)
		|| !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == true && Reg._mouseClickedButtonDown == true && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player) || !FlxG.overlap(_objectPlatformMoving, player) && Reg._antigravity == false && Reg._mouseClickedButtonUp == true && !FlxG.overlap(Reg.state._overlayPipe, player) && !FlxG.overlap(_objectLadders, player))
		{
			
			// player looking down. scroll the screen until the player is at the top of the screen.
			if (Reg._inHouse == "" && player.y - _tracker.y < 254 && _ticksTrackerUp > 25 && player.animation.name == "idle" || Reg._inHouse == "" &&  player.y - _tracker.y < 254 && _ticksTrackerUp > 25 && player.animation.name == "idle2" && Reg._usingFlyingHat == false) 
			{				
				Reg._trackerInUse = true;
				
				// move the tracker up and set camera on it, so the screen scrolls up.
				_tracker.velocity.y = -350;
				_tracker.x = player.x;
				FlxG.camera.follow(_tracker, FlxCameraFollowStyle.NO_DEAD_ZONE);				
			}
			else _tracker.velocity.y = 0; // stop scrolling the screen when player is at the top of the screen.
			
			Reg._arrowKeyInUseTicks = 0;
			_ticksTrackerUp = Reg.incrementTicks(_ticksTrackerUp, 60 / Reg._framerate); 			
		}	
		else 
		{	// no down key is pressed so reset tracker back to the players location.
			_ticksTrackerUp = 0;
			_ticksTrackerDown = 0;			
			_tracker.setPosition(player.x, player.y);	
			
			if(Reg._trackerInUse == true) _questionMark.cancel();
			
			FlxG.camera.follow(player, FlxCameraFollowStyle.SCREEN_BY_SCREEN);

		}
		//---------------------- END OF TRACKER -----------------------
		//###################### END OF DOWN KEY ######################
	}
	
	/**
	 * this down key is pressed and there is nothing to interact with then this function is called.
	 */
	private function onTimerQuestionMark(_questionMark:FlxTimer):Void
	{	
		_emitterQuestionMark.start(true, 1, 1);
		if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
	}
}
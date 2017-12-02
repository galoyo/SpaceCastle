package;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateDownKey
{
	/**
	 * this function is checked if the down key is pressed or held. pressed down and player talks to npc or goes through doors.
	 */
	public static function downKey():Void
	{
		//######################## DOWN KEY PRESS #######################
		var	_tileX = Std.int(Reg.state.player.x / 32);		
		var	_tileY = Std.int(Reg.state.player.y / 32);
		
		if (InputControls.down.justPressed && Reg._keyOrButtonDown == false)
		{			
			// save game is requested when down key is pressed at the save point.		
			if(FlxG.overlap(Reg.state.savePoint, Reg.state.player))
			{
				Reg.dialogIconFilename = "savePoint.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/saveTheGame.txt").split("#");
				Reg.dialogCharacterTalk[0] = "";
				Reg.displayDialogYesNo = true;
				Reg.state.openSubState(new Dialog());
			}				
					
			else if(FlxG.overlap(Reg.state._objectDoorToHouse, Reg.state.player))
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

			else if (Reg.state.tilemap.getTile(_tileX, _tileY) == 77
				  || Reg.state.tilemap.getTile(_tileX, _tileY) == 78) // teleporter
			{
				Reg.dialogIconFilename = "itemGun1.png";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/touchItemGun.txt").split("#");
					
				Reg.dialogCharacterTalk[0] = "";			
				// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());	
			}
	
			// emitter the "question mark if there is no action.
			else if (InputControls.up.justPressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == true && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player) && !FlxG.overlap(Reg.state.npcs, Reg.state.player) && !FlxG.overlap(Reg.state._objectTeleporter, Reg.state.player)
				  || InputControls.down.justPressed && !FlxG.overlap(Reg.state._objectPlatformMoving, Reg.state.player) && Reg._antigravity == false && !FlxG.overlap(Reg.state._overlayPipe, Reg.state.player) && !FlxG.overlap(Reg.state._objectLadders, Reg.state.player) && !FlxG.overlap(Reg.state.npcs, Reg.state.player) && !FlxG.overlap(Reg.state._objectTeleporter, Reg.state.player) && !FlxG.overlap(Reg.state._objectSign, Reg.state.player)
				  || InputControls.down.justPressed && Reg._antigravity == false && !FlxG.overlap(Reg.state._objectCar, Reg.state.player)) // for npcs overlapping, see an npcs class.
			{
				if (!Reg.state.player.justTouched(FlxObject.FLOOR) && Reg.state.player.isTouching(FlxObject.FLOOR))
				{
					Reg.state._particleQuestionMark.focusOn(Reg.state.player);
					Reg.state._questionMark.start(0.15, onTimerQuestionMark, 1);
				}
				
				Reg._guildlineInUseTicks = 0;						
			}					
		}
		
		if (InputControls.down.justReleased && Reg._keyOrButtonDown == true)
		{
			Reg._keyOrButtonDown = false;
		}
	
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
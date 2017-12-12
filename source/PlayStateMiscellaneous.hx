package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateMiscellaneous
{
	// this function is called from other classes.
	public static function gameOver(?t:FlxTimer):Void
	{
		FlxG.switchState(new GameOver());
	}
	
	public static function winState(?t:FlxTimer):Void
	{
		FlxG.switchState(new WinState());
	}
	
	/**
	 * Play adventure music.
	 */
	public static function playMusic():Void
	{
		// play random music.
		
		var _randomMusicNumber:Int = FlxG.random.int(1, 6); // random var for random music.

		if (Reg._musicEnabled == true)
		{
			if ( _randomMusicNumber == 1) 
			FlxG.sound.playMusic("1", 0.40, false);
			if ( _randomMusicNumber == 2) 
			FlxG.sound.playMusic("2", 0.40, false);
			if ( _randomMusicNumber == 3) 
			FlxG.sound.playMusic("3", 0.40, false);
			if ( _randomMusicNumber == 4) 
			FlxG.sound.playMusic("4", 0.40, false);
			if ( _randomMusicNumber == 5) 
			FlxG.sound.playMusic("5", 0.40, false);
			if ( _randomMusicNumber == 6) 
			FlxG.sound.playMusic("6", 0.40, false);
			
			FlxG.sound.music.persist = true;
		} 
		
	}
	
	/**
	 * leave the map and go to another map.
	 */
	public static function leaveMap(player:Player):Void
	{
		player.getCoords();
		Reg.beginningOfGame = false;
		
		// east door.
		if (Reg.playerXcoords > 13)
		{
			Reg.mapXcoords++; // used to change the map when player walks in a door.
		} 
				
		// north door.
		else if(Reg.playerYcoords < 7)
		{
			Reg.mapYcoords--;
		}
				
		// west door.
		else if(Reg.playerXcoords < 11)
		{
			Reg.mapXcoords--;
		}
				
		// south door.
		else if(Reg.playerYcoords > 9)
		{
			Reg.mapYcoords++;
		}

		Reg._dogOnMap = false;
		Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;

		FlxG.switchState(new PlayState());
	}
	
	/**
	 * The guideline above the player head refers to the higher area that a jump can accur. The middle guideline refer to minimum player damage if player falls to that line, while the last line refers to player death.
	 */	
	public static function guidelines():Void
	{
		// If the player jumped / falled to this line then the player would receive small health damage. The player's health decreases more in value the greater the player drops.
		Reg.state.warningFallLine = new FlxSprite(0, 0);
		Reg.state.warningFallLine.loadGraphic("assets/images/guideline.png", false);
		Reg.state.warningFallLine.visible = false;
		Reg.state.add(Reg.state.warningFallLine);
		
		// If the player jumped / falled to this line then the player would die.		
		Reg.state.deathFallLine = new FlxSprite(0, 0);
		Reg.state.deathFallLine.loadGraphic("assets/images/guideline.png", false);
		Reg.state.deathFallLine.visible = false;
		Reg.state.add(Reg.state.deathFallLine);
		
		// This line refers to a maximum height that the player is able to jump.
		Reg.state.maximumJumpLine = new FlxSprite(0, 0);
		Reg.state.maximumJumpLine.loadGraphic("assets/images/guideline.png", false);
		Reg.state.maximumJumpLine.visible = false;
		Reg.state.add(Reg.state.maximumJumpLine);

	}
}
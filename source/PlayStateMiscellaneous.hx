package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateMiscellaneous extends PlayStateChildClass
{
	// this function is called from other classes.
	public function gameOver(?t:FlxTimer):Void
	{
		FlxG.switchState(new GameOver());
	}
	
	public function winState(?t:FlxTimer):Void
	{
		FlxG.switchState(new WinState());
	}
	
	/**
	 * play a short music before playing the longer music.
	 */
	public function playMusicIntro():Void
	{
		if (Reg._inHouse == "")
		{
			var _randomMusicNumber:Int = FlxG.random.int(20, 24); // random var for random music.

			if (Reg._musicEnabled == true)
			{
				if (FlxG.sound.music.playing == false)
				{
					if ( _randomMusicNumber == 20) 
						FlxG.sound.playMusic("20", 0.40, false);
					if ( _randomMusicNumber == 21) 
						FlxG.sound.playMusic("21", 0.40, false);
					if ( _randomMusicNumber == 22) 
						FlxG.sound.playMusic("22", 0.40, false);
					if ( _randomMusicNumber == 23) 
						FlxG.sound.playMusic("23", 0.40, false);
					if ( _randomMusicNumber == 24) 
						FlxG.sound.playMusic("24", 0.40, false);
				}
				
				FlxG.sound.music.persist = true;
			}
		}
	}
	
	/**
	 * Play a long 1 minute+ music.
	 */
	public function playMusic():Void
	{
		// play random music.
		
		var _randomMusicNumber:Int = FlxG.random.int(1, 8); // random var for random music.

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
			if ( _randomMusicNumber == 7) 
			FlxG.sound.playMusic("7", 0.40, false);
			
			FlxG.sound.music.persist = true;
		} 
		
	}
	
	/**
	 * leave the map and go to another map.
	 */
	public function leaveMap(player:Player):Void
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
	public function guidelines():Void
	{
		// the player will receive small health damage one tile below this line.
		warningFallLine = new FlxSprite(0, 0);
		warningFallLine.loadGraphic("assets/images/guideline.png", false);
		warningFallLine.visible = false;
		add(warningFallLine);
		
		// lets the player know where the death fall line is. feet touching this line is instant death.		
		deathFallLine = new FlxSprite(0, 0);
		deathFallLine.loadGraphic("assets/images/guideline.png", false);
		deathFallLine.visible = false;
		add(deathFallLine);
		
		// this line refers to a maximum height that the player is able to jump.
		maximumJumpLine = new FlxSprite(0, 0);
		maximumJumpLine.loadGraphic("assets/images/guideline.png", false);
		maximumJumpLine.visible = false;
		add(maximumJumpLine);

	}
}
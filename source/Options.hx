package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class Options extends FlxSubState
{	
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var title:FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 1.
	 */
	private var options1 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 2
	 */
	private	var options2 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 3
	 */
	private	var options3 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 4
	 */
	private	var options4 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 5
	 */
	private	var options5 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 6
	 */
	private	var options6 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 7
	 */
	private	var options7 :FlxText;
	
	/*******************************************************************************************************
	 * The text for configuration option 8
	 */
	private	var options8 :FlxText;

	/*******************************************************************************************************
	 * Used to change preference for option 1
	 */
	private var button1:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 2
	 */
	private var button2:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 3
	 */
	private var button3:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 4
	 */
	private var button4:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 5
	 */
	private var button5:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 6
	 */
	private var button6:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 7
	 */
	private var button7:Button;
	
	/*******************************************************************************************************
	 * Used to change preference for option 8
	 */
	private var button8:Button;
	
	/*******************************************************************************************************
	 * Save the options buttom.
	 */
	private var button10:Button;
		
	/*******************************************************************************************************
	 * This is what we're going to save the options to.
	 */
	private var _gameOptions:FlxSave;
	
	public function new():Void
	{
		super();
		
		var background = new FlxSprite(0, 0, "assets/images/backgroundSubState2.jpg");
		background.scrollFactor.set(0, 0);	
		add(background);
		
		title = new FlxText(0, 50, 0, "Options");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.BLUE);
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		title.scrollFactor.set();
		title.screenCenter(X);
		add(title);		
		
		options1 = new FlxText(250, 127, 0, "Music [ON].");
		options1.color = FlxColor.BLACK;
		options1.font = Reg.defaultFont;
		options1.size = 14;
		options1.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options1.scrollFactor.set();
		if (Reg._musicEnabled == true) options1.text = "Music [ON].";
		else 
		{
			options1.text = "Music [OFF].";
			if(Reg._musicEnabled == true) FlxG.sound.music.stop();			
		}
		add(options1);
	
		options2 = new FlxText(250, 167, 0, "Background Sounds [OFF].");
		options2.color = FlxColor.BLACK;
		options2.font = Reg.defaultFont;
		options2.size = 14;
		options2.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options2.scrollFactor.set();
		if (Reg._backgroundSoundsEnabled == true) options2.text = "Background Sounds [ON].";
		else
		{
			options2.text = "Background Sounds [OFF].";
			if(Reg._musicEnabled == true) FlxG.sound.music.stop();
		}
		add(options2);
		
		options3 = new FlxText(250, 207, 0, "Sound Effects [ON].");
		options3.color = FlxColor.BLACK;
		options3.font = Reg.defaultFont;
		options3.size = 14;
		options3.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options3.scrollFactor.set();
		if (Reg._soundEnabled == true) options3.text = "Sound Effects [ON].";
		else
		{
			options3.text = "Sound Effects [OFF].";
		}		
		add(options3);
		
		options4 = new FlxText(250, 247, 0, "Fast dialog text [TRUE].");
		options4.color = FlxColor.BLACK;
		options4.font = Reg.defaultFont;
		options4.size = 14;
		options4.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options4.scrollFactor.set();
		if (Reg._dialogFastTextEnabled == true) options4.text = "Fast dialog text [TRUE].";
		else
		{
			options4.text = "Fast dialog text [FALSE].";
		}	
		add(options4);
		
		options5 = new FlxText(250, 287, 0, "Cheat Mode [ON].");
		options5.color = FlxColor.BLACK;
		options5.font = Reg.defaultFont;
		options5.size = 14;
		options5.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options5.scrollFactor.set();
		if (Reg._cheatModeEnabled == true) options5.text = "Cheat Mode [ON].";
		else
		{
			options5.text = "Cheat Mode [OFF].";
		}	
		add(options5);
		
		options6 = new FlxText(250, 327, 0, "Game Speed: Framerate " + Std.string(Reg._framerate));
		options6.color = FlxColor.BLACK;
		options6.font = Reg.defaultFont;
		options6.size = 14;
		options6.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options6.scrollFactor.set();
		add(options6);
		
		options7 = new FlxText(250, 367, 0, "Player Fall Damage [" + Std.string(Reg._playerFallDamage).toUpperCase() + "].");
		options7.color = FlxColor.BLACK;
		options7.font = Reg.defaultFont;
		options7.size = 14;
		options7.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options7.scrollFactor.set();
		add(options7);
		
		options8 = new FlxText(250, 407, 0, "");
		if (Reg._difficultyLevel == 1) options8.text = "Difficulty Level [EASY].";
		if (Reg._difficultyLevel == 2 || Reg._difficultyLevel == 0) options8.text = "Difficulty Level [NORMAL].";
		if (Reg._difficultyLevel == 3) options8.text = "Difficulty Level [HARD].";
		options8.color = FlxColor.BLACK;
		options8.font = Reg.defaultFont;
		options8.size = 14;
		options8.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		options8.scrollFactor.set();
		add(options8);
		
		button1 = new Button(170, 120, "1", 70, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);	
		button2 = new Button(170, 160, "2", 70, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);	
		button3 = new Button(170, 200, "3", 70, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);	
		button4 = new Button(170, 240, "4", 70, 35, null, 16, 0xFFCCFF33, 0, button4Clicked);	
		button5 = new Button(170, 280, "5", 70, 35, null, 16, 0xFFCCFF33, 0, button5Clicked);	
		button6 = new Button(170, 320, "6", 70, 35, null, 16, 0xFFCCFF33, 0, button6Clicked);	
		button7 = new Button(170, 360, "7", 70, 35, null, 16, 0xFFCCFF33, 0, button7Clicked);	
		button8 = new Button(170, 400, "8", 70, 35, null, 16, 0xFFCCFF33, 0, button8Clicked);	
		button10 = new Button(180, 510, "z: Back.", 160, 35, null, 16, 0xFFCCFF33, 0, button10Clicked);		
		button10.screenCenter(X);
		
		button1.label.font = Reg.defaultFont;
		button2.label.font = Reg.defaultFont;
		button3.label.font = Reg.defaultFont;
		button4.label.font = Reg.defaultFont;
		button5.label.font = Reg.defaultFont;
		button6.label.font = Reg.defaultFont;
		button7.label.font = Reg.defaultFont;
		button8.label.font = Reg.defaultFont;
		button10.label.font = Reg.defaultFont;
		
		add(button1);
		add(button2);
		add(button3);
		add(button4);
		add(button5);
		add(button6);
		add(button7);
		add(button8);
		add(button10);				
	}
	
	override public function update(elapsed:Float):Void 
	{				
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["ONE"])) 
			{
				button1Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["TWO"])) 
			{
				button2Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["THREE"])) 
			{
				button3Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["FOUR"])) // player is running.
			{
				button4Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["FIVE"])) // fast text dialog display.
			{
				button5Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["SIX"])) // game speed: framerate.
			{
				button6Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["SEVEN"])) // player fall damage.
			{
				button7Clicked();
			}

			else if (FlxG.keys.anyJustReleased(["EIGHT"])) // difficulty level.
			{
				button8Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["Z"])) button10Clicked();
		#end
		
		super.update(elapsed);
	}
	
	private function playTwinkle():Void
	{
		if (Reg._soundEnabled == true) 
		{
			FlxG.sound.playMusic("twinkle", 1, false);		
			FlxG.sound.music.persist = true;
		}
	}
	
	private function button1Clicked():Void
	{
		if (Reg._musicEnabled == true)
		{			
			options1.text = "Music [OFF].";
			Reg._musicEnabled = false;
			FlxG.sound.music.stop();
		}
		else
		{
			options1.text = "Music [ON].";
			Reg._musicEnabled = true;
			
			// can only play one music track so if this sound is enabled then diable the background sound.
			options2.text = "Background Sounds [OFF].";
			Reg._backgroundSoundsEnabled = false;
		}
		
		Reg.playTwinkle();
	}

	private function button2Clicked():Void
	{
		if (Reg._backgroundSoundsEnabled == true) 
		{
			options2.text = "Background Sounds [OFF].";
			Reg._backgroundSoundsEnabled = false;
			FlxG.sound.music.stop();
		}
		else
		{
			options2.text = "Background Sounds [ON].";
			Reg._backgroundSoundsEnabled = true;
			
			// can only be one music track played so if the background sound is enabled then diable the music.
			options1.text = "Music [OFF].";
			Reg._musicEnabled = false;
		}
		
		Reg.playTwinkle();
	}
	
	private function button3Clicked():Void
	{
		if (Reg._soundEnabled == true) 
		{
			
			options3.text = "Sound Effects [OFF].";
			Reg._soundEnabled = false;
		}
		else
		{
			
			options3.text = "Sound Effects [ON].";
			Reg._soundEnabled = true;
		}
		
		Reg.playTwinkle();
	}
	
	private function button4Clicked():Void
	{
		if (Reg._dialogFastTextEnabled == true) 
		{				
			options4.text = "Fast dialog text [FALSE].";
			Reg._dialogFastTextEnabled = false;
		}
		else
		{				
			options4.text = "Fast dialog text [TRUE].";
			Reg._dialogFastTextEnabled = true;
		}		
		
		Reg.playTwinkle();
	}
	
	private function button5Clicked():Void
	{
		if (Reg._cheatModeEnabled == true) 
		{
			
			options5.text = "Cheat Mode [OFF].";
			Reg._cheatModeEnabled = false;
		}
		else
		{
			
			options5.text = "Cheat Mode [ON].";
			Reg._cheatModeEnabled = true;
		}
		
		Reg.playTwinkle();
	}
	
	private function button6Clicked():Void
	{
		if (Reg._framerate == 60)
		{			
			FlxG.updateFramerate = 120;
			FlxG.drawFramerate = 120;	
			Reg._framerate = 120;		
		}
		
		else if (Reg._framerate == 120)
		{
			FlxG.updateFramerate = 180;
			FlxG.drawFramerate = 180;	
			Reg._framerate = 180;		
		}
		
		else if (Reg._framerate == 180)
		{			
			FlxG.updateFramerate = 240;
			FlxG.drawFramerate = 240;	
			Reg._framerate = 240;		
		}
		
		else if (Reg._framerate == 240)
		{						
			// notice these 3 lines are different then the above. they need to be that way or there is a warning in debug that a game framerate is smaller then a frame framerate, note that tje above lines need to be in that order to avoid a similar warning. 
			FlxG.drawFramerate = 60;
			FlxG.updateFramerate = 60;
			Reg._framerate = 60;			
		}
		
		options6.text = "Game Speed: Framerate " + Std.string(Reg._framerate);
		
		Reg.playTwinkle();
	}
	
	private function button7Clicked():Void
	{
		// does the player take fall damage if landing on the ground from a high up distance.
		if (Reg._playerFallDamage == true) Reg._playerFallDamage = false;			
		else if (Reg._playerFallDamage == false) Reg._playerFallDamage = true;			
		
		options7.text = "Player Fall Damage [" + Std.string(Reg._playerFallDamage).toUpperCase() + "].";
		
		Reg.playTwinkle();
	}
		
	private function button8Clicked():Void
	{
		Reg._difficultyLevel++;
		if (Reg._difficultyLevel == 4) Reg._difficultyLevel = 1;
		
		if (Reg._difficultyLevel == 1) options8.text = "Difficulty Level [EASY].";
		if (Reg._difficultyLevel == 2) options8.text = "Difficulty Level [NORMAL].";
		if (Reg._difficultyLevel == 3) options8.text = "Difficulty Level [HARD].";

		Reg.playTwinkle();
	}
	
	private function button10Clicked():Void
	{
		Reg.playTwinkle();
		new FlxTimer().start(0.15, delayChangeState,1);

	}
	
	private function delayChangeState(Timer:FlxTimer):Void
	{
		saveOptions();
	}
	
	public function saveOptions():Void
	{		
		if ( Reg._difficultyLevel == 0) Reg._difficultyLevel = 2;
		
		_gameOptions = new FlxSave(); // initialize
		_gameOptions.bind("TSC-SAVED-OPTIONS"); // bind to the named save slot.			
		
		_gameOptions.data._musicEnabled = Reg._musicEnabled;
		_gameOptions.data._soundEnabled = Reg._soundEnabled;
		_gameOptions.data._backgroundSoundsEnabled = Reg._backgroundSoundsEnabled;
		_gameOptions.data._dialogFastTextEnabled = Reg._dialogFastTextEnabled;
		_gameOptions.data._cheatModeEnabled = Reg._cheatModeEnabled;
		_gameOptions.data.framerate = Reg._framerate;
		_gameOptions.data._playerFallDamage = Reg._playerFallDamage;
		_gameOptions.data._difficultyLevel = Reg._difficultyLevel;
		
		// save options
		_gameOptions.flush();
		_gameOptions.close;
		
		Reg._stopDemoFromPlaying = false;
		FlxG.switchState(new MenuState());
		
	}
}
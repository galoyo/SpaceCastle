package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxMath;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import openfl.Assets;
import flixel.system.scaleModes.FillScaleMode;

/**
 * @author galoyo
 */

class MenuState extends FlxState
{
	/*******************************************************************************************************v
	 * New game.
	 */
	private var button1:Button;
	
	/*******************************************************************************************************
	 * Load game.
	 */
	private var button2:Button;
	
	/*******************************************************************************************************
	 * Go to game instructions.
	 */
	private var button3:Button;
	
	/*******************************************************************************************************
	 * Game configuration options.
	 */
	private var button4:Button;
	
	/*******************************************************************************************************
	 * Quit program.
	 */
	private var exitProgram:Button;
	
	/*******************************************************************************************************
	 * Toggles fullscreen mode off or on.
	 */
	private var toggleFullScreen:Button;
	
	/*******************************************************************************************************
	 * Change the scale mode. The scale mode changes the width and height of the program's window settings.
	 */
	private var scale:Button;
	
	/*******************************************************************************************************
	 * Saves the scale mode and the bool value of fullscreen.
	 */
	private var _gameMenu:FlxSave;
	
	/*******************************************************************************************************
	 * Used to stop the demo from playing when the user presses the scale button.
	 */
	private var _userPressedScaleButton:Bool = false;
	
	/*******************************************************************************************************
	 * Current text of the scale mode selected.
	 */
	private var scaleModeCurrentText:FlxText;
	
	/*******************************************************************************************************
	 * The scale modes. Changes the game's aspect ratio and/or size. Can maintain the aspect ratio of width and height and can windowbox the game if necessary.
	 */
	private var scaleModes:Array<ScaleMode> = [RATIO_DEFAULT, FIXED, RELATIVE, FILL];
	
	/*******************************************************************************************************
	 * This holds the value of the scale mode selected.
	 */
	private var scaleModeIndex:Int = 0;
	
	private var _test:Array<Array<Int>> = [[0, 2], [3, 4]];
	
	override public function create():Void
	{
		super.create();
		//FlxG.switchState(new PlayState());
		//FlxG.mouse.visible = false;
		
		// Get all text file names and then search that array to find the total maps in game.
		if (Reg._maps_X_Y_OutsideTotalAutomatic [0] == null) 
		{
			var textAssetsList = Assets.list(AssetType.TEXT);
			Reg.getTotalMaps(textAssetsList, "_Layer 0 tiles"); // To output the total maps use Reg._maps_X_Y_OutsideTotalAutomatic.length
		}
		
		//do not put fullscreen here. there is a bug. Flash will not embed in html page.
		//FlxG.fullscreen = true;

		FlxG.camera.antialiasing = true;				
	
		var background = new FlxSprite(); // Background image of universe stars.
		background.loadGraphic("assets/images/background2-1.jpg", true, 800, 600);
		background.scrollFactor.set();
		background.setPosition(0, 0);
		add(background);	
		
		var title = new FlxSprite(); // Title image.
		title.loadGraphic("assets/images/titleImage.png", false);
		title.scrollFactor.set();
		title.setPosition(0, 0);
		add(title);
		
		var titleOptionsBar = new FlxSprite(); // This image is displayed underneath the main buttons.
		titleOptionsBar.loadGraphic("assets/images/titleOptionsBar.png", false);
		titleOptionsBar.scrollFactor.set();
		titleOptionsBar.setPosition(0, 328);
		add(titleOptionsBar);
		
		var house = new FlxSprite(); // Image of the house.
		house.loadGraphic("assets/images/titleHouse.png", false);
		house.scrollFactor.set();
		house.setPosition(0, 380);
		add(house);
		
		if (Reg._musicEnabled == true) 
		{
			FlxG.sound.playMusic("titleScreen", 1, false);
		}
		
		#if !FLX_NO_KEYBOARD
			FlxG.keys.reset; // if key is pressed then do not yet count it as a key press. 
		#end
		
		_gameMenu = new FlxSave(); // initialize		
		_gameMenu.bind("TSC-MENU"); // bind to the named save slot.	
		
		if (_gameMenu.data.scaleModeIndex != null || _gameMenu.data.fullscreen != null)	loadMenu();
		
		button1 = 			new Button(110, 346, "1: New Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		button2 = 			new Button(110, 394, "2: Load Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);
		button3 = 			new Button(320, 346, "3: Instructions.", 160, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);
		button4 = 			new Button(320, 394, "4: Options.", 160, 35, null, 16, 0xFFCCFF33, 0, button4Clicked);
		toggleFullScreen = 	new Button(530, 346, "t: Fullscreen.", 160, 35, null, 16, 0xFFCCFF33, 0, toggleFullScreenClicked);
		if (FlxG.fullscreen == true) toggleFullScreen.text = "t: Window."; 
		exitProgram = 		new Button(530, 394, "e: Exit.", 160, 35, null, 16, 0xFFCCFF33, 0, Reg.exitProgram);
		scale = 			new Button(10, 280, "s: scale", 90, 35, null, 16, 0xFFCCFF33, 0, scaleClicked);
		
		add(button1);
		add(button2);
		add(button3);
		add(button4);		
		add(toggleFullScreen);
		add(exitProgram);
		add(scale);
		
		var info:FlxText = new FlxText(115, 290, FlxG.width, "Press S key to change the scale mode.");
		info.setFormat(null, 14, FlxColor.WHITE, LEFT);
		info.alpha = 0.75;
		info.scrollFactor.set(0, 0);	
		add(info);
		
		scaleModeCurrentText = new FlxText(452, 290, FlxG.width, ScaleMode.RATIO_DEFAULT);
		scaleModeCurrentText.alignment = LEFT;
		scaleModeCurrentText.size = 14;
		scaleModeCurrentText.scrollFactor.set(0, 0);	
		add(scaleModeCurrentText);		
		
		scaleModeLoad();		
		_userPressedScaleButton = false;
	}
	
	private function button1Clicked():Void
	{		
		_userPressedScaleButton = false;
		
		if (Reg._playRecordedDemo == false)
		{	
			Reg.playTwinkle();		
			loadPlayState();
		}
	}
	
	private function button2Clicked():Void
	{		
		_userPressedScaleButton = false;
		Reg._stopDemoFromPlaying = true;
		
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == true)
			FlxG.sound.music.stop();
		}
			
		openSubState(new GameLoad());	
		Reg.playTwinkle();		
	}	
	
	private function button3Clicked():Void
	{
		Reg._stopDemoFromPlaying = true;
		
		instructions();
	}
	
	
	private function button4Clicked():Void
	{
		Reg._stopDemoFromPlaying = true;
		
		openSubState(new Options());
		Reg.playTwinkle();
	}
	
	override public function update(elapsed:Float):Void
	{	
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["F12"])) 
			{
				Reg._stopDemoFromPlaying = true;
				toggleFullScreenClicked(); // toggles fullscreen mode.
			}
		
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
			
			else if (FlxG.keys.anyJustReleased(["FOUR"])) 
			{
				button4Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["E"])) 
			{
				Reg.exitProgram();
			}
			
			else if (FlxG.keys.anyJustReleased(["T"])) 
			{
				toggleFullScreenClicked();
			}
			
			else if (FlxG.keys.justPressed.S)
			{
				scaleClicked();
			}

			#end

		// if music has finished and user has not yet pressed 1 or 2 to play the game then prepare to play the recorded demo.
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == false && _userPressedScaleButton == false)
			{
				Reg._playRecordedDemo = true; 
				FlxG.switchState(new PlayState());
			}
		}
		
		super.update(elapsed);
	}
	
	private function setScaleMode(scaleMode:ScaleMode)
	{
		scaleModeCurrentText.text = scaleMode;
		
		FlxG.scaleMode = switch (scaleMode)
		{
			case ScaleMode.RATIO_DEFAULT:
				new RatioScaleMode();
				
			case ScaleMode.FIXED:
				new FixedScaleMode();
				
			case ScaleMode.RELATIVE:
				new RelativeScaleMode(0.75, 0.75);
				
			case ScaleMode.FILL:
				new FillScaleMode();
	
		}

	}
		
	private function instructions():Void
	{
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == true)
			FlxG.sound.music.stop();
		}
		
		Reg.playTwinkle();
		openSubState(new Instructions());	
	}
	
	private function loadPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}	
	
	private function toggleFullScreenClicked():Void
	{
		if (Reg._soundEnabled == true) FlxG.sound.play("twinkle", 1, false);
		
		if (toggleFullScreen.text == "t: Fullscreen.") 
		{
			toggleFullScreen.text = "t: Window.";
			FlxG.fullscreen = true;
		}
		else 
		{
			toggleFullScreen.text = "t: Fullscreen.";
			FlxG.fullscreen = false;
		}		
		
		saveMenu();
	}	
	
	public function scaleModeLoad():Void
	{
		scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
		setScaleMode(scaleModes[scaleModeIndex]);		
		
		_gameMenu.data.scaleModeIndex = scaleModeIndex - 1;
		
		// save data
		_gameMenu.flush();
		_gameMenu.close;		
		
	}
	
	public function scaleClicked():Void
	{
		scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
		setScaleMode(scaleModes[scaleModeIndex]);		
		
		_gameMenu.data.scaleModeIndex = scaleModeIndex - 1;
		
		// save data
		_gameMenu.flush();
		_gameMenu.close;		
		
		_userPressedScaleButton = true;
		
		if (Reg._soundEnabled == true)
		FlxG.sound.play("twinkle", 1, false);	
	}
	
	public function saveMenu():Void
	{
		_gameMenu.data.fullscreen = FlxG.fullscreen;

		// save data
		_gameMenu.flush();
		_gameMenu.close;
	}
	
	public function loadMenu():Void
	{
		scaleModeIndex = _gameMenu.data.scaleModeIndex;
		FlxG.fullscreen = _gameMenu.data.fullscreen;
		
		_gameMenu.close;
	}
	
}

@:enum
abstract ScaleMode(String) to String
{
	var RATIO_DEFAULT = "(Ratio)";
	var FIXED = "(Fixed)";
	var RELATIVE = "(Relative 75%)";
	var FILL = "(Fill)";
}
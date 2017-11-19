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
	// Here's the FlxSave variable this is what we're going to be saving to.
	private var title:FlxSprite;
	private var house:FlxSprite;
	private var _gameSave:FlxSave;
	private var once:Bool = false;
	private var background:FlxSprite;
	private var titleOptionsBar:FlxSprite;
	private var ticks:Int = 0;
	private var ticksSlide:Int;
	
	private var _gameMenu:FlxSave;
	
	private var _userPressedScaleButton:Bool = false; // used to stop the demo from playing when the user presses the scale button.
	
	private var button1:Button;
	private var button2:Button;
	private var button3:Button;
	private var button4:Button;
	private var exitProgram:Button;
	private var toggleFullScreen:Button;
	private var scale:Button;
	// the text when an item is picked up or a char is talking.
	public var dialog:Dialog;
	
	private var currentPolicy:FlxText;
	private var scaleModes:Array<ScaleMode> = [RATIO_DEFAULT, FIXED, RELATIVE, FILL];
	private var scaleModeIndex:Int = 0;
	
	override public function create():Void
	{
		super.create();
		//FlxG.switchState(new PlayState());
		//FlxG.mouse.visible = false;
		
		//do not put fullscreen here. there is a bug. Flash will not embed in html page.
		//FlxG.fullscreen = true;
		
		FlxG.camera.antialiasing = true;				
	
		background = new FlxSprite();
		background.loadGraphic("assets/images/background2-1.jpg", true, 800, 600);
		background.scrollFactor.set();
		background.setPosition(0, 0);
		add(background);	
		
		title = new FlxSprite();
		title.loadGraphic("assets/images/titleImage.png", false);
		title.scrollFactor.set();
		title.setPosition(0, 0);
		add(title);
		
		titleOptionsBar = new FlxSprite();
		titleOptionsBar.loadGraphic("assets/images/titleOptionsBar.png", false);
		titleOptionsBar.scrollFactor.set();
		titleOptionsBar.setPosition(0, 328);
		add(titleOptionsBar);
		
		house = new FlxSprite();
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
		
		_gameSave = new FlxSave(); // initialize
		_gameSave.bind("TSC-SAVED-GAME"); // bind to the named save slot.
		
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
		add(info);
		
		currentPolicy = new FlxText(460, 290, FlxG.width, ScaleMode.RATIO_DEFAULT);
		currentPolicy.alignment = LEFT;
		currentPolicy.size = 14;
		add(currentPolicy);
		
		scaleClicked();
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
			if (Reg._stopDemoFromPlaying == true && FlxG.sound.music.playing == false || Reg._stopDemoFromPlaying == false && FlxG.sound.music.playing == true)
			{
				if (FlxG.keys.anyJustReleased(["F12"])) 
				{
					Reg._stopDemoFromPlaying = true;
					FlxG.fullscreen = !FlxG.fullscreen; // toggles fullscreen mode.
				}
				
				else if (FlxG.keys.anyJustReleased(["ONE"])) 
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
		currentPolicy.text = scaleMode;
		
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
		FlxG.sound.play("twinkle", 1, false);
		
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
	
	public function scaleClicked():Void
	{
		scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
		setScaleMode(scaleModes[scaleModeIndex]);		
		
		_gameMenu.data.scaleModeIndex = scaleModeIndex - 1;
		
		// save data
		_gameMenu.flush();
		_gameMenu.close;
		
		_userPressedScaleButton = true;
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
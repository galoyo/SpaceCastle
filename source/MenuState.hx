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
	private var ticksDelay:Bool = false;
	private var ticksSlide:Int;
	
	private var _gameMenu:FlxSave;
	
	private var _userPressedScaleButton:Bool = false; // used to stop the demo from playing when the user presses the scale button.
	
	private var button1:MouseClickThisButton;
	private var button2:MouseClickThisButton;
	private var button3:MouseClickThisButton;
	private var button4:MouseClickThisButton;
	private var exitProgram:MouseClickThisButton;
	private var toggleFullScreen:MouseClickThisButton;
	private var scale:MouseClickThisButton;
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
		
		// smooth the image.
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
		
		if (Reg._musicEnabled == true) FlxG.sound.playMusic("titleScreen", 1, false);
		
				
		_gameMenu = new FlxSave(); // initialize		
		_gameMenu.bind("TSC-MENU"); // bind to the named save slot.	
		
		if (_gameMenu.data.scaleModeIndex != null || _gameMenu.data.fullscreen != null)	loadMenu();
		
		_gameSave = new FlxSave(); // initialize
		_gameSave.bind("TSC-SAVED-GAME"); // bind to the named save slot.
		
		button1 = 			new MouseClickThisButton(110, 346, "1: New Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		button2 = 			new MouseClickThisButton(110, 394, "2: Load Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);
		button3 = 			new MouseClickThisButton(320, 346, "3: Instructions.", 160, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);
		button4 = 			new MouseClickThisButton(320, 394, "4: Options.", 160, 35, null, 16, 0xFFCCFF33, 0, button4Clicked);
		toggleFullScreen = 	new MouseClickThisButton(530, 346, "t: Fullscreen.", 160, 35, null, 16, 0xFFCCFF33, 0, toggleFullScreenClicked);
		if (FlxG.fullscreen == true) toggleFullScreen.text = "t: Window."; 
		exitProgram = 		new MouseClickThisButton(530, 394, "e: Exit.", 160, 35, null, 16, 0xFFCCFF33, 0, Reg.exitProgram);
		scale = 			new MouseClickThisButton(10, 280, "s: scale", 90, 35, null, 16, 0xFFCCFF33, 0, scaleClicked);
		
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
		
		#if !FLX_NO_KEYBOARD
			FlxG.keys.reset; // if key is pressed then do not yet count it as a key press. 
			FlxG.mouse.reset;
		#end
	}
	
	private function button1Clicked():Void
	{		
		_userPressedScaleButton = false;
		
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == true)
			FlxG.sound.music.stop();
		}
		
		if (Reg._soundEnabled == true) 
		{
			FlxG.sound.playMusic("twinkle", 1, false); 
			FlxG.sound.music.persist = true;
		}
		
		loadPlayState();
	}
	
	private function button2Clicked():Void
	{				
		if (_gameSave.data._fallAllowedDistanceInPixels == null)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false); 
		} 
		else if (_gameSave.data._fallAllowedDistanceInPixels != null && Reg._soundEnabled == true) 
		{
			
			_userPressedScaleButton = false;
			loadGame();
		} 
		
		else { _userPressedScaleButton = false; loadGame(); }
	}
	
	private function button3Clicked():Void
	{
		Reg._ignoreIfMusicPlaying = true;

		instructions();	
	}
	
	
	private function button4Clicked():Void
	{
		Reg._ignoreIfMusicPlaying = true;

		openSubState(new Options());
	}
	
	override public function update(elapsed:Float):Void
	{	
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["F12"])) 
			{
				Reg._ignoreIfMusicPlaying = true;
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

			
			
			
			#end

		// if music has finished and user has not yet pressed 1 or 2 to play the game then prepare to play the recorded demo.
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == false && Reg._ignoreIfMusicPlaying == false && _userPressedScaleButton == false)
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
		
		openSubState(new Instructions());	
	}
	
	private function loadGame():Void
	{
		// player is at a save point.
		Reg.restoreGameState = true;
		Reg.beginningOfGame = false; 
		
		for (i in 0...4)
		{
			Reg._itemGotKey[i] = _gameSave.data._itemGotKey[i]; 
			Reg._itemGotJump[i] = _gameSave.data._itemGotJump[i];
		}
		
		for (i in 0...8)
		{
			Reg._itemGotSuperBlock[i] = _gameSave.data._itemGotSuperBlock[i]; 
		}
		
		for (i in 0...126)
		{
			Reg._inventoryIconZNumber[i] = _gameSave.data._inventoryIconZNumber[i];	
			Reg._inventoryIconXNumber[i] = _gameSave.data._inventoryIconXNumber[i];	
			Reg._inventoryIconCNumber[i] = _gameSave.data._inventoryIconCNumber[i];	
			Reg._inventoryIconName[i] = _gameSave.data._inventoryIconName[i];
			Reg._inventoryIconDescription[i] = _gameSave.data._inventoryIconDescription[i];
			Reg._inventoryIconFilemame[i] = _gameSave.data._inventoryIconFilemame[i];	
		}
		
		Reg._fallAllowedDistanceInPixels = _gameSave.data._fallAllowedDistanceInPixels;	
		Reg._jumpForce = _gameSave.data._jumpForce;
		Reg._gunPower = _gameSave.data._gunPower;
		Reg._gunHudBoxCollectedTriangles = _gameSave.data._gunHudBoxCollectedTriangles;
		Reg._typeOfGunCurrentlyUsed = _gameSave.data._typeOfGunCurrentlyUsed;
		
		Reg._itemGotGun = _gameSave.data._itemGotGun;
		Reg._itemGotGunFreeze = _gameSave.data._itemGotGunFreeze;
		Reg._itemGotGunFlame = _gameSave.data._itemGotGunFlame;
		Reg._itemGotGunRapidFire = _gameSave.data._itemGotGunRapidFire;
		Reg._healthMaximum = _gameSave.data._healthMaximum;
		Reg.mapXcoords = _gameSave.data.mapXcoords;
		Reg.mapYcoords = _gameSave.data.mapYcoords; 
		Reg.dogXcoords = _gameSave.data.dogXcoords;
		Reg.dogYcoords = _gameSave.data.dogYcoords; 
		Reg._healthContainerCoords = _gameSave.data._healthContainerCoords;
		Reg._dogCarriedItsID = _gameSave.data._dogCarriedItsID;
		Reg._dogCurrentlyCarried = _gameSave.data._dogCurrentlyCarried;
		Reg._dogCarried = _gameSave.data._dogCarried;		
		Reg._dogFoundAtMap = _gameSave.data._dogFoundAtMap;		
		Reg._dogNoLongerAtMap = _gameSave.data._dogNoLongerAtMap;		
		Reg.playerXcoords = _gameSave.data.playerXcoords;
		Reg.playerYcoords = _gameSave.data.playerYcoords;		
		Reg.playerXcoords = _gameSave.data.playerX;
		Reg.playerYcoords = _gameSave.data.playerY;
		Reg.facingDirectionRight = _gameSave.data.facing;
		Reg._itemGotFlyingHat = _gameSave.data._itemGotFlyingHat; 
		Reg._usingFlyingHat = _gameSave.data._usingFlyingHat;
		Reg._inHouse = _gameSave.data._inHouse;
		Reg._dogInHouse = _gameSave.data._dogInHouse;
		Reg.playerXcoordsLast = _gameSave.data.playerXcoordsLast;
		Reg.playerYcoordsLast = _gameSave.data.playerYcoordsLast;
		
		Reg._itemGotSwimmingSkill = _gameSave.data._itemGotSwimmingSkill;
		Reg._healthCurrent = _gameSave.data._healthCurrent;
		Reg._boss1ADefeated = _gameSave.data._boss1ADefeated;
		Reg._boss1BDefeated = _gameSave.data._boss1BDefeated;
		Reg._diamondCoords = _gameSave.data._diamondCoords;
		Reg._playerFeelsWeak = _gameSave.data._playerFeelsWeak;
		Reg._boss2Defeated = _gameSave.data._boss2Defeated;
		Reg._itemGotDogFlute = _gameSave.data._itemGotDogFlute; 
		Reg._talkToDoctorAt24_25Map = _gameSave.data._talkToDoctorAt24_25Map; 
		Reg._totalMalasTeleported = _gameSave.data._totalMalasTeleported; 
		Reg._score = _gameSave.data._score; 
		Reg._nuggets = _gameSave.data._nuggets; 
		Reg._inventoryGridXTotalSlots = _gameSave.data._inventoryGridXTotalSlots;
		Reg._inventoryGridYTotalSlots = _gameSave.data._inventoryGridYTotalSlots;
		Reg._itemZSelectedFromInventory = _gameSave.data._itemZSelectedFromInventory;
		Reg._itemXSelectedFromInventory = _gameSave.data._itemXSelectedFromInventory;
		Reg._itemCSelectedFromInventory = _gameSave.data._itemCSelectedFromInventory;

		Reg._inventoryIconNumberMaximum = _gameSave.data._inventoryIconNumberMaximum;
		Reg._itemZSelectedFromInventoryName = _gameSave.data._itemZSelectedFromInventoryName;
		Reg._itemXSelectedFromInventoryName = _gameSave.data._itemXSelectedFromInventoryName;
		Reg._itemCSelectedFromInventoryName = _gameSave.data._itemCSelectedFromInventoryName;
		Reg._itemGotAntigravitySuit = _gameSave.data._itemGotAntigravitySuit;		
		
		_gameSave.close;
		ticksDelay = true;
		
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == true)
			FlxG.sound.music.stop();
		}
		
		if (Reg._soundEnabled == true) 
		{
			FlxG.sound.playMusic("twinkle", 1, false); 
			FlxG.sound.music.persist = true;
		}

		FlxG.switchState(new PlayState());
	}

	private function loadPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}	
	
	private function toggleFullScreenClicked():Void
	{
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
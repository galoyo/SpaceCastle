package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
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
	
	private var button1:MouseClickThisButton;
	private var button2:MouseClickThisButton;
	private var button3:MouseClickThisButton;
	private var button4:MouseClickThisButton;
	
	// the text when an item is picked up or a char is talking.
	public var dialog:Dialog;
	
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
		titleOptionsBar.setPosition(0, 348);
		add(titleOptionsBar);
		
		house = new FlxSprite();
		house.loadGraphic("assets/images/titleHouse.png", false);
		house.scrollFactor.set();
		house.setPosition(0, 380);
		add(house);
		
		var newGame:FlxText;
		newGame = new FlxText(130, 170, 0, "");
		// set the properties of the font and then add the font to the screen.
		newGame.color = FlxColor.WHITE;
		newGame.size = 16;
		newGame.scrollFactor.set();
		newGame.alignment = FlxTextAlign.CENTER;
		add(newGame);
		
		var oldGame:FlxText;
		oldGame = new FlxText(130, 200, 0, "");
		// set the properties of the font and then add the font to the screen.
		oldGame.color = FlxColor.WHITE;
		oldGame.size = 16;
		oldGame.scrollFactor.set();
		oldGame.alignment = FlxTextAlign.CENTER;
		add(oldGame);
		
		var instructions:FlxText;
		instructions = new FlxText(460, 170, 0, "");
		// set the properties of the font and then add the font to the screen.
		instructions.color = FlxColor.WHITE;
		instructions.size = 16;
		instructions.scrollFactor.set();
		instructions.alignment = FlxTextAlign.CENTER;
		add(instructions);
		
		var options:FlxText;
		options = new FlxText(460, 200, 0, "");
		// set the properties of the font and then add the font to the screen.
		options.color = FlxColor.WHITE;
		options.size = 16;
		options.scrollFactor.set();
		options.alignment = FlxTextAlign.CENTER;
		add(options);
		
		var version:FlxText;
		version = new FlxText(600, 530, 0, "Version 0.6.0.0.");
		// set the properties of the font and then add the font to the screen.
		version.color = FlxColor.CYAN;
		version.size = 12;
		version.scrollFactor.set();
		version.alignment = FlxTextAlign.CENTER;
		version.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
		add(version);
		
		if(Reg._musicEnabled == true) FlxG.sound.playMusic("titleScreen", 1, false);
		
		FlxG.scaleMode = new FillScaleMode(); // no black bars at the sides of the game screen.
		
		_gameSave = new FlxSave(); // initialize
		_gameSave.bind("TSC-SAVED-GAME"); // bind to the named save slot.
		
		button1 = new MouseClickThisButton(180, 360, "1: New Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		button2 = new MouseClickThisButton(180, 400, "2: Load Game.", 160, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);
		button3 = new MouseClickThisButton(450, 360, "3: Instructions.", 160, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);
		button4 = new MouseClickThisButton(450, 400, "4: Options.", 160, 35, null, 16, 0xFFCCFF33, 0, button4Clicked);
		add(button1);
		add(button2);
		add(button3);
		add(button4);
	}
	
	private function button1Clicked():Void
	{		
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
			loadGame();
		} 
		
		else loadGame();
	}
	
	private function button3Clicked():Void
	{
		Reg._ignoreIfMusicPlaying = true;
		
		if (Reg._soundEnabled == true) FlxG.sound.play("twinkle", 1, false); 
		instructions();	
	}
	
	
	private function button4Clicked():Void
	{
		Reg._ignoreIfMusicPlaying = true;
		
		if (Reg._soundEnabled == true) FlxG.sound.play("twinkle", 1, false); 
		openSubState(new Options());
	}
	
	override public function update(elapsed:Float):Void
	{	
		if (FlxG.keys.anyJustReleased(["F12"])) 
		{
			Reg._ignoreIfMusicPlaying = true;
			FlxG.fullscreen = !FlxG.fullscreen; // toggles fullscreen mode.
		}
		
		else if (FlxG.keys.anyJustReleased(["F1"])) // display exit choices.
		{ 
			Reg.exitGameMenu = true;  
			Reg._F1KeyUsedFromMenuState = true;
			Reg._ignoreIfMusicPlaying = true;
			openSubState(new Dialog());			
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

		// if music has finished and user has not yet pressed 1 or 2 to play the game then prepare to play the recorded demo.
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == false && Reg._ignoreIfMusicPlaying == false)
			{
				Reg._playRecordedDemo = true; 
				FlxG.switchState(new PlayState());
			}
		}
		
		super.update(elapsed);
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
			Reg._itemGotKey[i] = _gameSave.data._itemGotKey[i]; 	// 4
			Reg._itemGotJump[i] = _gameSave.data._itemGotJump[i];	// 4
		}
		
		for (i in 0...8)
		{
			Reg._itemGotSuperBlock[i] = _gameSave.data._itemGotSuperBlock[i]; // 8
		}
		
		for (i in 0...126)
		{
			Reg._inventoryIconZNumber[i] = _gameSave.data._inventoryIconZNumber[i];	// 126
			Reg._inventoryIconXNumber[i] = _gameSave.data._inventoryIconXNumber[i];	// 126
			Reg._inventoryIconCNumber[i] = _gameSave.data._inventoryIconCNumber[i];	// 126
			Reg._inventoryIconName[i] = _gameSave.data._inventoryIconName[i];
			Reg._inventoryIconDescription[i] = _gameSave.data._inventoryIconDescription[i];// 126
			Reg._inventoryIconFilemame[i] = _gameSave.data._inventoryIconFilemame[i];	// 126
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
	


}
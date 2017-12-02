package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class GameSaveLoadParent extends FlxSubState
{	
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var screenBox:FlxSprite;
			
	/*******************************************************************************************************
	 * This is what we're going to save to.
	 */ 
	private var _gameSave:FlxSave;
	
	/*******************************************************************************************************
	 * This is what we're going to load the game from.
	 */ 
	private var _gameLoad:FlxSave;
	
	/*******************************************************************************************************
	 * Used to save the slot data.
	 */ 
	private var _gameSlotSave:FlxSave;
	
	/*******************************************************************************************************
	 * Used to display the slot data at the text boxes.
	 */ 
	private var _gameSlotLoad:Array<FlxSave> = [];
	
	/*******************************************************************************************************
	 * This soild box displayed underneath the save/load slot data.
	 */
	private var slotBox:FlxSprite;
	
	/*******************************************************************************************************
	 * Save to slot 1.
	 */
	private var button1:Button;
	
	/*******************************************************************************************************
	 * Save to slot 2.
	 */
	private var button2:Button;
	
	/*******************************************************************************************************
	 * Save to slot 3.
	 */
	private var button3:Button;
	
	/*******************************************************************************************************
	 * Save to slot 4.
	 */
	private var button4:Button;
	
	/*******************************************************************************************************
	 * Depending on a var used with this var, clicking this button's text of "Back" will cancel and close this subState. 
	 * This button's text will be changed to "OK" when a save game is made. Clicking the OK text will then confirm that a save was made.
	 */
	private var button10:Button;
	
	public function new():Void
	{
		super();
		
		// the background image of this subState.
		screenBox = new FlxSprite(0, 0);
		screenBox.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);		
		screenBox.setPosition(0, 0); 
		screenBox.scrollFactor.set(0, 0);
		add(screenBox);

		// Create the four slots of text boxes. Note that the fifth count ends before another loop, so only four loops will be performed. 
		for (i in 1...5) 
		{
			slotBox = new FlxSprite(0, 0);
			slotBox.makeGraphic(FlxG.width - 40, 55, 0xFF011f13);		
			slotBox.setPosition(20, 120 + (i * 70)); 
			slotBox.scrollFactor.set(0, 0);
			add(slotBox);
		}		
	
		// Create the four slot buttons. 1 button displayed overtop of 1 text box. Positioned at the left side of the screen. If Reg._gameSaveOrLoad has a value of 1 then clicking these buttons will save the game, else a value of 2 will load a game.
		button1 = new Button(60, 130 + (1 * 70), "1", 70, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);	
		button2 = new Button(60, 130 + (2 * 70), "2", 70, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);	
		button3 = new Button(60, 130 + (3 * 70), "3", 70, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);	
		button4 = new Button(60, 130 + (4 * 70), "4", 70, 35, null, 16, 0xFFCCFF33, 0, button4Clicked);
		add(button1);
		add(button2);
		add(button3);
		add(button4);
		
		// This button's text will be displayed for both save and load screens. However, only after a save slot has been clicked will this button's text be changed to "OK". After the user saves the game, all four slot buttons will be hidden and the text box where the save was made will be highlighted and then this button's text will be displayed as the text labled OK, giving the option for the user to verify the save made.
		button10 = new Button(180, 510, "z: Back.", 160, 35, null, 16, 0xFFCCFF33, 0, cancelSave);		
		button10.screenCenter(X);
		add(button10);
		
		//--------------------------------------------------- Header columns for the data rows.
		var slot = new FlxText(60, 145, 0, "Slot");
		slot.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
		slot.scrollFactor.set();
		add(slot);	
		
		var health = new FlxText(157, 145, 0, "Health");
		health.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
		health.scrollFactor.set();
		add(health);	
		
		var nuggets = new FlxText(279, 145, 0, "Nuggets");
		nuggets.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
		nuggets.scrollFactor.set();
		add(nuggets);	
		
		var map = new FlxText(421, 145, 0, "Map");
		map.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
		map.scrollFactor.set();
		add(map);
		
		var date = new FlxText(526, 145, 0, "Date");
		date.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
		date.scrollFactor.set();
		add(date);		
		//--------------------------------------------------- End of header columns
		
		// Go to the function four times. Each loop, load the data and display that data at that text box.
		for (i in 1...5) {gameSlotLoad(i);}
	}
	
	override public function update(elapsed:Float):Void 
	{				
		#if !FLX_NO_KEYBOARD  
			// Slots can also be accessed be pressing the 1 to 4 key on the keyboard.
		
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
			
			// The Z keyboard key is used to either load a game or cancel/confirm saving a game.
			else if (FlxG.keys.anyJustReleased(["Z"])) cancelSave();
		#end
		
		super.update(elapsed);
	}
	
	/*******************************************************************************************************
	 * Used to delay closing of this subState so that the clicking sound of a button can complete.
	 */
	private function delayChangeState(Timer:FlxTimer):Void
	{
		Reg._stopDemoFromPlaying = false;
		
		if (Reg._gameSaveOrLoad == 2) FlxG.switchState(new MenuState());
		
		close();
	}
	
	private function button1Clicked():Void
	{		
		if (Reg._gameSaveOrLoad == 1) gameSave(1);				
		if (Reg._gameSaveOrLoad == 2) gameLoad(1); 
	}
	
	private function button2Clicked():Void
	{		
		if (Reg._gameSaveOrLoad == 1) gameSave(2);
		if (Reg._gameSaveOrLoad == 2) gameLoad(2); 
	}
	
	private function button3Clicked():Void
	{
		if (Reg._gameSaveOrLoad == 1) gameSave(3);
		if (Reg._gameSaveOrLoad == 2) gameLoad(3); 			
	}
	
	private function button4Clicked():Void
	{
		if (Reg._gameSaveOrLoad == 1) gameSave(4);			
		if (Reg._gameSaveOrLoad == 2) gameLoad(4); 		
	}
	
	/*******************************************************************************************************
	 * Used to delay a subState close() so that a sound can finish playing.
	 */
	private function cancelSave():Void
	{
		Reg.playTwinkle();
		new FlxTimer().start(0.15, delayChangeState,1);
	}
	
	/*******************************************************************************************************
	 * There are four text boxes. Each text box displays the health, nuggets, etc of the player. Only save the data needed to display information at a text box. So if the second button was clicked then data for the second text box would be saved and that text box would have an ID of slot 2.
	 */
	public function gameSlotSave(slotID:Int):Void
	{			
		if (_gameSlotSave == null)
			_gameSlotSave = new FlxSave();
	
		_gameSlotSave.bind("TSC-SAVED-SLOT" + slotID);
		
		_gameSlotSave.data._score = Reg._score;
		_gameSlotSave.data._nuggets = Reg._nuggets;
		_gameSlotSave.data._healthMaximum = Reg._healthMaximum;
		_gameSlotSave.data._healthCurrent = Reg._healthCurrent;
		_gameSlotSave.data.mapXcoords = Reg.mapXcoords;
		_gameSlotSave.data.mapYcoords = Reg.mapYcoords;
		_gameSlotSave.data._dateAndTimeSaved = Date.now();
		
		_gameSlotSave.flush();
		_gameSlotSave.close;
	}
	
	public function gameSave(slotID:Int):Void
	{	
		gameSlotSave(slotID);
		
		if (_gameSave == null)
			_gameSave = new FlxSave();
	
		_gameSave.bind("TSC-SAVED-GAME" + slotID);
	
		// when saving arrays, the array first needs to ne newed then looped.
		_gameSave.data._itemGotKey = new Array<Bool>();
		_gameSave.data._itemGotJump = new Array<Bool>();

		for (i in 0...4)
		{
			_gameSave.data._itemGotKey[i] = Reg._itemGotKey[i];
			_gameSave.data._itemGotJump[i] = Reg._itemGotJump[i];	
		}
		
		_gameSave.data._itemGotSuperBlock = new Array<Bool>();
		
		for (i in 0...8)
		{
			_gameSave.data._itemGotSuperBlock[i] = Reg._itemGotSuperBlock[i];
		}

		_gameSave.data._inventoryIconZNumber = new Array<Bool>();
		_gameSave.data._inventoryIconXNumber = new Array<Bool>();
		_gameSave.data._inventoryIconCNumber = new Array<Bool>();
		_gameSave.data._inventoryIconName = new Array<String>();
		_gameSave.data._inventoryIconDescription = new Array<String>();
		_gameSave.data._inventoryIconFilemame = new Array<String>();

		for (i in 0...126)
		{
			_gameSave.data._inventoryIconZNumber[i] = Reg._inventoryIconZNumber[i];
			_gameSave.data._inventoryIconXNumber[i] = Reg._inventoryIconXNumber[i];
			_gameSave.data._inventoryIconCNumber[i] = Reg._inventoryIconCNumber[i];
			_gameSave.data._inventoryIconName[i] = Reg._inventoryIconName[i];
			_gameSave.data._inventoryIconDescription[i] = Reg._inventoryIconDescription[i];
			_gameSave.data._inventoryIconFilemame[i] = Reg._inventoryIconFilemame[i];
		}
		
		_gameSave.data._fallAllowedDistanceInPixels = Reg._fallAllowedDistanceInPixels;
		_gameSave.data._jumpForce = Reg._jumpForce;
		_gameSave.data._gunPower = Reg._gunPower;
		_gameSave.data._gunHudBoxCollectedTriangles = Reg._gunHudBoxCollectedTriangles;
		_gameSave.data._typeOfGunCurrentlyUsed = Reg._typeOfGunCurrentlyUsed;
		_gameSave.data._itemGotGun = Reg._itemGotGun;
		_gameSave.data._itemGotGunFreeze = Reg._itemGotGunFreeze;
		_gameSave.data._itemGotGunFlame = Reg._itemGotGunFlame;
		_gameSave.data._itemGotGunRapidFire = Reg._itemGotGunRapidFire;
		_gameSave.data._healthMaximum = Reg._healthMaximum;
		_gameSave.data.mapXcoords = Reg.mapXcoords;
		_gameSave.data.mapYcoords = Reg.mapYcoords;
		_gameSave.data.dogXcoords = Reg.dogXcoords;
		_gameSave.data.dogYcoords = Reg.dogYcoords;
		_gameSave.data._healthContainerCoords = Reg._healthContainerCoords;
		_gameSave.data._dogCarriedItsID = Reg._dogCarriedItsID; 
		_gameSave.data._dogCurrentlyCarried = Reg._dogCurrentlyCarried; 
		_gameSave.data._dogCarried = Reg._dogCarried; 
		_gameSave.data._dogFoundAtMap = Reg._dogFoundAtMap; 
		_gameSave.data.playerXcoords = Reg.playerXcoords;
		_gameSave.data.playerYcoords = Reg.playerYcoords;
		_gameSave.data.playerX = Reg.state.player.x;
		_gameSave.data.playerY = Reg.state.player.y;		
		_gameSave.data.facing = Reg.facingDirectionRight;
		_gameSave.data._itemGotFlyingHat = Reg._itemGotFlyingHat;
		_gameSave.data._usingFlyingHat = Reg._usingFlyingHat;
		_gameSave.data._inHouse = Reg._inHouse;
		_gameSave.data._dogInHouse = Reg._dogInHouse;
		_gameSave.data.playerXcoordsLast = Reg.playerXcoordsLast;
		_gameSave.data.playerYcoordsLast = Reg.playerYcoordsLast;
		
		_gameSave.data._itemGotSwimmingSkill = Reg._itemGotSwimmingSkill;
		_gameSave.data._healthCurrent = Reg._healthCurrent;
		_gameSave.data._boss1ADefeated = Reg._boss1ADefeated;
		_gameSave.data._boss1BDefeated = Reg._boss1BDefeated;
		_gameSave.data._diamondCoords = Reg._diamondCoords;
		_gameSave.data._playerFeelsWeak = Reg._playerFeelsWeak;
		_gameSave.data._boss2Defeated = Reg._boss2Defeated;
		_gameSave.data._itemGotDogFlute = Reg._itemGotDogFlute;
		_gameSave.data._talkToDoctorAt24_25Map = Reg._talkToDoctorAt24_25Map;
		_gameSave.data._totalMalasTeleported = Reg._totalMalasTeleported;
		_gameSave.data._score = Reg._score;
		_gameSave.data._nuggets = Reg._nuggets;
		_gameSave.data._inventoryGridXTotalSlots = Reg._inventoryGridXTotalSlots;
		_gameSave.data._inventoryGridYTotalSlots = Reg._inventoryGridYTotalSlots;
		_gameSave.data._itemZSelectedFromInventory	= Reg._itemZSelectedFromInventory;
		_gameSave.data._itemXSelectedFromInventory	= Reg._itemXSelectedFromInventory;
		_gameSave.data._itemCSelectedFromInventory = Reg._itemCSelectedFromInventory;

		_gameSave.data._inventoryIconNumberMaximum = Reg._inventoryIconNumberMaximum;
		_gameSave.data._itemZSelectedFromInventoryName = Reg._itemZSelectedFromInventoryName;
		_gameSave.data._itemXSelectedFromInventoryName = Reg._itemXSelectedFromInventoryName;
		_gameSave.data._itemCSelectedFromInventoryName = Reg._itemCSelectedFromInventoryName;
		_gameSave.data._itemGotAntigravitySuit = Reg._itemGotAntigravitySuit;		
		_gameSave.data._itemGotSkillDash = Reg._itemGotSkillDash;
		
		if (Reg.state.player.facing == FlxObject.LEFT)
			Reg.facingDirectionRight = false;
		else Reg.facingDirectionRight = true;
		_gameSave.data.facing = Reg.facingDirectionRight;

		_gameSave.data._dateAndTimeSaved = Date.now();
		
		_gameSave.data._mapsThatPlayerHasBeenToLength = Reg._mapsThatPlayerHasBeenTo.length;
					   
		_gameSave.data._mapsThatPlayerHasBeenTo = new Array<String>();
		for (i in 0...Reg._mapsThatPlayerHasBeenTo.length)
		{
			_gameSave.data._mapsThatPlayerHasBeenTo[i] = Reg._mapsThatPlayerHasBeenTo[i];
		}
		
		// save data
		_gameSave.flush();
		_gameSave.close;
		
		// The following in this function is used to highlight the text box that was saved and to set the cancel button as the OK button. When this subState is closed, if the button that has the text of "Back" now has the text of OK then the saved message will be displayed.
		Reg._gameSlotNumberSaved = slotID;
		
		button1.visible = false;
		button2.visible = false;
		button3.visible = false;
		button4.visible = false;
		button10.text = "Z: OK";
		
		// If slot 2 was clicked then all slot buttons are hidden. Place this different colored text box overtop of the second text box. Next, display the updated text overtop of this new text box. 
		var slotBox = new FlxSprite(0, 0);
		slotBox.makeGraphic(FlxG.width - 40, 55, 0xFF004400);		
		slotBox.setPosition(20, 120 + (slotID * 70)); 
		slotBox.scrollFactor.set(0, 0);
		add(slotBox);
			
		gameSlotLoad(slotID);		
		Reg.playTwinkle();
	}
	
	public function gameSlotLoad(slotID:Int):Void
	{		
		if (_gameSlotLoad[slotID] == null)
			_gameSlotLoad[slotID] = new FlxSave();
		
		_gameSlotLoad[slotID].bind("TSC-SAVED-SLOT" + slotID);
		
		if (_gameSlotLoad[slotID].data._score != null)
		{		
			var _score = _gameSlotLoad[slotID].data._score; 
			var _nuggets = _gameSlotLoad[slotID].data._nuggets; 
			var _healthMaximum = _gameSlotLoad[slotID].data._healthMaximum;
			var _healthCurrent = _gameSlotLoad[slotID].data._healthCurrent;
			var _mapXcoords = _gameSlotLoad[slotID].data.mapXcoords;
			var _mapYcoords = _gameSlotLoad[slotID].data.mapYcoords; 
			var _dateAndTimeSaved = _gameSlotLoad[slotID].data._dateAndTimeSaved;
			
			_gameSlotLoad[slotID].close;
			
			var health = new FlxText(157, 130 + (slotID * 70), 0, Std.int(_healthCurrent) + "/" + Std.int(_healthMaximum));
			health.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
			health.scrollFactor.set();
			add(health);
			
			var nuggets = new FlxText(279, 130 + (slotID * 70), 0, _nuggets);
			nuggets.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
			nuggets.scrollFactor.set();
			add(nuggets);

			var map = new FlxText(421, 130 + (slotID * 70), 0, _mapXcoords + "/" + _mapYcoords);
			map.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
			map.scrollFactor.set();
			add(map);

			var date = new FlxText(526, 130 + (slotID * 70), 0, _dateAndTimeSaved);
			date.setFormat("assets/fonts/trim.ttf", 20, FlxColor.WHITE);
			date.scrollFactor.set();
			add(date);			
			
		}
	}
	
	public function gameLoad(slotID:Int):Void
	{		
		if (_gameLoad == null)
			_gameLoad = new FlxSave();
	
		_gameLoad.bind("TSC-SAVED-GAME" + slotID);

		if (_gameLoad.data._fallAllowedDistanceInPixels == null)
		{			
			if (Reg._soundEnabled == true) 
			{
				FlxG.sound.play("buzz", 1, false);		
			}
		
			_gameLoad.close;
		
			FlxG.sound.music.persist = true;		
		}
		else
		{
			Reg.playTwinkle();
			
			// player is at a save point.
			Reg.restoreGameState = true;
			Reg.beginningOfGame = false; 
			
			for (i in 0...4)
			{
				Reg._itemGotKey[i] = _gameLoad.data._itemGotKey[i]; 
				Reg._itemGotJump[i] = _gameLoad.data._itemGotJump[i];
			}
			
			for (i in 0...8)
			{
				Reg._itemGotSuperBlock[i] = _gameLoad.data._itemGotSuperBlock[i]; 
			}
			
			for (i in 0...126)
			{
				Reg._inventoryIconZNumber[i] = _gameLoad.data._inventoryIconZNumber[i];	
				Reg._inventoryIconXNumber[i] = _gameLoad.data._inventoryIconXNumber[i];	
				Reg._inventoryIconCNumber[i] = _gameLoad.data._inventoryIconCNumber[i];	
				Reg._inventoryIconName[i] = _gameLoad.data._inventoryIconName[i];
				Reg._inventoryIconDescription[i] = _gameLoad.data._inventoryIconDescription[i];
				Reg._inventoryIconFilemame[i] = _gameLoad.data._inventoryIconFilemame[i];	
			}
			
			Reg._fallAllowedDistanceInPixels = _gameLoad.data._fallAllowedDistanceInPixels;	
			Reg._jumpForce = _gameLoad.data._jumpForce;
			Reg._gunPower = _gameLoad.data._gunPower;
			Reg._gunHudBoxCollectedTriangles = _gameLoad.data._gunHudBoxCollectedTriangles;
			Reg._typeOfGunCurrentlyUsed = _gameLoad.data._typeOfGunCurrentlyUsed;
			
			Reg._itemGotGun = _gameLoad.data._itemGotGun;
			Reg._itemGotGunFreeze = _gameLoad.data._itemGotGunFreeze;
			Reg._itemGotGunFlame = _gameLoad.data._itemGotGunFlame;
			Reg._itemGotGunRapidFire = _gameLoad.data._itemGotGunRapidFire;
			Reg._healthMaximum = _gameLoad.data._healthMaximum;
			Reg.mapXcoords = _gameLoad.data.mapXcoords;
			Reg.mapYcoords = _gameLoad.data.mapYcoords; 
			Reg.dogXcoords = _gameLoad.data.dogXcoords;
			Reg.dogYcoords = _gameLoad.data.dogYcoords; 
			Reg._healthContainerCoords = _gameLoad.data._healthContainerCoords;
			Reg._dogCarriedItsID = _gameLoad.data._dogCarriedItsID;
			Reg._dogCurrentlyCarried = _gameLoad.data._dogCurrentlyCarried;
			Reg._dogCarried = _gameLoad.data._dogCarried;		
			Reg._dogFoundAtMap = _gameLoad.data._dogFoundAtMap;		
			Reg.playerXcoords = _gameLoad.data.playerXcoords;
			Reg.playerYcoords = _gameLoad.data.playerYcoords;		
			Reg.playerXcoords = _gameLoad.data.playerX;
			Reg.playerYcoords = _gameLoad.data.playerY;

			Reg.facingDirectionRight = _gameLoad.data.facing;
			Reg._itemGotFlyingHat = _gameLoad.data._itemGotFlyingHat; 
			Reg._usingFlyingHat = _gameLoad.data._usingFlyingHat;
			Reg._inHouse = _gameLoad.data._inHouse;
			Reg._dogInHouse = _gameLoad.data._dogInHouse;
			Reg.playerXcoordsLast = _gameLoad.data.playerXcoordsLast;
			Reg.playerYcoordsLast = _gameLoad.data.playerYcoordsLast;
			
			Reg._itemGotSwimmingSkill = _gameLoad.data._itemGotSwimmingSkill;
			Reg._healthCurrent = _gameLoad.data._healthCurrent;
			Reg._boss1ADefeated = _gameLoad.data._boss1ADefeated;
			Reg._boss1BDefeated = _gameLoad.data._boss1BDefeated;
			Reg._diamondCoords = _gameLoad.data._diamondCoords;
			Reg._playerFeelsWeak = _gameLoad.data._playerFeelsWeak;
			Reg._boss2Defeated = _gameLoad.data._boss2Defeated;
			Reg._itemGotDogFlute = _gameLoad.data._itemGotDogFlute; 
			Reg._talkToDoctorAt24_25Map = _gameLoad.data._talkToDoctorAt24_25Map; 
			Reg._totalMalasTeleported = _gameLoad.data._totalMalasTeleported; 
			Reg._score = _gameLoad.data._score; 
			Reg._nuggets = _gameLoad.data._nuggets; 
			Reg._inventoryGridXTotalSlots = _gameLoad.data._inventoryGridXTotalSlots;
			Reg._inventoryGridYTotalSlots = _gameLoad.data._inventoryGridYTotalSlots;
			Reg._itemZSelectedFromInventory = _gameLoad.data._itemZSelectedFromInventory;
			Reg._itemXSelectedFromInventory = _gameLoad.data._itemXSelectedFromInventory;
			Reg._itemCSelectedFromInventory = _gameLoad.data._itemCSelectedFromInventory;

			Reg._inventoryIconNumberMaximum = _gameLoad.data._inventoryIconNumberMaximum;
			Reg._itemZSelectedFromInventoryName = _gameLoad.data._itemZSelectedFromInventoryName;
			Reg._itemXSelectedFromInventoryName = _gameLoad.data._itemXSelectedFromInventoryName;
			Reg._itemCSelectedFromInventoryName = _gameLoad.data._itemCSelectedFromInventoryName;
			Reg._itemGotAntigravitySuit = _gameLoad.data._itemGotAntigravitySuit;		
			Reg._itemGotSkillDash = _gameLoad.data._itemGotSkillDash;
			
			Reg._dateAndTimeSaved = _gameLoad.data._dateAndTimeSaved;
			
			var _mapsThatPlayerHasBeenToLength:Int = _gameLoad.data._mapsThatPlayerHasBeenToLength;

			for (i in 0..._mapsThatPlayerHasBeenToLength)
			{
				Reg._mapsThatPlayerHasBeenTo[i] = _gameLoad.data._mapsThatPlayerHasBeenTo[i];
			}
			
			_gameLoad.close;		
			
			FlxG.switchState(new PlayState());	
		}
	}	
	
}
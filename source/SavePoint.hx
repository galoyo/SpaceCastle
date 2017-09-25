package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSave;

/**
 * @author galoyo
 */

class SavePoint extends FlxSprite 
{
	// Here's the FlxSave variable this is what we're going to be saving to.
	private var _gameSave:FlxSave;	
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// my door is a 4 frame sprite sheet. make it how you want
		loadGraphic("assets/images/savePoint.png", true, Reg._tileSize, Reg._tileSize);
	
		animation.add("play", [0,2,4,6], 15, true);
		animation.play("play");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	public function saveGame():Void
	{		
		_gameSave = new FlxSave(); // initialize
		_gameSave.bind("TSC-SAVED-GAME"); // bind to the named save slot.	
		
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
		_gameSave.data._dogNoLongerAtMap = Reg._dogNoLongerAtMap;
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

		// save data
		_gameSave.flush();
		_gameSave.close;
		
	}
	
}
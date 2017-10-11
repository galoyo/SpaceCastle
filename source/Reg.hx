package;
import flixel.FlxG;
import flixel.math.FlxMath;

/**
 * @author galoyo
 */

//######################## NOTES ################################
// change _gunPower back to 1;
	
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko. to fix do this, var test:int = 0; the 0 initializes the variables.
//###############################################################

class Reg
{

	//########################################################################
	// these vars will NOT get saved by saving the game when playing the game.
	//########################################################################
	
	/**
	* if a map is within this var then the rain will be displayed on that map.
	*/
	public static var _displayRainCoords:String = "17-15,16-20,14-15,20-20,21-19,21-20,20-19,19-20,18-20,18-19,18-15,24-21,22-19,27-19";
	
	/**
	* if set to true then the Test-Items.map will be displayed. That map is used to test the game features. mapXcoords and mapYcoords vars do not need to be changed when setting this var to true.
	*/
	public static var _testItems:Bool = false; 
	
	/**
	* How many frames per second the game should update.
	*/
	public static var _framerate:Int = 120;
	
	/**
	 * Size of the bullet that objects and mobs use. Currently only two types of bullets are in use. 0 = large, and a value of 1 or 2 refers to a small bullet.
	 */
	public static var _bulletSize:Int = 0;
	
	/**
	 * used to determine if player is walking or using the car. See map 23-19.
	 */
	public static var _playerInsideCar:Bool = false;
	
	/**
	 * used to determine what direction the car is moving in. If true then the car is moving east, else moving west.
	 */
	public static var _carMovingEast:Bool = true;
	
	/**
	 * there are four cartoon backgrounds for the maps and four star backgrounds. When this var is set to 10, then for 0 to 10 times that the player goes to a map the playstate.hx will load a cartoon background, and at 11 to 20 times a map is load a star background will be displayed. 
	 */
	public static var _changeToDayOrNightBgsAtPageLoad:Int = 10; 	

	/**
	 * used in the castle waiting room for a player death countdown. if player has not left the castle within this time then its game over. See map-24-25.tmx at /assets/data/
	 */
	public static var _deathWhenReachedZeroCurrent:Int = 400; 
	public static var _deathWhenReachedZero:Int = 400;	// this vars value should be the same as above.
	
	/**
	 * mainly used to remember the last direction of the player in the pipe so that the player can continue in the pipe when the pipe extends two or more maps.
	 */
	public static var _lastArrowKeyPressed:String = "";
		
	//------------------
	// The following three vars should have the same values. 
	/**
	 * how much maximum air the player can have in lungs.
	 */
	public static var _playerAirLeftInLungsMaximum:Int = 100;
	/**
	 * how much current air the player has left in lungs.
	 */
	public static var _playerAirLeftInLungsCurrent:Int = 100;
	/**
	 * used with the air timer to display the air remaining text. value must be the same as the two values above.
	 */
	public static var _playerAirLeftInLungs:Int = 100;
	//------------------
	
	/**
	 * before a map is shown, a black screen is displayed in front of the map where the player is at. moving from the bottom-right corner to the top-left corner is small diamond shapes that appear. those diamond shape is part of the map where the player is at. this var nust be enabled to display the transition diamond effect for each map. 
	 */	
	public static var _transitionEffectEnable:Bool = true;

	/**
	 * how many ticks the mob frozen for. increase value to increase the length of time the mob stays frozen. 0 = 1.33 seconds. 40 = 2 seconds. 100 = 3 seconds. Do not use a negative value.
	 */		
	public static var _mobIsFrozenFor:Int = 0;

	//------------------------
	/**
	 * how fast the player moves within the pipes horizontally.
	 */
	public static var _pipeVelocityX:Float = 1200;
	/**
	 * how fast the player moves within the pipes vertically.
	 */	
	public static var _pipeVelocityY:Float = 1200;
	//------------------------
	
	/**
	 * The tick amount to delay the disappearing block from displaying on screen. delay in ticks. 60 = 1 second. 40 ticks is added on to this value.
	 */
	public static var _blockDisappearingDelay:Float = 10;

	// // This var is used to delay a respawn. wait until the timer is finished then set the mob at the top left corner of screen and hide it to prepare it for a respawn. this is the seconds used to set mobs x and y coords to 0 and then set the mob as not visable.	
	public static var _mobsDelayAfterDeath = 1;
	
	//------------------------
	//The following two gunhud values must be the same.
	/**
	 * triangles collected increases gun power but cannot go beyond this value.
	 */
	public static var _gunHudBoxMaximumTriangles:Float = 10;
	/**
	 * How many triangles need to be collected before the next powerup occurs.
	 */
	public static var _gunHudBoxCollectedTrianglesIncreaseBy:Int = 10;
	//------------------------

	
	
	// seconds the mob flickers when hit.
	public static var _mobHitFlicker:Float = 0.4;
	
	// When the mob respawned, this is the amount of time that the mob cannot be hit by the player.
	public static var _mobResetFlicker:Float = 0.4;
	
	public static var _spawnTime:Float = 1.2;
	
	public static var _tileSize:Int = 32;
	
	// this is the speed the mon rotates at death.
	public static var _angleDefault:Float = 10;
	
	public static var _mobDropItemDelay:Float = 0.07;
	
	// used to position the player on the map. if true then the player will be displayed at the save point.
	public static var restoreGameState:Bool = false;
	
	public static var displayDialogYesNo:Bool = false;
	
	public static var facingDirectionRight:Bool = true;
	
	public static var _dialogAnsweredYes:Bool = false;
	public static var _dialogYesNoWasAnswered:Bool = false;
	
	// random value used for the speed of the fireball sprites.
	public static var fireballRandom:Float = 0.10;
	
	// the amount of delay when a mob is moving in the water. this value divides the velocity.
	public static var _swimmingDelay:Float = 1.60;
	
	// speed the invisible chaser is moving.
	public static var _chaserVelocity:Float = 130;
	
	public static var _playersYLastOnTile:Float = 0;

	public static var _playerYNewFallTotal:Float = 0; 
	
	public static var _trackerInUse:Bool = false; // player can look beyond the players currently view region.
	public static var _arrowKeyInUseTicks:Float = 0; // show the guildlines if ticks are high in value.
	
	// display the quit to system / quit to main menu / resume text.
	public static var exitGameMenu:Bool = false;
	
	//------------------------
	// the speed of a vine depends on a random value of minimum and maximum values set at playState. to be used at the objectVineMoving class.
	public static var _vineMovingSpeed:Float = 0;
	public static var _vineMovingMinimumSpeed:Float = 0.40; // used in a random value at playState.
	public static var _vineMovingMaximumSpeed:Float = 0.50;
	public static var _vineToggleMovementSpeed:Bool = false; // every second vine moves faster.
	//------------------------
	
	public static var _antigravity:Bool = false;
	public static var _boss1AIsMala:Bool = true;
	public static var _boss1BIsMala:Bool = true;
	public static var _boss2IsMala:Bool = true; // bumping into this mob when var is true will not cause any player damage.
	
	public static var _playerHasTalkedToThisMob:Bool = false; //used to determine when talk has ended. 	
	
	public static var _playerCanShoot:Bool = true;
	public static var _playerCanShootOrMove:Bool = true;
	
	public static var _teleportedToHouse:Bool = false; // did the player used the teleporter?
	
	public static var _distanceBetweenMaximum:Int = 832; // the maximum value in pixels that a mob can be from the player before the mob is re-spawned, eg, reset().
	
	public static var _talkedToDoctorAtDogLady:Bool = false; // used to move the player to the waiting room.
	
	public static var ticksDoctor:Float = 0; // used to delay the siren sound and screen shake effect and to display a help message from the doctor.
	public static var ticksTeleport:Float = 0;
	
	public static var _numberOfMalasToSave:Int = FlxG.random.int(3, 6);
	
	// dogs need to exist at every map or else when a dog is carried by player from one map to the next, the dog will not be overtop of the player. The reason is because there is not dog sprite on the map. This var is used at the the end of "playState.hx finction create" to check if the dog exists. if no dog exist then a dog will be created at 0-0 map coords and this var will be set to true.
	public static var _dogExistsAtMap:Array<Bool> = [
	false, false, false, false
	];
	
	// when a dog does not exist at a map then the above var needs to be true by setting the sprites at the top left corner. The problem is that the second id of the dog will make the dog run back and forth. this var stops.
	public static var _dogStopMoving:Bool = false;
	
	// if dog is invisible then the flute should play a buzz sound.
	public static var _dogIsVisible:Bool = true;
	public static var _dogIsInPipe:Bool = false; // this var is used to hide the dog in the pipes.
	
	public static var _musicEnabled:Bool = true;
	public static var _soundEnabled:Bool = true;
	public static var _backgroundSounds:Bool = false;
	public static var _cheatModeEnabled:Bool = false; // is the cheat mode on. unlimited health, bullets ect.
	public static var _playerRunningEnabled = true;
	public static var _dialogFastTextEnabled = true; // do not change this. player must always be running so that some jumps will be difficult to do.
	
	public static var _buttonsNavigationUpdate:Bool = false; // used to update X and C buttons at playstate.hx once only when inventory menu is closed.
	
	//##################################################################
	//############## These vars value must NOT be changed. #############
	//##################################################################
	
	/**
	* DO NOT change the value of this var. It is used to determine if a substate should be displayed or if a demo should be played. Removing this var from all code will result in the demo playing when a substate at main menu is displayed.
	*/
	public static var _ignoreIfMusicPlaying:Bool = false;
	
	/**
	 * Do NOT change the value of this var. Used to stop a particular music from playing. This "dream" music is played only at the parallax car scene. This var makes that happen.
	 */
	public static var _stopDreamsMusic:Bool = false;
	
	/**
	 * Do NOT change the value of this var. each time playstate.hx is loaded this var is increased. when it reaches the value of Reg._changeToDayOrNightBgsAtPageLoad then the background image will change from cartoon to stars and then back again.
	 */
	public static var _changeToDayOrNightBgsAtPageLoadTicks:Int = 0;
	
	/**
	 * Do NOT change the value of this var. Player is in water and the player's air is decreasing. This var is used to remember that state.
	 */
	public static var _playerAirIsDecreasing:Bool = true;
	
	/**
	 * Do NOT change the value of this var. When player picks up a star powerup, player will not take damage from mobs but will still take damage when fallimg from a great distance. This var is used to take health away but only once per fall.
	 */
	public static var _isFallDamage:Bool = false;
	
	/**
	 * Do NOT change the value of this var. used to stop the player's flicker. if true then the player's flicker will stop when the powerup music stops playing.
	 */
	public static var _powerUpStopFlicker:Bool = false;	
		
	/**
	 * Do NOT change the value of this var. When set to false this var can be used to stop a function or code block from updating. see Hud.hx for an example about how it is used in a function. without this var at Hud.hx, when playomg the game, the Map coords at the top right corner will display the next map value just before loading that map. An undesired result.
	 */
	public static var _update:Bool = true;
	
	/**
	 * Do NOT change the value of this var. Without this var, the player jumps down instead of walking down the tiled slope. This high value stops that from happening. Instead the player will seem to walk down the slope because of a high gravity.
	 */
	public static var _gravityOnSlopes:Int = 100000;
	
	/**
	 * Do NOT change the value of this var. When value is true at playState.hx, this var is used to disable the transition effect when the recorded demo is playing. recorded demos will be broken when played more than once if the transition effect is allowed to plays with the demos. at menuState, a demo will be played when the introduction music ends.
	 */
	public static var _noTransitionEffectDemoPlaying = false;
		
	/**
	 * Do NOT change the value of this var. this var holds the parent state. If a class is public at playState.hx then it can be accessed at playState.hx using the code "Reg.state." then select the public class from the popup box.
	 */
	public static var state:PlayState;	
	
	/**
	 * Do NOT change the value of this var. the value of this var will be true then player us standing on a frozon mob. The mob can be frozen with the freeze gun.
	 */
	public static var _playerGravitySetToZero:Bool = false;
	
	/**
	 * Do NOT change the value of this var. the number of total diamonds at a map. This var is initialized for neko builds. The value is determined at playStateAdd.hx.
	 */ 
	public static var diamondsRemaining:Int = 0;
		
	/**
	 * Do NOT change the value of this var. This var will be true if user has not pressed a key/button before music stops at menuState. the recorded demo will play when the introduction music stops at MenuState.hx.
	 */
	public static var _playRecordedDemo:Bool = false;
	
	//---------------------
	/**
	 * Do NOT change the value of this var. The message displayed after player picks up an item or when talking to an NPC.
	 */
	public static var dialogIconText:Array<String>;
	/**
	 * Do NOT change the value of this var. This is the image filename of the item that the player picked up. The image is displayed at the dialog.
	 */
	public static var dialogIconFilename:String = "";
	
	/**
	 * Do NOT change the value of this var. This is the image filename of a NPC or player currently talking at the Dialog.hx. The image is displayed at the dialog. search for "boss1B-ID1-Map12-19C.txt" at Boss1.hx for an example about how to use this var.
	 */
	public static var dialogCharacterTalk:Array<String> = [
	"", "", ""
	];
	//---------------------
	
	/**
	 * Do NOT change the value of this var. This var will be true when the maximum amount of triangles are collected. The word "Maximum" at the gun hudBox will then be seen.
	 */
	public static var _gunHudBoxDisplayMaximumText:Bool = false;
	
	/**
	 * Do NOT change the value of this var. Triangle collected increase gun power when the maximum amount of triangles collected for that power-up level is reached. The collected triangles decrease when player is hit. this var is used to load a new bullet image when gun power increases or decreases in level.
	 */
	public static var _gunPowerIncreasedOrDecreased:Bool = false;
	
	//##################################################################
	//########## vars that WILL be saved when game is saved ############
	//##################################################################
	// NOTE: these vars MUST also be in the resetRegVars function at this
	// class so they can be reset to there default value when a new game
	// is selected.	
	
	public static var _nuggets:Int = 0;
	
	public static var _playerFallDamage:Bool = true; // If true then the player well take fall damage when falling to the ground beyond the tile fall limit.
	
	public static var _differcuityLevel:Int = 2; // how easy will the mobs be to defeat. 1:easy, 2:normal, 3:hard
	
	public static var _boss1ADefeated:Bool = false;
	public static var _boss1BDefeated:Bool = false;
	public static var _boss2Defeated:Bool = false;
	
	// Remember to change these values also near the top of this constructor. used to change the map when player walks in a door. in map units.
	public static var mapXcoords:Float = 20; // should be 20.
	public static var mapYcoords:Float = 20; // should be 20. 20-20 is the start map of the game.
	public static var dogXcoords:Float = 0; // used to remember where the dog was picked up.
	public static var dogYcoords:Float = 0;
	
	public static var _score:Int = 0;
	public static var _talkToDoctorAt24_25Map:Bool = false; // used to display the talked to mala countdown.
	public static var _totalMalasTeleported:Int = 0; 
		
	// When all the malas are talked to at 24-25map, the barricate will be removed.
	public static var _talkedToMalaAtWaitingRoom:Array<Bool> = [
	false, false, false, false, false, false, false, false
	];
	
	// _gunPower determines if its a double or single bullet, ect. Bullet power increases the higher this value is. values are 1, 2 or 3.
	public static var _gunPower:Float = 1;
	
	// once _gunPowerCollected reaches _gunPowerMaximum, the gunBox power value will increase by one.
	public static var _gunHudBoxCollectedTriangles:Float = 0;	
	
	// normal gun has a value of 0. flame gun has a value of 1, ect.
	public static var _typeOfGunCurrentlyUsed:Int = 0;
	
	// at the start of game, player can stand anywhere at the beginning  of the game. after entering another level, the player stands near a door.
	public static var beginningOfGame:Bool = true;
	
	// currently set for a total of 4 different keys. this var refers to a key that was picked up.
	public static var _itemGotKey:Array<Bool> = [
	false, false, false, false
	];
	
	// different jump items. array 1 is a low jump while 4 is a higher jump ability. currenly only 4 jump upgrades are available.
	public static var _itemGotJump:Array<Bool> = [
	false, false, false, false
	];
	
	// different guns, like normal gun, flame, ice, ect. the first var is normal, then flame. if ture that the item will not be displayed for the player to pickup when player goes back to that map.
	public static var _itemGotGun:Bool = false;	
	public static var _itemGotGunFreeze:Bool = false;
	public static var _itemGotGunFlame:Bool = false;
	
	public static var _itemGotGunRapidFire:Bool = false;
	
	// hearts collected increases health but cannot go beyond the total health of this var.
	public static var _healthMaximum:Float = 5;
	public static var _healthCurrent:Float = 5; // health is not reset going to a different level.
	
	// used to determine if a heart container should be displayed on the map or was picked up.
	public static var _healthContainerCoords:String = "";
	
	// used to determine if diamonds should be displayed on the map or if they were picked up.
	public static var _diamondCoords:String = "";
	
	// position of the player in the x and y coords system.
	public static var playerXcoords:Float = 0;
	public static var playerYcoords:Float = 0;
	
	public static var _fallAllowedDistanceInPixels = 64; // go to function touchItemJump at playState for more values.
	public static var _jumpForce:Int = 680;
	
	public static var _itemGotFlyingHat:Bool = false;
	
	public static var _usingFlyingHat:Bool = false; // refers to an item currently in use. 1 = flying hat.
	
	public static var _inHouse:String = ""; // values are "house" and "". when value is house, the house map will be displayed.
	public static var _dogInHouse:String = ""; // // used to remember where the dog was picked up.
	
	// this is the last player coords befor entering the house, hut, cave, ect.
	// position of the player in the x and y coords system.
	public static var playerXcoordsLast:Float = 0;
	public static var playerYcoordsLast:Float = 0;
	
	// got a super block item. if true then player is able to pass a super block.
	public static var _itemGotSuperBlock:Array<Bool> = [
	false, false, false, false, false, false, false, false
	];
	
	public static var _itemGotSwimmingSkill:Bool = false;
	public static var _itemGotAntigravitySuit:Bool = false;
	public static var _itemGotSkillDash:Bool = false;
	public static var _playerFeelsWeak:Bool = false;
	public static var _itemGotDogFlute:Bool = false;
	
	// is there a dog at the current area?
	public static var _dogOnMap:Bool = false;
	// is the dog carried?
	
	public static var _dogCarriedItsID:String = "";
	public static var _dogCurrentlyCarried:Int = 0;
	public static var _dogFoundAtMap:String = "";
	public static var _dogNoLongerAtMap:String = "";
	
	public static var _dogCarried:Bool = false;
	
	public static var _displayFluteDialog:Bool = true;
	
	//########## INVENTORY MENU
	public static var _inventoryGridXTotalSlots:Int = 13; // total number of horizontal slots in the inventory grid.
	public static var _inventoryGridYTotalSlots:Int = 7; // total number of vertical slots in the inventory grid.
	public static var _itemZSelectedFromInventory:Int = 1; // current item selected.
	public static var _itemXSelectedFromInventory:Int = 0;
	public static var _itemCSelectedFromInventory:Int = 0;
	public static var _itemZSelectedFromInventoryName:String = ""; // current item selected.
	public static var _itemXSelectedFromInventoryName:String = "Normal Jump.";
	public static var _itemCSelectedFromInventoryName:String = "";
	
	// 104 items
	public static var _inventoryIconZNumber:Array<Bool> = [
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false
	];
	
	public static var _inventoryIconXNumber:Array<Bool> = [
	true, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false
	];
	
	public static var _inventoryIconCNumber:Array<Bool> = [
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false, false, false, false, false
	];
	
	public static var _inventoryIconName:Array<String> = [
	"Normal Jump.", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", ""
	];
	
	public static var _inventoryIconDescription:Array<String> = [
	"Can jump a maximum distance of two tiles.", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", ""
	];
	
	public static var _inventoryIconFilemame:Array<String> = [
	"itemJumpNormal.png", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", 
	"", "", "", "", "", "", "", "", "", "", "", "", "", ""
	];	
	
	public static var _inventoryIconNumberMaximum:Int = 1;
	
	//						----MUST READ---
	//##############################################################
	//############# Reg values used when game is reset #############
	//##############################################################
	/**
	* Function to reset all Reg values back to their default values.
	* When saving a game, these Reg vars are used but thier current
	* values are saved, not these values. 
	* */
	public static function resetRegVars():Void
	{

		// this does not need to be changed.
		_boss1ADefeated = false;
		_boss1BDefeated = false;
		_boss2Defeated = false;
		
		mapXcoords = 20;
		mapYcoords = 20;
		dogXcoords = 0;
		dogYcoords = 0;
		
		_boss1AIsMala = true;
		_boss1BIsMala = true;
		_boss2IsMala = true;
		
		_playerHasTalkedToThisMob = false;
	
		_gunPower = 1;
		_gunHudBoxCollectedTriangles = 0;	
		_typeOfGunCurrentlyUsed = 0;
		beginningOfGame = true;
		
		_itemGotKey = [
	false, false, false, false
	];
	
		_itemGotJump = [
	false, false, false, false
	];
		_itemGotGun = false;
		_itemGotGunFreeze = false;
		_itemGotGunFlame = false;
		_itemGotGunRapidFire = false;
	
		_healthMaximum = 5;
		_healthCurrent = 5;
		
		_healthContainerCoords = "";
		
		playerXcoords = 0; 
		playerYcoords = 0;
		
		_jumpForce = 680;
		_fallAllowedDistanceInPixels = 64;
		_itemGotFlyingHat = false;
		
		_inHouse = "";
		_dogInHouse = "";
		
		_itemGotSuperBlock = [
	false, false, false, false, false, false, false, false
	];
	
		_itemGotSwimmingSkill = false;
		_itemGotAntigravitySuit = false;
		_itemGotSkillDash = false;
		_antigravity = false;
		exitGameMenu = false;
		
		_playerFeelsWeak = false;
		
		_itemGotDogFlute = false;
		_dogCarried = false;
		_dogCurrentlyCarried = 0;
		_dogFoundAtMap = "";
		_displayFluteDialog = true;
		_dogCarriedItsID = "";
		_dogNoLongerAtMap = "";
		
		_dogExistsAtMap = [
	false, false, false, false
	];
		
		_numberOfMalasToSave =  FlxG.random.int(3, 6);
		
		_talkedToMalaAtWaitingRoom = [
	false, false, false, false, false, false, false, false
	];
	
		//-----------------inventory menu.
		_inventoryGridXTotalSlots = 13; // x coords system.
		_inventoryGridYTotalSlots = 7;  // y coords system.
		_itemZSelectedFromInventory = 0;
		_itemXSelectedFromInventory = 0;
		_itemCSelectedFromInventory = 0;
		_itemZSelectedFromInventoryName = "";
		_itemXSelectedFromInventoryName = "";
		_itemCSelectedFromInventoryName = "";
		
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			_inventoryIconZNumber[i] = false;
			_inventoryIconXNumber[i] = false;
			_inventoryIconCNumber[i] = false;
			_inventoryIconName[i] = "";
			_inventoryIconDescription[i] = "";
			_inventoryIconFilemame[i] = "";
		}
		//------------------end of inventory menu.
		
		// set normal jump as the default item for key x.
		_inventoryIconXNumber[0] = true;
		_itemXSelectedFromInventoryName = "Normal Jump.";
		_inventoryIconName[0] = "Normal Jump.";
		_inventoryIconDescription[0] = "Can jump a maximum distance of two tiles.";
		_inventoryIconFilemame[0] = "itemJumpNormal.png";
		
		_inventoryIconNumberMaximum = 1;
		_deathWhenReachedZero = _deathWhenReachedZeroCurrent = 400;
		
		_changeToDayOrNightBgsAtPageLoadTicks = 0;
		
		_playerInsideCar = false;
		_carMovingEast = true;
	}
	//################### end of resetRegVars function ###################
	//#####################################################################
	
	/**
	* Random number generator that accepts negative numbers.
	* @param min	Minimum inclusive number. Must be smaller than max. Can be negative, 0 or positive.
	* @param max	Maximum inclusive number. Must be larger than min. Can be negative, 0 or positive.
	* */
	public static function randomNumber(min:Int, max:Int):Int 
	{
		// public static so you can var rn = Util.randomNumber(1, 10);
		var minimum:Int;
			if (min < 0) {
			minimum = min - 1;
			} else {
			minimum = min;
		}
		var maximum:Int;
 			if (max < 0) {
			maximum = max- 1;
			} else {
			maximum= max;
		}
		
		return Std.int(Math.random() * (maximum - minimum + 1) + minimum);
	} 
	
	/**
	* framerate ticks.
	* @param ticks	the current value of a tick.
	* @param inc	by how much a tick increments. 
	* framerate 60 = 1, rate 120 = 0.5, 180 = 0.33, 240 = 0.25
	* */
	public static function incrementTicks(ticks:Float, inc:Float):Float
	{
		ticks = FlxMath.roundDecimal(inc, 2) + FlxMath.roundDecimal(ticks, 2);
		ticks = Math.round(ticks * 100) / 100;

		if (FlxMath.roundDecimal(inc,2) == 0.33)
		{			
			var temp:String = Std.string(ticks);
			var temp2:Array<String> = temp.split(".");				

			if (temp2[1] != null)
			{
				if (StringTools.startsWith(temp2[1], "99"))
				{
					var temp3:Float = Std.parseFloat(temp2[0]);
					temp3++;  ticks = FlxMath.roundDecimal(temp3, 2);	
				}
			}
		}
		
		return ticks;
	}
	
	public static function exitProgram():Void
	{
		//#if WEB_EMBED	// enable in project.xml <haxedef name="WEB_EMBED" />
			//FlxG.openURL(quitURL, "_self"); // quitUrl is url to go to
		//#else
			#if cpp
				Sys.exit(0);
			#else
				openfl.system.System.exit(0);
			#end
		//#end
	}
}

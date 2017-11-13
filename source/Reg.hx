package;
import flixel.FlxG;
import flixel.math.FlxMath;

/**
 * @author galoyo
 */

//######################## NOTES ################################
// change _gunPower back to 1;
	
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko.

	// Checking for null errors are important. The build error on neko, the invalid operation, come from uninitialized variables. To fix do var foo:int = 0. The 0 initializes that variable.
//###############################################################

class Reg
{

	//########################################################################
	// these vars will NOT get saved by saving the game when playing the game.
	//########################################################################
	
	/*******************************************************************************************************
	* If a map coordinate are within this var then the rain will be displayed on that map.
	*/
	public static var _displayRainCoords:String = "17-15,16-20,14-15,20-20,21-19,21-20,20-19,19-20,18-20,18-19,18-15,24-21,22-19,27-19";
	
	/*******************************************************************************************************
	* If set to true then the Test-Items.map will be displayed. That map is used to test the game features. mapXcoords and mapYcoords vars do not need to be changed when setting this var to true.
	*/
	public static var _testItems:Bool = false; 
	
	/*******************************************************************************************************
	* How many frames per second the game should update.
	*/
	public static var _framerate:Int = 120;
	
	/*******************************************************************************************************
	 * Size of the bullet that objects and mobs use. Currently only two types of bullets are in use. 0 = large, and a value of 1 or 2 refers to a small bullet.
	 */
	public static var _bulletSize:Int = 0;
	
	/*******************************************************************************************************
	 * Used to determine if player is walking or using the car. See map 23-19.
	 */
	public static var _playerInsideCar:Bool = false;
	
	/*******************************************************************************************************
	 * Used to determine what direction the car is moving in. If true then the car is moving east, else moving west.
	 */
	public static var _carMovingEast:Bool = true;
	
	/*******************************************************************************************************
	 * There are four cartoon backgrounds for the maps and four star backgrounds. When this var is set to 10, then for 0 to 10 times that the player goes to a map the playstate.hx will load a cartoon background, and at 11 to 20 times a map is load a star background will be displayed. 
	 */
	public static var _changeToDayOrNightBgsAtPageLoad:Int = 10; 	

	// DEATH COUNTDOWN #####################################################################################
	/*******************************************************************************************************
	 * Used in the castle waiting room for a player death countdown. If player has not left the castle within this time then its game over. See map-24-25.tmx at /assets/data/
	 */
	public static var _deathWhenReachedZeroCurrent:Int = 400; 
	
	/*******************************************************************************************************
	 * This vars value should be the same as above. Game over when this countdown var reaches zero.
	 */
	public static var _deathWhenReachedZero:Int = 400;
	// #####################################################################################################
	
	/*******************************************************************************************************
	 * Mainly used to remember the last direction of the player in the pipe so that the player can continue in the pipe when the pipe extends two or more maps.
	 */
	public static var _lastArrowKeyPressed:String = "";
		
	// AIR IN LUNGS ########################################################################################
	// The following three vars should have the same values. 
	/*******************************************************************************************************
	 * how much maximum air the player can have in lungs.
	 */
	public static var _playerAirLeftInLungsMaximum:Int = 100;
	/*******************************************************************************************************
	 * How much current air the player has left in lungs.
	 */
	public static var _playerAirLeftInLungsCurrent:Int = 100;
	/*******************************************************************************************************
	 * Uued with the air timer to display the air remaining text. Value must be the same as the two values above.
	 */
	public static var _playerAirLeftInLungs:Int = 100;
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Before a map is shown, a black screen is displayed in front of the map where the player is at. Moving from the bottom-right corner to the top-left corner is small diamond shapes that appear. Those diamond shape is part of the map where the player is at. This var nust be enabled to display the transition diamond effect for each map. 
	 */	
	public static var _transitionEffectEnable:Bool = false;

	/*******************************************************************************************************
	 * How many ticks the mob frozen for. increase value to increase the length of time the mob stays frozen. 0 = 1.33 seconds. 40 = 2 seconds. 100 = 3 seconds. Do not use a negative value.
	 */		
	public static var _mobIsFrozenFor:Int = 0;

	// PIPE VELOCITY #######################################################################################
	
	/*******************************************************************************************************
	 * How fast the player moves within the pipes horizontally.
	 */
	public static var _pipeVelocityX:Float = 1200;
	
	/*******************************************************************************************************
	 * How fast the player moves within the pipes vertically.
	 */	
	public static var _pipeVelocityY:Float = 1200;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * The tick amount to delay the disappearing block from displaying on screen. Delay in ticks. 60 = 1 second. 40 ticks is added on to this value.
	 */
	public static var _blockDisappearingDelay:Float = 10;

	// GUN HUDBOX ##########################################################################################
	
	//The following two gunhud values must be the same.
	/*******************************************************************************************************
	 * Triangles collected increases gun power but cannot go beyond this value.
	 */
	public static var _gunHudBoxMaximumTriangles:Float = 10;
	
	/*******************************************************************************************************
	 * How many triangles need to be collected before the next powerup occurs.
	 */
	public static var _gunHudBoxCollectedTrianglesIncreaseBy:Int = 10;
	
	//######################################################################################################

	/*******************************************************************************************************
	 * Seconds the mob flickers after hit. The mob cannot receive damage When flickering.
	 */
	public static var _mobHitFlicker:Float = 0.4;
	
	/*******************************************************************************************************
	 * After a respawn, the amount of time that the mob cannot be hit by the player.
	 */
	public static var _mobResetFlicker:Float = 0.4;
	
	/*******************************************************************************************************
	 * A monster, after defeated, will reappear at this value in seconds.
	 */
	public static var _spawnTime:Float = 3.2;	
	
	/*******************************************************************************************************
	 * A monster will not move when its health is zero. Therefore, before a respawn, this is the amount in degrees that the monster will rotate around its center point.
	 */
	public static var _angleDefault:Float = 10;
	
	/*******************************************************************************************************
	 * A monster will drop an item, such as, a triangle, diamond, nugget, or health when this time in seconds is reached.
	 */
	public static var _mobDropItemDelay:Float = 0.07;

	/*******************************************************************************************************
	 * Fireball that revolves around an object. Duration of movement in seconds. Good values are about 0.08 to 0.15
	 */ 
	public static var fireballSpeed:Float = 0.10;
	
	/*******************************************************************************************************
	 * How much slower will the player/monster be in water than on land. Velocity will equal velocity devided by this value.
	 */ 
	public static var _swimmingDelay:Float = 1.60;
	
	/*******************************************************************************************************
	 * When true, display the exit game, go back to title and resume game sub menu.
	 */
	public static var exitGameMenu:Bool = false;
	
	// VINES ###############################################################################################
	
	/*******************************************************************************************************
	 * This will determine how fast a vine moves. Used in a random value at PlayState.hx. Example, Reg._vineMovingSpeed = FlxG.random.float(Reg._vineMovingMinimumSpeed, Reg._vineMovingMaximumSpeed);
	 */
	public static var _vineMovingMinimumSpeed:Float = 0.40;
	
	/*******************************************************************************************************
	 * This is the second parameter of a randon value used as the object vine's velocity.
	 */
	public static var _vineMovingMaximumSpeed:Float = 0.50;
	
	//######################################################################################################
	
	// BOSS IS MALA ########################################################################################
	
	/*******************************************************************************************************
	 * Bumping into this monster when var is true will not cause any player damage. When mob is fighting then this var will be false.
	 */
	public static var _boss1AIsMala:Bool = true;
	
	/*******************************************************************************************************
	 * True when this boss is willing to talk.
	 */
	public static var _boss1BIsMala:Bool = true;
	
	/*******************************************************************************************************
	 * True when this boss is willing to talk.
	 */
	public static var _boss2IsMala:Bool = true;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * If mobs distance is greater than this value in pixels from the player then the mob is re-spawned/reset().
	 */
	public static var _mobDistanceFromPlayer:Int = 832;
	

	/*******************************************************************************************************
	 * Number of Malas that the Doctor will save at the waiting room. Values can be 1 to 8.
	 */
	public static var _numberOfMalasToSave:Int = FlxG.random.int(3, 6);
	
	//##################################################################
	//################ These values must NOT be changed. ###############
	//##################################################################
	
	/*******************************************************************************************************
	* DO NOT change the value of this var. It is used to determine if a substate should be displayed or if a demo should be played. Removing this var from all code will result in the demo playing when a substate at main menu is displayed.
	*/
	public static var _ignoreIfMusicPlaying:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to stop a particular music from playing. This "dream" music is played only at the parallax car scene. This var makes that happen.
	 */
	public static var _stopDreamsMusic:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Each time playstate.hx is loaded this var is increased. When it reaches the value of Reg._changeToDayOrNightBgsAtPageLoad then the background image will change from cartoon to stars and then back again.
	 */
	public static var _changeToDayOrNightBgsAtPageLoadTicks:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Player is in water and the player's air is decreasing. This var is used to remember that state.
	 */
	public static var _playerAirIsDecreasing:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. When player picks up a star powerup, player will not take damage from mobs but will still take damage when fallimg from a great distance. This var is used to take health away but only once per fall.
	 */
	public static var _isFallDamage:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to stop the player's flicker. If true then the player's flicker will stop when the powerup music stops playing.
	 */
	public static var _powerUpStopFlicker:Bool = false;	
		
	/*******************************************************************************************************
	 * Do NOT change the value of this var. When set to false this var can be used to stop a function or code block from updating. see Hud.hx for an example about how it is used in a function. Without this var at Hud.hx, when playomg the game, the Map coords at the top right corner will display the next map value just before loading that map. An undesired result.
	 */
	public static var _update:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Without this var, the player jumps down instead of walking down the tiled slope. This high value stops that from happening. Instead the player will seem to walk down the slope because of a high gravity.
	 */
	public static var _gravityOnSlopes:Int = 100000;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. When value is true at playState.hx, this var is used to disable the transition effect when the recorded demo is playing. Recorded demos will be broken when played more than once if the transition effect is allowed to plays with the demos. At menuState, a demo will be played when the introduction music ends.
	 */
	public static var _noTransitionEffectDemoPlaying = false;
		
	/*******************************************************************************************************
	 * Do NOT change the value of this var. this var holds the parent state. If a class is public at playState.hx then it can be accessed at playState.hx using the code "Reg.state." then select the public class from the popup box.
	 */
	public static var state:PlayState;	
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The value of this var will be true then player is standing on a frozon mob. The mob can be frozen with the freeze gun.
	 */
	public static var _playerGravitySetToZero:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The number of total diamonds at a map. This var is initialized for neko builds. The value is determined at playStateAdd.hx.
	 */ 
	public static var diamondsRemaining:Int = 0;
		
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var will be true if user has not pressed a key/button before music stops at menuState. The recorded demo will play when the introduction music stops at MenuState.hx.
	 */
	public static var _playRecordedDemo:Bool = false;
	
	// DIALOG STUFF ########################################################################################
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If you plan to have an NPC ask the user a questiopn, this var will need to be set to true. When this var is true, at Dialog.hx, a "yes and no" text/button will be displayed above the dialog text box when the question is asked.  
	 */
	public static var displayDialogYesNo:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The message displayed after player picks up an item or when talking to an NPC.
	 * eg, Reg.dialogIconText = openfl.Assets.getText("assets/text/Map13-15B-doctor.txt").split("#");
	 */
	public static var dialogIconText:Array<String>;
	
	 /*******************************************************************************************************
	 * Do NOT change the value of this var. This is the image filename of the item that the player picked up. The image is displayed at the dialog.
	 */
	public static var dialogIconFilename:String = "";
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This is the image filename of a NPC or player currently talking at the Dialog.hx. The image is displayed at the dialog. Search for "boss1B-ID1-Map12-19C.txt" at Boss1.hx for an example about how to use this var.
	 */
	public static var dialogCharacterTalk:Array<String> = [
	"", "", ""
	];	
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Value is true when the player answered YES to a question.
	 */
	public static var _dialogAnsweredYes:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Value is true when the player answered a question.
	 */
	public static var _dialogYesNoWasAnswered:Bool = false; 
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var will be true when the maximum amount of triangles are collected. The word "Maximum" at the gun hudBox will then be seen.
	 */
	public static var _gunHudBoxDisplayMaximumText:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The width/height of a map tile in pixels.
	 */
	public static var _tileSize:Int = 32;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used when "load game" at the MenuState.hx is selected. if true then the player will be displayed on the map at the save point.
	 */	
	public static var restoreGameState:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var is used to remember the direction the player is facing when the game is saved. 
	 */
	public static var facingDirectionRight:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var keeps the last known standing location. Example, player is currently standing at Y value of 100 . If player jumps or falls to an area that is below 100 then this var will be minus the player's landing Y location. Players damage will then be calculated.
	 */
	public static var _playersYLastOnTile:Float = 0;

	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var is used to determine the players fall damage. Reg._playerYNewFallTotal = players.y - Reg._playersYLastOnTile; If this vars values is within the allowed fall value then player will not receive any damage when landing on the ground.
	 */
	public static var _playerYNewFallTotal:Float = 0; 

	/*******************************************************************************************************
	 * Do NOT change the value of this var. Show the guildlines if this var is too high in value.
	 */
	public static var _guildlineInUseTicks:Float = 0;
	
	// VINE ################################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The speed of a vine depends on a random value of the _vineMovingMinimumSpeed and _vineMovingMaximumSpeed values set at PlayState.hx to be used at the objectVineMoving class.
	 */ 
	public static var _vineMovingSpeed:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. When var is false, make every other vine move faster.
	 */
	public static var _vineToggleMovementSpeed:Bool = false;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. When this var is true then the player's gravity will be reversed.
	 */
	public static var _antigravity:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to determine when a conversation with a mob has ended. usually used in a boss.
	 */
	public static var _playerHasTalkedToThisMob:Bool = false;
	
	// PLAYER ###############################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If value is true then the player can fire a gun.
	 */
	public static var _playerCanShoot:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If value is true then the player can fire a gun and move.
	 */
	public static var _playerCanShootAndMove:Bool = true;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Determine if the player used the teleporter.
	 */
	public static var _teleportedToHouse:Bool = false; 
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to move the player to the waiting room.
	 */
	public static var _talkedToDoctorNearDogLady:Bool = false;
	

	/*******************************************************************************************************
	 * Do NOT change the value of this var. At the waiting room scene, the var is used to delay the siren sound and screen shake effect and to display a help message from the doctor.
	 */
	public static var ticksDoctor:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Doctor randomly teleporting malas when this var is of a certain value.
	 */
	public static var ticksTeleport:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Dogs need to exist at every map or else when a dog is carried by player from one map to the next, the dog will not be overtop of the player. The reason is because there is no dog sprite on the map. This var is used at the the end of "playState.hx finction create()" to check if the dog exists. If no dog exist then a dog will be created at 0-0 map coords and this var will be set to true.
	 */ 
	public static var _dogExistsAtMap:Array<Bool> = [
	false, false, false, false
	];
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If player picked up a dog that ran (ID 2) then that dog needs to move with the player. The problem is that the second id of the dog make the dog run back and forth. this var stops that from happening.
	 */
	public static var _dogStopMoving:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The flute will play a buzz sound when both dogs are invisible. That sound refers to no dogs existing at current map because they are both at location 0-0 map coords.
	 */
	public static var _dogIsVisible:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. this var is used to hide the dog in the pipes.
	 */
	public static var _dogIsInPipe:Bool = false; 
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Determines if a music can be played. This value can be changed within the game at Options.
	 */
	public static var _musicEnabled:Bool = true; 	
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Determines if a sound can be played. This value can be changed within the game at Options.
	 */
	public static var _soundEnabled:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Determines if background sounds of different types of noises can be played. This value can be changed within the game at Options.
	 */
	public static var _backgroundSoundsEnabled:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var.
	 * T KEY toggles cheat mode on / off.
	 * H KEY increase health by 1.
	 * L KEY increase air in lungs by 10.
	 */
	public static var _cheatModeEnabled:Bool = false;
	/*******************************************************************************************************
	 * Do NOT change the value of this var. No delay displaying the text at the dialog. The dialog is the text that the mob, npc or player outputs.
	 */
	public static var _dialogFastTextEnabled = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to update Z, X and C buttons at playstate.hx when inventory menu is closed.
	 */
	public static var _buttonsNavigationUpdate:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. At the inventory, the total number of horizontal slots that make the inventory grid.
	 */
	public static var _inventoryGridXTotalSlots:Int = 13;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. At the inventory, the total number of vertical slots that make the inventory grid.
	 */
	public static var _inventoryGridYTotalSlots:Int = 7;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If true then the player will take fall damage when falling to the ground if player falls pass the tile fall limit.
	 */
	public static var _playerFallDamage:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to remember where the dog was picked up.
	 */
	public static var dogXcoords:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to remember where the dog was picked up.
	 */
	public static var dogYcoords:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The player.x position on the map in pixels.
	 */
	public static var playerXcoords:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The player.y position on the map in pixels.
	 */
	public static var playerYcoords:Float = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Your current score.
	 */
	public static var _score:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Your current gold.
	 */
	public static var _nuggets:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to determine if diamonds should be displayed on the map or if all dismonds were picked up. If the current displayed map is found within this var then all diamonds were collected.
	 */ 
	public static var _diamondCoords:String = "";
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to determine if a heart container should be displayed on the current map or was picked up. If map coords exist in this var then heart container was picked up. Therefore, do not display the heart container on the current map.
	 */ 
	public static var _healthContainerCoords:String = "";
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The Doctor will talk to the player at the waiting room shortly before the "death countdown" text is displayed. See _deathWhenReachedZero. 
	 */
	public static var _talkToDoctorAt24_25Map:Bool = false;
			
	/*******************************************************************************************************
	 * Do NOT change the value of this var. The wall barricate will be removed after the player talks to every Mala at the waiting room. Example, when player talks to Mala number 3, then the third array will be set to true.
	 */
	public static var _talkedToMalaAtWaitingRoom:Array<Bool> = [
	false, false, false, false, false, false, false, false
	];
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If Reg._totalMalasTeleported is less than _numberOfMalasToSave then can teleport another Mala.
	 */
	public static var _totalMalasTeleported:Int = 0; 
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Thus var refers to what gun it currently in use. normal gun has a value of 0, flame gun has a value of 1 and freeze gun has a value of 2.
	 */
	public static var _typeOfGunCurrentlyUsed:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. At the start of game, player can stand anywhere at the beginning of the game. This var is false then after entering another map, the player stands near the edge of the screen.
	 */
	public static var beginningOfGame:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Currently set for a total of 4 different keys that can be collected. When player picks up a key then an array has a value of true.
	 */
	public static var _itemGotKey:Array<Bool> = [
	false, false, false, false
	];
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Different jump items. array 1 is a low jump while 4 is a higher jump ability. currenly only 4 jump upgrades are available. When a jump item is collected then an array has a value of true.
	 */
	public static var _itemGotJump:Array<Bool> = [
	false, false, false, false
	];
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. If a Map tile is made of any 1 of 8 super blocks then that tile can only be destroyed if the player has an item of that type. If player picks up a super block item then an array is true. If an array is true and its ID is the same as the super block ID then player is able to destroy that super block.
	 */ 
	public static var _itemGotSuperBlock:Array<Bool> = [
	false, false, false, false, false, false, false, false
	];
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up a normal gun.
	 */
	public static var _itemGotGun:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up a freeze gun.
	 */
	public static var _itemGotGunFreeze:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up a flame gun.
	 */
	public static var _itemGotGunFlame:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up rapid fire for the normal gun.
	 */
	public static var _itemGotGunRapidFire:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up flying hat. Player need to stand on a flying pad to begin flying.
	 */
	public static var _itemGotFlyingHat:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up a swimming skill item. Player can now swim.
	 */
	public static var _itemGotSwimmingSkill:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up an antigravity suit item. Player can now walk on the ceiling.
	 */
	public static var _itemGotAntigravitySuit:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Picked up a skill dash item. Player can now dash quickly.
	 */
	public static var _itemGotSkillDash:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Player can now use the flute to find a dog.
	 */
	public static var _itemGotDogFlute:Bool = false;

	/*******************************************************************************************************
	 * Do NOT change the value of this var. This is the default fall distance that the player can fall without receiving fall damage. This distance has a height of 2 tiles.
	 */
	public static var _fallAllowedDistanceInPixels = 64;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var.  How high the player can jump.
	 */
	public static var _jumpForce:Int = 680;	
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Value is true if the player is using the flying hat item.
	 */
	public static var _usingFlyingHat:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This is the last player coords befor entering the house, hut, cave, ect. Position of the player in the x and y coords system.
	 */
	public static var playerXcoordsLast:Float = 0;
	public static var playerYcoordsLast:Float = 0;
	
	/*******************************************************************************************************
	 * Plaer will be a yellow color when felling weak.
	 */
	public static var _playerFeelsWeak:Bool = false;
	
	// HOUSE ###############################################################################################
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Values are "house" and "". The house map will be displayed when value is house, 
	 */
	public static var _inHouse:String = "";
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to remember if player picked up the dog at a house or outside.
	 */public static var _dogInHouse:String = "";
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to store a list of dog ID's. If ID exists in this var then that dog was returned to dog lady. Therefore, at the current map, a dog with that ID must not exist.
	 */
	public static var _dogCarriedItsID:String = ""; 
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Used to determine the dog's ID. Example, if ID is 2 then the dog carried was running on the ground before player carried that dog.
	 */
	public static var _dogCurrentlyCarried:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. True if dog is visable on the current map.
	 */
	public static var _dogOnMap:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Holds the map data of all dogs returned to the dog lady. If map data in this var matches the map data of the current map then _dogOnMap will equal false. 
	 */
	public static var _dogFoundAtMap:String = "";
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. Determines if the dog is carried. 
	 */
	public static var _dogCarried:Bool = false;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. This var is used at the dog lady to only display the dog flute dialog once.
	 */
	public static var _displayFluteDialog:Bool = true;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. For the Z key/button this is the current value of the inventory item selected.
	 */
	public static var _itemZSelectedFromInventory:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. For the X key/button this is the current value of the inventory item selected.
	 */
	public static var _itemXSelectedFromInventory:Int = 0;
	
	/*******************************************************************************************************
	 * Do NOT change the value of this var. For the C key/button this is the current value of the inventory item selected.
	 */
	public static var _itemCSelectedFromInventory:Int = 0;
	
	/**
	 * Do NOT change the value of this var. Used to determine if there should be player fall damage after the player hits a mob.
	 */
	public static var _playerFallDamageHitMob:Bool = false;
	
	//##################################################################
	//########## vars that WILL be saved when game is saved ############
	//##################################################################
	// NOTE: these vars MUST also be in the resetRegVars function at this
	// class so they can be reset to there default value when, after the 
	// player dies, a new game is selected.	
	
	// BOSS DEFEATED ########################################################################################
	
	// You must only change these values when debugging. If this value is true then that boss has been defeated. Example, if you are setting the second boss to true then all the previous bosses must also be set to true. That value should only be changed if you want to test the dialog of NPCs or some event after a boss has been defeated. 
	
	/*******************************************************************************************************
	 * For debugging only. Very first boss named susan.
	 */
	public static var _boss1ADefeated:Bool = false;
	
	/*******************************************************************************************************
	 * For debugging only. Susan is now bigger and more aggressive.
	 */
	public static var _boss1BDefeated:Bool = false;
	
	/*******************************************************************************************************
	 * For debugging only. Ghost mob.
	 */
	public static var _boss2Defeated:Bool = false;
	
	// ######################################################################################################
	
	/*******************************************************************************************************
	 * Sometimes a mob will drop a heart. A heart collected will increase players health but cannot go beyond the total health of this var. Only a health container will increase the value of this var.
	 */
	public static var _healthMaximum:Float = 5;
	
	/*******************************************************************************************************
	 * This is the current health of player. The "Player.health" will equal this var when player is placed on the map. This var must not be greater than the _healthMaximum var.
	 */
	public static var _healthCurrent:Float = 5; 
	
	// MAP #################################################################################################
	
	// These vars are used to load a map. You can change these vars to debug a different map but remember to set the map back to Map-20-20.csv because that map is the starting map of the game. Example, mapXcoords = 20 and mapYcoords = 20 will set the map back to the start of the game.
	// These var values will be used the first time a new game loads. The second time, the values will come from the function resetRegVars at this clase. So, if you need to test a map other than 20-20 then you need to also change those values at that function.
	
	/*******************************************************************************************************
	 * The X coords of the current map displayed. Example, Map-X-Y.csv.
	 */
	public static var mapXcoords:Float = 20; // should be 20.
	
	/*******************************************************************************************************
	 * The Y coords of the current map displayed. Example, Map-X-Y.csv.
	 */
	public static var mapYcoords:Float = 20; // should be 20.
	
	//######################################################################################################
		
	/*******************************************************************************************************
	 * If a map is within this var then the light will be displayed on that map. The map will be dark except for a light source that surrounds the player.
	 */
	public static var _displayLightCoords:String = "19-21,19-22";
		
	/*******************************************************************************************************
	 * Light effect for the player. If the value is true then the player can see in dark places.
	 */
	public static var _darkness:Bool = false;
	
	/*******************************************************************************************************
	 * how easy will the mobs be to defeat. 1:easy, 2:normal, 3:hard
	 */
	public static var _difficultyLevel:Int = 2;
	
	/*******************************************************************************************************
	 * _gunPower determines if its a double or single bullet, ect. Bullet power and bullet size increase the higher this value is. values are 1, 2 or 3.
	 */ 
	public static var _gunPower:Float = 1;
	
	/*******************************************************************************************************
	 * The amount of triangles that the player has collected. Triangles sometimes drop from a monster when monster is defeated. When player picks up enough triangles when gun will increase in power and bullet will then be more powerful. Bullets will hurt monsters health at damage times gun power.
	 */ 
	public static var _gunHudBoxCollectedTriangles:Float = 0;	
		
	//######################## INVENTORY MENU ######################	
	/*******************************************************************************************************
	 * For the Z key/button this is the current name of the inventory item selected.
	 */
	public static var _itemZSelectedFromInventoryName:String = "";
	
	/*******************************************************************************************************
	 * For the X key/button this is the current name of the inventory item selected.
	 */
	public static var _itemXSelectedFromInventoryName:String = "Normal Jump.";
	
	/*******************************************************************************************************
	 * For the C key/button this is the current name of the inventory item selected.
	 */
	public static var _itemCSelectedFromInventoryName:String = "";
	
	/*******************************************************************************************************
	 * Currently a new game only has one item in the inventory, so this value must equal 1. If you add another item to the inventory list then change this value to 2 and add the data at the second field of _inventoryIconName, _inventoryIconDescription and _inventoryIconFilemame. 
	 */
	public static var _inventoryIconNumberMaximum:Int = 1;
	
	/*******************************************************************************************************
	 * At default, when you start a new game, the "normal jump" at inventory is the only item that can be selected. If you want that item to be at the Z action key then change here the first false to value true.
	 * If there were two items at the inventory and you wanted the second item to be used as default at this action key then change the first value to false and the second value to true. Then at _inventoryIconName, _inventoryIconDescription and _inventoryIconFilemame add the second item data to the second value of those vars and then plus one the value of _inventoryIconNumberMaximum.
	 */
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
	
	/*******************************************************************************************************
	 * If at the inventory screen there are two items displayed at slot one and two and you want the second item to be displayed at the navigation bar where the big X is displayed then change here the first value to false and then change the second value to true.
	 */
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
	
	/*******************************************************************************************************
	 * If you would like to have this action key to use the third inventory item when a new game starts then change here the third "false" value and make it "true".
	 */
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
	
	/*******************************************************************************************************
	 * Name of the inventory item.
	 */
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
	
	/*******************************************************************************************************
	 * Description of the inventory item. Needs to be a short one-liner or else the text will run off of the screen.
	 */
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
	
	/*******************************************************************************************************
	 * The file image should be 32 x 32 in pixels and exist at the assets/images directory. Next, add the filename beside "itemJumpNormal.png". The image will be displayed at the inventory screen but only after you set the other inventory vars.
	 */
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
	//################## END OF INVENTORY MENU #####################

	
	//						----MUST READ---
	//##############################################################
	//############# Reg values used when game is reset #############
	//##############################################################
	/*******************************************************************************************************
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
	
	/*******************************************************************************************************
	* Random number generator that accepts negative numbers.
	* @param min	Minimum inclusive number. Must be smaller than max. Can be negative, 0 or positive.
	* @param max	Maximum inclusive number. Must be larger than min. Can be negative, 0 or positive.
	* */
	public static function randomNumber(min:Int, max:Int):Int 
	{
		// public static so you can var rn = Util.randomNumber(1, 10);
		var minimum:Int;
		var maximum:Int;
		
		// The minus 1 at this code will make var minimum a negative value.
		if (min < 0) minimum = min - 1;
		else minimum = min; // No plus 1 value because 0 is a positive value.
 		
		if (max < 0) maximum = max - 1;
		else maximum = max;
		
		return Std.int(Math.random() * (maximum - minimum + 1) + minimum);
	} 
	
	/*******************************************************************************************************
	* framerate ticks.
	* @param ticks	the current value of a tick.
	* @param inc	by how much a tick increments. 
	* framerate 60 = 1, rate 120 = 0.5, 180 = 0.33, 240 = 0.25
	* */
	public static function incrementTicks(ticks:Float, inc:Float):Float
	{
		// Round ticks to the second decimal place.
		ticks = FlxMath.roundDecimal(inc, 2) + FlxMath.roundDecimal(ticks, 2);
		ticks = Math.round(ticks * 100) / 100;

		// When framerate equals 180 then this "code block" will get called everytime. When the value is 0.33 then the code will make the ticks plus one its value but the inc var at next loop will still be a value of 0.33,
		if (FlxMath.roundDecimal(inc,2) == 0.33)
		{			
			var temp:String = Std.string(ticks);
			
			// temp2[0] refers to a value at the left side of the decimal while tamp2[1] refers to the value at the right side of the decimal.
			var temp2:Array<String> = temp.split(".");				

			if (temp2[1] != null)
			{
				// If framerate equals 180 then 60 divided by framerate will equal 0.33. The problem is that ticks need to be in increments of 1. When a tick has a value of .99 then the tick will be rounded up to the next whole value. Then at a class we can do if (ticks == 1).
				if (StringTools.startsWith(temp2[1], "99"))
				{
					// convert a string to a float/
					var temp3:Float = Std.parseFloat(temp2[0]);
					temp3++;  ticks = FlxMath.roundDecimal(temp3, 2);	
				}
			}
		}
		
		return ticks;
	}
	
	/*******************************************************************************************************
	* Function used to exit the game.
	*/
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
	
	/**
	 * play a sound when a menu button is clicked.
	 */
	public static function playTwinkle():Void
	{
		if (Reg._soundEnabled == true) 
		{
			FlxG.sound.playMusic("twinkle", 1, false);		
			FlxG.sound.music.persist = true;
		}
	}
}

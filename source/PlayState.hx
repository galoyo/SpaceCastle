package;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import openfl.display.StageQuality;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxTrailEffect;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.ui.FlxUIState;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween; // A FlxTween allows you to create smooth animations easily such as moving in a circle or semi circle. Tweening means inbetweening. Specify a start and end value and the FlxTween class will generate all values between them.
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


/**
 * @author galoyo
 */

class PlayState extends FlxUIState
{
	/*******************************************************************************************************
	 * Used in the recording of a game demo.
	 */
	public var recording:Bool = false;
		
	/*******************************************************************************************************
	 *  This emitter of colorful square particles will continue through its straight path hitting anything in its way.
	 */
	public var _emitterBulletFlame:FlxEmitter;	
	
	/*******************************************************************************************************
	 * This emitter will emit when a mob takes damage.
	 */
	public var _emitterMobsDamage:FlxEmitter;
	
	/*******************************************************************************************************
	 * This emitter will display an animated explosion in front of a mob just before that mob is destroyed.
	 */
	public var _emitterDeath:FlxEmitter;
	
	/*******************************************************************************************************
	 * One or more triangles might be dropped from a defeated mob. A collected triangle will inclease the "Gun Power" hud value. Collect enought of them and the gun power will increase. Hence, a gun bullet will then be more powerful.
	 */
	public var _emitterItemTriangle:FlxEmitter;
	
	/*******************************************************************************************************
	 * Sometimes a mob drops a diamond when defeated. That small diamond will increase the Score seen at the Score hud.
	 */
	public var _emitterItemDiamond:FlxEmitter;
	
	/*******************************************************************************************************
	 * Sometimes a mob drops a star. This emitter controls the animation and velocity of that star. The player will be invincible When that star is collected. A "powerUp" music will be played when the star is collected. The player can receive damage only after the powerUp music has ended.
	 */
	public var _emitterItemPowerUp:FlxEmitter;
	
	/*******************************************************************************************************
	 * A mob might drop some nuggets when that mob is defeated. Nuggets are used to buy stuff from the store.
	 */
	public var _emitterItemNugget:FlxEmitter;
	
	/*******************************************************************************************************
	 * Increases the players health by one health point. If the player is not damaged, a full blue health bar, then picking up this item will not increase player's health.
	 */
	public var _emitterItemHeart:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. When the emitter emits, the player will quickly dash to the left or to the right while the player is rising in the air. At that time, a trail of gray players will be behind the player creating an effect that the player is moving so quickly that many of players can be seen.
	 */
	public var _emitterSkillDash:FlxEmitter;	
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when the bullet reaches its maximum distance or when the bullet hits a mob.
	 */
	public var _particleBulletHit:FlxEmitter;
	
	/*******************************************************************************************************
	 * DO NOT change the value of this var. This particle will emit when a bullet from the normal gun hits a tile. 
	 */
	public var _particleBulletMiss:FlxEmitter;
	
	/*******************************************************************************************************
	 * This is jetpack smoke for moving left mobs.
	 */
	public var _particleSmokeLeft:FlxEmitter;	
	
	/*******************************************************************************************************
	 * This is jetpack smoke for moving right mobs.
	 */
	public var _particleSmokeRight:FlxEmitter;
	
	/*******************************************************************************************************
	 * This partical emits a water splash effect when player or mob enters or exits the water.
	 */
	public var _particleWaterSplash:FlxEmitter;
	
	/*******************************************************************************************************
	 * The player is stunned for a moment when the player's head hits the ceiling. This particle emits the image for that effect. 
	 */
	public var _particleCeilingHit:FlxEmitter;
	
	/*******************************************************************************************************
	 * When playing the game, pressing the "Down arrow" key is used to interact with objects such as opening a door or talking to a mob. When there is nothing to interact with at thst location then a "?" will emit.
	 */
	public var _particleQuestionMark:FlxEmitter;		
	
	/*******************************************************************************************************
	 * The player is able to breath underwater at an "air bubble" location. At the air bubble this emitter emits the animation.
	 */
	public var _particleAirBubble:FlxEmitter;
	
	// BULLET CLASSES ######################################################################################
	
	/*******************************************************************************************************
	 * Var that points to a normal gun bullets class.
	 */
	public var _bullets:FlxTypedGroup<Bullet>;	
	
	/*******************************************************************************************************
	 * Var that points to a bullets from mob class.
	 */
	public var _bulletsMob:FlxTypedGroup<BulletMob>;
	
	/*******************************************************************************************************
	 * Var that points to a bullets from object class. For example, the object cannon shoots bullets.
	 */
	public var _bulletsObject:FlxTypedGroup<BulletObject>;
	
	//######################################################################################################
	
	// GUN OVERLAY #########################################################################################
	
	/*******************************************************************************************************
	 * Normal gun class. For example, for access to this gun class do Reg.state._gun. 
	 */
	public var _gun:PlayerOverlayGun;
	
	/*******************************************************************************************************
	 * Flame gun class.
	 */
	public var _gunFlame:PlayerOverlayGunFlame;
	
	/*******************************************************************************************************
	 * Freeze gun class.
	 */
	public var _gunFreeze:PlayerOverlayGunFreeze;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * This group holds most items that were picked up by the player. A collide check for this group points to the PlayStateTouchItems.itemPickedUp function. See that function for an example about how to access a dialog when an item in this group is picked up.
	 */
	public var _itemsThatWerePickedUp:FlxGroup;
	
	/*******************************************************************************************************
	 * The player is free to fly for any lenght of time so long as player does not touch a tile. Touching a tile will stop the player from flying. The player will then need to stand on a flying pad to fly again.
	 */
	public var _itemFlyingHatPlatform:FlxGroup;	
	
	// GUN ITEMS ###########################################################################################
	// Other items are at reg.hx. These items are placed on a map with the Tiled Map Editor software. The player must collect these items first before using them.
	
	/*******************************************************************************************************
	 * Normal gun item. Normal pea shooter gun.
	 */
	public var _itemGun:FlxGroup;
	
	/*******************************************************************************************************
	 * Gun freeze item. This gun shoots cold bullets that can freeze SOME mobs.
	 */
	public var _itemGunFreeze:FlxGroup;
	
	/*******************************************************************************************************
	 * Gun flame item. This gun shoots flame of fire.
	 */
	public var _itemGunFlame:FlxGroup;

	//######################################################################################################
	
	// OBJECTS #############################################################################################
	
	/*******************************************************************************************************
	 * A few layer 3 objects are in this group.
	 * Treasure chest and computer object are here.
	 */
	public var _objectsLayer3:FlxGroup;
	
	/*******************************************************************************************************
	 * Objects that do not move are in this group. See cannon, barricade, spikeTrap.
	 */
	public var _objectsThatDoNotMove:FlxGroup;	
	
	/*******************************************************************************************************
	 * Objects that move are in this group. See SpikeFalling and rockFalling.
	 */
	public var _objectsThatMove:FlxGroup;	
	
	/*******************************************************************************************************
	 * All blocks and rocks that do no damage to the player should be in this group.
	 */
	public var _objectBlockOrRock:FlxGroup;	
	
	/*******************************************************************************************************
	 * Clime the ladder. Player can fall off the ladder by using the Left or Right arrow key / button.
	 */
	public var _objectLadders:FlxGroup;
	
	/*******************************************************************************************************
	 * Some Malas are held in cages. See map-18-15.
	 */
	public var _objectCage:FlxGroup;
	
	/*******************************************************************************************************
	 * MobTube exits this tube and flys in the direction of the player. MobTube will not exit this tube if player is standing on this tube.
	 */
	public var _objectTube:FlxGroup;
	
	/*******************************************************************************************************
	 * Player can only open a door with a key that is the same color as that door.
	 */
	public var _objectDoor:FlxGroup;
	
	/*******************************************************************************************************
	 * Door to the house. No key is needed to enter a house.
	 */
	public var _objectDoorToHouse:FlxGroup;	
	
	/*******************************************************************************************************
	 * Horizontal and vertical moing platforms.
	 */
	public var _objectPlatformMoving:FlxGroup;
	
	/*******************************************************************************************************
	 * Malas water grass weeds. Some grass weeds have flowers.
	 */
	public var _objectGrassWeed:FlxGroup;	
	
	/*******************************************************************************************************
	 * Treasure chest. TODO: Not currently working.
	 */
	public var _objectTreasureChest:ObjectTreasureChest;	
	
	/*******************************************************************************************************
	 * Computers. TODO: Not currently working.
	 */
	public var _objectComputer:ObjectComputer;		
	
	/*******************************************************************************************************
	 * This fireball will revolve around the fireballBlock. 
	 */
	public var _objectFireball:FlxGroup;
	
	/*******************************************************************************************************
	 * Fireballs that revolve around mobBubble. Tween is an easy to use feature to make animations and predefined sprite movements easily.
	 */
	public var _objectFireballTween:FlxGroup;
	
	/*******************************************************************************************************
	 * This laser beam is an obstacle for the player to overcome. This laser beam moves in an upward direction. Once the laser beam touches the ceiling it will reset back to the floor and will begin to move again. The player must move to the other side of this object without touching it. 
	 */
	public var _objectBeamLaser:FlxGroup;
	
	/*******************************************************************************************************
	 * This super block is used to stop to player from progressing in the game by blocking the player's path. the player can only remove this block with an block item of the same type.
	 */
	public var _objectSuperBlock:FlxGroup;
	
	/*******************************************************************************************************
	 * Player is forced to swim in the direction of the water current. A water current can point in the direction of north, east, south or west. A water current cannot change direction.
	 */
	public var _objectWaterCurrent:FlxGroup;
	
	/*******************************************************************************************************
	 * A moving platform is a tile that moves either horizontally or vertically and will change direction when touching a wall or this object.
	 */
	public var _objectPlatformParameter:FlxGroup;	
	
	/*******************************************************************************************************
	 * Vine is a long, slender stem from a plant. Player can swing from vine to vine to progress the journey. 
	 */
	public var _objectVineMoving:FlxGroup;	
	
	/*******************************************************************************************************
	 * A fireball will revolve around the block. 
	 */
	public var _objectFireballBlock:FlxGroup;
	
	/*******************************************************************************************************
	 * This tile is invisable when playing the game. In the Tiled Map Editor, it is placed above the water wave so that the game knowns when the player or mob enters or exits the water.
	 */
	public var _objectWaterParameter:FlxGroup;	
	
	/*******************************************************************************************************
	 * The laser beam will stop and then reset when it touches this object. ../readme dev/README FIRST.txt for more information.
	 */
	public var _objectLaserParameter:FlxGroup;	
	
	/*******************************************************************************************************
	 * When player is in front of this sign and the user presses the "Down arrow" key or button, the dialog text of this object can be read.
	 */
	public var _objectSign:FlxGroup;
	
	/*******************************************************************************************************
	 * A key collected will activate a new level to teleport to. At that time, the player can use a teleporter to go to a different level. A teleporter is located at the inside of a house.
	 */
	public var _objectTeleporter:FlxGroup;
	
	/*******************************************************************************************************
	 * This object must be placed at the left side or right side of walls. The direction of the player is reversed when jumping on this jumping pad. The player can make it to the top of the screen by jumping from this jumping pad to the next jumping pad.
	 */
	public var _objectJumpingPad:FlxGroup;
	
	/*******************************************************************************************************
	 * If this block is touched by the player or mob when health damage will be given. If the player or a mob is still standing on this tile, then within a set time, more damage will be given.
	 */
	public var _objectLavaBlock:FlxGroup;
	
	/*******************************************************************************************************
	 * The player or a mob can slowly sink into this quicksand. Rapid jumping is needed to exit this quicksand. Health damage will be given to the player or mob when fully underneath this quicksand.
	 */
	public var _objectQuickSand:FlxGroup;
	
	/*******************************************************************************************************
	 * A car is needed to make it to the other side of the boulevard (trees on both sides of the street).
	 */
	public var _objectCar:ObjectCar;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * All still overlays are within this group.
	 */ 
	public var _overlaysThatDoNotMove:FlxGroup;	
	
	/*******************************************************************************************************
	 * This overlay hides the start location and end location of a laser beam. ../readme dev/README FIRST.txt for more information.
	 */
	public var _overlayLaserBeam:FlxGroup;
	
	/*******************************************************************************************************
	 * The surface of the water.
	 */
	public var _overlayWave:FlxGroup;	
	
	/*******************************************************************************************************
	 * This is water that the player or mob swims or walks in.
	 */
	public var _overlayWater:FlxGroup;
	
	/*******************************************************************************************************
	 * The player or mob is able to breath underwater at an air bubble location.
	 */
	public var _overlayAirBubble:FlxGroup;	
	
	/*******************************************************************************************************
	 * All blue pipes are added here. A pipe is a hollow cylinder material. When the player enters the pipe, the player will be forced to move in a forward direction until the player reaches a junction or an end of the pipe is reached. A series of pipe can be placed togetter for the player to travel in any direction.
	 * IMPORTANT, there must be two horizontal or two vertical pipes that connect to a three or four way pipe or it will not work. also, there cannot be two angle (90 degree) pipes placed together.
	 */
	public var _overlayPipe:FlxGroup;	
	
	/*******************************************************************************************************
	 * Player class.
	 */ 
	public var player:Player;
		
	/*******************************************************************************************************
	 * All mobs that collide will tilemaps are in this group.
	 */ 
	public var enemies:FlxGroup;
		
	/*******************************************************************************************************
	 * All mobs that do not collide will tilemaps but can collide with other mobs are in this group.
	 */
	public var enemiesNoCollideWithTileMap:FlxGroup;
	
	/*******************************************************************************************************
	 * Non-player characters (malas)
	 */
	public var npcs:FlxGroup;  
	
	/*******************************************************************************************************
	 * The HUD, heads up display, is the display area where a user can see their player's data such as score or gun power.
	 */
	public var hud:Hud;
	
	/*******************************************************************************************************
	 * The left, right, jump, etc, buttons at the bottom of the screen.
	 */
	public var _buttonsNavigation:ButtonsNavigation;
	
	/*******************************************************************************************************
	 * The text when an item is picked up or when a character is talking.
	 */
	public var dialog:Dialog;
	
	// MOBS ################################################################################################
	// These mobs are in the enemies group.
	
	/*******************************************************************************************************
	 * Walks left and right a platform. Reverses direction when at edge of platform. Shoots no bullet.
	 */
	public var mobApple:MobApple;
	
	/*******************************************************************************************************
	 * This mob with an ID of 2 jumps faster than mob ID 1. Shoots no bullets.
	 */
	public var mobSlime:MobSlime;	
	
	/*******************************************************************************************************
	 * Walks left and right. Reverses direction when touching a wall. Jumps over holes. Shoots no bullets.
	 */
	public var mobCutter:MobCutter;	
	
	/*******************************************************************************************************
	 * Only moves horizontally from one side of the screen to the other.
	 */
	public var mobBullet:MobBullet;
	
	/*******************************************************************************************************
	 * This mob exits a tube and horizontally flies towards to the player.
	 */
	public var mobTube:MobTube;
	
	/*******************************************************************************************************
	 * Moves vertically in the air. Shoots no bullets.
	 */
	public var mobBat:MobBat;
	
	/*******************************************************************************************************
	 * Jump happy mob. Shoots no bullets.
	 */
	public var mobSqu:MobSqu;
	
	/*******************************************************************************************************
	 * swims left and right. Reverses direction when touching a wall. shoots no bullets. Mob with an ID of 2 swims faster than mob ID 1.
	 */
	public var mobFish:MobFish;
	
	/*******************************************************************************************************
	 * Walks on ceiling, walls or floors. Some types of this mob shoots bullets.
	 */
	public var mobGlob:MobGlob;
	
	/*******************************************************************************************************
	 * Flying horizonally back and forth. Reverses direction when touching a tile. Fires bullets up and down.
	 */
	public var mobWorm:MobWorm;
	
	/*******************************************************************************************************
	 * This mob hangs from the ceiling shooting bullets in an angle. Flys toward the player when player and this mob is near vertical from each other. occupies two tiles.
	 */
	public var mobExplode:MobExplode;
	
	/*******************************************************************************************************
	 * Moves left and right. Reverses direction when at edge of platform.
	 */
	public var mobSaw:MobSaw;
	
	//######################################################################################################
	
	// BOSSES ##############################################################################################
	
	/*******************************************************************************************************
	 * First appearance of susan.
	 */
	public var boss1A:Boss1;
	
	/*******************************************************************************************************
	 * Second appearance of susan. She can now jump. She is much stronger than when the player first battled her.
	 */
	public var boss1B:Boss1;
	
	/*******************************************************************************************************
	 * The ghost monster. This mob is strong.
	 */
	public var boss2:Boss2;
	
	/*******************************************************************************************************
	 * End boss.
	 */
	public var mobBubble:MobBubble;
	
	//######################################################################################################
	
	// NPC's ###############################################################################################
	
	/*******************************************************************************************************
	 * The doctor is a mystery. Is the doctor trying to save the Malas from doom or does the doctor have a hidden agenda.
	 */
	public var npcDoctor:NpcDoctor;
	
	/*******************************************************************************************************
	 * Good NPCx but unhealthy.
	 */
	public var npcMalaUnhealthy:NpcMalaUnhealthy;
	
	/*******************************************************************************************************
	 * healthy Malas.
	 */
	public var npcMalaHealthy:NpcMalaHealthy;
	
	/*******************************************************************************************************
	 * Help find her dogs. She has an important story to tell the player.
	 */
	public var npcDogLady:NpcDogLady;
	
	/*******************************************************************************************************
	 * The dog lady's dogs.
	 */
	public var npcDog:NpcDog;	
	
	//######################################################################################################
	
	// FLXBAR ##############################################################################################
	
	/*******************************************************************************************************
	 * This health bar represents the health of a mob. This health bar is located under the legs of a mob. The color blue refers to health and the color red refers to health damage. Mob dies when there is no more blue color on the health bar.
	 */
	public var _healthBars:FlxGroup;
	
	/*******************************************************************************************************
	 * This health bar represents the health of the player. This health bar is located under the legs of the player.
	 */
	public var _healthBarPlayer:HealthBar;
	
	/*******************************************************************************************************
	 * This health bar represents the health of mobBubble. This health bar is located under the legs of mobBubble. MobBubble is not in the FlxGroup "enemies" because mobBubble is the last boss in the game.
	 */
	public var _healthBarMobBubble:FlxBar;
	
	//######################################################################################################
	
	// FIREBALLS FOR MOBBUBBLE #############################################################################
	
	/*******************************************************************************************************
	 * The first fireball that revolves around mobBubble.
	 */
	public var _defenseMobFireball1:FlxSprite;
	
	/*******************************************************************************************************
	 * The second fireball that revolves around mobBubble.
	 */
	public var _defenseMobFireball2:FlxSprite;
	
	/*******************************************************************************************************
	 * The third fireball that revolves around mobBubble.
	 */
	public var _defenseMobFireball3:FlxSprite;
	
	/*******************************************************************************************************
	 * The forth fireball that revolves around mobBubble.
	 */
	public var _defenseMobFireball4:FlxSprite;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Malas use this shovel to dig the grass weeds for the doctor.
	 */
	public var _npcShovel:FlxGroup;
	
	/*******************************************************************************************************
	 * Malas use this watering can to water the grass weeds.
	 */
	public var _npcWateringCan:FlxGroup;
	
	// BACKGROUND AND OVERLAYS #############################################################################
	
	/*******************************************************************************************************
	 * Layer 0: Main tiles are here. FlxTilemapExt handles tiled slopes. FlxTilemap has no tiled slopes.
	 */
	public var tilemap:FlxTilemapExt;
	
	/*******************************************************************************************************
	 * These tiles are displayed in front of the tilemap but are displayed behind all other tiles.
	 */
	public var underlays:FlxTilemap;
	
	/*******************************************************************************************************
	 * Layer 5: if (Reg.state.tilemap.getTile(i, j) == 177) refers to an tile ID to check. These tiles are displayed in front of all other tiles.
	 */
	public var overlays:FlxTilemap;
	
	/*******************************************************************************************************
	 * This var displays the background scene of a map. 
	 */
	public var background:FlxSprite;
	
	/*******************************************************************************************************
	 * Light effect for the player. The player can see in dark places.
	 */
	public var _light:FlxSprite;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * If a map coordinate are within Reg._displayRainCoords var then the rain will be displayed on that map.
	 */
	public var _rain:FlxTypedGroup<ObjectRain>;
	
	// TIMER ###############################################################################################
	// Used to go to a function every set time for how many loops.
	
	/*******************************************************************************************************
	 * Triggered when player hits the ceiling.
	 */
	public var _ceilingHit:FlxTimer;
	
	/*******************************************************************************************************
	 * Triggered when user presses the "Down arrow" key.
	 */
	public var _questionMark:FlxTimer;
	
	/*******************************************************************************************************
	 * Triggered when player enters and exits the water. Plays the water sound.
	 */
	public var _waterPlayer:FlxTimer;
	
	/*******************************************************************************************************
	 * Triggered when the mob enters or exits the water.
	 */
	public var _waterEnemy:FlxTimer;
	
	/*******************************************************************************************************
	 * Used for the countdown text of the air remaining in the players lungs.
	 */
	public var _playerAirRemainingTimer:FlxTimer;	
		
	//######################################################################################################
	
	/*******************************************************************************************************
	 * Used to determine if the player is on the ladder.
	 */
	public var _playerOnLadder:Bool = false;
	
	/*******************************************************************************************************
	 * Used to reset the player's Y acceleration of gravity. Gravity is needed when player is no longer on the ladder.
	 */
	public var _playerJustExitedLadder:Bool = false;
	
	/*******************************************************************************************************
	 * Normally a player is stunned for a moment when the player's head hits the ceiling. At that time, an animation effect will play. However, when this value is true then a collision between the player and this tile will not result in the player being stunned nor an anaimation played. Instead, the block will be destoyed when a collision is detected.
	 */
	public var _touchingSuperBlock:Bool = false;	
	
	/*******************************************************************************************************
	 * This vars value will be true when the player enters or exits the water. This var is used to trigger a water splash sound.
	 */
	public var _playWaterSound:Bool = true;
	
	/*******************************************************************************************************
	 * This vars value will be true when a mob enters or exits the water. This var is used to trigger a water splash sound.
	 */
	public var _playWaterSoundEnemy:Bool = true;

	/*******************************************************************************************************
	 * At user saves the game when the player is at this location.
	 */
	public var savePoint:FlxGroup;
	
	/*******************************************************************************************************
	 * Start the fireball at this position in degrees. Currently, this var is used in part of a tween code that creates a fireball for the object fireball block.
	 */
	public var _fireballPositionInDegrees:Int = 359;
	
	/*******************************************************************************************************
	 * This is the remaining air in lungs countdown text when player is in the water.
	 */
	public var airLeftInLungsText:FlxText;
	
	/*******************************************************************************************************
	 * At the waiting room, this var holds how many more Malas the player needs to talk to.
	 */
	public var _talkToHowManyMoreMalas:FlxText;
	
	/*******************************************************************************************************
	 * Used for the waiting room countdown text. The player has to leave the waiting room within this time or else the player will die.
	 */
	public var _timeRemainingBeforeDeath:FlxText;	
	
	/*******************************************************************************************************
	 * If the player jumped / falled to this line then the player would receive small health damage. The player's health decreases more in value the greater the player drops.
	 */
	public var warningFallLine:FlxSprite;
	
	/*******************************************************************************************************
	 * If the player jumped / falled to this line then the player would die.	
	 */
	public var deathFallLine:FlxSprite;
	
	/*******************************************************************************************************
	 * This line refers to a maximum height that the player is able to jump.
	 */
	public var maximumJumpLine:FlxSprite;
	
	/*******************************************************************************************************
	 * The constructor.
	 */
	override public function create():Void
	{
		Reg._update = true;
		persistentDraw = false;
		
		// near the bottom of this constructor, if you plan to use more than 2 dogs then uncomment those two lines with id 3 and 4.
		
		// Multiple overlap between two objects. https://github.com/HaxeFlixel/flixel/issues/1247 uncomment the following to fix the issue. might lose small cpu preformance. you don't use many callbacks so this is currently not a concern.
		FlxG.worldDivisions = 1;
		FlxG.worldBounds.set(0); 
		
		Reg._keyOrButtonDown = false;
		
		if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19)
		{
			var parallaxCar1 = new FlxBackdrop("assets/images/parallaxForest1.png", 0.4, 0, true, false, 0, 0);
			var parallaxCar2 = new FlxBackdrop("assets/images/parallaxForest2.png", 0.6, 0, true, false, 0, 0);
			var parallaxCar3 = new FlxBackdrop("assets/images/parallaxForest3.png", 0.8, 0, true, false, 0, 0);
			var parallaxCar4 = new FlxBackdrop("assets/images/parallaxForest4.png", 1, 0, true, false, 0, 0);
	
			add(parallaxCar1);
			add(parallaxCar2);
			add(parallaxCar3);
			add(parallaxCar4);
						
		}
			
		// reset important dog vars.
		for (i in 1...5)
		{
			Reg._dogExistsAtMap[i] = false;
		}
		Reg._dogIsVisible = true;
		
		//FlxG.mouse.visible = false;
		
		// smooth the image.
		//FlxG.stage.quality = StageQuality.BEST;
		//FlxG.camera.antialiasing = true;
		//FlxG.camera.pixelPerfectRender = true;
				
		Reg.diamondsRemaining = 0;
		Reg.state = this;
		Reg._playerAirIsDecreasing = false;
		
		Reg._teleporterStartX = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		Reg._teleporterStartY = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		Reg._teleporterInUse = [true, true, true, true, true, true, true, true, true];
		
		_ceilingHit = new FlxTimer();
		_questionMark = new FlxTimer();
		_waterPlayer = new FlxTimer();
		_waterEnemy = new FlxTimer();
		_playerAirRemainingTimer = new FlxTimer();
		
		// create the items and objects.
		savePoint = new FlxGroup();		
		_objectDoor = new FlxGroup();
		_itemsThatWerePickedUp = new FlxGroup();
				
		_itemGunFlame = new FlxGroup();			
		_itemGun = new FlxGroup();	
		_itemGunFreeze = new FlxGroup();	
		_healthBars = new FlxGroup();
		
		_objectGrassWeed = new FlxGroup();
		_objectFireballBlock = new FlxGroup();
		_objectFireball = new FlxGroup();
		_objectFireballTween = new FlxGroup();
		_objectBeamLaser = new FlxGroup();
		_objectWaterParameter = new FlxGroup();
		_objectLaserParameter = new FlxGroup();
		_objectPlatformParameter = new FlxGroup();
		
		_npcShovel = new FlxGroup();			
		_npcWateringCan = new FlxGroup();
		
		_overlayWave = new FlxGroup();	
		_overlayWater = new FlxGroup();			
		_overlayAirBubble = new FlxGroup();	
		_overlayPipe = new FlxGroup();	
		
		// draw the map tiles and place the objects and layers on the map.
		PlayStateCreateMap.createLayer0Tilemap();
		
		// setup the bullet star emitter		
		_particleBulletHit = new FlxEmitter();
		_particleBulletHit.maxSize = 50;
		for (i in 0..._particleBulletHit.maxSize) _particleBulletHit.add(new ParticleBulletHit());
		_particleBulletHit.lifespan.set(0.2);
		
		_particleCeilingHit = new FlxEmitter();
		_particleCeilingHit.maxSize = 5;
		for (i in 0..._particleCeilingHit.maxSize) _particleCeilingHit.add(new ParticleCeilingHit());
		_particleCeilingHit.lifespan.set(0.2);
		
		_particleQuestionMark = new FlxEmitter();
		_particleQuestionMark.maxSize = 20;
		for (i in 0..._particleQuestionMark.maxSize) _particleQuestionMark.add(new ParticleQuestionMark());
		_particleQuestionMark.lifespan.set(0.4);
		
		_particleBulletMiss = new FlxEmitter();
		_particleBulletMiss.maxSize = 50;
		for (i in 0..._particleBulletMiss.maxSize) _particleBulletMiss.add(new ParticleBulletMiss());
		_particleBulletMiss.lifespan.set(0.2);	
		
		_particleWaterSplash = new FlxEmitter();
		_particleWaterSplash.maxSize = 15;
		for (i in 0..._particleWaterSplash.maxSize) _particleWaterSplash.add(new ParticleWaterSplash());
		_particleWaterSplash.lifespan.set(0.2);
		
		_particleSmokeRight = new FlxEmitter();
		_particleSmokeRight.maxSize = 40; // enough for four mobBullets on the screen at same time.
		for (i in 0..._particleSmokeRight.maxSize) _particleSmokeRight.add(new ParticleSmokeRight());
		_particleSmokeRight.lifespan.set(0.15);
		
		_particleSmokeLeft = new FlxEmitter();
		_particleSmokeLeft.maxSize = 40; // enough for four mobBullets on the screen at same time.
		for (i in 0..._particleSmokeLeft.maxSize) _particleSmokeLeft.add(new ParticleSmokeLeft());
		_particleSmokeLeft.lifespan.set(0.15);
		
		_particleAirBubble = new FlxEmitter();
		_particleAirBubble.maxSize = 40;
		for (i in 0..._particleAirBubble.maxSize) _particleAirBubble.add(new ParticleAirBubble());
		_particleAirBubble.lifespan.set(0.2);
		
		_emitterBulletFlame = new EmitterBulletFlame();
		_emitterMobsDamage = new EmitterMobsDamage();
		_emitterDeath = new EmitterDeath();
		_emitterItemTriangle = new EmitterItemTriangle();
		_emitterItemDiamond = new EmitterItemDiamond();
		_emitterItemPowerUp = new EmitterItemPowerUp();
		_emitterItemNugget = new EmitterItemNugget();
		_emitterItemHeart = new EmitterItemHeart();
		_emitterSkillDash = new EmitterSkillDash();
		
		_bullets = new FlxTypedGroup<Bullet>(0);
		_bulletsMob = new FlxTypedGroup<BulletMob>(0);
		_bulletsObject = new FlxTypedGroup<BulletObject>(0);								
				
		add(_healthBars);
		
		_objectCage = new FlxGroup();
		_objectTube = new FlxGroup();

		//########################## Player talks about being unhealthy.
		if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._itemGotSuperBlock[1] == true && Reg._playerFeelsWeak == false)
		{
			Reg._playerFeelsWeak = true; // after getting the first super block, when the player leaves the area the player will be a yellow color.
			
			Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-player.txt").split("#");
										
			Reg.dialogCharacterTalk[0] = "talkPlayerUnhealthy.png";
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());
		}
		//##########################		
		
		PlayStateCreateMap.createLayer1UnderlaysTiles();
		PlayStateCreateMap.createLayer2Player();			
		PlayStateCreateMap.createSpriteGroups();		
		PlayStateCreateMap.createLayer3Sprites();
		
		add(_particleBulletHit);
		add(_particleCeilingHit);
		add(_particleQuestionMark);
		add(_particleBulletMiss);	
		add(_emitterBulletFlame);
		add(_emitterMobsDamage);
		add(_emitterDeath);
		add(_emitterItemHeart);
		add(_emitterItemTriangle);
		add(_emitterItemDiamond);
		add(_emitterItemPowerUp);
		add(_emitterItemNugget);
		add(_emitterSkillDash);
		
		add(_particleWaterSplash);
		add(_particleSmokeRight);		
		add(_particleSmokeLeft);		
		
		PlayStateCreateMap.createOverlaysGroups();
		PlayStateCreateMap.createLayer4OverlaySprites();
		PlayStateCreateMap.createLayer5OverlaysTiles();
		
		add(_objectWaterParameter);
		add(_objectLaserParameter);
		add(_objectPlatformParameter);
		
		// add overlay objects after overlay tilemap.
		add(_overlayWave);
		add(_overlayWater);		
		add(_particleAirBubble);
		add(_overlayAirBubble);		
		add(_overlayPipe);		
				
		// ---------------------------------- rain.		
		var outside:Bool = displayRain();

		// trap this because != does not work. this is for the parallax var scene.
		if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19) {}
		else if (outside == true && Reg._inHouse == "")
		{
			// we're going to have some rain or ash flakes drifting down at different 'levels'. We need a lot of them for the effect to work nicely
			_rain = new FlxTypedGroup<ObjectRain>();
			add(_rain);
		
			for (i in 0...200)
			{
				_rain.add(new ObjectRain(i % 10));
			}
		}
		//-----------------------------------------------
		
		// Light effect for the player. The player can see in dark places.
		Reg._darkness = displayLight();
		
		if (Reg._darkness == true && Reg._inHouse == "")
		{
			_light = new FlxSprite();
			_light.loadGraphic("assets/images/light.png", false);		
			_light.setPosition((-FlxG.width + (Reg.state.player.width / 2)) + Reg.state.player.x, ((-FlxG.height + (Reg.state.player.height / 2)) + Reg.state.player.y + 57));
			_light.scrollFactor.set(0, 0);
			add(_light);
		}
		
		// If this is the first time that the player has been to the current map then add the map to a var so that the map will be displayed correctly at the mini map screen.		
		currentMap();
									
		hud = new Hud();		
		add(hud);		
		
		// bad hack to display the gun power when trangles are zero.
		hud.decreaseGunPowerCollected();
		hud.increaseGunPowerCollected();		
		
		_buttonsNavigation = new ButtonsNavigation();	
		add(_buttonsNavigation);
	
		// add the guns.
		_gun = new PlayerOverlayGun(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gun);

		_gunFlame = new PlayerOverlayGunFlame(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gunFlame);
		
		_gunFreeze = new PlayerOverlayGunFreeze(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gunFreeze);
				
		FlxG.camera.bgColor = FlxColor.TRANSPARENT;	
		Reg.setCamera();
		
		airLeftInLungsText = new FlxText();
		airLeftInLungsText.color = FlxColor.WHITE;
		airLeftInLungsText.size = 22;
		airLeftInLungsText.scrollFactor.set();
		airLeftInLungsText.alignment = FlxTextAlign.CENTER;
		airLeftInLungsText.setPosition(Reg.state.camera.width / 2 - 50, Reg.state.camera.height / 2);
		airLeftInLungsText.visible = false;
		add(airLeftInLungsText);
		
		_talkToHowManyMoreMalas = new FlxText();
		_talkToHowManyMoreMalas.color = FlxColor.WHITE;
		_talkToHowManyMoreMalas.size = 22;
		_talkToHowManyMoreMalas.scrollFactor.set();
		_talkToHowManyMoreMalas.alignment = FlxTextAlign.CENTER;
		_talkToHowManyMoreMalas.setPosition(Reg.state.camera.width / 2 - 65, Reg.state.camera.height / 2);
		_talkToHowManyMoreMalas.visible = false;
		add(_talkToHowManyMoreMalas);
		
		_timeRemainingBeforeDeath = new FlxText();
		_timeRemainingBeforeDeath.color = FlxColor.WHITE;
		_timeRemainingBeforeDeath.size = 22;
		_timeRemainingBeforeDeath.scrollFactor.set();
		_timeRemainingBeforeDeath.alignment = FlxTextAlign.CENTER;
		_timeRemainingBeforeDeath.setPosition(Reg.state.camera.width / 2 - 65, Reg.state.camera.height / 2);
		_timeRemainingBeforeDeath.visible = false;
		add(_timeRemainingBeforeDeath);
		
		PlayStateMiscellaneous.guidelines(); // display the fall/jump guide lines.
		
		if (Reg._stopDreamsMusic == true) {FlxG.sound.music.stop(); Reg._stopDreamsMusic = false;}
		
		if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19)
		{
			if (FlxG.sound.music.playing == true) FlxG.sound.music.stop();
			
			if (Reg._playerInsideCar == false) 
			{
				FlxG.sound.playMusic("dreams1", 1, false);
				Reg._stopDreamsMusic = true;
			}
			else FlxG.sound.playMusic("dreams2", 1, false);
		}
	
		else if (Reg._musicEnabled == true) 
		{
			if (Reg.mapXcoords == 24 && Reg.mapYcoords >= 21 && Reg.mapYcoords <= 24 ) 
			{
				FlxG.sound.music.persist = true;
			}
			else  PlayStateMiscellaneous.playMusicIntro(); // played when entering a house, cave, ect.			
		}	
		
		if (Reg.mapXcoords == 24 && Reg.mapYcoords >= 21 && Reg.mapYcoords <= 24)
		{
			if (Reg._soundEnabled == true) 
			{
				// if at castle waiting room and doctor has talked then play siren for the remaining of the maps, until player has exited the red door.
				FlxG.sound.play("siren", 1, true);
				FlxG.cameras.shake(0.005, 999999);			
			}
				
		}  
		
		// If powerUpStopflicker equals true then the powerUp music is still playing, so make the player flicker.
		if (Reg._musicEnabled == true && Reg._powerUpStopFlicker == true && FlxG.sound.music.playing == true)
			FlxSpriteUtil.flicker(Reg.state.player, 100, 0.04);
		
		if (Reg._backgroundSoundsEnabled == true) FlxG.sound.play("backgroundSounds", 0.25, true);
	
		
		//################# KEEP THIS CODE NEAR THE BOTTOM OF THIS FUNCTION.
		//################################################################
		//check if dog exists on the map. if no dog exists then create the dogs at the top left corner of the screen. There needs to be dogs at each level, some hidden some not, so that a dog can be carried from one map to another. if there are dogs that exists, then there should be one dog that can be found while the other dog cannot. when carried the dog can be seen at another map when there is a dog with the id that is hidden. the following code makes that happen.
		Reg._dogStopMoving = true;
		if (Reg._dogExistsAtMap[1] == false) PlayStateAdd.addNpcDog(0, 0, player, 1);
		if (Reg._dogExistsAtMap[2] == false) PlayStateAdd.addNpcDog(0, 0, player, 2);				
		//if (Reg._dogExistsAtMap[3] == false) PlayStateAdd.addNpcDog(0, 0, player, 3);
		//if (Reg._dogExistsAtMap[4] == false) PlayStateAdd.addNpcDog(0, 0, player, 4);	
		Reg._dogStopMoving = false;
		
		//##################### RECORDING CODE BLOCK ####################
		// if you want to play the recorded demo then uncomment this block only after you have recorded a demo located at the top of update() function at this file. if you uncomment this block then you need to comment the recording code block at the top of the update() function at this file.
		if (Reg._playRecordedDemo == true)
		{			
			Reg._playRecordedDemo = false;
			Reg._noTransitionEffectDemoPlaying = true;
			
			FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr"), new PlayState(), ["Z","X","C"], 0, replayCallback);

		}
		//##################### END OF RECORDING CODE BLOCK ####################
		
		// display the diamond transition effect before a map is displayed?
		if (Reg._transitionEffectEnable == true && Reg._noTransitionEffectDemoPlaying == false)
		{
			init();
		}
		
	
		super.create();
	}
	
	function displayRain():Bool
	{
		var paragraph = Reg._displayRainCoords.split(",");
		
		// loop through the paragraph array. if there is a match then do not display the rain on the map.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				return true;
		}
		
		return false;
	}	
	
	function currentMap():Bool
	{
		// loop through the array. if there is a match then do not add this map to the array. Old mini maps will be displayed in a different color. No need to add two or more of the same map to the list.
		for (i in 0...Reg._mapsThatPlayerHasBeenTo.length)
		{	
			if (Reg._mapsThatPlayerHasBeenTo[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				return true;
		}
		
		Reg._mapsThatPlayerHasBeenTo.push(Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords));
		return false;
	}	
	
	public function removeItemFromMiniMap():Void
	{
		// If there is a match then remove item so that the item will not be displayed at the mini map.
		Reg._mapsThatHaveAnItem.remove(Reg.mapXcoords + "-" + Reg.mapYcoords);
	}	
	
	function displayLight():Bool
	{
		var paragraph = Reg._displayLightCoords.split(",");
		
		// loop through the paragraph array. if there is a match then do not display the clouds on the map.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				return true;
		}
		
		return false;
	}	

	override public function update(elapsed:Float):Void
	{			
		//################ RECORDING DEMO BLOCK #####################
		//to record a demo you need to uncomment this block and you need to comment the recording code block near the bottom of the create() function at this file. search for the keyword "record".
		
		// remember to change the framerate at options before recording. at playstate.hx press 8 to record and press 9 to save the recording and save the file "replay-60.fgr", "replay-120.fgr", etc to the assests/data directory.
		/*if (FlxG.keys.anyJustPressed(["EIGHT"]) && !recording) {recording = true; FlxG.vcr.startRecording(true);} 
		if (FlxG.keys.anyJustPressed(["NINE"])) FlxG.vcr.stopRecording();
		if (FlxG.keys.anyJustPressed(["ZERO"])) FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr")); */
		//################ END RECORDING DEMO BLOCK #################
				
		if (Reg._gameSaveOrLoad == 1 && Reg._savingGame == true && Reg._gameSlotNumberSaved != 0)
		{
			Reg.dialogIconText = openfl.Assets.getText("assets/text/gameSaved.txt").split("#");
			Reg.dialogCharacterTalk[0] = "";
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());

			Reg._savingGame = false;
			Reg._gameSaveOrLoad = 0;
		}
			
		Reg._gameSlotNumberSaved = 0;
		
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used. This line is needed for the keys/buttons to work.		
		InputControls.checkInput();
		
		if (InputControls.z.justPressed && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Mini Maps."
		 || InputControls.x.justPressed && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Mini Maps."
		 || InputControls.c.justPressed && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Mini Maps.")
		{
			openSubState(new ObjectMap());	
		}
		
		if (InputControls.i.justPressed && Reg._keyOrButtonDown == false)
		{
			Reg._keyOrButtonDown = true;
		}
		
		if (InputControls.i.justReleased && Reg._keyOrButtonDown == true)
		{
			Reg._keyOrButtonDown = false;
			openSubState(new Inventory());
		}
		
		if (Reg._buttonsNavigationUpdate == true)
		{
			// user was at inventory menu and may have changed icons, update those icons here so that they are display correctly the navigation menu and fire correctly for game play.
			_buttonsNavigation.findInventoryIconZNumber();
			_buttonsNavigation.findInventoryIconXNumber();
			_buttonsNavigation.findInventoryIconCNumber();
		
		// if gun is not selected from the inventory then hide it in case it is displayed.
		if (   Reg._itemXSelectedFromInventoryName != "Normal Gun." && Reg._itemCSelectedFromInventoryName != "Normal Gun.")
			_gun.visible = false;
		if (   Reg._itemXSelectedFromInventoryName != "Flame Gun." && Reg._itemCSelectedFromInventoryName != "Flame Gun.")
			_gunFlame.visible = false;
		if (   Reg._itemXSelectedFromInventoryName != "Freeze Gun." && Reg._itemCSelectedFromInventoryName != "Freeze Gun.")
			_gunFreeze.visible = false;
		
			Reg._buttonsNavigationUpdate = false;
		}
		
		// play a random background monster sound.
		var ra = FlxG.random.int(1, 600);
		if (ra == 600)
		{
			var ra2 = FlxG.random.int(1, 9); 
			if (Reg._soundEnabled == true) FlxG.sound.play("ambient" + Std.string(ra2), 0.25, false);
		}
		
		// talked to the doctor?
		if (Reg._talkedToDoctorNearDogLady == true)
		{
			Reg._talkedToDoctorNearDogLady = false;
			Reg._dogOnMap = false;
			Reg.mapXcoords = 24;
			Reg.mapYcoords = 25;

			Reg.playerXcoordsLast = 12 * Reg._tileSize;
			Reg.playerYcoordsLast = 12 * Reg._tileSize;
						
			FlxG.switchState(new PlayState());
		}
	
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["F12"])) FlxG.fullscreen = !FlxG.fullscreen; // toggles fullscreen mode.
		#end
		
		// play another music if music is not player.
		if (Reg._musicEnabled == true || Reg._powerUpStopFlicker == true)
		{
			if (FlxG.sound.music.playing == false) 
			{
				PlayStateMiscellaneous.playMusic();
				
				Reg._powerUpStopFlicker = false;
				FlxSpriteUtil.stopFlickering(Reg.state.player);
			}
		}
	
		// enter key was pressed after replying to a dialog question.
		if (Reg.dialogIconFilename == "savePoint.png" && Reg._dialogAnsweredYes == true)
		{
			if (Reg.dialogIconFilename == "savePoint.png")
				FlxG.overlap(savePoint, player, PlayStateTouchItems.touchSavePoint);
			
			Reg._dialogAnsweredYes = false;
		}
		
		PlayStateDownKey.downKey();

		//####################### EMITTERS ############################		
		FlxG.overlap(_emitterItemTriangle, player, PlayStateTouchObjects.emitterTrianglePlayerOverlap);
		FlxG.overlap(_emitterItemDiamond, player, PlayStateTouchObjects.emitterDiamondPlayerOverlap);	
		FlxG.overlap(_emitterItemPowerUp, player, PlayStateTouchObjects.emitterPowerUpPlayerOverlap);	
		FlxG.overlap(_emitterItemNugget, player, PlayStateTouchObjects.emitterNuggetPlayerOverlap);	
		FlxG.overlap(_emitterItemHeart, player, PlayStateTouchObjects.emitterHeartPlayerOverlap);	
		
		//############### COLLIDE - OVERLAP STARTS HERE ###############
				
		//######################### TWEENS#############################
		FlxG.collide(_objectFireballBlock, player, PlayStateTouchObjects.fireballBlockPlayer);
		FlxG.collide(_objectFireballBlock, enemies);
		
		// fireballs that rotate the block.
		if (FlxSpriteUtil.isFlickering(player) == false)
		{
			FlxG.overlap(_objectFireball, player, PlayStateTouchObjects.fireballCollidePlayer);
			FlxG.overlap(_objectFireballTween, player, PlayStateTouchObjects.fireballCollidePlayer);
		}		
			FlxG.overlap(_objectFireball, enemies, PlayStateTouchObjects.fireballCollideEnemy);
		
		
		//######################### TOUCH ITEMS #######################
		
		// _objectDoor is a group that put all the FlxSprite in to one area.
		// add the ovelap check to PlayState update() that calls 
		// the function touchDoor() when player overlaps the door
		FlxG.overlap(_objectDoor, player, PlayStateTouchObjects.touchDoor);
		FlxG.collide(_objectDoor, player);
		FlxG.collide(_objectDoor, enemies);
		FlxG.collide(_objectDoor, _bullets);	
		FlxG.collide(_objectDoor, _bulletsMob);	
		FlxG.collide(_objectDoor, _bulletsObject);
		
		FlxG.overlap(_itemsThatWerePickedUp, player, PlayStateTouchItems.itemPickedUp);

		FlxG.overlap(_itemGunFlame, player, PlayStateTouchItems.touchItemGunFlame);		
		FlxG.overlap(_itemGun, player, PlayStateTouchItems.touchItemGun);
		FlxG.overlap(_itemGunFreeze, player, PlayStateTouchItems.touchItemGunFreeze);
				
		//####################### MISC COLLIDE #######################
		FlxG.collide(_bullets, tilemap);
		FlxG.collide(_bulletsMob, tilemap);	
		FlxG.collide(_bulletsObject, tilemap);	
		
		if (Reg._typeOfGunCurrentlyUsed == 2)
		{
			// do not kill the mob after the mob has been defeated because mob needs to talk still.
			if (Reg.mapXcoords == 17 && Reg.mapYcoords == 22 && FlxG.overlap(_bullets, boss1A) && Reg._boss1AIsMala == true || Reg.mapXcoords == 12 && Reg.mapYcoords == 19 && FlxG.overlap(_bullets, boss1B) && Reg._boss1BIsMala == true)
			{	
				// do nothing.		
			} 

			else 
			{
				FlxG.overlap(_bullets, enemies, EnemyCastSpriteCollide.hitEnemy);
			}
		}
		else 
		{
			if (Reg.mapXcoords == 17 && Reg.mapYcoords == 22 && FlxG.overlap(_bullets, boss1A) && Reg._boss1AIsMala == true || Reg.mapXcoords == 12 && Reg.mapYcoords == 19 && FlxG.overlap(_bullets, boss1B) && Reg._boss1BIsMala == true || Reg.mapXcoords == 15 && Reg.mapYcoords == 15 && FlxG.overlap(_bullets, boss2) && Reg._boss2IsMala == true)
			{	
				// do nothing.		
			} 
			else if (Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && FlxG.overlap(_bullets, mobBubble))
			{
				// this code block is needed so that the player cannot just fire the gun in an upward direction repeatedly and kill this mob in under 5 seconds.
				if(Reg.state.mobBubble.ticksTween != 3)
				FlxG.overlap(_bullets, enemies, PlayStateTouchObjects.hitEnemy);
				
				FlxSpriteUtil.stopFlickering(mobBubble);
			}else
			{
				FlxG.overlap(_bullets, enemies, PlayStateTouchObjects.hitEnemy);
			}
		}
		
		FlxG.overlap(_bulletsMob, player, PlayStateTouchObjects.hitPlayer);
		FlxG.overlap(_bulletsObject, player, PlayStateTouchObjects.hitPlayer);
		FlxG.overlap(_emitterBulletFlame, enemies, PlayStateTouchObjects.hitEnemyWithFlame);
			
		if(FlxG.overlap(_objectLadders, player))
		FlxG.overlap(_objectLadders, player, PlayStateTouchObjects.ladderPlayerOverlap);
		else if (_playerOnLadder == true)
		{
			_playerOnLadder = false;
			_playerJustExitedLadder = true;
			
		} 
		
		// determine if the player is on the ladder. if not then set the gravity so that the player can fall again.
		if (_playerJustExitedLadder == true && !player.overlapsAt(player.x, player.y + 16, Reg.state._objectLadders))
		{
			_playerJustExitedLadder = false;	
			// stops high jump bug or stop leaving ladder bug when antigravity is on..		
			if (Reg._antigravity == false) player.acceleration.y = player._gravity; 
				else player.acceleration.y = -player._gravity;
		}		
		
		//######################### BOSS DAMAGE ########################
		if (FlxSpriteUtil.isFlickering(player) == false || Reg._powerUpStopFlicker == true)
		{	
			// no collide with the boss because player is talking with the boss.
			if (Reg.mapXcoords == 17 && Reg.mapYcoords == 22 && FlxG.overlap(boss1A, player) && Reg._boss1AIsMala == true || Reg.mapXcoords == 12 && Reg.mapYcoords == 19 && FlxG.overlap(boss1B, player) && Reg._boss1BIsMala == true || Reg.mapXcoords == 15 && Reg.mapYcoords == 15 && FlxG.overlap(boss2, player) && Reg._boss2IsMala == true)
			{	
				// do nothing.
				_questionMark.active = false;
			} 
			else 
			{
				//FlxG.collide(enemies, player, EnemyCastSpriteCollide.enemyPlayerCollide);
				FlxG.overlap(enemies, player, EnemyCastSpriteCollide.enemyPlayerCollide);
				FlxG.overlap(enemiesNoCollideWithTileMap, player, EnemyCastSpriteCollide.enemyPlayerCollide);						
			}		
		}	
		
		FlxG.collide(_objectsThatDoNotMove, _bullets);
		FlxG.collide(_objectsThatDoNotMove, _bulletsMob);
		FlxG.collide(_objectsThatDoNotMove, _bulletsObject);
		
		//#################### MOVING PLATFORMS ###################
		FlxG.collide(_objectPlatformMoving, player, PlayStateTouchObjects.platformMovingPlayer);		
		//FlxG.collide(_objectPlatformMoving, enemies);
		FlxG.collide(_objectPlatformMoving, tilemap);
		FlxG.collide(_objectPlatformMoving, _objectPlatformMoving);
		FlxG.collide(_objectPlatformMoving, _objectBlockOrRock);
		
		FlxG.collide(_objectBlockOrRock, player, PlayStateTouchObjects.blockPlayerCollide);
		FlxG.collide(_objectBlockOrRock, enemies, EnemyCastSpriteCollide.blockEnemyCollide);
		FlxG.collide(_objectBlockOrRock, npcs);
		FlxG.collide(_objectBlockOrRock, tilemap);
		
		FlxG.collide(_objectTube, player);
		FlxG.collide(_objectTube, enemies);
		FlxG.collide(_objectTube, npcs);
		FlxG.collide(_objectTube, tilemap);
	
		//#################### overlays ############################
		FlxG.overlap(_objectWaterParameter, player, PlayStateTouchObjects.waterPlayerParameter);
		FlxG.overlap(_objectWaterParameter, enemies, EnemyCastSpriteCollide.waterEnemyParameter);		
		FlxG.overlap(_overlayWave, player, PlayStateTouchObjects.wavePlayer);		
		FlxG.overlap(_overlayWave, enemies, EnemyCastSpriteCollide.waveEnemy);	
		FlxG.overlap(_overlayAirBubble, player, PlayStateTouchObjects.airBubblePlayerOverlap);		
		FlxG.overlap(_overlayAirBubble, enemies, EnemyCastSpriteCollide.airBubbleEnemyOverlap);	
		
		FlxG.overlap(_objectBeamLaser, player, PlayStateTouchObjects.laserBeamPlayer);		
		FlxG.overlap(_objectBeamLaser, enemies, EnemyCastSpriteCollide.laserBeamEnemy);
		FlxG.collide(_objectBeamLaser, _objectLaserParameter);
		FlxG.collide(_objectSuperBlock, player, PlayStateTouchObjects.touchSuperBlock);
		FlxG.collide(_objectSuperBlock, enemies);
		FlxG.collide(_objectsThatDoNotMove, enemies);
		FlxG.collide(_objectsThatDoNotMove, player);
		FlxG.collide(_objectsThatDoNotMove, _objectsThatMove);
		
		// check if player is in the water. These values are from layer 5. they refer to water overlays. when a player overlaps one of these tiles the air countdown text will be displayed.
		if (FlxG.overlap(_overlayPipe, player) && player._mobInWater == true 
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 15 // water.
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 294
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 302
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 310
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 334
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 342
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 350
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 374
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 382
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 390
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 414
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 422
		|| Reg.state.overlays.getTile(Std.int(player.x / 32), Std.int(player.y / 32)) == 430
		|| FlxG.overlap(_objectWaterCurrent, player)
		) PlayStateTouchObjects.waterPlayer(player);
		
		// if no arrow key was pressed for a lenght of time then show the guidelines.
		if (Reg._guildlineInUseTicks > 30)
		{
			if (player._mobInWater == true) Reg._guildlineInUseTicks = 0;
			else
			{
				if (warningFallLine != null)
				{
					warningFallLine.visible = true;
					deathFallLine.visible = true;
					maximumJumpLine.visible = true;
				}
			}
		} 
		else if(Reg._guildlineInUseTicks == 0)
		{
			if (warningFallLine != null)
			{
				warningFallLine.visible = false;
				deathFallLine.visible = false;
				maximumJumpLine.visible = false;
			}
		}
		
		Reg._guildlineInUseTicks = Reg.incrementTicks(Reg._guildlineInUseTicks, 60 / Reg._framerate);
		
		if (Reg._itemGotFlyingHat == true && Reg._usingFlyingHat == true)
			flyingHat(player);
		
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["M"])) // display main menu choices.
			{ 
				Reg.exitGameMenu = true;  
				openSubState(new Dialog()); 				
			}		
		#end
		
		// hide this emitter mob hit damage if it is at the top-left corner of screen.
		if (_emitterMobsDamage.x < 128 && _emitterMobsDamage.y < 128) _emitterMobsDamage.visible = false;
		else _emitterMobsDamage.visible = true;
			
		//####################### ENTER / EXIT PIPE ########################
		// hide player, make player not solid when in pipes.
		if (FlxG.overlap(_overlayPipe, player)) 
		{
			player.offset.set(0, 12); // at interection, hide head of player from displaying.
			player.visible = false; 		
			
			if (player.velocity.y > 0) Reg._pipeVelocityY;
			if (player.velocity.y < 0) -Reg._pipeVelocityY;
			if (player.velocity.x > 0) Reg._pipeVelocityX;
			if (player.velocity.x < 0) -Reg._pipeVelocityX;
			if (Reg._itemGotGun == true)
			{
				_gun.visible = false; 
				_gunFlame.visible = false; 
				_gunFreeze.visible = false; // hide gun inside pipe.			
			}
		}
		else if (player._setPlayerOffset == true) 
		{
			player.offset.set(0, 0); 
			player.visible = true; 
			player.acceleration.x = player.acceleration.y = player._gravity; // set gravity. 
			player.drag.x = player._drag;			
			player._setPlayerOffset = false; // needed to play sound when re-entering pipe.
			
			
			if (   Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Gun."  
				|| Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Gun." 
				|| Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Gun.")
			{
				if (Reg._itemGotGun == true && Reg._typeOfGunCurrentlyUsed == 0) _gun.visible = true;
			}
				
			if (Reg._itemGotGunFlame == true && Reg._typeOfGunCurrentlyUsed == 1) 
				_gunFlame.visible = true; 
			if (Reg._itemGotGunFreeze == true && Reg._typeOfGunCurrentlyUsed == 2) 
				_gunFreeze.visible = true; 
				
		}
		//########################### END OF PIPE ###########################		
		
		// change to the next map when player is at the edge of the screen simular to how zelda does it.
		if (alive == true)
		{
			if (Reg.state.player.x < 2 && Reg._playerInsideCar == false || Reg.mapXcoords == 23 && Reg.mapYcoords == 19 && Reg.state._objectCar != null && Reg.state._objectCar.x < - 152 && Reg._playerInsideCar == true || Reg.state._objectCar != null && Reg.mapXcoords != 23 && Reg.state._objectCar.x < - 2 && Reg._playerInsideCar == true)
			{
				Reg.state.player.getCoords();
				
				if (Reg.mapXcoords == 27 && Reg.mapYcoords == 19 )
				{
					Reg.mapXcoords--; Reg.mapXcoords--; Reg.mapXcoords--;					
				}
				
				Reg.beginningOfGame = false;
				
				Reg.mapXcoords--;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg._update = false;
				FlxG.switchState(new PlayState());
			}
			
			// parallax car.
			if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19)
			{
				if (Reg.state.player.x > 3160 && Reg._playerInsideCar == false || Reg.state._objectCar != null &&  Reg.state._objectCar.x > 3198 && Reg._playerInsideCar == true)
				{
					Reg.beginningOfGame = false;
					Reg.state.player.getCoords();
					Reg.mapXcoords++; Reg.mapXcoords++; Reg.mapXcoords++; Reg.mapXcoords++;
					Reg._dogOnMap = false;
					Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
					Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
					Reg._update = false;
					FlxG.switchState(new PlayState());
				}
			}
			
			else if (Reg.state.player.x > 770 && Reg._playerInsideCar == false || Reg.state._objectCar != null &&  Reg.state._objectCar.x + 116 > 770 && Reg.mapXcoords == 22 && Reg.mapYcoords == 19 )
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapXcoords++;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg._update =  false;
				FlxG.switchState(new PlayState());
			}
			
			if (Reg.state.player.y < 2 && Reg._playerInsideCar == false )
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapYcoords--;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg.state._timeRemainingBeforeDeath.visible = false;
				Reg._update =  false;
				FlxG.switchState(new PlayState());
			}
			
			if (Reg.state.player.y > 450 && Reg._playerInsideCar == false )
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapYcoords++;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg.state._timeRemainingBeforeDeath.visible = false;
				Reg._update =  false;
				FlxG.switchState(new PlayState());
			}
		}
	
		super.update(elapsed);			
		
		//################## TILEMAP COLLIDE ##################		
		// without this code, the player will sometimes walk through a north-west sloped tile. the collide code needs to be called twice and the tilemapPlayerCollide function called outside of this code.
		FlxG.overlap(tilemap, player);
		FlxG.collide(tilemap, player);
		FlxG.collide(tilemap, player);
		PlayStateTouchObjects.tilemapPlayerCollide(tilemap, player);
		
		if (FlxG.overlap(tilemap, enemies)) FlxG.collide(tilemap, enemies);
		FlxG.collide(tilemap, enemies, EnemyCastSpriteCollide.tilemapEnemyCollide);
		
		FlxG.collide(tilemap, _emitterItemTriangle, PlayStateTouchObjects.tilemapParticalCollide);
		FlxG.collide(tilemap, _emitterItemHeart, PlayStateTouchObjects.tilemapParticalCollide);
		FlxG.collide(tilemap, _emitterItemNugget, PlayStateTouchObjects.tilemapParticalCollide);
		FlxG.collide(tilemap, npcs);
		FlxG.collide(tilemap, _objectsThatMove);
		
		
		
	}	
	
	function flyingHat(p:Player):Void
	{
		if (InputControls.up.pressed) 
		{
			p._yForce--;p._yForce = FlxMath.bound(p._yForce, -1, 1);		
			p.acceleration.y = p._yForce * p._maxYacceleration; // How fast the object accelerates horizontally when the Y value of the object is changed.		
				
			p.animation.play("flyingHat");
		}
		else if (InputControls.down.pressed) 
		{
			p._yForce++;p._yForce = FlxMath.bound(p._yForce, -1, 1);		
			p.acceleration.y = p._yForce * p._maxYacceleration; // How fast the object accelerates horizontally when the Y value of the object is changed.
			
			p.animation.play("flyingHat");
		} else p.velocity.y = 300;
		
		Reg._guildlineInUseTicks = 0;		
		Reg._playersYLastOnTile = p.y;  // no fall damage;
	}
	
	function replayCallback():Void
	{
		FlxG.vcr.stopReplay();
		Reg.resetRegVars();
		Reg._stopDemoFromPlaying = true;
		FlxG.switchState(new MenuState());
	}
	
	public function mainMenuChoices():Void
	{
			Reg.exitGameMenu = true;  
			openSubState(new Dialog()); 
	}
	
	public static function init():Void
	{
		//If this is the first time we've run the program, we initialize the TransitionData
		
		//When we set the default static transIn/transOut values, on construction all 
		//FlxTransitionableStates will use those values if their own transIn/transOut states are null
		FlxTransitionableState.defaultTransIn = new TransitionData();
		//FlxTransitionableState.defaultTransOut = new TransitionData();
		
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		
		FlxTransitionableState.defaultTransIn.tileData = { asset:diamond, width:32, height:32 };
		//FlxTransitionableState.defaultTransOut.tileData = { asset:diamond, width:32, height:32 };
		
		//Of course, this state has already been constructed, so we need to set a transOut value for it right now:
		//transOut = FlxTransitionableState.defaultTransOut;

		matchUI(false);
	}
	
	public static function matchUI(matchData:Bool=true):Void
	{
		var in_duration:Float = 0.3; // draw speed.
		var in_type:String = "tiles";
		var in_tile:String = "diamond";
		var in_tile_text:String = "diamond";
		var in_color:FlxColor = FlxColor.BLACK;
		var in_dir:String = "nw";
		
		/*var out_duration:Float = 1;
		var out_type:String = "tiles";
		var out_tile:String = "diamond";
		var out_tile_text:String = "diamond";
		var out_color:FlxColor = FlxColor.BLACK;
		var out_dir:String = "se";
		*/
		FlxTransitionableState.defaultTransIn.color = in_color;
		FlxTransitionableState.defaultTransIn.type = cast in_type;
		setDirectionFromStr(in_dir, FlxTransitionableState.defaultTransIn.direction);
		FlxTransitionableState.defaultTransIn.duration = in_duration;
		FlxTransitionableState.defaultTransIn.tileData.asset = getDefaultAsset(in_tile);
		/*
		FlxTransitionableState.defaultTransOut.color = out_color;
		FlxTransitionableState.defaultTransOut.type = cast out_type;
		setDirectionFromStr(out_dir, FlxTransitionableState.defaultTransOut.direction);
		FlxTransitionableState.defaultTransOut.duration = 1;
		FlxTransitionableState.defaultTransOut.tileData.asset = getDefaultAsset(out_tile);
		*/
		
	}
	
	public static function getDefaultAssetStr(c:FlxGraphic):String
	{
		return switch (c.assetsClass)
		{
			case GraphicTransTileCircle: "circle";
			case GraphicTransTileSquare: "square";
			case GraphicTransTileDiamond, _: "diamond";
		}
	}
	
	public static function getDefaultAsset(str):FlxGraphic
	{
		var graphicClass:Class<Dynamic> = switch (str)
		{
			case "circle": GraphicTransTileCircle;
			case "square": GraphicTransTileSquare;
			case "diamond", _: GraphicTransTileDiamond;
		}
		
		var graphic:FlxGraphic = FlxGraphic.fromClass(cast graphicClass);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		return graphic;
	}
			
	public static function setDirectionFromStr(str:String,p:FlxPoint=null):FlxPoint
	{
		if (p == null)
		{
			p = new FlxPoint();
		}
		switch (str)
		{
			case "n": p.set(0, -1);
			case "s": p.set(0, 1);
			case "w": p.set(-1, 0);
			case "e": p.set(1, 0);
			case "nw": p.set( -1, -1);
			case "ne": p.set(1, -1);
			case "sw":p.set( -1, 1);
			case "se":p.set(1, 1);
			default: p.set(0, 0);
		}
		return p;
	}
}
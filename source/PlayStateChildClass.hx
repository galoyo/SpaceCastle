package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxTrailEffect;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.ui.FlxUIState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateChildClass extends FlxUIState
{	
	private var recording:Bool = false;
	private var replaying:Bool = false;
	
	private var _emitterBulletHit:FlxEmitter;
	private var _emitterBulletMiss:FlxEmitter;	
	private var _emitterMobsDamage:FlxEmitter;
	private var _emitterDeath:FlxEmitter;
	private var _emitterItemTriangle:FlxEmitter;
	private var _emitterItemDiamond:FlxEmitter;
	private var _emitterItemPowerUp:FlxEmitter;
	private var _emitterItemNugget:FlxEmitter;
	private var _emitterItemHeart:FlxEmitter;
	private var _emitterCeilingHit:FlxEmitter;
	private var _emitterQuestionMark:FlxEmitter;
	private var _emitterSmokeRight:FlxEmitter;
	private var _emitterSmokeLeft:FlxEmitter;
	private var _emitterAirBubble:FlxEmitter;
	public var _emitterBulletFlame:FlxEmitter;
	public var _emitterWaterSplash:FlxEmitter;
	
	public var _gun:PlayerOverlayGun;
	public var _gunFlame:PlayerOverlayGunFlame;
	public var _gunFreeze:PlayerOverlayGunFreeze;
		
	public var _itemsThatWerePickedUp:FlxGroup;
	public var _itemFlyingHatPlatform:FlxGroup;	
	public var _itemGunFlame:FlxGroup;
	public var _itemGun:FlxGroup;
	public var _itemGunFreeze:FlxGroup;
	
	public var _objectLadders:FlxGroup; // needs to be in a group by itself.	
	public var _objectCage:FlxGroup; // this needs to be in a group by itself.
	public var _objectTube:FlxGroup; // this too.
	public var _objectDoor:FlxGroup;
	public var _objectsThatDoNotMove:FlxGroup;	
	public var _objectDoorToHouse:FlxGroup;	
	public var _objectPlatformMoving:FlxGroup;
	public var _objectGrassWeed:FlxGroup;	
	public var _objectTreasureChest:ObjectTreasureChest;	
	public var _objectComputer:ObjectComputer;		
	public var _objectFireball:FlxGroup;
	public var _objectFireballTween:FlxGroup;
	public var _objectBeamLaser:FlxGroup;
	public var _objectSuperBlock:FlxGroup;
	public var _objectWaterCurrent:FlxGroup;
	public var _objectPlatformParameter:FlxGroup;	
	public var _objectVineMoving:FlxGroup;
	public var _objectBlockOrRock:FlxGroup; // all blocks that do no damage should be in this group.	
	public var _objectFireballBlock:FlxGroup;
	public var _objectWaterParameter:FlxGroup;	
	public var _objectLaserParameter:FlxGroup;	
	public var _objectSign:FlxGroup;
	public var _objectTeleporter:FlxGroup;
	public var _rangedWeapon:FlxGroup;
	public var _jumpingPad:FlxGroup;
	public var _objectLavaBlock:FlxGroup;
	public var _tube:FlxGroup;
	
	// all still objects are within this group	
	public var _overlaysThatDoNotMove:FlxGroup;	
	public var _overlayLaserBeam:FlxGroup;		
	public var _overlayWave:FlxGroup;	
	public var _overlayWater:FlxGroup;
	public var _overlayAirBubble:FlxGroup;	
	public var _overlayPipe:FlxGroup;
	
	public var _objectLayer3OverlapOnly:FlxGroup;
	
	// These mobs are in the enemies group.
	public var mobApple:MobApple;
	public var mobSlime:MobSlime;	
	public var mobCutter:MobCutter;
	public var boss2:Boss2;
	public var mobBullet:MobBullet;
	public var mobTube:MobTube;
	public var mobBat:MobBat;
	public var mobSqu:MobSqu;
	public var mobFish:MobFish;
	public var mobGlob:MobGlob;
	public var mobWorm:MobWorm;
	public var mobExplode:MobExplode;
	
	public var boss1A:Boss1;
	public var boss1B:Boss1;
	public var mobBubble:MobBubble;
	public var npcDoctor:NpcDoctor;
	
	public var npcMalaUnhealthy:NpcMalaUnhealthy;
	public var npcMalaHealthy:NpcMalaHealthy;
	public var npcDogLady:NpcDogLady;
	public var npcDog:NpcDog;
	
	public var _bullets:FlxTypedGroup<Bullet>;	
	public var _bulletsMob:FlxTypedGroup<BulletMob>;
	private var _bulletsObject:FlxTypedGroup<BulletObject>;
	
	// player class.
	public var player:Player;
	
	private var _healthBars:FlxGroup;
	public var _healthBarPlayer:HealthBar;
	public var _bubbleHealthBar:FlxBar;
	
	// all mobs that collide will tilemaps are in this group.
	public var enemies:FlxGroup;
	// all mobs that do not collide will tilemaps but can collide with other mobs are in this group.	
	private var enemiesNoCollideWithTileMap:FlxGroup;
	private var npcs:FlxGroup; //  non-player characters (malas)
	
	public var _defenseMobFireball1:FlxSprite;
	public var _defenseMobFireball2:FlxSprite;
	public var _defenseMobFireball3:FlxSprite;
	public var _defenseMobFireball4:FlxSprite;
	
	public var _npcShovel:FlxGroup;	
	public var _npcWateringCan:FlxGroup;
	
	private var _trail:FlxTrailEffect;
	private var _tween:FlxTween;
	
	private var background:FlxSprite;
	private var _playerOnLadder:Bool = false;
	private var _playerJustExitedLadder:Bool = false;
	public var _touchingSuperBlock:Bool = false;
	
	private var _playWaterSound:Bool = true;
	public var _playWaterSoundEnemy:Bool = true;
	
	public var tilemap:FlxTilemapExt;
	public var underlays:FlxTilemap;
	public var overlays:FlxTilemap;
	private var foregroundImage:FlxBackdrop = new FlxBackdrop();
	
	// the inventory system across the top part of the screen.
	public var hud:Hud;
	
	public var _buttonsNavigation:ButtonsNavigation; // left, right, jump, etc, buttons at the bottom of the screen.
	
	// the text when an item is picked up or a char is talking.
	public var dialog:Dialog;

	private var _rain:FlxTypedGroup<ObjectRain>; // a group of flakes
	//private var _vPad:FlxVirtualPad;
	
	public var _ceilingHit:FlxTimer;
	public var _questionMark:FlxTimer;
	public var _waterPlayer:FlxTimer;
	public var _waterEnemy:FlxTimer;
	public var _playerAirRemainingTimer:FlxTimer;
	
	public var _ceilingHitFromMob:Bool;
	
	// save point.
	public var savePoint:FlxGroup;
	public var _fireballPositionInDegrees:Int;
	private var airLeftInLungsText:FlxText;
	public var _talkToHowManyMoreMalas:FlxText;
	public var _timeRemainingBeforeDeath:FlxText;
	
	public var warningFallLine:FlxSprite;
	public var deathFallLine:FlxSprite;
	public var maximumJumpLine:FlxSprite;
	public var _tracker:FlxSprite; // not visible. player looks beyond the game regions.	

	private var ticks = 0;
	public var _ticksTrackerUp:Float = 0;
	public var _ticksTrackerDown:Float = 0;
	
	private var _dogFound:Bool = false;
	
	// ######################################################
	// MOBS	
	// ######################################################
	override public function create():Void
	{
		super.create();
	}
	
	/**
	 * walks back and forth on a platform. no bullet ability.
	 */
	public function addMobApple(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		// when power is greater than 1, make it so that monsters at a higher level have a 66 percent chance of appearing.
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobApple = new MobApple(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobApple);

			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	Reg.state.mobApple, "health", 0, Reg.state.mobApple.health, false);		
			Reg.state._healthBars.add(_healthBar);
		}
	}

	/**
	 * moves back/forth by touching a wall. jumps over holes. no bullets.
	 */
	public function addMobCutter(X:Float, Y:Float, id:Int):Void
	{
		// normal walking monster that walks in one direction.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobCutter = new MobCutter(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobCutter);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobCutter, "health", 0, mobCutter.health, false);	
			_healthBars.add(_healthBar);
		}
	}
	
	/**
	 * higher id = faster movement. able to jump. bullets maybe.
	 */
	public function addMobSlime(X:Float, Y:Float, id:Int):Void
	{
		// the mobs in this class can jump.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobSlime = new MobSlime(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobSlime);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobSlime, "health", 0, mobSlime.health, false);		
			_healthBars.add(_healthBar);
		}
	}
	
	/**
	 * flies. warps to player when wall is a path obstacle. bullets.
	 */
	public function addBoss2(X:Float, Y:Float):Void
	{
		if (Reg._boss2Defeated == false)
		{
			boss2 = new Boss2(X, Y, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(boss2);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	boss2, "health", 0, boss2.health, false);		
			_healthBars.add(_healthBar);
		} else Reg._boss2IsMala = false;
	}
	
	/**
	 * only moves horizontally from one side of the screen to the other.
	 */
	public function addMobBullet(X:Float, Y:Float):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		mobBullet = new MobBullet(X, Y, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
		enemiesNoCollideWithTileMap.add(mobBullet);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobBullet, "health", 0, mobBullet.health, false);		
		_healthBars.add(_healthBar);		
	}
	
	public function addMobTube(X:Float, Y:Float):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		mobTube = new MobTube(X, Y, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
		enemiesNoCollideWithTileMap.add(mobTube);
	
	}
	
	/**
	 * moves randomly in the air. no bullets ability.
	 */
	public function addMobBat(X:Float, Y:Float, id:Int):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobBat = new MobBat(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobBat);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobBat, "health", 0, mobBat.health, false);		
			_healthBars.add(_healthBar);
		}
	}
	
	/**
	 * jump happy mob: no bullets.
	 */
	public function addMobSqu(X:Float, Y:Float, id:Int):Void
	{
		// x and y coords, _emitterMobsDamage is the effect seen when a mob is hit.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobSqu = new MobSqu(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobSqu);
			
			// the health bar displayed underneath the players legs.
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobSqu, "health", 0, mobSqu.health, false);		
			_healthBars.add(_healthBar);	
		}
	}
	
	/**
	 * NPC. looks like the player but yellow color. weak from the virus in the air.
	 */
	public function addNpcMalaUnhealthy(X:Float, Y:Float, id:Int):Void
	{
		npcMalaUnhealthy = new NpcMalaUnhealthy(X, Y, id);			
		npcs.add(npcMalaUnhealthy);
	}
	
	/**
	 * moves back/forth by touching a wall. no bullets. different speeds.
	 */
	public function addMobFish(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobFish = new MobFish(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobFish);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobFish, "health", 0, mobFish.health, false);		
			_healthBars.add(_healthBar);		
		}
	}
	
	/**
	 * moves on ceiling, walls or floors. slow movement. no bullets.
	 */
	public function addMobGlob(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobGlob = new MobGlob(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobGlob);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobGlob, "health", 0, mobGlob.health, false);	
			_healthBar.offset.set( -3, -6);
			_healthBars.add(_healthBar);	
		}
	}
	
	/**
	 * flies back and forth on an invisible horizontal line.
	 */
	public function addMobWorm(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			mobWorm = new MobWorm(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(mobWorm);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobWorm, "health", 0, mobWorm.health, false);	
			_healthBar.offset.set( -3, -6);
			_healthBars.add(_healthBar);
		}
	}

	/**
	 * mobExplode: This mob hangs from the ceiling shooting bullets in an angle. Fly towards player when they are near vertical. occupies two tiles.
	 */
	public function addMobExplode(X:Float, Y:Float):Void
	{
		mobExplode = new MobExplode(X, Y, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
		enemies.add(mobExplode);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, mobExplode, "health", 0, mobExplode.health, false);	
		_healthBar.offset.set( 0, -12);
		_healthBars.add(_healthBar);
	}
	
	/**
	 * Runs and jumps randomly.
	 */
	public function addBoss(X:Float, Y:Float, id:Int):Void
	{
		if (Reg._boss1ADefeated == false && id == 1)
		{
			boss1A = new Boss1(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(boss1A);
			
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	boss1A, "health", 0, boss1A.health, false);	
		_healthBar.offset.set( -3, -6);
		_healthBars.add(_healthBar);
		}
		
		if (Reg._boss1BDefeated == false && id == 2)
		{
			boss1B = new Boss1(X, Y, id, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
			enemies.add(boss1B);
			
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	boss1B, "health", 0, boss1B.health, false);	
		_healthBar.offset.set( -3, -30); // minus values = move down;
		_healthBars.add(_healthBar);
		}
	}
	
	/**
	 * NPC looks like the player. not sick from the bad air.
	 */
	public function addNpcMalaHealthy(X:Float, Y:Float, id:Int):Void
	{
		npcMalaHealthy = new NpcMalaHealthy(X, Y, id);
		npcs.add(npcMalaHealthy);
	}
	
	/**
	 * Boss. ??? (doctors friend).
	 */
	public function addMobBubble(X:Float, Y:Float):Void
	{
		if (Reg._boss1BDefeated == true && Reg.mapXcoords != 12 && Reg.mapYcoords != 19 || Reg._boss1BDefeated == false && Reg.mapXcoords == 12 && Reg.mapYcoords == 19)
		{
			mobBubble = new MobBubble(X, Y, player, _emitterMobsDamage, _emitterDeath, _emitterItemTriangle, _emitterItemDiamond, _emitterItemPowerUp, _emitterItemNugget, _emitterItemHeart, _emitterSmokeRight, _emitterSmokeLeft, _bulletsMob, _emitterBulletHit, _emitterBulletMiss);
		
			enemies.add(mobBubble);		
			
			Reg.fireballRandom = FlxG.random.float( 0.90, 1.10);
			
			_defenseMobFireball1 = new DefenseMobFireball(0,0);
			add(_defenseMobFireball1);
			
			_defenseMobFireball2 = new DefenseMobFireball(0,0);
			add(_defenseMobFireball2);
			
			_defenseMobFireball3 = new DefenseMobFireball(0,0);
			add(_defenseMobFireball3);
			
			_defenseMobFireball4 = new DefenseMobFireball(0,0);
			add(_defenseMobFireball4);
			
			// this is needed so that player can take damage from these fireballs.
			_objectFireballTween.add(_defenseMobFireball1);
			_objectFireballTween.add(_defenseMobFireball2);
			_objectFireballTween.add(_defenseMobFireball3);
			_objectFireballTween.add(_defenseMobFireball4);
			
			_bubbleHealthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	mobBubble, "health", 0, mobBubble.health, false);	
			_bubbleHealthBar.offset.set( -3, 0);
			_bubbleHealthBar.visible = false;
			_healthBars.add(_bubbleHealthBar);	
		}
	}
	
	/**
	 * ???
	 */
	public function addNpcDoctor(X:Float, Y:Float):Void
	{
		npcDoctor = new NpcDoctor(X, Y);
		npcs.add(npcDoctor);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	npcDoctor, "health", 0, npcDoctor.health, false);		
		_healthBars.add(_healthBar);		
	}
	
	/**
	 * NPC. talks about the doctor, his friends and how the malas became sick. needs help finding her dogs.
	 */
	public function addNpcDogLady(X:Float, Y:Float):Void
	{
		npcDogLady = new NpcDogLady(X, Y);
		npcs.add(npcDogLady);
	}
	
	/**
	 * NPC. player needs to collect 2 dogs to get a special block from the dog lady to advance in the game.
	 */
	public function addNpcDog(X:Float, Y:Float, P:Player, id:Int):Void
	{
		if (Reg._itemGotDogFlute == false) return;
		
		var _dogCarriedItsID2 = Reg._dogCarriedItsID.split(",");
		var _dogFoundAtMap2 = Reg._dogFoundAtMap.split(",");
		Reg._dogOnMap = true;
			
		// if dog lady is not on map and the dog on map is not currently carried then create dog at its position.
		if ( npcDogLady == null)
		{			
			for (i in 0..._dogFoundAtMap2.length)
			{	
				// was the dog picked up at map
				if (_dogFoundAtMap2[i] == Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse)
				{
					Reg._dogOnMap = false;
					break;
				}
			}		
			
			if (Reg._dogOnMap == true)
			{
				var idFound:Bool = false;
				
				for (i in 0..._dogCarriedItsID2.length)
				{						
					// is the dog currently carried?
					if (_dogCarriedItsID2[i] == Std.string(id))
					{
						idFound = true;
					}					
				}	
				
				// do this code block if the dog was not carried to the lady.
				if (idFound == false || Reg._dogCarried == true && Reg._dogCurrentlyCarried == id)
				{
					npcDog = new NpcDog(X, Y, P, id);
					npcs.add(npcDog);
				}
				else idFound = false;
			}
		}

			// loop through the _dogCarriedItsID2 array. if there is a match (id value of sprite and id value of _dogCarriedItsID2 var) then a dog was carried to the lady. she now has that dog. so display the dog beside her.
		if (npcDogLady != null)
		{
			for (i in 0..._dogCarriedItsID2.length)
			{	
				if (_dogCarriedItsID2[i] == Std.string(id))
				{
					if (_dogFoundAtMap2[i] != null)
					{
						npcDog = new NpcDog(X, Y, P, id);
						npcs.add(npcDog);	
						Reg._dogOnMap = true;
					}

				}
			}
		}
	}
	
		
	// ######################################################
	// ITEMS	
	// ######################################################
	
	/**
	 * add the diamonds to the map. collect all diamonds at the map for 1 health point increase.
	 */
	public function addDiamond(X:Float, Y:Float):Void
	{
		var paragraph = Reg._diamondCoords.split(",");
		var diamondsFoundOnMap:Bool = false;
		
		// loop through the paragraph array. if there is a match then a heart was picked up at the current map the player is at.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				diamondsFoundOnMap = true;
		}
		
		if (diamondsFoundOnMap == false)
		{
			// diamonds that the player collects/
			_itemsThatWerePickedUp.add(new ItemDiamond(X, Y));
			add(_itemsThatWerePickedUp);
			Reg.diamondsRemaining++;
		}		
		
	}
	
	/**
	 * add the door keys to the map. These key are different colored and open the same colored door.
	 */
	public function addItemDoorKey(X:Float, Y:Float, id:Int):Void
	{
		if (Reg._itemGotKey[id] == false)
		{
			_itemsThatWerePickedUp.add(new ItemDoorKey(X, Y, id));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the jump higher ability to the map.
	 */
	public function addItemJump(X:Float, Y:Float, I:Int):Void
	{
		if (Reg._itemGotJump[I] == false)
		{
			_itemsThatWerePickedUp.add(new ItemJump(X, Y, I));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flame gun to the map. 2 times more powerful than the normal gun. does not stop when hitting an object.
	 */
	public function addItemGunFlame(X:Float, Y:Float):Void
	{
		if (Reg._itemGotGunFlame == false)
		{
			_itemGunFlame.add(new ItemGunFlame(X, Y));
			add(_itemGunFlame);
		}
	}
	
	/**
	 * add the guns rapid fire to the map. increase the bullet speed of the normal gun.
	 */
	public function addItemGunRapidFire(X:Float, Y:Float):Void
	{
		if (Reg._itemGotGunRapidFire == false)
		{
			_itemsThatWerePickedUp.add(new ItemGunRapidFire(X, Y));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add a save point to the map.
	 */
	public function addSavePoint(X:Float, Y:Float):Void
	{
		savePoint.add(new SavePoint(X, Y));
		add(savePoint);
	}
	
	/**
	 * add a heath container to the map. collect these to increase health maximum by 3.
	 */
	public function addHeartContainer(X:Float, Y:Float):Void
	{
		var paragraph = Reg._healthContainerCoords.split(",");
		var heartContainerFound:Bool = false;
		
		// loop through the paragraph array. if there is a match then a heart was picked up at the current map the player is at.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				heartContainerFound = true;
		}
		// refilling or picking up health peices increases health but cannot go beyond the maximum health total number. heart container increases the maximum health total number by 3.
		if (heartContainerFound == false)
		{
			_itemsThatWerePickedUp.add(new ItemHeartContainer(X, Y));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flying hat to the map. able to fly but gravity will continue to pull the player down.
	 */
	public function addFlyingHat(X:Float, Y:Float):Void
	{
		if (Reg._itemGotFlyingHat == false)
		{
			_itemsThatWerePickedUp.add(new ItemFlyingHat(X, Y));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flying hat platform to the map. can only fly using the hat when at this platform.
	 */
	public function addFlyingHatPlatform(X:Float, Y:Float):Void
	{
		var flyingHatPlatform:ItemFlyingHatPlatform = new ItemFlyingHatPlatform(X, Y);
		_itemFlyingHatPlatform.add(flyingHatPlatform);
	}

	/**
	 * add the normal gun to the map.
	 */
	public function addItemGun(X:Float, Y:Float, id:Int = 1):Void
	{
		if (Reg._itemGotGun == false)
		{
			_itemGun.add(new ItemGun(X, Y, id));
			add(_itemGun);
		}
	}

	/**
	 * add a shovel to the map. must be placed beside the grass weed and at the other side of that shovel must be an unhealthy Mala.
	 */
	public function addNpcShovel(X:Float, Y:Float):Void
	{
		_npcShovel.add(new NpcShovel(X, Y));
			add(_npcShovel);
	}
	
	/**
	 * add the grass weed to the map. the malas beleave that the doctor needs lots of flowers from the grass weeds to cure them.
	 */
	public function addGrassWeed(X:Float, Y:Float, id:Int):Void
	{
		_objectGrassWeed.add(new ObjectGrassWeed(X, Y, id));
			add(_objectGrassWeed);
	}
	
	/**
	 * add the watering can to the map. place the watering can next to the weed and at the other side place an unhealthy mala.
	 */
	public function addWateringCan(X:Float, Y:Float):Void
	{
		_npcWateringCan.add(new NpcWateringCan(X, Y));
			add(_npcWateringCan);
	}
	
	/**
	 * add a ladder to the map. that ladder will not be seen so place an overlay or underlay ladder to the map on top of that ladder sprite.
	 */
	public function addLadder(X:Float, Y:Float, id:Int):Void
	{		
		var ladder:ObjectLadder = new ObjectLadder(X, Y, id);
		_objectLadders.add(ladder);
	}
	
	/**
	 * add a door to a house. currently, the house is a place to warp from one level to the next.
	 */
	public function addDoorHouse(X:Float, Y:Float):Void
	{		
		var door:ObjectDoorHouse = new ObjectDoorHouse(X, Y);
		_objectDoorToHouse.add(door);
	}
	
	/**
	 * collect treasure chest to get a bonus in score.
	 */
	public function addTreasureChest(X:Float, Y:Float):Void
	{		
		_objectTreasureChest = new ObjectTreasureChest(X, Y);
		_objectLayer3OverlapOnly.add(_objectTreasureChest);
	}
	
	/**
	 * ???
	 */
	public function addComputer(X:Float, Y:Float):Void
	{		
		_objectComputer = new ObjectComputer(X, Y);
		_objectLayer3OverlapOnly.add(_objectComputer);
	}
	
	/**
	 * add a super block to the map. these special blocks are needed to bypass an obstacle block of this type.
	 */
	public function addItemSuperBlock(X:Float, Y:Float, id:Int):Void
	{		
		if (Reg._itemGotSuperBlock[id] == false)
		{
			var superBlock:ItemSuperBlock = new ItemSuperBlock(X, Y, id);
			_itemsThatWerePickedUp.add(superBlock);
		}
	}	
	
	/**
	 * add a swimming skill to the map. picking up this item will enable player to swim not walk in the water.
	 */
	public function addItemSwimmingSkill(X:Float, Y:Float):Void
	{		
		if (Reg._itemGotSwimmingSkill == false)
		{
			var swimming:ItemSwimmingSkill = new ItemSwimmingSkill(X, Y);
			_itemsThatWerePickedUp.add(swimming);
		}
	}	
	
	/**
	 * add this item to the map. mob hit by this bullet will be frozen for a short time. at that time, player can jump on the mob.
	 */
	public function addItemGunFreeze(X:Float, Y:Float, id:Int = 2):Void
	{
		if (Reg._itemGotGunFreeze == false)
		{
			_itemGunFreeze.add(new ItemGun(X, Y, id));
			add(_itemGunFreeze);
		}
	}
	
	/**
	 * add this flute to the map. This flute will not be visible and is handing to the player by the dog lady. Plays a melody when at a map that has a dog and a buzz sound when not.
	 */
	public function addDogFlute(X:Float, Y:Float):Void
	{
		if (Reg._itemGotDogFlute == false)
		{
			_itemsThatWerePickedUp.add(new ItemDogFlute(X, Y));
			add(_itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add a swimming skill to the map. picking up this item will enable player to swim not walk in the water.
	 */
	public function addItemAnitgravitySuit(X:Float, Y:Float):Void
	{		
		if (Reg._itemGotAntigravitySuit == false)
		{
			_itemsThatWerePickedUp.add(new ItemAntigravitySuit(X, Y));
			add(_itemsThatWerePickedUp);
		}
	}
	
	// ################################################################
	// ####### OBJECTS
	// ################################################################
	
	/**
	 * add a spike trap the the map. one touch means big health damage.
	 */
	public function addSpikeTrap(X:Float, Y:Float, id:Int):Void
	{
		var spikeTrap:ObjectSpikeTrap = new ObjectSpikeTrap(X, Y, id);
		_objectsThatDoNotMove.add(spikeTrap);
	}
	
	/**
	 * add this to the map to block the player from leaving an area.
	 */
	public function addBarricade(X:Float, Y:Float):Void
	{
		var barricade:ObjectBarricade = new ObjectBarricade(X, Y);
		_objectsThatDoNotMove.add(barricade);
	}
	
	/**
	 * add a colored door to the map. can only be opened by the same colored key.
	 */
	public function addDoor(X:Float, Y:Float, id):Void
	{
		// east door.
		if (X > 13)
		{
			_objectDoor.add(new ObjectDoor(X, Y, id));
		} 
		
		// north door.
		else if(Y < 7)
		{
			_objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		// west door.
		else if(X < 11)
		{
			_objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		// south door.
		else if(Y > 9)
		{
			_objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		add(_objectDoor);
	}
	
	/**
	 * add a moving platform to the map.
	 */
	public function addPlatformMoving(X:Float, Y:Float, id:Int):Void
	{
		var platform:ObjectPlatformMoving = new ObjectPlatformMoving(X, Y, id);
		_objectPlatformMoving.add(platform);
	}
		
	/**
	 * add a fireball block to the map. the fireball will rotate around the block. 
	 */
	public function addObjectFireballBlock(X:Float, Y:Float):Void
	{
		_objectFireballBlock.add(new ObjectFireballBlock(X, Y));
		add(_objectFireballBlock);	
		
		Reg.fireballRandom = FlxG.random.float( 0.95, 1.15);
		_fireballPositionInDegrees = 359;			
		
		// add the four different fireball sprites at the fireball block.
		_objectFireball.add(new ObjectFireball1(X, Y));
			add(_objectFireball);
			
		_objectFireball.add(new ObjectFireball2(X, Y));
			add(_objectFireball);
			
		_objectFireball.add(new ObjectFireball3(X, Y));
			add(_objectFireball);
			
		_objectFireball.add(new ObjectFireball4(X, Y));
			add(_objectFireball);			
	}	
	
	/**
	 * add the laser beam to the map. This laser will move vertically starting from the ground then will touch the ceiling and then start over again. 
	 */
	public function addLaserBeam(X:Float, Y:Float):Void
	{
		_objectBeamLaser.add(new ObjectLaserBeam(X, Y));
		add(_objectBeamLaser);
	}
	
	/**
	 * add the disappearing block to the map. the player must time the jump to land on this block when it is visible. 
	 */
	public function addBlockDisappearing(X:Float, Y:Float, id:Int):Void
	{
		_objectBlockOrRock.add( new ObjectBlockDisappearing(X, Y, id));
		add(_objectBlockOrRock);
	}
	
	/**
	 * add the super block to the map. the player can only remove this block that stands in players way when player has an item of that type.
	 */
	public function addObjectSuperBlock(X:Float, Y:Float, id:Int):Void
	{		
		var superBlock:ObjectSuperBlock = new ObjectSuperBlock(X, Y, id);
		_objectSuperBlock.add(superBlock);
	}
	
	/**
	 * add the water current to the map. player is forced to swim in the direction of the current.
	 */
	public function addWaterCurrent(X:Float, Y:Float, id:Int):Void
	{		
		var waterCurrent:ObjectWaterCurrent = new ObjectWaterCurrent(X, Y, id);
		_objectWaterCurrent.add(waterCurrent);
	}
	
	/**
	 * add the moving vine to the map.
	 */	
	public function addVineMoving(X:Float, Y:Float, id:Int):Void
	{			
		// make a random var so that each vine moves at a different speed. to be used at the vine class.
		Reg._vineMovingSpeed = FlxG.random.float(Reg._vineMovingMinimumSpeed, Reg._vineMovingMaximumSpeed);
				
		// used to make every second vine move faster than the first so that is it possible to jump from vine to vine.
		if (Reg._vineToggleMovementSpeed == false) Reg._vineToggleMovementSpeed = true;
			else {Reg._vineToggleMovementSpeed = false; Reg._vineMovingSpeed = Reg._vineMovingSpeed * 1.2;}
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y, 1);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 10, 2);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 10, 3);
		add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 4);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 5);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 6);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 7);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 8);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 9);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 10);
		_objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving2 = new ObjectVineMoving2(X, Y = Y + 7, 11);
		_objectVineMoving.add(vine);
		
	}

	/**
	 * add the cannon that fires a cannon ball to the map.
	 */	
	public function addCannon(X:Float, Y:Float, id:Int):Void
	{
		var cannon:ObjectCannon = new ObjectCannon(X, Y, id, _bulletsObject, _emitterBulletHit, _emitterBulletMiss);
		_objectsThatDoNotMove.add(cannon);
	}
	
	/**
	 * add the cracked block that can only be destroyed by the normal gun
	 */	
	public function addBlockedCracked(X:Float, Y:Float):Void
	{
		var blockCracked:ObjectBlockCracked = new ObjectBlockCracked(X, Y, _emitterBulletFlame, _emitterDeath, _emitterBulletHit);
		_objectBlockOrRock.add(blockCracked);
	}

	/**
	 * add the sign to the map that has readable information.
	 */	
	public function addSign(X:Float, Y:Float, id:Int):Void
	{
		var sign:ObjectSign = new ObjectSign(X, Y, id);
		_objectSign.add(sign);
	}
	
	/**
	 * add the different rocks to the map.
	 */	
	public function addRock(X:Float, Y:Float, id:Int):Void
	{
		_objectBlockOrRock.add( new ObjectRock(X, Y, id));
		add(_objectBlockOrRock);
	}
	
	/**
	 * add a teleporter to the map. used to teleport to a different level. needs a different key to activate a new level to teleport to.
	 */	
	public function addTeleporter(X:Float, Y:Float):Void
	{
		_objectTeleporter.add( new ObjectTeleporter(X, Y));
		add(_objectTeleporter);
	}
	
	/**
	 * add a spike that hangs from the ceiling and falls when the player is vertically close to the spike.
	 */	
	public function addSpikeFalling(X:Float, Y:Float):Void
	{
		_rangedWeapon.add( new ObjectSpikeFalling(X, Y));
		add(_rangedWeapon);
	}
	
	
	public function addJumpingPad(X:Float, Y:Float, id:Int):Void
	{
		_jumpingPad.add( new ObjectJumpingPad(X, Y, id));
		add(_jumpingPad);
	}
	/**
	 * add a mala cage to the map. malas placed at the bottom of the cage will appear to be inside the cage with game is played.
	 */	
	public function addCage(X:Float, Y:Float, id:Int):Void
	{
		var cage:ObjectCage = new ObjectCage(X, Y, id);
		_objectCage.add(cage);
	}
	
	/**
	 * add a lava block to the map. every once in awhile damage will be given to the mob or player that touches this block.
	 */
	public function addLavaBlock(X:Float, Y:Float):Void
	{
		_objectLavaBlock.add( new ObjectLavaBlock(X, Y));
		add(_objectLavaBlock);
	}
	
	/**
	 * add a tube to the map. a monster exits this tube then flies towards the player.
	 */
	public function addTube(X:Float, Y:Float):Void
	{
		var tube:ObjectTube = new ObjectTube(X, Y);
		_objectTube.add(tube); 
	}
	
	// ###############################################################
	// ADD OVERLAYS
	// ###############################################################
	
	/**
	 * add a water wave to the map. a water wave if tghe surface of the water.
	 */
	public function addWave(X:Float, Y:Float):Void
	{
		var wave:OverlayWave = new OverlayWave(X, Y);
		_overlayWave.add(wave);
	}
	
	/**
	 * add the body of the water to the map. this is water, deep water, ect.
	 */
	public function addWater(X:Float, Y:Float):Void
	{
		var water:OverlayWater = new OverlayWater(X, Y);
		_overlayWater.add(water);
	}
	
	/**
	 * add a water parameter to the map. must be place above the water wave so that game knowns when water is entered or exited.
	 */
	public function addWaterParameter(X:Float, Y:Float):Void
	{
		var waterParameter:ObjectWaterParameter = new ObjectWaterParameter(X, Y);
		_objectWaterParameter.add(waterParameter);
	}
	
	/**
	 * add the air bubble to the map. player is able to breath underwater at an air bubble location.
	 */
	public function addAirBubble(X:Float, Y:Float):Void
	{
		var airBubble:OverlayAirBubble = new OverlayAirBubble(X, Y);
		_overlayAirBubble.add(airBubble);
		
		_emitterAirBubble.focusOn(airBubble);
		_emitterAirBubble.start(false, 0.05, 0);
	}
	
	/**
	 * add a laser block to the map. ../readme dev/README FIRST.txt for more information.
	 */
	public function addLaserBlock(X:Float, Y:Float, id:Int):Void
	{
		var laser:OverlayLaserBlocks = new OverlayLaserBlocks(X, Y, id);
		// the yellow overlay block used for the laser is in a different group than the orange laser block. the reason is that this stops a mob from waiting for the laser to not be in its current path when standing near the brown block. 
		if (id == 1) _overlayLaserBeam.add(laser);
		else _overlaysThatDoNotMove.add(laser);		
	}
	
	/**
	 * add a laser parameter to the map. ../readme dev/README FIRST.txt for more information.
	 */
	public function addLaserParameter(X:Float, Y:Float):Void
	{
		var laserParameter:ObjectLaserParameter = new ObjectLaserParameter(X, Y);
		_objectLaserParameter.add(laserParameter);
	}
	
	/**
	 * add a pipe1 segment to the map.
	 */
	public function addPipe1(X:Float, Y:Float, id:Int):Void
	{
		var pipe:OverlayPipe1 = new OverlayPipe1(X, Y, id);
		_overlayPipe.add(pipe);
	}
	
	/**
	 * add a pipe2 segment to the map.
	 */
	public function addPipe2(X:Float, Y:Float, id:Int):Void
	{
		var pipe:OverlayPipe2 = new OverlayPipe2(X, Y, id);
		_overlayPipe.add(pipe);
	}
	
	/**
	 * add a platform parameter to the map. a moving platform will change direction when touching a wall or this object.
	 */
	public function addPlatformParameter(X:Float, Y:Float):Void
	{
		var platformParameter:ObjectPlatformParameter = new ObjectPlatformParameter(X, Y);
		_objectPlatformParameter.add(platformParameter);
	}

}
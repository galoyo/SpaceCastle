package;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import openfl.display.StageQuality;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxTrailEffect;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.ui.FlxUIState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


/**
 * @author galoyo
 */

class PlayState extends FlxUIState
{
	public var recording:Bool = false;
	public var replaying:Bool = false;	
	
	public var _emitterMobsDamage:FlxEmitter;
	public var _emitterDeath:FlxEmitter;
	public var _emitterItemTriangle:FlxEmitter;
	public var _emitterItemDiamond:FlxEmitter;
	public var _emitterItemPowerUp:FlxEmitter;
	public var _emitterItemNugget:FlxEmitter;
	public var _emitterItemHeart:FlxEmitter;
	public var _particleSmokeRight:FlxEmitter;
	public var _particleSmokeLeft:FlxEmitter;	
	public var _emitterBulletFlame:FlxEmitter;
	public var _particleWaterSplash:FlxEmitter;
	public var _emitterSkillDash:FlxEmitter;
	
	public var _particleCeilingHit:FlxEmitter;
	public var _particleQuestionMark:FlxEmitter;
	public var _particleBulletHit:FlxEmitter;
	public var _particleBulletMiss:FlxEmitter;	
	public var _particleAirBubble:FlxEmitter;
	
	public var _gun:PlayerOverlayGun;
	public var _gunFlame:PlayerOverlayGunFlame;
	public var _gunFreeze:PlayerOverlayGunFreeze;
		
	public var _itemsThatWerePickedUp:FlxGroup;
	public var _itemFlyingHatPlatform:FlxGroup;	
	public var _itemGunFlame:FlxGroup;
	public var _itemGun:FlxGroup;
	public var _itemGunFreeze:FlxGroup;
	
	// other items are made at reg.hx.
	
	public var _objectLadders:FlxGroup; // needs to be in a group by itself.	
	public var _objectCage:FlxGroup; // this needs to be in a group by itself.
	public var _objectTube:FlxGroup; // this too.
	public var _objectDoor:FlxGroup;
	public var _objectsThatDoNotMove:FlxGroup;	
	public var _objectsThatMove:FlxGroup;	
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
	public var _jumpingPad:FlxGroup;
	public var _objectLavaBlock:FlxGroup;
	public var _objectQuickSand:FlxGroup;
	public var _objectCar:ObjectCar;
	
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
	public var mobSaw:MobSaw;
	
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
	public var _bulletsObject:FlxTypedGroup<BulletObject>;
	
	// player class.
	public var player:Player;
	
	public var _healthBars:FlxGroup;
	public var _healthBarPlayer:HealthBar;
	public var _bubbleHealthBar:FlxBar;
	
	// all mobs that collide will tilemaps are in this group.
	public var enemies:FlxGroup;
	// all mobs that do not collide will tilemaps but can collide with other mobs are in this group.	
	public var enemiesNoCollideWithTileMap:FlxGroup;
	public var npcs:FlxGroup; //  non-player characters (malas)
	
	public var _defenseMobFireball1:FlxSprite;
	public var _defenseMobFireball2:FlxSprite;
	public var _defenseMobFireball3:FlxSprite;
	public var _defenseMobFireball4:FlxSprite;
	
	public var _npcShovel:FlxGroup;	
	public var _npcWateringCan:FlxGroup;
	
	public var _trail:FlxTrailEffect;
	public var _tween:FlxTween;
	
	public var background:FlxSprite;
	public var _playerOnLadder:Bool = false;
	public var _playerJustExitedLadder:Bool = false;
	public var _touchingSuperBlock:Bool = false;
	
	public var _playWaterSound:Bool = true;
	public var _playWaterSoundEnemy:Bool = true;
	
	public var tilemap:FlxTilemapExt;
	public var underlays:FlxTilemap;
	public var overlays:FlxTilemap;
	public var foregroundImage:FlxBackdrop;	
	
	// the inventory system across the top part of the screen.
	public var hud:Hud;
	
	public var _buttonsNavigation:ButtonsNavigation; // left, right, jump, etc, buttons at the bottom of the screen.
	
	// the text when an item is picked up or a char is talking.
	public var dialog:Dialog;

	public var _rain:FlxTypedGroup<ObjectRain>; // a group of flakes
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
	public var airLeftInLungsText:FlxText;
	public var _talkToHowManyMoreMalas:FlxText;
	public var _timeRemainingBeforeDeath:FlxText;
	
	public var warningFallLine:FlxSprite;
	public var deathFallLine:FlxSprite;
	public var maximumJumpLine:FlxSprite;
	public var _tracker:FlxSprite; // not visible. player looks beyond the game regions.	

	public var ticks = 0;
	public var _ticksTrackerUp:Float = 0;
	public var _ticksTrackerDown:Float = 0;
	
	public var _dogFound:Bool = false;
	
	override public function create():Void
	{
		Reg._update = true;
		
		// near the bottom of this constructor, if you plan to use more than 2 dogs then uncomment those two lines with id 3 and 4.
		
		// Multiple overlap between two objects. https://github.com/HaxeFlixel/flixel/issues/1247 uncomment the following to fix the issue. might lose small cpu preformance. you don't use many callbacks so this is currently not a concern.
		//FlxG.worldDivisions = 1;
		FlxG.worldBounds.set(); 
		
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
		
		// some music that is invalid need to be saved with the free program Audacity.
		// music1.ogg must be in the music folder for this music to play.
		//FlxG.sound.playMusic("music1", 1, true); // also make music1 in project.xml. see the music section of that file.
		
		// reset var values here.
		
		//FlxG.mouse.visible = false;
		
		// smooth the image.
		//FlxG.stage.quality = StageQuality.BEST;
		//FlxG.camera.antialiasing = true;
		//FlxG.camera.pixelPerfectRender = true;
				
		Reg.diamondsRemaining = 0;
		Reg.state = this;
		Reg._playerAirIsDecreasing = false;
		
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
		
		hud = new Hud();		
		add(hud);		
		
		// bad hack to display the gun power when trangles are zero.
		hud.decreaseGunPowerCollected();
		hud.increaseGunPowerCollected();
				
		// add the guns.
		_gun = new PlayerOverlayGun(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gun);

		_gunFlame = new PlayerOverlayGunFlame(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gunFlame);
		
		_gunFreeze = new PlayerOverlayGunFreeze(Reg.state.player.x+15, Reg.state.player.y+21);
		add(_gunFreeze);
				
		FlxG.camera.bgColor = FlxColor.TRANSPARENT;	
		setCamera();
		
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
		
		_tracker = new FlxSprite(0, 0);
		_tracker.makeGraphic(28, 28, 0x00FFFFFF);
		add(_tracker);
		
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
		
		if (Reg._backgroundSounds == true) FlxG.sound.play("backgroundSounds", 0.25, true);
		
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
		// if you want to play the recorded demo then uncomment this block only after you have recording a demo located at the top of update() function at this file. if you uncomment this block then you need to comment the recording code block at the top of the update() function at this file.
		if (Reg._playRecordedDemo == true)
		{			
			Reg._playRecordedDemo = false;
			Reg._noTransitionEffectDemoPlaying = true;
			
			FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr"), new PlayState(),["ANY"],0,replayCallback);

		}
		//##################### END OF RECORDING CODE BLOCK ####################
		
		// display the diamond transition effect before a map is displayed?
		if (Reg._transitionEffectEnable == true && Reg._noTransitionEffectDemoPlaying == false)
		{
			init();
		}
		
		_buttonsNavigation = new ButtonsNavigation();	
		add(_buttonsNavigation);
		
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

	// ################################################################
	// update - camera
	// ################################################################
	function setCamera():Void
	{
		
		if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19 )
		{
			if (Reg._playerInsideCar == true)
				FlxG.camera.follow(_objectCar, FlxCameraFollowStyle.TOPDOWN);	// make the camera follow the car.
			else FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN);
		}
		else 
			FlxG.camera.follow(player, FlxCameraFollowStyle.SCREEN_BY_SCREEN); // make player walk to sides of screen.
			
		// do not display anything outside of the current map displayed.
		FlxG.camera.setScrollBoundsRect(0, -60, tilemap.width - Reg._tileSize + 32, tilemap.height - Reg._tileSize + 155, true);		

	}
	
	override public function update(elapsed:Float):Void
	{			
		//################ RECORDING DEMO BLOCK #####################
		//to record a demo you need to uncomment this block and you need to comment the recording code block near the bottom of the create() function at this file. search for the keyword "record".
		
		// remember to change the framerate at options before recording. at playstate.hx press 8 to record and press 9 to save the recording and save the file "replay-60.fgr", "replay-120.fgr", etc to the assests/data directory.
		/*if (FlxG.keys.anyJustPressed(["EIGHT"]) && !recording && !replaying) {recording = true; replaying = false; FlxG.vcr.startRecording(true);} 
		if (FlxG.keys.anyJustPressed(["NINE"])) FlxG.vcr.stopRecording();
		if (FlxG.keys.anyJustPressed(["ZERO"])) {replaying = false; FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr")); }*/
		//################ END RECORDING DEMO BLOCK #################
		
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
		if (InputControls.i.justReleased)
		{
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
		if (Reg._talkedToDoctorAtDogLady == true)
		{
			Reg._talkedToDoctorAtDogLady = false;
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
				
				if ( Reg._powerUpStopFlicker == true)
				{
					Reg._powerUpStopFlicker = false;
					FlxSpriteUtil.stopFlickering(Reg.state.player);
				}
			}
		}
	
		// enter key was pressed after replying to a dialog question.
		if (Reg.dialogIconFilename == "savePoint.png" && Reg._dialogAnsweredYes == true)
		{
			if (Reg.dialogIconFilename == "savePoint.png")
				FlxG.overlap(savePoint, player, PlayStateTouchItems.touchSavePoint);
			
			Reg._dialogAnsweredYes = false;
		}
		
		PlayStateDownKey.downKeyAndTracker(); // Down key and tracker.

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
		if (FlxG.overlap(_overlayPipe, player) && player._mobIsSwimming == true 
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
		if (Reg._arrowKeyInUseTicks > 30)
		{
			if (player._mobIsSwimming == true) Reg._arrowKeyInUseTicks = 0;
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
		else if(Reg._arrowKeyInUseTicks == 0)
		{
			if (warningFallLine != null)
			{
				warningFallLine.visible = false;
				deathFallLine.visible = false;
				maximumJumpLine.visible = false;
			}
		}
		
		Reg._arrowKeyInUseTicks = Reg.incrementTicks(Reg._arrowKeyInUseTicks, 60 / Reg._framerate);
		
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
	
	function winGame(e:FlxSprite, p:Player):Void
	{
		// stop the player from moving when touching the exit, the floor and has not yet
		// won the game.
		if (p.isTouching(FlxObject.FLOOR) && !p.hasWon) {
			p.velocity.x = 0;
			p.acceleration.x = 0;

			p.hasWon = true;

			// goto the funtion that calls the playState.hx file.
			PlayStateMiscellaneous.leaveMap(p);
		}
	}
	
	function flyingHat(p:Player):Void
	{
		if (InputControls.up.pressed) 
		{
			p.yForce--;p.yForce = FlxMath.bound(p.yForce, -1, 1);		
			p.acceleration.y = p.yForce * p._yMaxAcceleration;			
				
			p.animation.play("flyingHat");
		}
		else if (InputControls.down.pressed) 
		{
			p.yForce++;p.yForce = FlxMath.bound(p.yForce, -1, 1);		
			p.acceleration.y = p.yForce * p._yMaxAcceleration;
			
			p.animation.play("flyingHat");
		} else p.velocity.y = 300;
		
		Reg._arrowKeyInUseTicks = 0;		
		Reg._playersYLastOnTile = p.y;  // no fall damage;
	}
	
	function replayCallback():Void
	{
		Reg.resetRegVars();
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
package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.tile.FlxTilemapExt;
import flixel.effects.particles.FlxEmitter;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import haxe.Timer;
import openfl.Assets; 
import openfl.display.StageQuality;
/**
 * @author galoyo
 */

class PlayState extends PlayStateDownKey
{
	override public function create():Void
	{
		// near the bottom of this constructor, if you plan to use more than 2 dogs then uncomment those two lines with id 3 and 4.
		
		// Multiple overlap between two objects. https://github.com/HaxeFlixel/flixel/issues/1247 uncomment the following to fix the issue. might lose small cpu preformance. you don't use many callbacks so this is currently not a concern.
		//FlxG.worldDivisions = 1;
		FlxG.worldBounds.set(); 
		
		// display the diamond transition effect before a map is displayed?
		if (Reg._transitionEffectEnable == true)
		{
			// bad hack to load the initialize the transition.
			if (Reg._transitionInitialized == false)
			{
				camera.visible = false;
				FlxG.sound.volume = 0;
				Transition.init();
				FlxG.switchState(new PlayState());
			} 
			else
			{
				FlxG.sound.volume = 1;
				camera.visible = true;
			}
		}
			
		// reset important dog vars.
		for (i in 1...5)
		{
			Reg._dogExistsAtMap[i] = false;
		}
		Reg._dogIsVisible = true;
		
		// stop vertical lines on tilemap when player is in motion.
		FlxG.camera.pixelPerfectRender = true; 
		
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
		createLayer0Tilemap();
		
		// setup the bullet star emitter		
		_emitterBulletHit = new FlxEmitter();
		_emitterBulletHit.maxSize = 50;
		for (i in 0..._emitterBulletHit.maxSize) _emitterBulletHit.add(new EmitterBulletHit());
		_emitterBulletHit.lifespan.set(0.2);
		
		_emitterCeilingHit = new FlxEmitter();
		_emitterCeilingHit.maxSize = 5;
		for (i in 0..._emitterCeilingHit.maxSize) _emitterCeilingHit.add(new EmitterCeilingHit());
		_emitterCeilingHit.lifespan.set(0.2);
		
		_emitterQuestionMark = new FlxEmitter();
		_emitterQuestionMark.maxSize = 20;
		for (i in 0..._emitterQuestionMark.maxSize) _emitterQuestionMark.add(new EmitterQuestionMark());
		_emitterQuestionMark.lifespan.set(0.4);
		
		_emitterBulletMiss = new FlxEmitter();
		_emitterBulletMiss.maxSize = 50;
		for (i in 0..._emitterBulletMiss.maxSize) _emitterBulletMiss.add(new EmitterBulletMiss());
		_emitterBulletMiss.lifespan.set(0.2);	
		
		_emitterWaterSplash = new FlxEmitter();
		_emitterWaterSplash.maxSize = 15;
		for (i in 0..._emitterWaterSplash.maxSize) _emitterWaterSplash.add(new EmitterWaterSplash());
		_emitterWaterSplash.lifespan.set(0.2);
		
		_emitterSmokeRight = new FlxEmitter();
		_emitterSmokeRight.maxSize = 40; // enough for four mobBullets on the screen at same time.
		for (i in 0..._emitterSmokeRight.maxSize) _emitterSmokeRight.add(new EmitterSmokeRight());
		_emitterSmokeRight.lifespan.set(0.15);
		
		_emitterSmokeLeft = new FlxEmitter();
		_emitterSmokeLeft.maxSize = 40; // enough for four mobBullets on the screen at same time.
		for (i in 0..._emitterSmokeLeft.maxSize) _emitterSmokeLeft.add(new EmitterSmokeLeft());
		_emitterSmokeLeft.lifespan.set(0.15);
		
		_emitterAirBubble = new FlxEmitter();
		_emitterAirBubble.maxSize = 40;
		for (i in 0..._emitterAirBubble.maxSize) _emitterAirBubble.add(new EmitterAirBubble());
		_emitterAirBubble.lifespan.set(0.2);
		
		_emitterBulletFlame = new EmitterBulletFlame();
		_emitterMobsDamage = new EmitterMobsDamage();
		_emitterDeath = new EmitterDeath();
		_emitterItemTriangle = new EmitterItemTriangle();
		_emitterItemDiamond = new EmitterItemDiamond();
		_emitterItemPowerUp = new EmitterItemPowerUp();
		_emitterItemNugget = new EmitterItemNugget();
		_emitterItemHeart = new EmitterItemHeart();
		
		_bullets = new FlxTypedGroup<Bullet>(0);
		_bulletsMob = new FlxTypedGroup<BulletMob>(0);
		_bulletsObject = new FlxTypedGroup<BulletObject>(0);								
				
		add(_healthBars);
		
		_objectCage = new FlxGroup();

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
		
		createLayer1UnderlaysTiles();
		createLayer2Player();			
		createSpriteGroups();		
		createLayer3Sprites();
		
		add(_emitterBulletHit);
		add(_emitterCeilingHit);
		add(_emitterQuestionMark);
		add(_emitterBulletMiss);	
		add(_emitterBulletFlame);
		add(_emitterMobsDamage);
		add(_emitterDeath);
		add(_emitterItemHeart);
		add(_emitterItemTriangle);
		add(_emitterItemDiamond);
		add(_emitterItemPowerUp);
		add(_emitterItemNugget);
		add(_emitterWaterSplash);
		add(_emitterSmokeRight);		
		add(_emitterSmokeLeft);		
		
		createOverlaysGroups();
		createLayer4OverlaySprites();
		createLayer5OverlaysTiles();
		
		add(_objectWaterParameter);
		add(_objectLaserParameter);
		add(_objectPlatformParameter);
		
		// add overlay objects after overlay tilemap.
		add(_overlayWave);
		add(_overlayWater);		
		add(_emitterAirBubble);
		add(_overlayAirBubble);		
		add(_overlayPipe);
		
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
				
		FlxG.camera.bgColor = 0xFF0000FF;		
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
		
		guidelines(); // display the fall/jump guide lines.
		
		_tracker = new FlxSprite(0, 0);
		_tracker.makeGraphic(28, 28, 0x00FFFFFF);
		add(_tracker);
	
		if (Reg._musicEnabled == true && Reg._transitionInitialized == true || Reg._musicEnabled == true && Reg._transitionEffectEnable == false) 
		{
			if (Reg.mapXcoords == 24 && Reg.mapYcoords >= 21 && Reg.mapYcoords <= 24 ) 
			{
				FlxG.sound.music.persist = true;
			}
			else  
			playMusicIntro(); // played when entering a house, cave, ect.
			
		}	
		
		if (Reg._backgroundSounds == true) FlxG.sound.play("backgroundSounds", 0.25, true);
		
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
		
		//################# KEEP THIS CODE AT THE BOTTOM OF THIS FUNCTION.
		//################################################################
		//check if dog exists on the map. if no dog exists then create the dogs at the top left corner of the screen. There needs to be dogs at each level, some hidden some not, so that a dog can be carried from one map to another. if there are dogs that exists, then there should be one dog that can be found while the other dog cannot. when carried the dog can be seen at another map when there is a dog with the id that is hidden. the following code makes that happen.
		Reg._dogStopMoving = true;
		if (Reg._dogExistsAtMap[1] == false) addNpcDog(0, 0, player, 1);
		if (Reg._dogExistsAtMap[2] == false) addNpcDog(0, 0, player, 2);				
		//if (Reg._dogExistsAtMap[3] == false) addNpcDog(0, 0, player, 3);
		//if (Reg._dogExistsAtMap[4] == false) addNpcDog(0, 0, player, 4);	
		Reg._dogStopMoving = false;
		
		if (Reg._transitionEffectEnable == true) Transition.init();
		
		//##################### RECORDING CODE BLOCK ####################
		// if you want to play the recorded demo then uncomment this block only after you have recording a demo located at the top of update() function at this file. if you uncomment this block then you need to comment the recording code block at the top of the update() function at this file.
		if (Reg._playRecordedDemo == true)
		{			
			Reg._playRecordedDemo = false;
			
			if (Reg._transitionInitialized == true) FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr"), new PlayState(),["ANY"],0,replayCallback);
			else FlxG.vcr.loadReplay(openfl.Assets.getText("assets/data/replay-"+Reg._framerate+".fgr"),new PlayState(),["ANY"],0,replayCallback); 
		}
		//##################### END OF RECORDING CODE BLOCK ####################
		
		_buttonsNavigation = new ButtonsNavigation();	
		add(_buttonsNavigation);
		super.create();
	}
		
	function createLayer0Tilemap():Void
	{
		
		// the background image.
		//backdropImage = new FlxBackdrop("assets/images/background7.png", 0, 0, false, false, 0, 0);
		//add(backdropImage);
		
		if (Reg._inHouse == "" ) // not in house.
		{	
			//############## background set.
			var bgSet:Int = 1;
			
			// reset the ticks after all the image backgrounds have been displayed. if _changeToDayOrNightBgsAtPageLoad is set to 10 then for 0 to 10 the cartoon bg is displayed while 11 to 20 the stars background is displayed. anything greater than 20 and the ticks are reset back so that once again the cartoon bg can be displayed.
			if (Reg._changeToDayOrNightBgsAtPageLoadTicks >= Reg._changeToDayOrNightBgsAtPageLoad * 2)
			Reg._changeToDayOrNightBgsAtPageLoadTicks = 0;
			
			Reg._changeToDayOrNightBgsAtPageLoadTicks++;
			
			// display the cartoon background until the amount _changeToDayOrNightBgsAtPageLoad and then display the image until the amount of _changeToDayOrNightBgsAtPageLoad * 10;
			if (Reg._changeToDayOrNightBgsAtPageLoadTicks <= Reg._changeToDayOrNightBgsAtPageLoad)
			{
				bgSet = 1;
			}
			
			else if (Reg._changeToDayOrNightBgsAtPageLoadTicks > Reg._changeToDayOrNightBgsAtPageLoad)
			{
				bgSet = 2;
			}
			//-----------------------------------------------
			
			var bg:Int = 0;
			if (FlxMath.isEven(Reg.mapXcoords) == true && FlxMath.isEven(Reg.mapYcoords) == true) 
			bg = 1;			
			if (FlxMath.isOdd(Reg.mapXcoords) == true && FlxMath.isOdd(Reg.mapYcoords) == true) 
			bg = 2;
			if (FlxMath.isEven(Reg.mapXcoords) == true && FlxMath.isOdd(Reg.mapYcoords) == true) 
			bg = 3;
			if (FlxMath.isOdd(Reg.mapXcoords) == true && FlxMath.isEven(Reg.mapYcoords) == true) 
			bg = 4;
			
			background = new FlxSprite();
			
			if (Reg.mapXcoords >= 24 && Reg.mapYcoords >= 24)
				{
					FlxG.camera.color = 0xFF999999;
					background.loadGraphic("assets/images/background2.jpg", false);
				}
			else background.loadGraphic("assets/images/background"+bgSet+"-"+bg+".jpg", false);
			background.scrollFactor.set(0.2,0.2);
			background.setPosition(0, 0);
			add(background);	
		}
		
		// we're going to have some rain or ash flakes drifting down at different 'levels'. We need a lot of them for the effect to work nicely
		/*_rain = new FlxTypedGroup<ObjectRain>();
		add(_rain);
		
		for (i in 0...1200)
		{
			_rain.add(new ObjectRain(i % 10));
		}*/
	
		tilemap = new FlxTilemapExt();		
		if (Reg._testItems == false) tilemap.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse + "_Layer 0 tiles.csv"), "assets/images/map0Tiles.png", Reg._tileSize, Reg._tileSize);
		else tilemap.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items_Layer 0 tiles.csv"), "assets/images/map0Tiles.png", Reg._tileSize, Reg._tileSize);
		
		var levelTiles:FlxTileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/map0Tiles.png", new FlxPoint( Reg._tileSize, Reg._tileSize), new FlxPoint(4,4), new FlxPoint(4,4));
		tilemap.frames = levelTiles;
		// tile tearing problem fix
		tilemap.useScaleHack = false;
		
		// tiles.png has all the tiles for this tilemap. tile frame starts at the top left corner and end bottom right. this code allows the player to jump up from underneth the tile.		
		
		// no collision check. the last object is always + 1 more in the for loop.
		for (i in 16...19) tilemap.setTileProperties(i, FlxObject.NONE);// background castle. tile object can have UP, ANY, NONE...		
		for (i in 37...46) tilemap.setTileProperties(i, FlxObject.NONE);	
		for (i in 57...96) tilemap.setTileProperties(i, FlxObject.NONE);
							 tilemap.setTileProperties(96, FlxObject.RIGHT);
							 tilemap.setTileProperties(97, FlxObject.ANY);
							 tilemap.setTileProperties(98, FlxObject.LEFT);
							 tilemap.setTileProperties(99, FlxObject.ANY);
		for (i in 100...103) tilemap.setTileProperties(i, FlxObject.NONE);
							 tilemap.setTileProperties(178, FlxObject.ANY);
		// house background tiles.
		for (i in 181...183) tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 189...191) tilemap.setTileProperties(i, FlxObject.NONE);	
		for (i in 197...199) tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 205...207) tilemap.setTileProperties(i, FlxObject.NONE);
		
		// stage background tiles.
		for (i in 193...196) tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 201...204) tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 217...268) tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 281...295) tilemap.setTileProperties(i, FlxObject.ANY); 	// vertical tiles.
		for (i in 304...736) tilemap.setTileProperties(i, FlxObject.ANY); 	// level 2 tiles.
		for (i in 736...800) tilemap.setTileProperties(i, FlxObject.NONE);	// textures.
		
		var tempNW:Array<Int> = [8,9,10,11,57,59,248, 252,253, 260,262, 305,337,369,401,433,473,497,521,545,569,601,625,649,673,697];
		var tempNE:Array<Int> = [12,13,14,15,58,60,249, 254,255, 261, 263, 306,338,370,402,434,474,498,522,546,570,602,626,650,674,698];		
		var tempSW:Array<Int> = [250, 256, 257, 264, 266, 313,345,377,409,441,481,505,529,553,577,609,633,657,681,705];
		var tempSE:Array<Int> = [251, 258, 259, 265, 267, 314,346,378,410,442,482,506,530,554,578,610,634,658,682,706];
		
		tilemap.setSlopes(tempNW, tempNE, tempSW, tempSE);		
		tilemap.setGentle([253, 254, 257, 258], [252, 255, 256, 259]);
		tilemap.setSteep([260, 261, 264, 265], [262, 263, 266, 267]);
		
		add(tilemap);
		
		//set the left cage border to a blank tile.
		var newindex:Int = 96;
		for (j in 0...tilemap.heightInTiles)
		{
			for (i in 0...tilemap.widthInTiles - 1)
			{
				if (tilemap.getTile(i, j) == 97)
				{
					tilemap.setTile(i, j, newindex, true);
				}	
			}		
		}
		
		//set the right cage border to a blank tile.
		var newindex:Int = 98;
		for (j in 0...tilemap.heightInTiles)
		{
			for (i in 0...tilemap.widthInTiles - 1)
			{
				if (tilemap.getTile(i, j) == 99)
				{
					tilemap.setTile(i, j, newindex, true);
				}	
			}		
		}
	}	
			
	function createLayer1UnderlaysTiles():Void
	{
		underlays = new FlxTilemap();		
		if (Reg._testItems == false) underlays.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse +  "_Layer 1 underlays tiles.csv"), "assets/images/map1UnderlaysTiles.png", Reg._tileSize, Reg._tileSize);
		else underlays.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items_Layer 1 underlays tiles.csv"), "assets/images/map1UnderlaysTiles.png", Reg._tileSize, Reg._tileSize);
		
		//for (i in 0...1159) underlays.setTileProperties(i, FlxObject.NONE);	
		
		add(underlays);
		
		var newindex:Int = 38;
		for (j in 0...underlays.heightInTiles)
		{
			for (i in 0...underlays.widthInTiles - 1)
			{
				if (underlays.getTile(i, j) == 39)
				{
					underlays.setTile(i, j, newindex, true);
				}	
			}		
		}
	}
	
	function createSpriteGroups():Void
	{
		// at this function, objects added to a group will be displayed underneath the player when the player overlaps the object. if you want the reverse then place the add() code somewhere after the mob create function at create() function.
		
		_objectsThatDoNotMove = new FlxGroup();
		add(_objectsThatDoNotMove);	
		
		_objectLadders = new FlxGroup();
		add(_objectLadders);	
		
		_objectPlatformMoving = new FlxGroup();
		add(_objectPlatformMoving);
		
		_itemFlyingHatPlatform = new FlxGroup();
		add(_itemFlyingHatPlatform);
		
		_objectDoorToHouse = new FlxGroup();
		add(_objectDoorToHouse);
		
		_objectLayer3OverlapOnly = new FlxGroup();
		add(_objectLayer3OverlapOnly);
		
		_objectBlockOrRock = new FlxGroup();
		add(_objectBlockOrRock);	
		
		_objectSuperBlock = new FlxGroup();
		add(_objectSuperBlock);
		
		_objectWaterCurrent = new FlxGroup();
		add(_objectWaterCurrent);
		
		_objectVineMoving = new FlxGroup();
		add(_objectVineMoving);
		
		_objectSign = new FlxGroup();
		add(_objectSign);
		
		_objectTeleporter = new FlxGroup();
		add(_objectTeleporter);
		
		_rangedWeapon = new FlxGroup();
		add(_rangedWeapon);
		
		_jumpingPad = new FlxGroup();
		add(_jumpingPad);
		
		_objectLavaBlock = new FlxGroup();
		add(_objectLavaBlock);
	}
	
	function createLayer2Player():Void
	{					
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false) objectData = Assets.getText("assets/data/Map-" + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords) + Reg._inHouse + "_Layer 2 underlays sprites and player.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items_Layer 2 underlays sprites and player.csv");
		// split the object data (object.csv file) into rows where that data is only
		// seperated with a comma.
		
		// y now refers to the number of \n in the csv file. each row of var rows now
		// contains all the data of that tile maps row but without the line break.
		var rows:Array<String> = objectData.split("\n");
		
		for (y in 0...rows.length) 
		{
			if (rows[y].length > 0)
			{
				// store the data in another array that does not have any commas within it.
				var objectsString:Array<String> = rows[y].split(",");
			
				// create an array integer.
				var objects:Array<Float> = new Array();
			
				// loop through all the csv data, which is now not seperated by a comma.
				// the rows still exists with the objectsString. 
				for (i in 0...objectsString.length) objects.push(Std.parseInt(objectsString[i]));
				for (x in 0...objects.length) {
					// x and y refer to the location of the object within the object.csv file.
					// later these values need to be multiply by the width or height to display
					// the object at the correct map positions. 
					// if using tiled map editor, minus 1 for case values.
					switch(objects[x]) {
						case 0: addPlayer(x * Reg._tileSize, y * Reg._tileSize); // needed by itself to avoid startup crash.
						case 16: addCage(x * Reg._tileSize, y * Reg._tileSize, 1); 
						case 17: addCage(x * Reg._tileSize, y * Reg._tileSize, 2); 
						case 18: addCage(x * Reg._tileSize, y * Reg._tileSize, 3); 
						case 19: addCage(x * Reg._tileSize, y * Reg._tileSize, 4); 
						case 20: addCage(x * Reg._tileSize, y * Reg._tileSize, 5); 
						case 21: addCage(x * Reg._tileSize, y * Reg._tileSize, 6); 
						case 22: addCage(x * Reg._tileSize, y * Reg._tileSize, 7); 
						case 23: addCage(x * Reg._tileSize, y * Reg._tileSize, 8); 
					}
				}
			}
		}
		
				
		enemies = new FlxGroup();	
		enemiesNoCollideWithTileMap = new FlxGroup();
		npcs = new FlxGroup();	
		
	}
	
	function createLayer3Sprites():Void
	{				
	
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false) objectData = Assets.getText("assets/data/Map-" + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords) + Reg._inHouse + "_Layer 3 underlays sprites and mobs.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items_Layer 3 underlays sprites and mobs.csv");
		// split the object data (object.csv file) into rows where that data is only
		// seperated with a comma.
		
		// y now refers to the number of \n in the csv file. each row of var rows now
		// contains all the data of that tile maps row but without the line break.
		var rows:Array<String> = objectData.split("\n");
		
			for (y in 0...rows.length) 
		{
			if (rows[y].length > 0)
			{
				// store the data in another array that does not have any commas within it.
				var objectsString:Array<String> = rows[y].split(",");
			
				// create an array integer.
				var objects:Array<Float> = new Array();
			
				// loop through all the csv data, which is now not seperated by a comma.
				// the rows still exists with the objectsString. 
				for (i in 0...objectsString.length) objects.push(Std.parseInt(objectsString[i]));
				for (x in 0...objects.length) {
					// x and y refer to the location of the object within the object.csv file.
					// later these values need to be multiply by the width or height to display
					// the object at the correct map positions. 
					// if using tiled map editor, minus 1 for case values.
					switch(objects[x]) {					
						// ----------------- mobs. 
						case 0: addBarricade(x * Reg._tileSize, y * Reg._tileSize);				
						
						case 5: addBoss2(x * Reg._tileSize, y * Reg._tileSize);
						case 6: addMobBullet(x * Reg._tileSize + 2, y * Reg._tileSize + 2);
						
						case 8: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 1);
						case 9: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 2);
						case 10: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 3);
						case 11: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 4);
						case 12: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 5);
						case 13: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 6);
						case 14: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 7);
						case 15: addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 8);
						
						case 22: addBoss(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 23: addBoss(x * Reg._tileSize, y * Reg._tileSize - 27, 2);
						case 24: addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 1);
						case 25: addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 2);
						case 26: addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 3);
						case 27: addMobBubble(x * Reg._tileSize, y * Reg._tileSize);
						case 28: addNpcDogLady(x * Reg._tileSize, y * Reg._tileSize);
						case 29: addNpcDog(x * Reg._tileSize, y * Reg._tileSize, player, 1);
						case 30: addNpcDog(x * Reg._tileSize, y * Reg._tileSize, player, 2);
						case 31: addNpcDog(x * Reg._tileSize, y * Reg._tileSize, player, 3);
						case 32: addNpcDog(x * Reg._tileSize, y * Reg._tileSize, player, 4);
						case 33: addNpcDoctor(x * Reg._tileSize, y * Reg._tileSize);
						case 49: addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 50: addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 51: addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 52: addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 1);
						case 53: addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 2);
						case 54: addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 3);
						case 57: addMobApple(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 58: addMobApple(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 59: addMobApple(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 60: addMobBat(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 61: addMobBat(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 62: addMobBat(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 65: addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 66: addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 67: addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 68: addMobFish(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 69: addMobFish(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 70: addMobFish(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 73: addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 74: addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 75: addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 76: addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 77: addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 78: addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 3);
						
						
						//------------- items / objects.
						case 257: addDiamond(x * Reg._tileSize, y * Reg._tileSize);
						case 258: addDoor(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 259: addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 260: addDoor(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 261: addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 262: addItemJump(x * Reg._tileSize, y * Reg._tileSize, 1);	
						case 263: addItemGunFlame(x * Reg._tileSize, y * Reg._tileSize);		
						case 264: addItemGunRapidFire(x * Reg._tileSize, y * Reg._tileSize);	
						case 265: addSavePoint(x * Reg._tileSize, y * Reg._tileSize);	
						// horizontal for id 1 and 2. 3 is vertical.
						case 266: addPlatformMoving(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 267: addPlatformMoving(x * Reg._tileSize, (y * Reg._tileSize) - Reg._tileSize, 2);
						case 268: addObjectFireballBlock(x * Reg._tileSize, y * Reg._tileSize);
						case 269: addWaterParameter(x * Reg._tileSize, y * Reg._tileSize);
						case 270: addLaserBeam(x * Reg._tileSize + 4, y * Reg._tileSize);
						case 271: addLaserParameter(x * Reg._tileSize, y * Reg._tileSize);
						case 272: addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 273: addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 274: addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 275: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize + 17, 1);
						case 276: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 277: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 278: addSpikeTrap(x * Reg._tileSize + 17, y * Reg._tileSize, 4);
						case 279: addFlyingHat(x * Reg._tileSize, y * Reg._tileSize);
						case 280: addFlyingHatPlatform(x * Reg._tileSize, y * Reg._tileSize);
						case 281: addHeartContainer(x * Reg._tileSize, y * Reg._tileSize);		
						case 282: addItemGun(x * Reg._tileSize, y * Reg._tileSize);
						case 283: addNpcShovel(x * Reg._tileSize, y * Reg._tileSize);
						case 284: addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 285: addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 286: addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 287: addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 288: addWateringCan(x * Reg._tileSize, y * Reg._tileSize);
						case 289: addLadder(x * Reg._tileSize + 12, y * Reg._tileSize - 5, 1);
						case 290: addDoorHouse(x * Reg._tileSize + 1, y * Reg._tileSize + 1);
						case 291: addTreasureChest(x * Reg._tileSize, y * Reg._tileSize);
						case 292: addDoor(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 293: addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 294: addDoor(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 295: addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 296: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 297: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 298: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 299: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 300: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 301: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 302: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 303: addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 304: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 305: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 306: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 307: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 308: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 309: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 310: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 311: addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 312: addComputer(x * Reg._tileSize, y * Reg._tileSize);
						case 313: addItemSwimmingSkill(x * Reg._tileSize, y * Reg._tileSize);
						case 314: addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 315: addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 316: addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 317: addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 318: addVineMoving(x * Reg._tileSize + 8, y * Reg._tileSize, 1);
						case 319: addCannon(x * Reg._tileSize, y * Reg._tileSize - 5, 1);
						case 320: addCannon(x * Reg._tileSize, y * Reg._tileSize - 5, 2);
						case 321: addItemGunFreeze(x * Reg._tileSize, y * Reg._tileSize);
						case 322: addBlockedCracked(x * Reg._tileSize, y * Reg._tileSize);
						case 323: addPlatformMoving(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 324: addPlatformParameter(x * Reg._tileSize, y * Reg._tileSize);
						
						case 326: addRock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 327: addRock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 328: addRock(x * Reg._tileSize, y * Reg._tileSize + 10, 3);
						case 329: addRock(x * Reg._tileSize, y * Reg._tileSize + 24, 4);
						case 330: addRock(x * Reg._tileSize, y * Reg._tileSize + 12, 5);
						case 331: addRock(x * Reg._tileSize, y * Reg._tileSize + 17, 6);
						case 332: addSign(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 333: addSign(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 334: addTeleporter(x * Reg._tileSize, y * Reg._tileSize);
						case 335: addDogFlute(x * Reg._tileSize, y * Reg._tileSize);
						case 336: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 337: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 338: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 339: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 340: addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize + 10, 9);
						case 341: addJumpingPad(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 342: addJumpingPad(x * Reg._tileSize + 24, y * Reg._tileSize, 2);
						case 343: addSpikeFalling(x * Reg._tileSize + 7, y * Reg._tileSize);
						case 344: addItemAnitgravitySuit(x * Reg._tileSize, y * Reg._tileSize);
						case 345: addLavaBlock(x * Reg._tileSize, y * Reg._tileSize);
					}
				}
			}
		}		
		
		add(_bullets);
		add(_bulletsMob);
		add(_bulletsObject);
		
		// player is displayed in front of enemies.
		add(enemies);
		add(enemiesNoCollideWithTileMap);
		add(npcs);	
		add(_objectCage);
		add(player);
		
		
	}	
	
	function createOverlaysGroups():Void
	{
		_overlaysThatDoNotMove = new FlxGroup();
		add(_overlaysThatDoNotMove);
		_overlayLaserBeam = new FlxGroup();
		add(_overlayLaserBeam);
	}
	
	function createLayer4OverlaySprites():Void
	{
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false)  objectData = Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse +  "_Layer 4 overlays sprites.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items_Layer 4 overlays sprites.csv");
		// split the object data (object.csv file) into rows where that data is only
		// seperated with a comma.
		
		// y now refers to the number of \n in the csv file. each row of var rows now
		// contains all the data of that tile maps row but without the line break.
		var rows:Array<String> = objectData.split("\n");
		
		for (y in 0...rows.length) {
			if (rows[y].length > 0)
			{
				// store the data in another array that does not have any commas within it.
				var objectsString:Array<String> = rows[y].split(",");
			
				// create an array integer.
				var objects:Array<Float> = new Array();
			
				// loop through all the csv data, which is now not seperated by a comma.
				// the rows still exists with the objectsString. 
				for (i in 0...objectsString.length) objects.push(Std.parseInt(objectsString[i]));
				for (x in 0...objects.length) {
					// x and y refer to the location of the object within the object.csv file.
					// later these values need to be multiply by the width or height to display
					// the object at the correct map positions. 
					// if using tiled map editor, minus 1 for case values.
					switch(objects[x]) {
						case 0: addWave(x * Reg._tileSize, y * Reg._tileSize);
						// case 1: addWater function is not used. search for waterplayer or read LAYER 5 INFORMATION.txt
						case 2: addLaserBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 3: addLaserBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 4: addAirBubble(x * Reg._tileSize, y * Reg._tileSize);
						
						case 8: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 9: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 10: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 11: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 12: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 13: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 14: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 7);
						
						case 16: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 17: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 9);
						case 18: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 10);
						case 19: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 11);
						
						case 21: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 12);
						case 22: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 13);
						
						case 24: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 14);
						case 25: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 15);
						case 26: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 16);
						case 27: addPipe1(x * Reg._tileSize, y * Reg._tileSize, 17);
						
						case 32: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 33: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 34: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 35: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 36: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 37: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 38: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 7);
						
						case 40: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 41: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 9);
						case 42: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 10);
						case 43: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 11);
						
						case 45: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 12);
						case 46: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 13);
						
						case 48: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 14);
						case 49: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 15);
						case 50: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 16);
						case 51: addPipe2(x * Reg._tileSize, y * Reg._tileSize, 17);
					}					
				}
			}
		}	
		
	//foregroundImage = new FlxBackdrop("assets/images/foreground.png", 0.5, 0.5, true, true, 0, 0);
	//add(foregroundImage);
	}	
	
	function createLayer5OverlaysTiles():Void
	{				
		overlays = new FlxTilemap();		
		if (Reg._testItems == false) overlays.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse + "_Layer 5 overlays tiles.csv"), "assets/images/map5OverlaysTiles.png", Reg._tileSize, Reg._tileSize);
		else overlays.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items_Layer 5 overlays tiles.csv"), "assets/images/map5OverlaysTiles.png", Reg._tileSize, Reg._tileSize);
		
		//for (i in 0...4) underlays.setTileProperties(i, FlxObject.NONE);	
		
		add(overlays);

		//the folling code will search for the mob walk any direction tile (index 7) and change it into a blank tile so that when the game starts the tile will be blank.
		
		// The code loops through the map as it increments by its tile size height and then width. It searches for a tile with an index of 7 and then change that tile into an index of 6.
		var newindex:Int = 6;
		for (j in 0...overlays.heightInTiles)
		{
			for (i in 0...overlays.widthInTiles - 1)
			{
				if (overlays.getTile(i, j) == 7)
				{
					overlays.setTile(i, j, newindex, true);
				}	
			}		
		}
		
		// change the slope path to an enpty tile but later use this emtpy tile for checking if mob of player is standing on it.
		for (j in 0...overlays.heightInTiles)
		{
			for (i in 0...overlays.widthInTiles - 1)
			{
				if (overlays.getTile(i, j) == 23)
				{
					overlays.setTile(i, j, 22, true);
				}	
				if (overlays.getTile(i, j) == 31)
				{
					overlays.setTile(i, j, 30, true);
				}	
				if (overlays.getTile(i, j) == 39)
				{
					overlays.setTile(i, j, 38, true);
				}	
				if (overlays.getTile(i, j) == 47)
				{
					overlays.setTile(i, j, 46, true);
				}	
			}		
		}
		
		//############# REMOVE BLOCK TO GET ITEMS FROM BOSS ################
		if (Reg.mapXcoords == 17 && Reg.mapYcoords == 22 && Reg._boss1ADefeated == true || Reg.mapXcoords == 12 && Reg.mapYcoords == 19 && Reg._boss1BDefeated == true || Reg.mapXcoords == 15 && Reg.mapYcoords == 15 && Reg._boss2Defeated == true)
		{
			var newindex:Int = 193;
			for (j in 0...Reg.state.tilemap.heightInTiles)
			{
				for (i in 0...Reg.state.tilemap.widthInTiles - 1)
				{
					if (Reg.state.tilemap.getTile(i, j) == 177)
					{
						Reg.state.tilemap.setTile(i, j, newindex, true);
					}	
				}		
			}	
		}
	}
	
	// ############################################################
	//  ADD MOBS TO MAP
	// ############################################################
	
	function addPlayer(X:Int, Y:Int):Void
	{
		// when going to the Player constructor, the x and y values will be multiply by the
		// tile size. currently, these x and y value refers to how many blocks from the
		// left-right or up-down position of a csv file.
		var xNewCoords:Float = 0;
		var yNewCoords:Float = 0;
		
		if (Reg._inHouse == "")
		{
			if (Reg.beginningOfGame == false && Reg.restoreGameState == false)
			{
				// west - to go east door.
				if (Reg.playerXcoords < 1) {xNewCoords = 23 ; yNewCoords = Reg.playerYcoords; } 
				
				// north - to go south door.
				else if (Reg.playerYcoords < 1) {yNewCoords = 13 ; xNewCoords = Reg.playerXcoords; } 
				
				// east - to go west door.
				else if (Reg.playerXcoords > 24) {xNewCoords = 1 ; yNewCoords = Reg.playerYcoords; } 
								
				// south - go to north door.
				else if (Reg.playerYcoords > 14) {yNewCoords = 1 ; xNewCoords = Reg.playerXcoords;} 		
				
			}
			else
			{
				xNewCoords = Reg.playerXcoords;
				yNewCoords = Reg.playerYcoords;
			}
		}
	
		// place the player on the map.
		if (Reg._inHouse == "")
		{
			if (Reg.playerXcoordsLast != 0)
				{player = new Player(Reg.playerXcoordsLast, Reg.playerYcoordsLast, _bullets, _emitterBulletHit, _emitterBulletMiss, _emitterBulletFlame); Reg.playerXcoordsLast = 0; Reg.playerYcoordsLast = 0; }
			else if (Reg.beginningOfGame == false && Reg.restoreGameState == false)
				player = new Player(xNewCoords * Reg._tileSize, yNewCoords * Reg._tileSize, _bullets, _emitterBulletHit, _emitterBulletMiss, _emitterBulletFlame);
			else if (Reg.beginningOfGame == false && Reg.restoreGameState == true)
				player = new Player(Reg.playerXcoords, Reg.playerYcoords, _bullets, _emitterBulletHit, _emitterBulletMiss, _emitterBulletFlame); 			
			else player = new Player(X, Y, _bullets, _emitterBulletHit, _emitterBulletMiss, _emitterBulletFlame);
		}
		else 
		{
			if (Reg._teleportedToHouse == true) 
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("teleport2", 1, false);
				X += (10 * Reg._tileSize);
			}
			player = new Player(X, Y, _bullets, _emitterBulletHit, _emitterBulletMiss, _emitterBulletFlame); 			
			
			Reg._teleportedToHouse = false;
		}
		
		Reg.restoreGameState = false;		
		Reg._playersYLastOnTile = player.y;
		
		_healthBarPlayer = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	player, "health", 0, player.health, false);		
		_healthBarPlayer.setRange(0, Reg._healthMaximum);
		add(_healthBarPlayer);
	}
	
	// ################################################################
	// update - camera
	// ################################################################
	function setCamera():Void
	{
		// make the camera follow the player in a platformer game.
		FlxG.camera.follow(player, FlxCameraFollowStyle.SCREEN_BY_SCREEN);		
		
		// smooth the image.
		#if cpp
		FlxG.camera.antialiasing = true;
		#end
		
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
		
		if (FlxG.keys.anyJustReleased(["A"]) || Reg._mouseClickedButtonA == true)
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
	
		if (FlxG.keys.anyJustReleased(["F12"])) FlxG.fullscreen = !FlxG.fullscreen; // toggles fullscreen mode.
		
		// play another music if music is not player.
		if (Reg._musicEnabled == true || Reg._powerUpStopFlicker == true)
		{
			if (FlxG.sound.music.playing == false && Reg._transitionInitialized == true || FlxG.sound.music.playing == false && Reg._transitionEffectEnable == false) 
			{
				playMusic();
				
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
				FlxG.overlap(savePoint, player, touchSavePoint);
			
			Reg._dialogAnsweredYes = false;
		}
		
		downKeyAndTracker(); // Down key and tracker.

		//####################### EMITTERS ############################		
		FlxG.overlap(_emitterItemTriangle, player, emitterTrianglePlayerOverlap);
		FlxG.overlap(_emitterItemDiamond, player, emitterDiamondPlayerOverlap);	
		FlxG.overlap(_emitterItemPowerUp, player, emitterPowerUpPlayerOverlap);	
		FlxG.overlap(_emitterItemNugget, player, emitterNuggetPlayerOverlap);	
		FlxG.overlap(_emitterItemHeart, player, emitterHeartPlayerOverlap);	
		
		//############### COLLIDE - OVERLAP STARTS HERE ###############
				
		//######################### TWEENS#############################
		FlxG.collide(_objectFireballBlock, player, fireballBlockPlayer);
		FlxG.collide(_objectFireballBlock, enemies);
		
		// fireballs that rotate the block.
		if (FlxSpriteUtil.isFlickering(player) == false)
		{
			FlxG.overlap(_objectFireball, player, fireballCollidePlayer);
			FlxG.overlap(_objectFireballTween, player, fireballCollidePlayer);
		}		
			FlxG.overlap(_objectFireball, enemies, fireballCollideEnemy);
		
		
		//######################### TOUCH ITEMS #######################
		
		// _objectDoor is a group that put all the FlxSprite in to one area.
		// add the ovelap check to PlayState update() that calls 
		// the function touchDoor() when player overlaps the door
		FlxG.overlap(_objectDoor, player, touchDoor);
		FlxG.collide(_objectDoor, player);
		FlxG.collide(_objectDoor, enemies);
		FlxG.collide(_objectDoor, _bullets);	
		FlxG.collide(_objectDoor, _bulletsMob);	
		FlxG.collide(_objectDoor, _bulletsObject);
		
		FlxG.overlap(_itemsThatWerePickedUp, player, itemPickedUp);

		FlxG.overlap(_itemGunFlame, player, touchItemGunFlame);		
		FlxG.overlap(_itemGun, player, touchItemGun);
		FlxG.overlap(_itemGunFreeze, player, touchItemGunFreeze);
				
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
				FlxG.overlap(_bullets, enemies, hitEnemy);
				
				FlxSpriteUtil.stopFlickering(mobBubble);
			}else
			{
				FlxG.overlap(_bullets, enemies, hitEnemy);
			}
		}
		
		FlxG.overlap(_bulletsMob, player, hitPlayer);
		FlxG.overlap(_bulletsObject, player, hitPlayer);
		FlxG.overlap(_emitterBulletFlame, enemies, hitEnemyWithFlame);
			
		if(FlxG.overlap(_objectLadders, player))
		FlxG.overlap(_objectLadders, player, ladderPlayerOverlap);
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
		FlxG.collide(_objectPlatformMoving, player, platformMovingPlayer);		
		//FlxG.collide(_objectPlatformMoving, enemies);
		FlxG.collide(_objectPlatformMoving, tilemap);
		FlxG.collide(_objectPlatformMoving, _objectPlatformMoving);
		FlxG.collide(_objectPlatformMoving, _objectBlockOrRock);
		
		// spike is now at the ground.
		//FlxG.overlap(_rangedWeapon, player);
		//FlxG.overlap(_rangedWeapon, enemies);
			
		FlxG.collide(_objectBlockOrRock, player, blockPlayerCollide);
		FlxG.collide(_objectBlockOrRock, enemies, EnemyCastSpriteCollide.blockEnemyCollide);
		FlxG.collide(_objectBlockOrRock, npcs);
		FlxG.collide(_objectBlockOrRock, tilemap);
	
		//#################### overlays ############################
		FlxG.overlap(_objectWaterParameter, player, waterPlayerParameter);
		FlxG.overlap(_objectWaterParameter, enemies, EnemyCastSpriteCollide.waterEnemyParameter);		
		FlxG.overlap(_overlayWave, player, wavePlayer);		
		FlxG.overlap(_overlayWave, enemies, EnemyCastSpriteCollide.waveEnemy);	
		FlxG.overlap(_overlayAirBubble, player, airBubblePlayerOverlap);		
		FlxG.overlap(_overlayAirBubble, enemies, EnemyCastSpriteCollide.airBubbleEnemyOverlap);	
		
		FlxG.overlap(_objectBeamLaser, player, laserBeamPlayer);		
		FlxG.overlap(_objectBeamLaser, enemies, EnemyCastSpriteCollide.laserBeamEnemy);
		FlxG.collide(_objectBeamLaser, _objectLaserParameter);
		FlxG.collide(_objectSuperBlock, player, touchSuperBlock);
		FlxG.collide(_objectSuperBlock, enemies);
		FlxG.collide(_objectsThatDoNotMove, enemies);
		FlxG.collide(_objectsThatDoNotMove, player);
				
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
		) waterPlayer(player);
		
		// if no arrow key was pressed for a lenght of time then show the guidelines.
		if (Reg._arrowKeyInUseTicks > 30)
		{
			if (player._mobIsSwimming == true) Reg._arrowKeyInUseTicks = 0;
			else
			{
				warningFallLine.visible = true;
				deathFallLine.visible = true;
				maximumJumpLine.visible = true;
			}
		} 
		else if(Reg._arrowKeyInUseTicks == 0)
		{
			warningFallLine.visible = false;
			deathFallLine.visible = false;
			maximumJumpLine.visible = false;
		}
		
		Reg._arrowKeyInUseTicks = Reg.incrementTicks(Reg._arrowKeyInUseTicks, 60 / Reg._framerate);
		
		if (Reg._itemGotFlyingHat == true && Reg._usingFlyingHat == true)
			flyingHat(player);
		
		if (FlxG.keys.anyJustReleased(["F1"])) // display exit choices.
		{ 
			Reg.exitGameMenu = true;  
			Reg._F1KeyUsedFromMenuState = false;
			openSubState(new Dialog()); 				
		}		
		
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
			if (Reg.state.player.x < 2)
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapXcoords--;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				FlxG.switchState(new PlayState());
			}
			
			if (Reg.state.player.x > 770)
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapXcoords++;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				FlxG.switchState(new PlayState());
			}
			
			if (Reg.state.player.y < 2)
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapYcoords--;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg.state._timeRemainingBeforeDeath.visible = false;
				FlxG.switchState(new PlayState());
			}
			
			if (Reg.state.player.y > 450)
			{
				Reg.beginningOfGame = false;
				Reg.state.player.getCoords();
				Reg.mapYcoords++;
				Reg._dogOnMap = false;
				Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungs;
				Reg._deathWhenReachedZeroCurrent = Reg._deathWhenReachedZero;
				Reg.state._timeRemainingBeforeDeath.visible = false;
				FlxG.switchState(new PlayState());
			}
		}
	
		super.update(elapsed);			
		
		//################## TILEMAP COLLIDE ##################		
		// without this code, the player will sometimes walk through a north-west sloped tile. the collide code needs to be called twice and the tilemapPlayerCollide function called outside of this code.
		FlxG.overlap(tilemap, player);
		FlxG.collide(tilemap, player);
		FlxG.collide(tilemap, player);
		tilemapPlayerCollide(tilemap, player);
		
		if (FlxG.overlap(tilemap, enemies)) FlxG.collide(tilemap, enemies);
		FlxG.collide(tilemap, enemies, EnemyCastSpriteCollide.tilemapEnemyCollide);
		
		FlxG.collide(tilemap, _emitterItemTriangle, tilemapParticalCollide);
		FlxG.collide(tilemap, _emitterItemHeart, tilemapParticalCollide);
		FlxG.collide(tilemap, _emitterItemNugget, tilemapParticalCollide);
		FlxG.collide(tilemap, npcs);
		
		
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
			leaveMap(p);
		}
	}
	
	function flyingHat(p:Player):Void
	{
		if (FlxG.keys.anyPressed(["UP"]) || Reg._mouseClickedButtonUp == true) 
		{
			p.yForce--;p.yForce = FlxMath.bound(p.yForce, -1, 1);		
			p.acceleration.y = p.yForce * p._yMaxAcceleration;			
				
			p.animation.play("flyingHat");
		}
		else if (FlxG.keys.anyPressed(["DOWN"]) || Reg._mouseClickedButtonDown == true) 
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
}
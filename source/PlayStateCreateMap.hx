package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author galoyo
 */
class PlayStateCreateMap
{
	public static function createLayer0Tilemap():Void
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
			
			Reg.state.background = new FlxSprite();
			
			if (Reg.mapXcoords == 24 && Reg.mapYcoords == 20 || Reg.mapXcoords == 25 && Reg.mapYcoords == 20)
			{
				Reg.state.background.loadGraphic("assets/images/background2.jpg", false);
				Reg.state.background.setPosition(0, 0);
				Reg.state.add(Reg.state.background);
			}
			else if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19){} // trap the parallax car scene. 
			else
			{
				Reg.state.background.loadGraphic("assets/images/background"+bgSet+"-"+bg+".jpg", false);
				Reg.state.background.setPosition(0, 0);
				Reg.state.add(Reg.state.background);
			}
		}
		
		Reg.state.tilemap = new FlxTilemapExt();		
		if (Reg._testItems == false) Reg.state.tilemap.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse + "_Layer 0 tiles.csv"), "assets/images/map0Tiles.png", Reg._tileSize, Reg._tileSize);
		else Reg.state.tilemap.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items1_Layer 0 tiles.csv"), "assets/images/map0Tiles.png", Reg._tileSize, Reg._tileSize);
		
		var levelTiles:FlxTileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/images/map0Tiles.png", new FlxPoint( Reg._tileSize, Reg._tileSize), new FlxPoint(4,4), new FlxPoint(4,4));
		Reg.state.tilemap.frames = levelTiles;
		// tile tearing problem fix
		Reg.state.tilemap.useScaleHack = false;
		
		// tiles.png has all the tiles for this tilemap. tile frame starts at the top left corner and end bottom right. this code allows the player to jump up from underneth the tile.		
		
		//######################## READ ME ########################
		// no collision check. the last object is always + 1 more in the for loop. so if you are doing tiles 14 and 15, the code will be i in 14...16
		for (i in 16...19) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);// background castle. tile object can have UP, ANY, NONE...		
		for (i in 37...46) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);	
		for (i in 57...96) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
							 Reg.state.tilemap.setTileProperties(96, FlxObject.RIGHT);
							 Reg.state.tilemap.setTileProperties(97, FlxObject.ANY);
							 Reg.state.tilemap.setTileProperties(98, FlxObject.LEFT);
							 Reg.state.tilemap.setTileProperties(99, FlxObject.ANY);
		for (i in 100...103) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
							 Reg.state.tilemap.setTileProperties(178, FlxObject.ANY);
		// house background tiles.
		for (i in 181...184) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 189...192) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);	
		for (i in 197...200) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 205...208) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
		
		// stage background tiles.
		for (i in 193...196) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 201...204) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 217...268) Reg.state.tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 281...295) Reg.state.tilemap.setTileProperties(i, FlxObject.ANY); 	// vertical tiles.
		for (i in 304...736) Reg.state.tilemap.setTileProperties(i, FlxObject.ANY); 	// level 2 tiles.
		for (i in 736...800) Reg.state.tilemap.setTileProperties(i, FlxObject.NONE);	// textures.

		
		var tempNW:Array<Int> = [8,9,10,11,57,59,248, 252,253, 260,262, 305,337,369,401,433,473,497,521,545,569,601,625,649,673,697];
		var tempNE:Array<Int> = [12,13,14,15,58,60,249, 254,255, 261, 263, 306,338,370,402,434,474,498,522,546,570,602,626,650,674,698];		
		var tempSW:Array<Int> = [250, 256, 257, 264, 266, 313,345,377,409,441,481,505,529,553,577,609,633,657,681,705];
		var tempSE:Array<Int> = [251, 258, 259, 265, 267, 314,346,378,410,442,482,506,530,554,578,610,634,658,682,706];
		
		Reg.state.tilemap.setSlopes(tempNW, tempNE, tempSW, tempSE);		
		Reg.state.tilemap.setGentle([253, 254, 257, 258], [252, 255, 256, 259]);
		Reg.state.tilemap.setSteep([260, 261, 264, 265], [262, 263, 266, 267]);
		Reg.state.add(Reg.state.tilemap);

		var newindex:Int = 98;
		for (j in 0...Reg.state.tilemap.heightInTiles)
		{
			for (i in 0...Reg.state.tilemap.widthInTiles - 1)
			{
				if (Reg.state.tilemap.getTile(i, j) == 97)
				{
					Reg.state.tilemap.setTile(i, j, 96, true); // set the left cage border to a blank tile.
				}
				
				if (Reg.state.tilemap.getTile(i, j) == 99)
				{
					Reg.state.tilemap.setTile(i, j, 98, true); // set the right cage border to a blank tile.
				}	
				
				if (Reg.state.tilemap.getTile(i, j) == 217)
				{
					Reg.state.tilemap.setTile(i, j, 218, true); // set the any block soild to transparent tile.
				}	
			}		
		}
		
	}	
			
	public static function createLayer1UnderlaysTiles():Void
	{
		Reg.state.underlays = new FlxTilemap();		
		if (Reg._testItems == false) Reg.state.underlays.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse +  "_Layer 1 underlays tiles.csv"), "assets/images/map1UnderlaysTiles.png", Reg._tileSize, Reg._tileSize);
		else Reg.state.underlays.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items1_Layer 1 underlays tiles.csv"), "assets/images/map1UnderlaysTiles.png", Reg._tileSize, Reg._tileSize);
		
		Reg.state.add(Reg.state.underlays);
		
		var newindex:Int = 38;
		for (j in 0...Reg.state.underlays.heightInTiles)
		{
			for (i in 0...Reg.state.underlays.widthInTiles - 1)
			{
				if (Reg.state.underlays.getTile(i, j) == 39)
				{
					Reg.state.underlays.setTile(i, j, newindex, true);
				}	
			}		
		}
	}
	
	public static function createSpriteGroups():Void
	{
		// at this function, objects added to a group will be displayed underneath the player when the player overlaps the object. if you want the reverse then place the add() code somewhere after the mob create function at create() function.
		
		Reg.state._objectsThatDoNotMove = new FlxGroup();
		Reg.state.add(Reg.state._objectsThatDoNotMove);	
		
		Reg.state._objectsThatMove = new FlxGroup();
		Reg.state.add(Reg.state._objectsThatMove);	
		
		Reg.state._objectLadders = new FlxGroup();
		Reg.state.add(Reg.state._objectLadders);	
		
		Reg.state._objectPlatformMoving = new FlxGroup();
		Reg.state.add(Reg.state._objectPlatformMoving);
		
		Reg.state._itemFlyingHatPlatform = new FlxGroup();
		Reg.state.add(Reg.state._itemFlyingHatPlatform);
		
		Reg.state._objectDoorToHouse = new FlxGroup();
		Reg.state.add(Reg.state._objectDoorToHouse);
		
		Reg.state._objectsLayer3 = new FlxGroup();
		Reg.state.add(Reg.state._objectsLayer3);
		
		Reg.state._objectBlockOrRock = new FlxGroup();
		Reg.state.add(Reg.state._objectBlockOrRock);	
		
		Reg.state._objectSuperBlock = new FlxGroup();
		Reg.state.add(Reg.state._objectSuperBlock);
		
		Reg.state._objectWaterCurrent = new FlxGroup();
		Reg.state.add(Reg.state._objectWaterCurrent);
		
		Reg.state._objectVineMoving = new FlxGroup();
		Reg.state.add(Reg.state._objectVineMoving);
		
		Reg.state._objectSign = new FlxGroup();
		Reg.state.add(Reg.state._objectSign);
		
		Reg.state._objectTeleporter = new FlxGroup();
		Reg.state.add(Reg.state._objectTeleporter);
		
		Reg.state._objectJumpingPad = new FlxGroup();
		Reg.state.add(Reg.state._objectJumpingPad);
		
		Reg.state._objectLavaBlock = new FlxGroup();
		Reg.state.add(Reg.state._objectLavaBlock);
		
		Reg.state._objectQuickSand = new FlxGroup();
		Reg.state.add(Reg.state._objectQuickSand);
		
		Reg.state._objectsThatDoNotMove.add(Reg.state._objectTube);
		
	}
	
	public static function createLayer2Player():Void
	{					
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false) objectData = Assets.getText("assets/data/Map-" + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords) + Reg._inHouse + "_Layer 2 underlays sprites and player.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items1_Layer 2 underlays sprites and player.csv");
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
						case 0: PlayStateAdd.addPlayer(x * Reg._tileSize, y * Reg._tileSize); // needed by itself to avoid startup crash.
						case 16: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 1); 
						case 17: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 2); 
						case 18: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 3); 
						case 19: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 4); 
						case 20: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 5); 
						case 21: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 6); 
						case 22: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 7); 
						case 23: PlayStateAdd.addCage(x * Reg._tileSize, y * Reg._tileSize, 8); 
						case 24: PlayStateAdd.addTube(x * Reg._tileSize, (y - 1) * Reg._tileSize);
					}
				}
			}
		}
		
				
		Reg.state.enemies = new FlxGroup();	
		Reg.state.enemiesNoCollideWithTileMap = new FlxGroup();
		Reg.state.npcs = new FlxGroup();	
		
	}
	
	public static function createLayer3Sprites():Void
	{				
	
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false) objectData = Assets.getText("assets/data/Map-" + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords) + Reg._inHouse + "_Layer 3 underlays sprites and mobs.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items1_Layer 3 underlays sprites and mobs.csv");
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
						case 0: PlayStateAdd.addBarricade(x * Reg._tileSize, y * Reg._tileSize);				
						case 1: PlayStateAdd.addMobTube((x - 1) * Reg._tileSize, (y - 1) * Reg._tileSize);	
						case 2: PlayStateAdd.addMobExplode(x * Reg._tileSize - 2, y * Reg._tileSize);
						case 3: PlayStateAdd.addMobSaw(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 4: PlayStateAdd.addMobSaw(x * Reg._tileSize, y * Reg._tileSize, 2);
						
						case 5: PlayStateAdd.addBoss2(x * Reg._tileSize, y * Reg._tileSize);
						case 6: PlayStateAdd.addMobBullet(x * Reg._tileSize + 2, y * Reg._tileSize + 2);
						
						case 8: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 1);
						case 9: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 2);
						case 10: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 3);
						case 11: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 4);
						case 12: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 5);
						case 13: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 6);
						case 14: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 7);
						case 15: PlayStateAdd.addNpcMalaUnhealthy(x * Reg._tileSize, y * Reg._tileSize +4, 8);
						
						case 22: PlayStateAdd.addBoss(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 23: PlayStateAdd.addBoss(x * Reg._tileSize, y * Reg._tileSize - 27, 2);
						case 24: PlayStateAdd.addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 1);
						case 25: PlayStateAdd.addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 2);
						case 26: PlayStateAdd.addNpcMalaHealthy(x * Reg._tileSize, y * Reg._tileSize +4, 3);
						case 27: PlayStateAdd.addMobBubble(x * Reg._tileSize, y * Reg._tileSize);
						case 28: PlayStateAdd.addNpcDogLady(x * Reg._tileSize, y * Reg._tileSize);
						case 29: PlayStateAdd.addNpcDog(x * Reg._tileSize, y * Reg._tileSize, Reg.state.player, 1);
						case 30: PlayStateAdd.addNpcDog(x * Reg._tileSize, y * Reg._tileSize, Reg.state.player, 2);
						case 31: PlayStateAdd.addNpcDog(x * Reg._tileSize, y * Reg._tileSize, Reg.state.player, 3);
						case 32: PlayStateAdd.addNpcDog(x * Reg._tileSize, y * Reg._tileSize, Reg.state.player, 4);
						case 33: PlayStateAdd.addNpcDoctor(x * Reg._tileSize, y * Reg._tileSize);
						case 49: PlayStateAdd.addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 50: PlayStateAdd.addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 51: PlayStateAdd.addMobSlime(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 52: PlayStateAdd.addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 1);
						case 53: PlayStateAdd.addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 2);
						case 54: PlayStateAdd.addMobCutter(x * Reg._tileSize, y * Reg._tileSize - 2, 3);
						case 57: PlayStateAdd.addMobApple(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 58: PlayStateAdd.addMobApple(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 59: PlayStateAdd.addMobApple(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 60: PlayStateAdd.addMobBat(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 61: PlayStateAdd.addMobBat(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 62: PlayStateAdd.addMobBat(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 65: PlayStateAdd.addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 66: PlayStateAdd.addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 67: PlayStateAdd.addMobSqu(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 68: PlayStateAdd.addMobFish(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 69: PlayStateAdd.addMobFish(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 70: PlayStateAdd.addMobFish(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 73: PlayStateAdd.addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 74: PlayStateAdd.addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 75: PlayStateAdd.addMobGlob(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 76: PlayStateAdd.addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 77: PlayStateAdd.addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 78: PlayStateAdd.addMobWorm(x * Reg._tileSize, y * Reg._tileSize, 3);
						
						
						//------------- items / objects.
						case 257: PlayStateAdd.addDiamond(x * Reg._tileSize, y * Reg._tileSize);
						case 258: PlayStateAdd.addDoor(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 259: PlayStateAdd.addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 260: PlayStateAdd.addDoor(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 261: PlayStateAdd.addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 262: PlayStateAdd.addItemJump(x * Reg._tileSize, y * Reg._tileSize, 1);	
						case 263: PlayStateAdd.addItemGunFlame(x * Reg._tileSize, y * Reg._tileSize);		
						case 264: PlayStateAdd.addItemGunRapidFire(x * Reg._tileSize, y * Reg._tileSize);	
						case 265: PlayStateAdd.addSavePoint(x * Reg._tileSize, y * Reg._tileSize);	
						// horizontal for id 1 and 2. 3 is vertical.
						case 266: PlayStateAdd.addPlatformMoving(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 267: PlayStateAdd.addPlatformMoving(x * Reg._tileSize, (y * Reg._tileSize) - Reg._tileSize, 2);
						case 268: PlayStateAdd.addObjectFireballBlock(x * Reg._tileSize, y * Reg._tileSize);
						case 269: PlayStateAdd.addWaterParameter(x * Reg._tileSize, y * Reg._tileSize);
						case 270: PlayStateAdd.addLaserBeam(x * Reg._tileSize + 4, y * Reg._tileSize);
						case 271: PlayStateAdd.addLaserParameter(x * Reg._tileSize, y * Reg._tileSize);
						case 272: PlayStateAdd.addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 273: PlayStateAdd.addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 274: PlayStateAdd.addBlockDisappearing(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 275: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize + 17, 1);
						case 276: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 277: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 278: PlayStateAdd.addSpikeTrap(x * Reg._tileSize + 17, y * Reg._tileSize, 4);
						case 279: PlayStateAdd.addFlyingHat(x * Reg._tileSize, y * Reg._tileSize);
						case 280: PlayStateAdd.addFlyingHatPlatform(x * Reg._tileSize, y * Reg._tileSize);
						case 281: PlayStateAdd.addHeartContainer(x * Reg._tileSize, y * Reg._tileSize);		
						case 282: PlayStateAdd.addItemGun(x * Reg._tileSize, y * Reg._tileSize);
						case 283: PlayStateAdd.addNpcShovel(x * Reg._tileSize, y * Reg._tileSize);
						case 284: PlayStateAdd.addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 285: PlayStateAdd.addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 286: PlayStateAdd.addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 287: PlayStateAdd.addGrassWeed(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 288: PlayStateAdd.addWateringCan(x * Reg._tileSize, y * Reg._tileSize);
						case 289: PlayStateAdd.addLadder(x * Reg._tileSize + 12, y * Reg._tileSize - 5, 1);
						case 290: PlayStateAdd.addDoorHouse(x * Reg._tileSize + 1, y * Reg._tileSize + 1);
						case 291: PlayStateAdd.addTreasureChest(x * Reg._tileSize, y * Reg._tileSize);
						case 292: PlayStateAdd.addDoor(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 293: PlayStateAdd.addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 294: PlayStateAdd.addDoor(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 295: PlayStateAdd.addItemDoorKey(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 296: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 297: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 298: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 299: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 300: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 301: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 302: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 303: PlayStateAdd.addItemSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 304: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 305: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 306: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 307: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 308: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 309: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 310: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 311: PlayStateAdd.addObjectSuperBlock(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 312: PlayStateAdd.addComputer(x * Reg._tileSize, y * Reg._tileSize);
						case 313: PlayStateAdd.addItemSwimmingSkill(x * Reg._tileSize, y * Reg._tileSize);
						case 314: PlayStateAdd.addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 315: PlayStateAdd.addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 316: PlayStateAdd.addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 317: PlayStateAdd.addWaterCurrent(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 318: PlayStateAdd.addVineMoving(x * Reg._tileSize + 8, y * Reg._tileSize, 1);
						case 319: PlayStateAdd.addCannon(x * Reg._tileSize, y * Reg._tileSize - 5, 1);
						case 320: PlayStateAdd.addCannon(x * Reg._tileSize, y * Reg._tileSize - 5, 2);
						case 321: PlayStateAdd.addItemGunFreeze(x * Reg._tileSize, y * Reg._tileSize);
						case 322: PlayStateAdd.addBlockedCracked(x * Reg._tileSize, y * Reg._tileSize);
						case 323: PlayStateAdd.addPlatformMoving(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 324: PlayStateAdd.addPlatformParameter(x * Reg._tileSize, y * Reg._tileSize);
						
						case 326: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 327: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 328: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize + 10, 3);
						case 329: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize + 24, 4);
						case 330: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize + 12, 5);
						case 331: PlayStateAdd.addRock(x * Reg._tileSize, y * Reg._tileSize + 17, 6);
						case 332: PlayStateAdd.addSign(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 333: PlayStateAdd.addSign(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 334: PlayStateAdd.addTeleporter(x * Reg._tileSize, y * Reg._tileSize);
						case 335: PlayStateAdd.addDogFlute(x * Reg._tileSize, y * Reg._tileSize);
						case 336: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 337: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 338: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 7);
						case 339: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 340: PlayStateAdd.addSpikeTrap(x * Reg._tileSize, y * Reg._tileSize + 10, 9);
						case 341: PlayStateAdd.addJumpingPad(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 342: PlayStateAdd.addJumpingPad(x * Reg._tileSize + 24, y * Reg._tileSize, 2);
						case 343: PlayStateAdd.addSpikeFalling(x * Reg._tileSize + 7, y * Reg._tileSize);
						case 344: PlayStateAdd.addItemAnitgravitySuit(x * Reg._tileSize, y * Reg._tileSize);
						case 345: PlayStateAdd.addLavaBlock(x * Reg._tileSize, y * Reg._tileSize);			
						case 346: PlayStateAdd.addQuickSand(x * Reg._tileSize, y * Reg._tileSize);		
						case 347: PlayStateAdd.addItemSkillDash(x * Reg._tileSize, y * Reg._tileSize);
						case 348: PlayStateAdd.addCar(x * Reg._tileSize, y * Reg._tileSize - 33);
						case 349: PlayStateAdd.addRockFalling(x * Reg._tileSize, y * Reg._tileSize - 100);
					}
				}
			}
		}		
		
		if (Reg.state._bullets != null) Reg.state.add(Reg.state._bullets);
		if (Reg.state._bulletsMob != null)Reg.state.add(Reg.state._bulletsMob);
		if (Reg.state._bulletsObject != null)Reg.state.add(Reg.state._bulletsObject);
		
		// player is displayed in front of enemies.
		if (Reg.state.enemies != null)Reg.state.add(Reg.state.enemies);
		if (Reg.state.enemiesNoCollideWithTileMap != null)Reg.state.add(Reg.state.enemiesNoCollideWithTileMap);
		if (Reg.state.npcs != null)Reg.state.add(Reg.state.npcs);	
		if (Reg.state._objectCage != null)Reg.state.add(Reg.state._objectCage);
		if (Reg.state._objectTube != null)Reg.state.add(Reg.state._objectTube);
		if (Reg.state._objectCar != null)Reg.state.add(Reg.state._objectCar);
		if (Reg.state.player != null)Reg.state.add(Reg.state.player);
		
		
	}	
	
	public static function createOverlaysGroups():Void
	{
		Reg.state._overlaysThatDoNotMove = new FlxGroup();
		Reg.state.add(Reg.state._overlaysThatDoNotMove);
		Reg.state._overlayLaserBeam = new FlxGroup();
		Reg.state.add(Reg.state._overlayLaserBeam);
	}
	
	public static function createLayer4OverlaySprites():Void
	{
		// get the csv file that stores the objects. within the tiled map editot, the objects
		// graphics are loaded and then an object is displayed on the map. then that map is
		// exported as .csv file. the follow will get the object data.
		var objectData:String;
		
		if (Reg._testItems == false)  objectData = Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse +  "_Layer 4 overlays sprites.csv");
		else objectData = Assets.getText("assets/data/Map-Test-Items1_Layer 4 overlays sprites.csv");
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
						case 0: PlayStateAdd.addWave(x * Reg._tileSize, y * Reg._tileSize);
						// case 1: addWater function is not used. search for waterplayer or read LAYER 5 INFORMATION.txt
						case 2: PlayStateAdd.addLaserBlock(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 3: PlayStateAdd.addLaserBlock(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 4: PlayStateAdd.addAirBubble(x * Reg._tileSize, y * Reg._tileSize);
						
						case 8: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 9: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 10: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 11: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 12: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 13: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 14: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 7);
						
						case 16: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 17: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 9);
						case 18: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 10);
						case 19: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 11);
						
						case 21: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 12);
						case 22: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 13);
						
						case 24: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 14);
						case 25: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 15);
						case 26: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 16);
						case 27: PlayStateAdd.addPipe1(x * Reg._tileSize, y * Reg._tileSize, 17);
						
						case 32: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 1);
						case 33: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 2);
						case 34: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 3);
						case 35: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 4);
						case 36: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 5);
						case 37: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 6);
						case 38: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 7);
						
						case 40: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 8);
						case 41: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 9);
						case 42: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 10);
						case 43: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 11);
						
						case 45: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 12);
						case 46: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 13);
						
						case 48: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 14);
						case 49: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 15);
						case 50: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 16);
						case 51: PlayStateAdd.addPipe2(x * Reg._tileSize, y * Reg._tileSize, 17);
					}					
				}
			}
		}	
	}	
	
	public static function createLayer5OverlaysTiles():Void
	{
		Reg.state.overlays = new FlxTilemap();		
		if (Reg._testItems == false) Reg.state.overlays.loadMapFromCSV(Assets.getText("assets/data/Map-" + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse + "_Layer 5 overlays tiles.csv"), "assets/images/map5OverlaysTiles.png", Reg._tileSize, Reg._tileSize);
		else Reg.state.overlays.loadMapFromCSV(Assets.getText("assets/data/Map-Test-Items1_Layer 5 overlays tiles.csv"), "assets/images/map5OverlaysTiles.png", Reg._tileSize, Reg._tileSize);
		
		//for (i in 0...4) underlays.setTileProperties(i, FlxObject.NONE);	
		
		Reg.state.add(Reg.state.overlays);

		//the folling code will search for the mob walk any direction tile (index 7) and change it into a blank tile so that when the game starts the tile will be blank.
		
		// The code loops through the map as it increments by its tile size height and then width. It searches for a tile with an index of 7 and then change that tile into an index of 6.
		var newindex:Int = 6;
		for (j in 0...Reg.state.overlays.heightInTiles)
		{
			for (i in 0...Reg.state.overlays.widthInTiles - 1)
			{
				if (Reg.state.overlays.getTile(i, j) == 7)
				{
					Reg.state.overlays.setTile(i, j, newindex, true);
				}	
			}		
		}
		
		// change the slope path to an enpty tile but later use this emtpy tile for checking if mob of player is standing on it.
		for (j in 0...Reg.state.overlays.heightInTiles)
		{
			for (i in 0...Reg.state.overlays.widthInTiles - 1)
			{
				if (Reg.state.overlays.getTile(i, j) == 23)
				{
					Reg.state.overlays.setTile(i, j, 22, true);
				}	
				if (Reg.state.overlays.getTile(i, j) == 31)
				{
					Reg.state.overlays.setTile(i, j, 30, true);
				}	
				if (Reg.state.overlays.getTile(i, j) == 39)
				{
					Reg.state.overlays.setTile(i, j, 38, true);
				}	
				if (Reg.state.overlays.getTile(i, j) == 47)
				{
					Reg.state.overlays.setTile(i, j, 46, true);
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
}
	



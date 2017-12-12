package;

 import flixel.FlxBasic;
 import flixel.FlxG;
 import flixel.FlxObject;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
 import flixel.text.FlxText;
 import flixel.ui.FlxBar;
 import flixel.util.FlxColor;
 using flixel.util.FlxSpriteUtil;

 /**
 * @author galoyo
 * This class displays the hud boxes at the top left corner of the screen. The hud boxes are score, nuggets, diamonds, health, gun power.
 */
 
 class Hud extends FlxGroup
 {
	 /*******************************************************************************************************
	 * This is the background of the hud.
	 */
	 private var _hudBackground:FlxSprite;
	 
	 /*******************************************************************************************************
	  * Total score is displayed here.
	  */
	 private var _scoreHudBox:HudBox;
	 
	 /*******************************************************************************************************
	  * Total diamonds on a map that needs collecting are displayed here. Collecting all diamonds on a map will increase the maximum health by one point.
	  */
	 private var _diamondsHudBox:HudBox;
	 
	 /*******************************************************************************************************
	  * Current player's health is displayed here.
	  */
	 public var _healthHudBox:HudBox;
	 
	 /*******************************************************************************************************
	  * Total nuggets are displayed here. Nuggets are used to buy stuff at the store.
	  */
	 public var _nuggetsHudBox:HudBox;
	 
	 /*******************************************************************************************************
	  * Displays the gun power. The gun power determines how much damage a bullet does to a mob.
	  */
	 private var _gunHudBox:HudBox;
	 
	 /*******************************************************************************************************
	  * Clicking this button will display a subState that has three buttons to choose from. They are Exit button, Title button and Resume button.
	  */
	 private var mainMenu:Button;
	 
	 /*******************************************************************************************************
	 * This hud will not be displayed when inside a house. Stuff at the update() function will be bypassed.
	 */
	 private var _atHouse:Bool = false; 
	 
	 /*******************************************************************************************************
	  * The map coordinate. The first 20 in Map-20-20.tmx is the X value and the second 20 is the Y value. If the player is standing at Map-20-20.tmx and then exits that map from the left side, the X value would decrease by 1. Exiting the map from the north side would decrease the Y value by 1. Exiting the map at the north or east side would increase the X or Y values respectively.
	  */
	 private var _displayMapCoordinate:FlxText;
	 
	 /*******************************************************************************************************
	  * The map location of the player.
	  */
	 private var _displayManCoordinate:FlxText;

	public function new()
	{
		super();
		
			
		 // hub size.
         _hudBackground = new FlxSprite().makeGraphic(FlxG.width, 57, FlxColor.BLACK);
		 _hudBackground.scrollFactor.set(0, 0);
		 add(_hudBackground);			 
		
		if (Reg._inHouse == "" )
		{
			_scoreHudBox = new HudBox(0, 0, 90, 50, "Score", 0, 2, Reg, "_score", 11, 14);	
			_scoreHudBox.bgColor = 0x99330066;
			_scoreHudBox.valueColor = 0xFFFFFF00;
			_scoreHudBox.labelColor = 0xFFFFCC00;
			_scoreHudBox.borderColor = 0xCCCC00FF;
			_scoreHudBox.borderWidth = 2;
			_scoreHudBox.bgCornerRadius = 12;
			_scoreHudBox.barPadding = 6;
			_scoreHudBox.barBorderColor = 0xCCCC00FF;
			_scoreHudBox.showBarBorder = true;
			_scoreHudBox.barEmptyColors = [0xFF0000FF];
			_scoreHudBox.barFillColors =  [0xFF0000FF];
			_scoreHudBox.txtLabel.y += 2;
			_scoreHudBox.barValue.y -= 2;
			_scoreHudBox.txtValue.y -= 4;			
			_scoreHudBox.showValue = true;
			add(_scoreHudBox);
			
			_nuggetsHudBox = new HudBox(100, 0, 90, 50, "Nuggets", 0, 2, Reg , "_nuggets", 11, 14);	
			_nuggetsHudBox.bgColor = 0x99330066;
			_nuggetsHudBox.valueColor = 0xFFFFFF00;
			_nuggetsHudBox.labelColor = 0xFFFFCC00;
			_nuggetsHudBox.borderColor = 0xCCCC00FF;
			_nuggetsHudBox.borderWidth = 2;
			_nuggetsHudBox.bgCornerRadius = 12;
			_nuggetsHudBox.barPadding = 6;
			_nuggetsHudBox.barBorderColor = 0xCCCC00FF;
			_nuggetsHudBox.showBarBorder = true;
			_nuggetsHudBox.barEmptyColors = [0xFF0000FF];
			_nuggetsHudBox.barFillColors =  [0xFF0000FF];
			_nuggetsHudBox.txtLabel.y += 2;
			_nuggetsHudBox.barValue.y -= 2;
			_nuggetsHudBox.txtValue.y -= 4;
			_nuggetsHudBox.showValue = true;		
			add(_nuggetsHudBox);
			
			_diamondsHudBox = new HudBox(200, 0, 90, 50, "Diamonds", 0, 2, Reg, "diamondsRemaining", 11, 14);	
			_diamondsHudBox.bgColor = 0x99330066;
			_diamondsHudBox.valueColor = 0xFFFFFF00;
			_diamondsHudBox.labelColor = 0xFFFFCC00;
			_diamondsHudBox.borderColor = 0xCCCC00FF;
			_diamondsHudBox.borderWidth = 2;
			_diamondsHudBox.bgCornerRadius = 12;
			_diamondsHudBox.barPadding = 6;
			_diamondsHudBox.barBorderColor = 0xCCCC00FF;
			_diamondsHudBox.showBarBorder = true;
			_diamondsHudBox.barEmptyColors = [0xFF8f0f0f];
			_diamondsHudBox.barFillColors =  [0xFF0000FF];
			_diamondsHudBox.txtLabel.y += 2;
			_diamondsHudBox.barValue.y -= 2;
			_diamondsHudBox.txtValue.y -= 4;
			if(Reg.diamondsRemaining > 0 ) _diamondsHudBox.setRange(0,Reg.diamondsRemaining);
			_diamondsHudBox.showValue = true;
			_diamondsHudBox.valueSuffix = " / " + Std.string(Reg.diamondsRemaining);
			add(_diamondsHudBox);
				
			_healthHudBox = new HudBox(300, 0, 90, 50, "Health", 0, 2, Reg.state.player , "health", 11, 14);	
			_healthHudBox.bgColor = 0x99330066;
			_healthHudBox.valueColor = 0xFFFFFF00;
			_healthHudBox.labelColor = 0xFFFFCC00;
			_healthHudBox.borderColor = 0xCCCC00FF;
			_healthHudBox.borderWidth = 2;
			_healthHudBox.bgCornerRadius = 12;
			_healthHudBox.barPadding = 6;
			_healthHudBox.barBorderColor = 0xCCCC00FF;
			_healthHudBox.showBarBorder = true;
			_healthHudBox.barEmptyColors = [0xFF8f0f0f];
			_healthHudBox.barFillColors =  [0xFF0000FF];
			_healthHudBox.txtLabel.y += 2;
			_healthHudBox.barValue.y -= 2;
			_healthHudBox.txtValue.y -= 4;
			_healthHudBox.setRange(0, Reg._healthMaximum);
			_healthHudBox.valueSuffix = " / " + Std.string(Reg._healthMaximum);
			_healthHudBox.showValue = true;		
			add(_healthHudBox);
			
			_gunHudBox = new HudBox(400, 0, 90, 50, "Gun Power", 0, 2, Reg , "_gunHudBoxCollectedTriangles", 11, 14);	
			_gunHudBox.bgColor = 0x99330066;
			_gunHudBox.valueColor = 0xFFFFFF00;
			_gunHudBox.labelColor = 0xFFFFCC00;
			_gunHudBox.borderColor = 0xCCCC00FF;
			_gunHudBox.borderWidth = 2;
			_gunHudBox.bgCornerRadius = 12;
			_gunHudBox.barPadding = 6;
			_gunHudBox.barBorderColor = 0xCCCC00FF;
			_gunHudBox.showBarBorder = true;
			_gunHudBox.barEmptyColors = [0xFF8f0f0f];
			_gunHudBox.barFillColors =  [0xFF0000FF];
			_gunHudBox.txtLabel.y += 2;
			_gunHudBox.barValue.y -= 2;
			_gunHudBox.txtValue.y -= 4;
			_gunHudBox.setRange(0, Reg._gunHudBoxMaximumTriangles);
			_gunHudBox.showValue = true;
			_gunHudBox.showPower = true; 
			_gunHudBox.powerColor = FlxColor.WHITE;
			_gunHudBox.maxPower = 3;
			_gunHudBox.power = Std.int(Reg._gunPower);
			_gunHudBox.valueSuffix = " / " + Std.string(Reg._gunHudBoxMaximumTriangles) ;
			_gunHudBox.hidePowerWhenZero = false; 
			add(_gunHudBox);
			
			mainMenu = new Button(540, 0, "m: Menu", 90, 50, null, 16, 0xFFCCFF33, 0, Reg.state.mainMenuChoices);
			mainMenu.label.font = Reg.defaultFont;
		add(mainMenu);
			
			// display the map coordinate at the top right corner of the screen.	
			_displayMapCoordinate = new FlxText(680, 1, 0, "Map " + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords));
			// set the properties of the font and then add the font to the screen.
			_displayMapCoordinate.color = FlxColor.WHITE;
			_displayMapCoordinate.size = 16;
			_displayMapCoordinate.scrollFactor.set();
			_displayMapCoordinate.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
			add(_displayMapCoordinate);
			
			// display the man coordinate at the top right corner of the screen.		
			_displayManCoordinate = new FlxText(680, 29, 0, "Man " + Std.string(Reg.state.player.x / Reg._tileSize) + "-" + Std.string(Reg.state.player.y / Reg._tileSize));
			// set the properties of the font and then add the font to the screen.
			_displayManCoordinate.color = FlxColor.WHITE;
			_displayManCoordinate.size = 16;
			_displayManCoordinate.scrollFactor.set();
			_displayManCoordinate.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
			add(_displayManCoordinate);
		
			_atHouse = false;
		} else _atHouse = true;
     }
	 
	 override public function update(elapsed:Float):Void 
	{			
		// display the gun hub box if not inside the house.
		if (Reg._inHouse == "" && Reg._update == true )
		{
			if (_atHouse == false )
			{
				// make sure that max is always greater than min.
				if (Reg._score > 0 ) _scoreHudBox.setRange(0, (Reg._score + 2));
				if (Reg._nuggets > 0 ) _nuggetsHudBox.setRange(0, (Reg._nuggets + 2));
				
				_gunHudBox.setRange(0, Reg._gunHudBoxMaximumTriangles = (Reg._gunPower - 1) * Reg._gunHudBoxCollectedTrianglesIncreaseBy + Reg._gunHudBoxCollectedTrianglesIncreaseBy);			
				_gunHudBox.valueSuffix = " / " + Std.string(Reg._gunHudBoxMaximumTriangles);
				
				_healthHudBox.setRange(0, Reg._healthMaximum);
				_healthHudBox.valueSuffix = " / " + Std.string(Reg._healthMaximum);			
						
				// update the map and man coordinate at the top right corner of the screen.
				if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19 
				 || Reg.mapXcoords == 24 && Reg.mapYcoords == 19 
				 || Reg.mapXcoords == 25 && Reg.mapYcoords == 19 
				 || Reg.mapXcoords == 26 && Reg.mapYcoords == 19)
				{
					var carMap:Int = 0;
					var playerMap:Int = 0;
					
					if (Reg._playerInsideCar == true)
					{
					// the parallax car map is 100 tiles wide. since the normal map is one forth that amount, make that map x coords at the top right side of screen increase by one when the car drives every 25 tiles so it will give an effect tht the car is driving passed four maps.
					if (Std.int(Reg.state._objectCar.x / Reg._tileSize) >= 74) carMap = 3; 
					else if (Std.int(Reg.state._objectCar.x / Reg._tileSize) >= 49) carMap = 2;
					else if (Std.int(Reg.state._objectCar.x / Reg._tileSize) >= 24) carMap = 1;
					
					var carMapCoords:Float = Reg.mapXcoords + carMap;
					
					var carOffset = 0;
					if (Reg.state._objectCar.facing == FlxObject.LEFT) carOffset = 4;
					var carManOffset = Std.int(Reg.state._objectCar.x  / Reg._tileSize) + carOffset;
					
						_displayMapCoordinate.text = "Map " + Std.string(carMapCoords) + "-" + Std.string(Reg.mapYcoords);
						_displayManCoordinate.text = "Man " + Std.string(carManOffset) + "-" + Std.string(Std.int(Reg.state._objectCar.y / Reg._tileSize));
					}
					
					else
					{
						if (Std.int(Reg.state.player.x / Reg._tileSize) >= 74) playerMap = 3; 
						else if (Std.int(Reg.state.player.x / Reg._tileSize) >= 49) playerMap = 2;
						else if (Std.int(Reg.state.player.x / Reg._tileSize) >= 24) playerMap = 1;
					
						var playerMapCoords:Float = Reg.mapXcoords + playerMap;
						
						_displayMapCoordinate.text = "Map " + Std.string(playerMapCoords) + "-" + Std.string(Reg.mapYcoords);
						_displayManCoordinate.text = "Man " + Std.string(Std.int(Reg.state.player.x / Reg._tileSize)) + "-" + Std.string(Std.int(Reg.state.player.y / Reg._tileSize));
					}
				}
				
				else
				{
					_displayMapCoordinate.text = "Map " + Std.string(Reg.mapXcoords) + "-" + Std.string(Reg.mapYcoords);
					_displayManCoordinate.text = "Man " + Std.string(Std.int(Reg.state.player.x / Reg._tileSize)) + "-" + Std.string(Std.int(Reg.state.player.y / Reg._tileSize));
					//--------------------------------
				}
			}
		}
		
		super.update(elapsed);	
	}
	
	public function decreaseGunPowerCollected():Void
	{			
		if (Reg._inHouse == "" )
		{
			_gunHudBox.valuePrefix = "";
			_gunHudBox.showValue = true;
			Reg._gunHudBoxDisplayMaximumText = false;
			
			// if gun power is not zero, decrease the text value. if the value is minus zero then add to the value. for example, if gun power collected is 1 with a power of 1, if a hit for 2 results in power of 0 and power collected will be 1 minus 2 which will give -1, then a ten is added so that the result will be 9. 
			if (Reg._gunHudBoxCollectedTriangles <= 0 && _gunHudBox.power > 1)
			{	 
				Reg._gunHudBoxCollectedTriangles += Reg._gunHudBoxMaximumTriangles = (Reg._gunPower - 2) * Reg._gunHudBoxCollectedTrianglesIncreaseBy + Reg._gunHudBoxCollectedTrianglesIncreaseBy;
				_gunHudBox.value = Reg._gunHudBoxCollectedTriangles;			
				_gunHudBox.power--; Reg._gunPower = _gunHudBox.power;
				if (Reg._soundEnabled == true) FlxG.sound.play("bulletDown", 1, false);
				
			}	
			// when power is zero, do not let the gun power collected value drop below zero.
			else if (Reg._gunHudBoxCollectedTriangles <= 0 && _gunHudBox.power == 1)
				_gunHudBox.value = Reg._gunHudBoxCollectedTriangles = 0;
			else _gunHudBox.value = Reg._gunHudBoxCollectedTriangles;		
		}
		
	}	
	
	public function increaseGunPowerCollected():Void
	{
		if (Reg._inHouse == "" )
		{
			if(_gunHudBox.power < _gunHudBox.maxPower)
			{
				if (Reg._gunHudBoxCollectedTriangles >= Reg._gunHudBoxMaximumTriangles + 1)
				{
					_gunHudBox.power++; Reg._gunPower = _gunHudBox.power;
					Reg._gunHudBoxCollectedTriangles -= Reg._gunHudBoxMaximumTriangles;
					_gunHudBox.value = Reg._gunHudBoxCollectedTriangles;			
					
					if (Reg._soundEnabled == true) FlxG.sound.play("bulletUp", 1, false);
					
					_gunHudBox.valuePrefix = "";
					_gunHudBox.showValue = true;
					Reg._gunHudBoxDisplayMaximumText = false;
				}	
			}		
					
			// if gun power is full then display the word maximum instead of the number of triangles in the hud box.
			if (_gunHudBox.power == _gunHudBox.maxPower && Reg._gunHudBoxCollectedTriangles >= Reg._gunHudBoxMaximumTriangles)
			{	
				_gunHudBox.valuePrefix = "Maximum";
				_gunHudBox.showValue = false;
				_gunHudBox.value = Reg._gunHudBoxCollectedTriangles = Reg._gunHudBoxMaximumTriangles;			
				Reg._gunHudBoxDisplayMaximumText = true;
			}
		}
 	}
	
 }
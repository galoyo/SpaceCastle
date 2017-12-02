package;

import flash.Lib;
import flash.display.BlendMode;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
using flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class ObjectMap extends FlxSubState
{
	// Size of the camera scene.
	private var _mapSizeMinimumX:Int = 0;
	private var _mapSizeMaximumX:Int = 2700;
	private var _mapSizeMinimumY:Int = 0;
	private var _mapSizeMaximumY:Int = 2118;

	private var _halfWidth:Int = 340;
	private var _halfHeight:Int = 264;
	
	private var _tracker:FlxSprite;

	/*******************************************************************************************************
	 * Buttons displayed at the bottom of the screen. The images of those buttons are the left, up, down, right arrows, and the big letters of Z, X, C, I.
	 */
	public var _buttonsNavigation:ButtonsNavigation;
	
	public function new():Void
	{
		super();	
			
		// make the background semi-transparent.
		var background = new FlxSprite(0, 0);
		background.makeGraphic(_mapSizeMaximumX, _mapSizeMaximumY, 0xFF000000);
		background.scrollFactor.set(0, 0);	
		add(background);

		// Center the tracker on the screen. When an arrow key is pressed, the tracker will change direction. But because the camera follows this tracker, the scene will move while this tracker stays centered.
		_tracker = new FlxSprite(0, 0);
		_tracker.setPosition(0,0);
		_tracker.makeGraphic(1, 1, FlxColor.RED);
		add(_tracker);
				
		// Display the mini map on the screen.
		createMap();
				
		// camera. This code create a lafge scene. This scene is larger than the screen. Use the arrow keys to see the rest of this scene.
		FlxG.camera.setScrollBoundsRect(_mapSizeMinimumX, _mapSizeMinimumY, _mapSizeMaximumX + Math.abs(_mapSizeMinimumX) + Reg._tileSize + 155, _mapSizeMaximumY + Math.abs(_mapSizeMinimumY) + Reg._tileSize + 155, true);
		FlxG.camera.follow(_tracker, FlxCameraFollowStyle.LOCKON);
			
		_buttonsNavigation = new ButtonsNavigation();		
		add(_buttonsNavigation);
		
		_buttonsNavigation.zButtonSelectedIcon.visible = false;
		_buttonsNavigation.xButtonSelectedIcon.visible = false;
		_buttonsNavigation.cButtonSelectedIcon.visible = false;
		
		_buttonsNavigation.buttonX.visible = false;
		_buttonsNavigation.buttonC.visible = false;
		_buttonsNavigation.buttonI.visible = false;	
		
		// Display the mini map symbols to help understand what the drawn squares and circles represent.
		_buttonsNavigation._miniMapUnexplored.visible = true;
		_buttonsNavigation._miniMapUnexploredText.visible = true;
		_buttonsNavigation._miniMapExplored.visible = true;
		_buttonsNavigation._miniMapExploredText.visible = true;
		_buttonsNavigation._miniMapPlayer.visible = true;
		_buttonsNavigation._miniMapPlayerText.visible = true;
		_buttonsNavigation._miniMapItem.visible = true;
		_buttonsNavigation._miniMapItemText.visible = true;
		
		var title = new FlxText(0, 50, 0, "Mini Map");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.GREEN);
		title.scrollFactor.set(0, 0);
		title.setPosition(0, 50);
		title.screenCenter(X);
		add(title);
		
	}
	
	override public function update(elapsed:Float):Void 
	{			
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used. This line is needed for the keys/buttons to work.		
		InputControls.checkInput();
		#if !FLX_NO_KEYBOARD
			if (InputControls.left.pressed && !InputControls.up.pressed && _tracker.x > _halfWidth - 20
			||  InputControls.left.pressed && !InputControls.down.pressed && _tracker.x > _halfWidth - 20)
			{
				_tracker.velocity.x = -1000;
				_tracker.velocity.y = 0;
			}
			
			else if (InputControls.right.pressed && !InputControls.up.pressed && _tracker.x < _mapSizeMaximumX - _halfWidth - 48
			      || InputControls.right.pressed && !InputControls.down.pressed && _tracker.x < _mapSizeMaximumX - _halfWidth - 48)
			{
				_tracker.velocity.x = 1000;
				_tracker.velocity.y = 0;
			}
			
			else if (InputControls.up.pressed && !InputControls.left.pressed && _tracker.y > _halfHeight - 18
			    ||   InputControls.up.pressed && !InputControls.right.pressed && _tracker.y > _halfHeight - 18)
			{
				_tracker.velocity.x = 0;
				_tracker.velocity.y = - 1000;
			}
			
			else if (InputControls.down.pressed && !InputControls.left.pressed && _tracker.y < _mapSizeMaximumY - _halfHeight - 28
				||   InputControls.down.pressed && !InputControls.right.pressed && _tracker.y < _mapSizeMaximumY - _halfHeight - 28)
			{
				_tracker.velocity.x = 0;
				_tracker.velocity.y = 1000;
			}
			
			else _tracker.velocity.x = _tracker.velocity.y = 0;	
				
			if (InputControls.z.justReleased) 
			{
				Reg.setCamera();
				close();	
			}
		#else

			if (_buttonsNavigation.buttonLeft.pressed && !_buttonsNavigation.buttonUp.pressed && _tracker.x > _halfWidth - 20
			||  _buttonsNavigation.buttonLeft.pressed && !_buttonsNavigation.buttonDown.pressed && _tracker.x > _halfWidth - 20)
			{
				_tracker.velocity.x = -1000;
				_tracker.velocity.y = 0;
			}
			
			else if (_buttonsNavigation.buttonRight.pressed && !_buttonsNavigation.buttonUp.pressed && _tracker.x < _mapSizeMaximumX - _halfWidth - 48
			      || _buttonsNavigation.buttonRight.pressed && !_buttonsNavigation.buttonDown.pressed && _tracker.x < _mapSizeMaximumX - _halfWidth - 48)
			{
				_tracker.velocity.x = 1000;
				_tracker.velocity.y = 0;
			}
			
			else if (_buttonsNavigation.buttonUp.pressed && !_buttonsNavigation.buttonLeft.pressed && _tracker.y > _halfHeight - 18
			    ||   _buttonsNavigation.buttonUp.pressed && !_buttonsNavigation.buttonRight.pressed && _tracker.y > _halfHeight - 18)
			{
				_tracker.velocity.x = 0;
				_tracker.velocity.y = - 1000;
			}
			
			else if (_buttonsNavigation.buttonDown.pressed && !_buttonsNavigation.buttonLeft.pressed && _tracker.y < _mapSizeMaximumY - _halfHeight - 28
				||   _buttonsNavigation.buttonDown.pressed && !_buttonsNavigation.buttonRight.pressed && _tracker.y < _mapSizeMaximumY - _halfHeight - 28)
			{
				_tracker.velocity.x = 0;
				_tracker.velocity.y = 1000;
			}
			
			else _tracker.velocity.x = _tracker.velocity.y = 0;	
			
			if (_buttonsNavigation.buttonZ.justReleased)
			{
				Reg.setCamera();
				close();
			}
		#end		
		
		if (InputControls.z.justPressed) 
		{
			Reg.setCamera();
			close();	
		}
		super.update(elapsed);
		
	} 	

	private function createMap():Void
	{
		// Loop through every Y value in every outside maps.
		for (mapY in 0...Reg._maps_X_Y_OutsideTotalManual.length)
		{
			// loop through every X value in every outside map.
			for (mapX in 0...Reg._maps_X_Y_OutsideTotalManual.length)
			{
				// Search to determine if the X and Y value exists in the total map var. If true then display the map.
				for (i in 0...Reg._maps_X_Y_OutsideTotalManual.length)
				{
					if (Reg._maps_X_Y_OutsideTotalManual[i][0] == mapX + "-" + mapY)
					{
						var offsetX:Int = 0;
						
						// Create and then display a small square white map. The offset var is used when an odd sized map needs to be displayed.
						var _miniMap = new FlxSprite(0, 0);
						if (mapX == 23 && mapY == 19) offsetX = 120;						
						_miniMap.makeGraphic(32 + offsetX, 24, FlxColor.WHITE);
						
						// Make all small mini maps the color orange that the player has been to.
						for (i in 0...Reg._mapsThatPlayerHasBeenTo.length)
						{
							if (Reg._mapsThatPlayerHasBeenTo[i] == mapX + "-" + mapY)
								_miniMap.makeGraphic(32 + offsetX, 24, FlxColor.ORANGE);
						}
									
						// This mini map colored purple refers to the current location of the player.
						if (Reg.mapXcoords == mapX && Reg.mapYcoords == mapY)
						{
							_miniMap.makeGraphic(32 + offsetX, 24, FlxColor.PURPLE);
							_tracker.setPosition(_halfWidth + 20 + mapX * 40, _halfHeight + 18 + mapY * 32);
						}
											
						_miniMap.setPosition(_halfWidth + mapX * 40, _halfHeight + mapY * 32);
						add(_miniMap);						
						
						// This code block will draw a circle overtop every mini map that has an item for the player to pick up. 
						for (i in 0...Reg._mapsThatHaveAnItem.length)
						{
							if (Reg._mapsThatHaveAnItem[i] == mapX + "-" + mapY)
							{
								var _itemIsAtThisMap = new FlxSprite(0, 0);
								_itemIsAtThisMap.makeGraphic(20 + offsetX, 12, FlxColor.TRANSPARENT);
								_itemIsAtThisMap.drawCircle( -1, -1, -1, FlxColor.GREEN);
								_itemIsAtThisMap.setPosition(_halfWidth + 6 + mapX * 40, _halfHeight + 6 + mapY * 32);
								add(_itemIsAtThisMap);
							}
						}
						
						// draw the doorways on the map.
						doorways(Std.parseInt(Reg._maps_X_Y_OutsideTotalManual[i][1]), mapX, mapY, offsetX);							
					}		
				}
			}
		}
	}

	private function doorways(id:Int, mapX:Int, mapY:Int, offsetX:Int):Void
	{
		// These values are called doorway IDs. See /dev/README FIRST.html doorways. The ID values have been passed to this function from the _maps_X_Y_OutsideTotalManual var at Reg.hx. That var needs to be updated everytime a new map is created.
		
		// left doorway.				
		if (id == 1 || id == 3 || id == 5 || id == 7 || id == 9 || id == 11 || id == 13 || id == 15)
		{						
			var doorway = new FlxSprite(0, 0);
			doorway.makeGraphic(8, 8, FlxColor.YELLOW);
			doorway.setPosition(_halfWidth + mapX * 40 - 8, _halfHeight + mapY * 32 + 8); 
			add(doorway);	
		}
		
		// up doorway.
		if (id == 2 || id == 3 || id ==6 || id == 7 || id == 10 || id == 11 || id == 14 || id == 15)
		{						
			var doorway = new FlxSprite(0, 0);
			doorway.makeGraphic(8, 8, FlxColor.YELLOW);
			doorway.setPosition(_halfWidth + mapX * 40 + 12, _halfHeight + mapY * 32 - 8); 
			add(doorway);
		}  
		
		// right doorway.				
		if (id == 4 || id == 5 || id == 6 || id == 7 || id == 12 || id == 13 || id == 14 || id == 15)
		{						
			var doorway = new FlxSprite(0, 0);
			doorway.makeGraphic(8, 8, FlxColor.YELLOW);
			doorway.setPosition(_halfWidth + mapX * 40 + offsetX + 32, _halfHeight + mapY * 32 + 8); 
			add(doorway);	
		}
		
		// down doorway.
		if (id == 8 || id == 9 || id == 10 || id == 11 || id == 12 || id == 13 || id == 14 || id == 15)
		{						
			var doorway = new FlxSprite(0, 0);
			doorway.makeGraphic(8, 8, FlxColor.YELLOW);
			doorway.setPosition(_halfWidth + mapX * 40 + offsetX + 12, _halfHeight + mapY * 32 + 28 - 4); 
			add(doorway);
		}

	}
}

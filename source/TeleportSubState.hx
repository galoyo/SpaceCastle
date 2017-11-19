package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import openfl.system.System;
import openfl.text.Font;

#if !FLX_NO_KEYBOARD 
	import flixel.input.keyboard.FlxKey;
#end

/**
 * @author galoyo
 */

class TeleportSubState extends FlxSubState
{	
	private var screenBox:FlxSprite;
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var title:FlxText;
	private var ticks:Float = 0;
	private var ticksDelay:Bool = false;
	
	public var button1:Button;
	public var button2:Button;
	public var button3:Button;
	public var button4:Button;
	
	public function new():Void
	{
		super();
		
		// Set a background color
		screenBox = new FlxSprite(0, 0);
		screenBox.makeGraphic(FlxG.width, FlxG.height, 0x44000000);
		add(screenBox);
		
		title = new FlxText(0, 50, 0, "Teleporter");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.GREEN);
		title.scrollFactor.set();
		title.setPosition(0, 170);
		title.screenCenter(X);
		add(title);
		
		var selectLevel :FlxText;
		selectLevel = new FlxText(303, 245, 0, "Teleport to what level?");
		selectLevel.color = FlxColor.YELLOW;
		selectLevel.size = 12;
		selectLevel.scrollFactor.set();
		selectLevel.alignment = FlxTextAlign.CENTER;
		selectLevel.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
		add(selectLevel);
		
		var brickMoor :FlxText;
		brickMoor = new FlxText(333, 280, 0, "Brick Moor.");
		brickMoor.color = FlxColor.WHITE;
		brickMoor.size = 14;
		brickMoor.scrollFactor.set();
		brickMoor.alignment = FlxTextAlign.CENTER;
		brickMoor.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
		add(brickMoor);
		
		button1 = new Button(303, 273, "1", 30, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		add(button1);
		
		if (Reg._itemGotKey[2] == true)
		{
			var blueTown :FlxText;
			blueTown = new FlxText(333, 310, 0, "Blue Town.");
			blueTown.color = FlxColor.WHITE;
			blueTown.size = 14;
			blueTown.scrollFactor.set();
			blueTown.alignment = FlxTextAlign.CENTER;
			blueTown.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
			add(blueTown);
			
			button2 = new Button(303, 303, "2", 30, 35, null, 16, 0xFFCCFF33, 0, button2Clicked);
		add(button2);
		}
		
		if (Reg._itemGotKey[3] == true)
		{
			var rockFactor :FlxText;
			rockFactor = new FlxText(303, 340, 0, "Rock Factor.");
			rockFactor.color = FlxColor.WHITE;
			rockFactor.size = 14;
			rockFactor.scrollFactor.set();
			rockFactor.alignment = FlxTextAlign.CENTER;
			rockFactor.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLUE, 4);
			add(rockFactor);	
			
			button3 = new Button(303, 333, "3", 30, 35, null, 16, 0xFFCCFF33, 0, button3Clicked);			
			add(button3);
		}	
		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
		#if !FLX_NO_KEYBOARD
			if (FlxG.keys.anyJustReleased(["ONE"])) 
			{
				button1Clicked();
			}
			
			else if (FlxG.keys.anyJustReleased(["TWO"])) 
			{
				button2Clicked();
			}
		#end
		
		ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
		
		if (ticksDelay == true && ticks > 50) 
		{
			ticks = 0;
			loadPlayState();
		}
		
		if (ticks > 150) ticks = 0;
		
		super.update(elapsed);
	}
	
	private function loadPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function button1Clicked():Void
	{
		Reg.mapXcoords = 20; // map
		Reg.mapYcoords = 20;
		
		// this is true so position the player at the teleporter.
		Reg._teleportedToHouse = true; 
		Reg._inHouse = "-house";
	
		// remember the players last position on the map befor entering the house.
		Reg.playerXcoordsLast = 17 * Reg._tileSize;
		Reg.playerYcoordsLast = 12 * Reg._tileSize;
		
		if (Reg._soundEnabled == true) FlxG.sound.play("teleport1", 1, false);
		ticks = 0; ticksDelay = true;
	}

	private function button2Clicked():Void
	{
		if (Reg._itemGotKey[2] == true)
		{

			Reg.mapXcoords = 18;
			Reg.mapYcoords = 15;
			
			Reg._teleportedToHouse = true;
			Reg._inHouse = "-house";
		
			// remember the players last position on the map befor entering the house.
			Reg.playerXcoordsLast = 3 * Reg._tileSize;
			Reg.playerYcoordsLast = 12 * Reg._tileSize;
			
			if (Reg._soundEnabled == true) FlxG.sound.play("teleport1", 1, false);
			ticks = 0; ticksDelay = true;
		}	
	}
	
	private function button3Clicked():Void
	{
		if (Reg._itemGotKey[3] == true)
		{
			// this level does not exist yet. create a map that is not a house and place a house door on it. at the map editor get the X and Y coords of that door and then place those values in the Reg.playerXcoordsLast and Reg.playerYcoordsLast vars. The Reg.mapXcoords and Reg.mapYcoords is the map you created with the door on it. next create a house and place the teleporter at the far bottom-right side of the room. if in doubt, look at how the house is created by loading another house into the map editor. /root/assets/data 
			Reg.mapXcoords = 24;
			Reg.mapYcoords = 19;
			
			Reg._teleportedToHouse = true;
			Reg._inHouse = "-house";
		
			// remember the players last position on the map befor entering the house.
			Reg.playerXcoordsLast = 42 * Reg._tileSize;
			Reg.playerYcoordsLast = 42 * Reg._tileSize;
			
			if (Reg._soundEnabled == true) FlxG.sound.play("teleport1", 1, false);
			ticks = 0; ticksDelay = true;
		}
	}
}
package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class ButtonsNavigation extends FlxGroup 
{
	public var button1:MouseClickThisButton; // left.
	public var button2:MouseClickThisButton; // right.
	public var button3:MouseClickThisButton; // up.
	public var button4:MouseClickThisButton; // down.
	public var button5:MouseClickThisButton; // action 1.
	public var button6:MouseClickThisButton; // action 2.
	public var button7:MouseClickThisButton; // action 3.
	public var button8:MouseClickThisButton; // menu, imnventory.
	
	private var zButtonSelectedIcon:FlxSprite; // display the selected item beside the z button.
 	private var xButtonSelectedIcon:FlxSprite; 
	private var cButtonSelectedIcon:FlxSprite;
	
	private var _background:FlxSprite;
	
	public function new() 
	{
		super();	
		
		 _background = new FlxSprite().makeGraphic(FlxG.width, 80, FlxColor.BLACK);
		 _background.scrollFactor.set(0, 0);
		 _background.setPosition(0, 537);
		 add(_background);
		 
		button1 = new MouseClickThisButton(0, 538, "", 60, 62, "assets/images/buttonMenuArrowLeft.png", 28, 0xFFCCFF33, 0);
		button1.scrollFactor.set(0, 0);
		add(button1);
		
		button2 = new MouseClickThisButton(65, 538, "", 60, 62,  "assets/images/buttonMenuArrowRight.png", 28, 0xFFCCFF33, 0, buttonArrowRight );
		button2.scrollFactor.set(0, 0);
		add(button2);
		
		button3 = new MouseClickThisButton(130, 538, "", 60, 62, "assets/images/buttonMenuArrowUp.png", 32, 0xFFCCFF33, 0, buttonArrowUp );
		button3.scrollFactor.set(0, 0);
		add(button3);
		
		button4 = new MouseClickThisButton(195, 538, "", 60, 62, "assets/images/buttonMenuArrowDown.png", 28, 0xFFCCFF33, 0, buttonArrowDown );
		button4.scrollFactor.set(0, 0);
		add(button4);
		
		button5 = new MouseClickThisButton(260, 538, "", 84, 62, "assets/images/buttonMenuZ.png", 32, 0xFFCCFF33, 0, buttonZ );
		button5.scrollFactor.set(0, 0);
		add(button5);
		
		button6 = new MouseClickThisButton(349, 538, "", 84, 62, "assets/images/buttonMenuX.png", 28, 0xFFCCFF33, 0, buttonX );
		button6.scrollFactor.set(0, 0);
		add(button6);
		
		button7 = new MouseClickThisButton(438, 538, "", 84, 62, "assets/images/buttonMenuC.png", 28, 0xFFCCFF33, 0, buttonC );
		button7.scrollFactor.set(0, 0);
		add(button7);
		
		button8 = new MouseClickThisButton(740, 538, "", 60, 62, "assets/images/buttonMenuA.png", 28, 0xFFCCFF33, 0, buttonA );
		button8.scrollFactor.set(0, 0);
		add(button8);
		
		zButtonSelectedIcon = new FlxSprite();
		zButtonSelectedIcon.setPosition(306, 551); 
		zButtonSelectedIcon.scrollFactor.set(0, 0);
		zButtonSelectedIcon.visible = false;
		add(zButtonSelectedIcon);
		
		xButtonSelectedIcon = new FlxSprite();
		xButtonSelectedIcon.setPosition(394, 551); 
		xButtonSelectedIcon.scrollFactor.set(0, 0);
		xButtonSelectedIcon.visible = false;
		add(xButtonSelectedIcon);
		
		cButtonSelectedIcon = new FlxSprite();
		cButtonSelectedIcon.setPosition(482, 551); 
		cButtonSelectedIcon.scrollFactor.set(0, 0);
		cButtonSelectedIcon.visible = false;
		add(cButtonSelectedIcon);
		
		findInventoryIconZNumber();
		findInventoryIconXNumber();
		findInventoryIconCNumber();
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		// stop player action when mouse is relesed.
		if (FlxG.mouse.justReleased == true)
		{
			Reg._mouseClickedButtonLeft = false;
			Reg._mouseClickedButtonRight = false;
			Reg._mouseClickedButtonUp = false;
			Reg._mouseClickedButtonDown = false;
		}
		
		Reg._mouseClickedButtonZ = false;
		Reg._mouseClickedButtonX = false;
		Reg._mouseClickedButtonC = false;
		Reg._mouseClickedButtonA = false;
		
		// goes to a function that sets a var that once set, at players.hx, the var is used to move player or fire a weapon.
		if (button1.justPressed == true) buttonArrowLeft();
		else if (button2.justPressed == true) buttonArrowRight();
		else if (button3.justPressed == true) buttonArrowUp();
		else if (button4.justPressed == true) buttonArrowDown();

		super.update(elapsed);
	}
	
	private function buttonArrowLeft():Void
	{
		Reg._mouseClickedButtonLeft = true;
	}	

	private function buttonArrowRight():Void
	{
		Reg._mouseClickedButtonRight = true;
	}	
	
	private function buttonArrowUp():Void
	{
		Reg._mouseClickedButtonUp = true;
	}	
	
	private function buttonArrowDown():Void
	{
		Reg._mouseClickedButtonDown = true;
	}	
	
	private function buttonZ():Void
	{
		Reg._mouseClickedButtonZ = true;
	}	
	
	private function buttonX():Void
	{
		Reg._mouseClickedButtonX = true;
	}	
	
	private function buttonC():Void
	{
		Reg._mouseClickedButtonC = true;
	}	
	
	private function buttonA():Void
	{
		Reg._mouseClickedButtonA = true;
	}		
	
	// z was pressed so we need to set all this array var to false and set only one to true so that only one item is currently selecyed.
	public function resetInventoryIconZNumber(item:Int):Void
	{
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			Reg._inventoryIconZNumber[i] = false;
		}
		
		if (Reg._inventoryIconFilemame[item] != "" )
		{
			zButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[item], false);
			zButtonSelectedIcon.visible = true;
			
			Reg._itemZSelectedFromInventory = item;		
			if (Reg._soundEnabled == true) FlxG.sound.play("menuSelect", 1, false);
		}		
		else 
		{
			zButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
			zButtonSelectedIcon.visible = true;
			Reg._buttonsNavigationUpdate = true;
			if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
		}
	}
	
	// find the item that was selected when the z was pressed at the inventory screen.
	public function findInventoryIconZNumber():Void
	{
		// if this line is read then an empty button was selected.
		zButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
		zButtonSelectedIcon.visible = true;
		Reg._buttonsNavigationUpdate = true;
		
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			if (Reg._inventoryIconZNumber[i] == true)
			{
				zButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[i], false);
				zButtonSelectedIcon.visible = true;
		
				Reg._itemZSelectedFromInventory = i;
				Reg._itemZSelectedFromInventoryName = Reg._inventoryIconName[i];
				break;
			}
		}		
		
	}
	
	public function resetInventoryIconXNumber(item:Int):Void
	{
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			Reg._inventoryIconXNumber[i] = false;
		}
		
		if (Reg._inventoryIconFilemame[item] != "" )
		{
			xButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[item], false);
			xButtonSelectedIcon.visible = true;
			
			Reg._itemXSelectedFromInventory = item;	
			if (Reg._soundEnabled == true) FlxG.sound.play("menuSelect", 1, false);
		}		
		else 
		{
			xButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
			xButtonSelectedIcon.visible = true;
			Reg._buttonsNavigationUpdate = true;
			if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
		}
	}
	
	// find the item that was selected when the x was pressed at the inventory screen.
	public function findInventoryIconXNumber():Void
	{
		// if this line is read then an empty button was selected.
		xButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
		xButtonSelectedIcon.visible = true;
		Reg._buttonsNavigationUpdate = true;
		
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			if (Reg._inventoryIconXNumber[i] == true)
			{
				xButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[i], false);
				xButtonSelectedIcon.visible = true;
		
				Reg._itemXSelectedFromInventory = i;
				Reg._itemXSelectedFromInventoryName = Reg._inventoryIconName[i];
				break;
			}
		}		
		
	}
	
	public function resetInventoryIconCNumber(item:Int):Void
	{
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			Reg._inventoryIconCNumber[i] = false;
		}
		
		if (Reg._inventoryIconFilemame[item] != "" )
		{
			cButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[item], false);
			cButtonSelectedIcon.visible = true;
			
			Reg._itemCSelectedFromInventory = item;
			if (Reg._soundEnabled == true) FlxG.sound.play("menuSelect", 1, false);
			
		}	
		else 
		{
			cButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
			cButtonSelectedIcon.visible = true;
			Reg._buttonsNavigationUpdate = true;
			if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
		}
	}
	
	// find the item that was selected when the c was pressed at the inventory screen.
	public function findInventoryIconCNumber():Void
	{
		// if this line is read then an empty button was selected.
		cButtonSelectedIcon.loadGraphic("assets/images/itemEmptyImage.png", false);
		cButtonSelectedIcon.visible = true;
		Reg._buttonsNavigationUpdate = true;
		
		var max = Reg._inventoryGridXTotalSlots * Reg._inventoryGridYTotalSlots;
		for (i in 0...max)
		{
			if (Reg._inventoryIconCNumber[i] == true)
			{
				cButtonSelectedIcon.loadGraphic("assets/images/" + Reg._inventoryIconFilemame[i], false);
				cButtonSelectedIcon.visible = true;
			
				Reg._itemCSelectedFromInventory = i;
				Reg._itemCSelectedFromInventoryName = Reg._inventoryIconName[i];
				break;
			}
		}

	}

}
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
	public var buttonLeft:MouseClickThisButton; // left.
	public var buttonRight:MouseClickThisButton; // right.
	public var buttonUp:MouseClickThisButton; // up.
	public var buttonDown:MouseClickThisButton; // down.
	public var buttonZ:MouseClickThisButton; // action key first slot.
	public var buttonX:MouseClickThisButton; // action key second slot.
	public var buttonC:MouseClickThisButton; // action key third slot.
	public var buttonI:MouseClickThisButton; // menu, imnventory.
	
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
		 
		buttonLeft = new MouseClickThisButton(0, 538, "", 60, 62, "assets/images/buttonMenuArrowLeft.png", 28, 0xFFCCFF33, 0);
		buttonLeft.scrollFactor.set(0, 0);
		add(buttonLeft);
		
		buttonRight = new MouseClickThisButton(65, 538, "", 60, 62,  "assets/images/buttonMenuArrowRight.png", 28, 0xFFCCFF33, 0 );
		buttonRight.scrollFactor.set(0, 0);
		add(buttonRight);
		
		buttonUp = new MouseClickThisButton(130, 538, "", 60, 62, "assets/images/buttonMenuArrowUp.png", 32, 0xFFCCFF33, 0 );
		buttonUp.scrollFactor.set(0, 0);
		add(buttonUp);
		
		buttonDown = new MouseClickThisButton(195, 538, "", 60, 62, "assets/images/buttonMenuArrowDown.png", 28, 0xFFCCFF33, 0 );
		buttonDown.scrollFactor.set(0, 0);
		add(buttonDown);
		
		buttonZ = new MouseClickThisButton(260, 538, "", 84, 62, "assets/images/buttonMenuZ.png", 32, 0xFFCCFF33, 0 );
		buttonZ.scrollFactor.set(0, 0);
		add(buttonZ);
		
		buttonX = new MouseClickThisButton(349, 538, "", 84, 62, "assets/images/buttonMenuX.png", 28, 0xFFCCFF33, 0 );
		buttonX.scrollFactor.set(0, 0);
		add(buttonX);
		
		buttonC = new MouseClickThisButton(438, 538, "", 84, 62, "assets/images/buttonMenuC.png", 28, 0xFFCCFF33, 0 );
		buttonC.scrollFactor.set(0, 0);
		add(buttonC);
		
		buttonI = new MouseClickThisButton(740, 538, "", 60, 62, "assets/images/buttonMenuI.png", 28, 0xFFCCFF33, 0 );
		buttonI.scrollFactor.set(0, 0);
		add(buttonI);
		
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
		
		#if !FLX_NO_KEYBOARD 
			buttonLeft.active = false;
			buttonRight.active = false;
			buttonUp.active = false;
			buttonDown.active = false;
			buttonZ.active = false;
			buttonX.active = false;
			buttonC.active = false;
			buttonI.active = false;
		#end
	}
	
	override public function update(elapsed:Float):Void 
	{		
		super.update(elapsed);
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
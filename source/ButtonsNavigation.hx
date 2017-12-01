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
	/**
	 * This is the selected item of the Z button. At at inventory menu, if an item is highlighted, pressing the Z button will display the selected item beside the z button. After you have closed the inventory menu, pressing the Z button will do the action of that item selected.
	 */
	public var zButtonSelectedIcon:FlxSprite;
 	
	/**
	 * This is the selected item of the X button.
	 */
	public var xButtonSelectedIcon:FlxSprite;
	
	/**
	 * This is the selected item of the C button.
	 */
	public var cButtonSelectedIcon:FlxSprite;
	
	/**
	 * The player will move in the direction of left when this button is pressed.
	 */
	public var buttonLeft:Button;
	
	/**
	 * The player will move in the direction of right when this button is pressed.
	 */
	public var buttonRight:Button;
	
	/**
	 * If possible, the player will move up when this button is pressed.
	 */
	public var buttonUp:Button;
	
	/**
	 * If possible, the player will move down when this button is pressed.
	 */
	public var buttonDown:Button;
	
	/**
	 * Same as pressing the Z key on the keyboard. Pressing the Z button will do the action of the item it contains. For example, if the item is a jump item then the player will jump.
	 */
	public var buttonZ:Button;
	
	/**
	 * Same as pressing the X key on the keyboard. Pressing the X button will do the action of the item it contains.
	 */
	public var buttonX:Button;
	
	/**
	 * Same as pressing the C key on the keyboard. Pressing the C button will do the action of the item it contains.
	 */
	public var buttonC:Button;
	
	/**
	 * Button to access the inventory menu.
	 */
	public var buttonI:Button;
	
	/**
	 * Background of the navigation bar.
	 */
	private var _background:FlxSprite;
	
	public function new() 
	{
		super();	
		
		 _background = new FlxSprite().makeGraphic(FlxG.width, 80, FlxColor.BLACK);
		 _background.scrollFactor.set(0, 0);
		 _background.setPosition(0, 537);
		 add(_background);
		 
		buttonLeft = new Button(0, 538, "", 60, 62, "assets/images/buttonMenuArrowLeft.png", 28, 0xFFCCFF33, 0);
		buttonLeft.scrollFactor.set(0, 0);
		add(buttonLeft);
		
		buttonRight = new Button(65, 538, "", 60, 62,  "assets/images/buttonMenuArrowRight.png", 28, 0xFFCCFF33, 0 );
		buttonRight.scrollFactor.set(0, 0);
		add(buttonRight);
		
		buttonUp = new Button(130, 538, "", 60, 62, "assets/images/buttonMenuArrowUp.png", 32, 0xFFCCFF33, 0 );
		buttonUp.scrollFactor.set(0, 0);
		add(buttonUp);
		
		buttonDown = new Button(195, 538, "", 60, 62, "assets/images/buttonMenuArrowDown.png", 28, 0xFFCCFF33, 0 );
		buttonDown.scrollFactor.set(0, 0);
		add(buttonDown);
		
		buttonZ = new Button(260, 538, "", 84, 62, "assets/images/buttonMenuZ.png", 32, 0xFFCCFF33, 0 );
		buttonZ.scrollFactor.set(0, 0);
		add(buttonZ);
		
		buttonX = new Button(349, 538, "", 84, 62, "assets/images/buttonMenuX.png", 28, 0xFFCCFF33, 0 );
		buttonX.scrollFactor.set(0, 0);
		add(buttonX);
		
		buttonC = new Button(438, 538, "", 84, 62, "assets/images/buttonMenuC.png", 28, 0xFFCCFF33, 0 );
		buttonC.scrollFactor.set(0, 0);
		add(buttonC);
		
		buttonI = new Button(740, 538, "", 60, 62, "assets/images/buttonMenuI.png", 28, 0xFFCCFF33, 0 );
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
	
	// z was pressed so we need to set all this array var to false and set only one to true so that only one item is currently selected.
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
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

/**
 * @author galoyo
 */

class Inventory extends FlxSubState
{	
	private var _buttonDown:Bool;
	
	//private var screenBox:FlxSprite;
	private var title:FlxSprite;
	private var grid:FlxSprite;
	private var inventoryItemHighlightedSquare:FlxSprite;
	
	private var itemTitle :FlxText; // displays the item title just under the inventory title.
	private var itemDescription:FlxText;
	
	private var _icons:FlxSprite; // the reg._iconFilemame is passed to this class to get the icon sprite.
	private var _iconsGroup:FlxGroup; // add the above sprite to this group so that more than one sprite can be seen on the screen.
	
	public var _buttonsNavigation:ButtonsNavigation; // left, right, up, X, etc buttons.
	private var itemNumberSelected:Int = 0; // the location of the inventoryItemHighlightedSquare on the grid. the first square at the top-left corner of the grid refers to itemNumber 0 and to the right side of it is itemNumber 1;
	
	private var backdropImage:FlxBackdrop = new FlxBackdrop();
	
	public function new():Void
	{
		super();
		
		backdropImage = new FlxBackdrop("assets/images/backgroundTiles3.png", 0, 0, true, true, 0, 0);
		add(backdropImage);
		
		/*screenBox = new FlxSprite(10, 10);
		screenBox.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);		
		screenBox.setPosition(0, 0); 
		screenBox.scrollFactor.set(0, 0);
		add(screenBox);*/
		
		title = new FlxSprite();
		title.loadGraphic("assets/images/titleInventory.png", false);
		title.scrollFactor.set();
		title.setPosition(0, 50);
		title.screenCenter(X);
		add(title);
		
		grid = new FlxSprite();
		grid.loadGraphic("assets/images/inventoryGrid.png");		
		grid.setPosition(0, 186); 
		grid.screenCenter(X);
		grid.scrollFactor.set(0, 0);
		add(grid);
		
		inventoryItemHighlightedSquare = new FlxSprite();
		inventoryItemHighlightedSquare.loadGraphic("assets/images/inventoryItemHighlightedSquare.png", true);		
		inventoryItemHighlightedSquare.setPosition(147, 186); 
		inventoryItemHighlightedSquare.scrollFactor.set(0, 0);
		inventoryItemHighlightedSquare.animation.add("anin", [0, 1], 12);
		inventoryItemHighlightedSquare.animation.play("anin");
		add(inventoryItemHighlightedSquare);		
		
		// left, right, up, down, z and x buttons.
		_buttonsNavigation = new ButtonsNavigation();		
		add(_buttonsNavigation);
		
		_buttonsNavigation.findInventoryIconZNumber();
		_buttonsNavigation.findInventoryIconXNumber();
		_buttonsNavigation.findInventoryIconCNumber();
		
		_iconsGroup = new FlxGroup();
		add(_iconsGroup);
		
	
		// add all the inventory items to the screen.
		for (i in 0...Reg._inventoryIconNumberMaximum)
		{
			
			var iconFilename = Reg._inventoryIconFilemame[i];
			addInventoryItem(iconFilename, i);
		}
		
		// flashing square defaults to the top-left corner, so display the text of the first item if there is an item to display.
		if (Reg._inventoryIconNumberMaximum > 0)
		{
			itemTitle = new FlxText(147, 122, 0, Reg._inventoryIconName[0]);
			itemTitle.color = FlxColor.WHITE;
			itemTitle.size = 14;
			itemTitle.scrollFactor.set();
			add(itemTitle);
			
			itemDescription = new FlxText(147, 147, 0, Reg._inventoryIconDescription[0]);
			itemDescription.color = FlxColor.WHITE;
			itemDescription.size = 14;
			itemDescription.scrollFactor.set();
			add(itemDescription);			
			
		}
		
		//	FlxG.camera.setScrollBoundsRect(0, -60, tilemap.width - Reg._tileSize + 32, tilemap.height - Reg._tileSize + 92, true);		

	}
	
	override public function update(elapsed:Float):Void 
	{								
		
		navigation();
				
		if (FlxG.keys.anyJustReleased(["A"]) || Reg._mouseClickedButtonA == true) 
		{
			Reg._buttonsNavigationUpdate = true;
			if (Reg._soundEnabled == true) FlxG.sound.play("menu", 1, false);
			close();
		}
		super.update(elapsed);	
	}
	
	private function navigation():Void
	{
		
		if (FlxG.keys.anyJustPressed(["LEFT"]) && inventoryItemHighlightedSquare.x > 147 || _buttonsNavigation.button1.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.x > 147 )
		{
			inventoryItemHighlightedSquare.x = inventoryItemHighlightedSquare.x - 36;
			_buttonDown = true;
			itemNumberSelected--;
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		if (FlxG.keys.anyJustPressed(["RIGHT"]) && inventoryItemHighlightedSquare.x < (32 * Reg._inventoryGridXTotalSlots) + 180 || _buttonsNavigation.button2.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.x < (32 * Reg._inventoryGridXTotalSlots) + 180)
		{
			inventoryItemHighlightedSquare.x = inventoryItemHighlightedSquare.x + 36;
			_buttonDown = true;
			itemNumberSelected++;
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		if (FlxG.keys.anyJustPressed(["UP"]) && inventoryItemHighlightedSquare.y > 186 ||  _buttonsNavigation.button3.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.y > 186)
		{
			inventoryItemHighlightedSquare.y = inventoryItemHighlightedSquare.y - 36;
			_buttonDown = true;
			itemNumberSelected -= Reg._inventoryGridXTotalSlots;
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
			
		}
		
		if (FlxG.keys.anyJustPressed(["DOWN"]) && inventoryItemHighlightedSquare.y < (32 * Reg._inventoryGridYTotalSlots) + 186 || _buttonsNavigation.button4.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.y < (32 * Reg._inventoryGridYTotalSlots) + 186)
		{
			inventoryItemHighlightedSquare.y = inventoryItemHighlightedSquare.y + 36;
			_buttonDown = true;
			itemNumberSelected += Reg._inventoryGridXTotalSlots;
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		// if item is available and key is pressed then set item to that navigation button.
		if (FlxG.keys.anyJustPressed(["Z"]) && Reg._inventoryIconNumberMaximum > 0 || Reg._mouseClickedButtonZ == true && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconZNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconZNumber(itemNumberSelected);
			Reg._inventoryIconZNumber[itemNumberSelected] = true;
		}
		
		if (FlxG.keys.anyJustPressed(["X"]) && Reg._inventoryIconNumberMaximum > 0 || Reg._mouseClickedButtonX == true && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconXNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconXNumber(itemNumberSelected);
			Reg._inventoryIconXNumber[itemNumberSelected] = true;
		}
		
		if (FlxG.keys.anyJustPressed(["C"]) && Reg._inventoryIconNumberMaximum > 0 || Reg._mouseClickedButtonC == true && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconCNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconCNumber(itemNumberSelected);
			Reg._inventoryIconCNumber[itemNumberSelected] = true;			
		}
		
		if (_buttonsNavigation.button1.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.button2.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.button3.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.button4.justReleased && _buttonDown)	_buttonDown = false;

			
		_buttonsNavigation.button1.status = FlxButton.NORMAL; // fires once instead of the bug that fires twice. see _buttonDown
		_buttonsNavigation.button2.status = FlxButton.NORMAL;
		_buttonsNavigation.button3.status = FlxButton.NORMAL;
		_buttonsNavigation.button4.status = FlxButton.NORMAL;
		
		// output the items text and description.
		if ( Reg._inventoryIconName[itemNumberSelected] != "") 
		{
			itemTitle.text = Reg._inventoryIconName[itemNumberSelected];
			itemDescription.text = Reg._inventoryIconDescription[itemNumberSelected];
		}
	}
	
	public function addInventoryItem(iconFilename:String, iconLocation:Int):Void
	{
		_icons = new InventoryIcons(iconFilename, iconLocation);
		_iconsGroup.add(_icons);
	}
}
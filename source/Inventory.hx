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
	/**
	 * Stops a close this subState bug.
	 */
	private var _stopCloseSubState:Bool = true;
	
	/*******************************************************************************************************
	 * Stops the inventory Item Highlighted Square from moving quickly through the grid when holding down a key or button.
	 */
	private var _buttonDown:Bool;
	
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var title:FlxText;
		
	/*******************************************************************************************************
	 * Displays the item title just under the inventory title.
	 */
	private var itemTitle :FlxText;
	
	/*******************************************************************************************************
	 * Display a grid of boxes for the inventory items 
	 */
	private var imageGrid:FlxSprite;
	
	/*******************************************************************************************************
	 * A white square box that moves with the arrow keys/buttons. Pressing the action key will select any inventory item that is underneath this square.
	 */
	private var inventoryItemHighlightedSquare:FlxSprite;
		
	/*******************************************************************************************************
	 * Draws the text on the screen from the Reg._inventoryIconDescription var. Description of the inventory item. Needs to be a short one-liner or else the text will run off of the screen.
	 */
	private var itemDescription:FlxText;
	
	/*******************************************************************************************************
	 * The reg._iconFilemame is passed to this class to get the icon sprite.
	 */
	private var _icons:FlxSprite;
	
	/*******************************************************************************************************
	 * Will add the _icons sprite to this group so that more than one sprite can be seen on the screen.
	 */
	private var _iconsGroup:FlxGroup;
	
	/*******************************************************************************************************
	 * The buttons navigation class. Some button are left, right, up and X.
	 */
	public var _buttonsNavigation:ButtonsNavigation;
	
	/*******************************************************************************************************
	 * The location of the inventoryItemHighlightedSquare on the grid. the first square at the top-left corner of the grid refers to itemNumber 0 and to the right side of that location is itemNumber 1;
	 */
	private var itemNumberSelected:Int = 0;
		
	public function new():Void
	{
		super();
		
		var // Fill the screen with this tiled image.
		backdropImage = new FlxBackdrop("assets/images/backgroundTiles3.png", 0, 0, true, true, 0, 0);
		add(backdropImage);
		
		title = new FlxText(0, 50, 0, "Inventory");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.BLUE);
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 1);
		title.scrollFactor.set();
		title.setPosition(0, 50);
		title.screenCenter(X);
		add(title);
		
		imageGrid = new FlxSprite();
		imageGrid.loadGraphic("assets/images/inventoryGrid.png");		
		imageGrid.setPosition(0, 186); 
		imageGrid.screenCenter(X);
		imageGrid.scrollFactor.set(0, 0);
		add(imageGrid);
		
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
		
		var slotBox = new FlxSprite(0, 0);
		slotBox.makeGraphic(FlxG.width - 40, 54, 0xFF011f13);		
		slotBox.setPosition(20, 123); 
		slotBox.scrollFactor.set(0, 0);
		add(slotBox);
	
		// add all the inventory items that can be selected to the screen.
		for (i in 0...Reg._inventoryIconNumberMaximum)
		{
			
			var iconFilename = Reg._inventoryIconFilemame[i];
			addInventoryItem(iconFilename, i);
		}
		
		// add all the inventory items that cannot be selected to the screen.
		for (i in 0...Reg._inventoryIconNumberMaximumAutomatic)
		{
			
			var iconFilename = Reg._inventoryIconFilemameAutomatic[i];
			addInventoryItemAutomatic(iconFilename, i);
		}
		
		// flashing square defaults to the top-left corner, so display the text of the first item if there is an item to display.
		if (Reg._inventoryIconNumberMaximum > 0)
		{
			itemTitle = new FlxText(147, 122, 0, Reg._inventoryIconName[0]);
			itemTitle.color = FlxColor.WHITE;
			itemTitle.font = Reg.defaultFont;
			itemTitle.size = 14;
			itemTitle.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1);
			itemTitle.scrollFactor.set();
			add(itemTitle);
			
			itemDescription = new FlxText(147, 147, 0, Reg._inventoryIconDescription[0]);
			itemDescription.color = FlxColor.WHITE;
			itemDescription.font = Reg.defaultFont;
			itemDescription.size = 14;
			itemDescription.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1);
			itemDescription.scrollFactor.set();
			add(itemDescription);			
			
		}

	}
	
	override public function update(elapsed:Float):Void 
	{	
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
		navigation();
				
		if (InputControls.i.justPressed && _stopCloseSubState == false || _buttonsNavigation.buttonI.justReleased && Reg._inventoryIconNumberMaximum > 0 && _stopCloseSubState == false )
		{
			Reg._buttonsNavigationUpdate = true;
			if (Reg._soundEnabled == true) FlxG.sound.play("menu", 1, false);
			close();
		}

		_stopCloseSubState = false;
		super.update(elapsed);	
	}
	
	private function navigation():Void
	{
		
		if (InputControls.left.justReleased && inventoryItemHighlightedSquare.x > 147 || _buttonsNavigation.buttonLeft.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.x > 147 )
		{
			inventoryItemHighlightedSquare.x = inventoryItemHighlightedSquare.x - 36;
			_buttonDown = true;
			itemNumberSelected--;
			
	trace ("yp", itemNumberSelected);
			
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		if (InputControls.right.justReleased && inventoryItemHighlightedSquare.x < (32 * Reg._inventoryGridXTotalSlots) + 180 || _buttonsNavigation.buttonRight.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.x < (32 * Reg._inventoryGridXTotalSlots) + 180)
		{
			inventoryItemHighlightedSquare.x = inventoryItemHighlightedSquare.x + 36;
			_buttonDown = true;
			itemNumberSelected++;
	trace ("yp", itemNumberSelected);
	
		if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		if (InputControls.up.justReleased && inventoryItemHighlightedSquare.y > 186 ||  _buttonsNavigation.buttonUp.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.y > 186)
		{
			inventoryItemHighlightedSquare.y = inventoryItemHighlightedSquare.y - 36;
			_buttonDown = true;
			itemNumberSelected -= Reg._inventoryGridXTotalSlots + 1;

trace ("yp", itemNumberSelected);
			
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
			
		}
		
		if (InputControls.down.justReleased && inventoryItemHighlightedSquare.y < (32 * Reg._inventoryGridYTotalSlots) + 186 || _buttonsNavigation.buttonDown.justPressed == true  && !_buttonDown && inventoryItemHighlightedSquare.y < (32 * Reg._inventoryGridYTotalSlots) + 186)
		{
			inventoryItemHighlightedSquare.y = inventoryItemHighlightedSquare.y + 36;
			_buttonDown = true;
			itemNumberSelected += Reg._inventoryGridXTotalSlots + 1;
			
trace ("yp", itemNumberSelected);
			
			if (Reg._soundEnabled == true) FlxG.sound.play("menuMove", 1, false);
		}
		
		// if item is available and key is pressed then set item to that navigation button.
		if (InputControls.z.justReleased && Reg._inventoryIconNumberMaximum > 0 || _buttonsNavigation.buttonZ.justReleased && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconZNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconZNumber(itemNumberSelected);
			Reg._inventoryIconZNumber[itemNumberSelected] = true;
		}
		
		if (InputControls.x.justReleased && Reg._inventoryIconNumberMaximum > 0 || _buttonsNavigation.buttonX.justReleased && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconXNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconXNumber(itemNumberSelected);
			Reg._inventoryIconXNumber[itemNumberSelected] = true;
		}
		
		if (InputControls.c.justReleased && Reg._inventoryIconNumberMaximum > 0 || _buttonsNavigation.buttonC.justReleased && Reg._inventoryIconNumberMaximum > 0)
		{
			_buttonsNavigation.resetInventoryIconCNumber(itemNumberSelected);
			Reg.state._buttonsNavigation.resetInventoryIconCNumber(itemNumberSelected);
			Reg._inventoryIconCNumber[itemNumberSelected] = true;			
		}
		
		if (_buttonsNavigation.buttonLeft.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.buttonRight.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.buttonUp.justReleased && _buttonDown)	_buttonDown = false;
		if (_buttonsNavigation.buttonDown.justReleased && _buttonDown)	_buttonDown = false;

			
		_buttonsNavigation.buttonLeft.status = FlxButton.NORMAL; // fires once instead of the bug that fires twice. see _buttonDown
		_buttonsNavigation.buttonRight.status = FlxButton.NORMAL;
		_buttonsNavigation.buttonUp.status = FlxButton.NORMAL;
		_buttonsNavigation.buttonDown.status = FlxButton.NORMAL;
		
		// output the items text and description.
		if ( Reg._inventoryIconName[itemNumberSelected] != "") 
		{
			itemTitle.text = Reg._inventoryIconName[itemNumberSelected];
			itemDescription.text = Reg._inventoryIconDescription[itemNumberSelected];
		}
	}
	
	public function addInventoryItem(iconFilename:String, iconLocation:Int):Void
	{
		var id = 1;
		_icons = new InventoryIcons(iconFilename, iconLocation, id);
		_iconsGroup.add(_icons);
	}
	
	public function addInventoryItemAutomatic(iconFilename:String, iconLocation:Int):Void
	{
		var id = 2;
		_icons = new InventoryIcons(iconFilename, iconLocation, id);
		_iconsGroup.add(_icons);
	}
}
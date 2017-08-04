package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class ObjectVineMoving2 extends FlxSprite 
{		
	private var _tween:FlxTween;
	private var ticks:Float = 0; // used to delay holding of the vine if jumping.
	private var _keyPressed:Bool = false; // used to delay the holding of the vine if jumping.
	private var _isPlayerJumping:Bool = false; // used to jump off the vine only if the keyboard key used is a jump icon that was selected from the inventory.
	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectVineMoving.png", true, 16, 16);	
		color = FlxColor.BLACK;
		
		if(id == 11)
		{
			_tween = FlxTween.cubicMotion(this,
				x - 94, y,
				x - 94, y + 25,
				x + 94, y + 27.5,
				x + 94, y, Reg._vineMovingSpeed, { type: FlxTween.PINGPONG });
		}			
		
	}
		
	override public function update(elapsed:Float):Void 
	{
		
		if (isOnScreen()) 
		{
			if (FlxG.keys.anyPressed(["Z"]) && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			|| FlxG.keys.anyPressed(["X"]) && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			|| FlxG.keys.anyPressed(["C"]) && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."
			|| Reg._mouseClickedButtonZ == true && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Jump."
			|| Reg._mouseClickedButtonX == true && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Jump."
			|| Reg._mouseClickedButtonC == true && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Jump."			
			|| FlxG.keys.anyPressed(["Z"]) && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| FlxG.keys.anyPressed(["X"]) && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
			|| FlxG.keys.anyPressed(["C"]) && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1."
			|| Reg._mouseClickedButtonZ == true && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Super Jump 1."
			|| Reg._mouseClickedButtonX == true && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Super Jump 1."
			|| Reg._mouseClickedButtonC == true && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Super Jump 1."
			) 
			{
				if (FlxG.overlap(this, Reg.state.player))
				_isPlayerJumping = true;
			}
			
			if (_isPlayerJumping == true)
			{
				ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
			}
			
			if (ticks == 0) 
			{
				_isPlayerJumping = false;
				FlxG.overlap(this, Reg.state.player, vinePlayer);
			}
			
			// used to delay the player holding the vine.
			if (ticks >= 40) ticks = 0;
			
		}
		
		super.update(elapsed);
	}
	
	function vinePlayer(v:FlxSprite, p:Player):Void 
	{		
		p.velocity.x = 0; 
		p.acceleration.x = 0;
		p.drag.x = 50000;
		p.drag.y = 50000;
		
		p.animation.play("idle");
		Reg._antigravity = false;
		Reg._playersYLastOnTile = p.y; // no fall damage because player is on the vine.
		
		// can fall off the vine by pressing the left or right arrow key.
		p.x = v.x; p.y = y; 
		p.velocity.y = 0; // needed so that the player does not fall while on the vine.
	}
}
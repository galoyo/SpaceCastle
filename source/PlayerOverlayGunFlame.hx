package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class PlayerOverlayGunFlame extends FlxSprite 
{	
	private var _startX:Float = 0;
	private var _startY:Float = 0;
	private var yy:Float = 0;
	private var ticks:Float = 0;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/playerOverlayGunFlame.png", false, 22, 14);
		
		// set how this sprite flips when facing a particular way.
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("gun", [0]);
		animation.add("gun2", [0], 2, true, false, true);

		visible = false;
	}
	
	override public function update(elapsed:Float):Void 
	{			
		if (Reg._typeOfGunCurrentlyUsed != 1)
		{
			if (FlxG.keys.anyPressed(["Z"]) && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Flame Gun."
			|| FlxG.keys.anyPressed(["X"]) && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Flame Gun."
			|| FlxG.keys.anyPressed(["C"]) && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Flame Gun."
			|| Reg._mouseClickedButtonZ == true && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Flame Gun."
			|| Reg._mouseClickedButtonX == true && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Flame Gun."
			|| Reg._mouseClickedButtonC == true && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Flame Gun.")
			{	
				Reg._typeOfGunCurrentlyUsed = 1;
				Reg.state._gun.visible = false;
				Reg.state._gunFlame.visible = true; 
				Reg.state._gunFreeze.visible = false; 
				Reg._currentKeyPressed = "NULL";
				visible = true;
				Reg._playerCanShoot = false;
				ticks = 0;
			} 
		}
		
		else
		{
			if (Reg._typeOfGunCurrentlyUsed  == 1)
			{
				if (ticks >= 10) Reg._playerCanShoot = true;			
				if (ticks < 10) ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
			}
		}
		
		
		if (isOnScreen())
		{	
			//###################### NORMAL GRAVITY ######################
			if (Reg._antigravity == false)
			{
				if (FlxG.keys.anyPressed(["UP"]) && Reg.state.player.facing == FlxObject.RIGHT || Reg._mouseClickedButtonUp == true && Reg.state.player.facing == FlxObject.RIGHT)
				{				
					angle = 270;	// point the gun in an upward direction.
					facing = FlxObject.RIGHT;	// face the object in this class in the direction right.
					x = Reg.state.player.x + 19; // position this object to the body of the player.
					y = _startY - 23;
					yy = -23;
					animation.play("gun");
				}
			
				// position the gun in front of the player.
				else if (Reg.state.player.facing == FlxObject.RIGHT)
				{
					angle = 0 ;
					facing = FlxObject.RIGHT;  
					x = Reg.state.player.x + 22;	
					y = _startY - 7;
					yy = -7;
					animation.play("gun");
				}
				
				else if (FlxG.keys.anyPressed(["UP"]) && Reg.state.player.facing == FlxObject.LEFT || Reg._mouseClickedButtonUp == true && Reg.state.player.facing == FlxObject.LEFT)
				{
					angle = 90;	// point the gun in an upward direction.
					facing = FlxObject.LEFT;  
					
					x = Reg.state.player.x - 13;
					y = _startY - 23;
					yy = -23;
					animation.play("gun");
				}
			
				else if( Reg.state.player.facing == FlxObject.LEFT)
				{
					angle = 0 ;
					facing = FlxObject.LEFT; 
					x = Reg.state.player.x - 17;
					y = _startY - 7;
					yy = -7;
					animation.play("gun");
				}			
				
				y = Reg.state.player.y + 21 + yy;
			}
			//################## END OF NORMAL GRAVITY ###################

			//##################### ANITGRAVITY #######################
			if (Reg._antigravity == true)
			{
				if (FlxG.keys.anyPressed(["DOWN"]) && Reg.state.player.facing == FlxObject.RIGHT || Reg._mouseClickedButtonDown == true && Reg.state.player.facing == FlxObject.RIGHT)
				{				
					angle = 90;	// point the gun in an upward direction.
					facing = FlxObject.RIGHT;	// face the object in this class in the direction right.
					x = Reg.state.player.x + 18; // position this object to the body of the player.
					y = _startY - 1;
					yy = 9;
					animation.play("gun2");
				}
			
				// position the gun in front of the player.
				else if (Reg.state.player.facing == FlxObject.RIGHT)
				{
					angle = 0 ;
					facing = FlxObject.RIGHT;  
					x = Reg.state.player.x + 22;	
					y = _startY - 7;
					yy = -6;
					animation.play("gun2");
				}
				
				else if (FlxG.keys.anyPressed(["DOWN"]) && Reg.state.player.facing == FlxObject.LEFT || Reg._mouseClickedButtonDown == true && Reg.state.player.facing == FlxObject.LEFT)
				{
					angle = 270;	// point the gun in an upward direction.
					facing = FlxObject.LEFT;  
					
					x = Reg.state.player.x - 13;
					y = _startY - 1;
					yy = 9;
					animation.play("gun2");
				}
			
				else if( Reg.state.player.facing == FlxObject.LEFT)
				{
					angle = 0 ;
					facing = FlxObject.LEFT; 
					x = Reg.state.player.x - 17;
					y = _startY - 7;
					yy = -5;
					animation.play("gun2");
				}	
				
				y = Reg.state.player.y + 5 + yy;
			}		
		
			super.update(elapsed);
		

		}
	}
	
}
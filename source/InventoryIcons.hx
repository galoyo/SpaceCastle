package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class InventoryIcons extends FlxSprite  
{	
	public function new(iconName:String, iconLocation:Int, id:Int) 
	{		
		x = 150;
		if (id == 1) y = 189;
		if (id == 2) y = 366;
		
		findY(iconLocation);
		
		super(x, y);
		
		loadGraphic("assets/images/" + iconName, true, Reg._tileSize, Reg._tileSize);
		scrollFactor.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	private function findY(iconLocation:Int):Void
	{
		if (iconLocation > Reg._inventoryGridXTotalSlots)
		{
			var vertical = (iconLocation / Reg._inventoryGridXTotalSlots);
			var horizontal = iconLocation - (Std.int(vertical) * Reg._inventoryGridXTotalSlots) - Std.int(vertical);

			y = y + (Std.int(vertical) * 36);
			x = x + (Std.int(horizontal) * 36);
			
		}
		else x = x + iconLocation * 36;
	}
	
}
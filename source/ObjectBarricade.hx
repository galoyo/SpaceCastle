package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectBarricade extends FlxSprite 
{	
	private var _displayBarricadeDoOnlyOnce:Int = 0;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
				
		loadGraphic("assets/images/objectBarricade.png", true, Reg._tileSize, Reg._tileSize);
		
		immovable = false;
		visible = false;
		solid = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (Reg.mapXcoords == 25 && Reg.mapYcoords == 20 && Reg.state.player.x > 2528 && _displayBarricadeDoOnlyOnce == 0)
		{
			_displayBarricadeDoOnlyOnce = 1;
			solid = true;
			visible = true;
			immovable = true;
		}
		
		super.update(elapsed);
	}
	
}
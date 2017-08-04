package;

import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectFireballBlock extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectFireballBlock.png", false, Reg._tileSize, Reg._tileSize);		

		immovable = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	
}
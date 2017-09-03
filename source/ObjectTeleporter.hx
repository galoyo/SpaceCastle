package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * @author galoyo
 */

class ObjectTeleporter extends FlxSprite 
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectTeleporter.png", true, Reg._tileSize, Reg._tileSize);
	
		animation.add("on", [0, 1, 2, 4, 3, 2, 1], 30);
		animation.play("on");
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (InputControls.down.pressed) FlxG.overlap(this, Reg.state.player, teleport);
						
		super.update(elapsed);
	}
	
	public function teleport(t:FlxSprite, p:Player):Void
	{		
		Reg.state.openSubState(new TeleportSubState());				
	}
	
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class ObjectTeleporter extends FlxSprite 
{	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
				
		loadGraphic("assets/images/objectTeleporter.png", true, Reg._tileSize, Reg._tileSize);
		if (id == 0) color = FlxColor.GREEN; // change the color of this object.
		
		// Id 1 to 8 is used outside of a house. If you have created only 3 teleporters on that map when the ID must start with 1 and end with 3. No duplicate IDs are allowed on a map. Needs a teleporter key to use the teleporter. Press the action button that has the teleporter key. If player enters teleporter ID of 2 then the player will exit to the next higher ID value which in this case would be the teleporter with ID of 3. If at that map a teleporter of ID 3 does not exist then the player will exit the teleporter with an ID of 1.
		ID = id;
		
		animation.add("on", [0, 1, 2, 4, 3, 2, 1], 30);
		animation.play("on");
		
		// The location of outside teleporter. These vars are used to store the teleporter location so the player can move from teleporter to the next teleporter.
		Reg._teleporterStartX[id] = x;
		Reg._teleporterStartY[id] = y;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (InputControls.down.justPressed && Reg._keyOrButtonDown == false)
		{
			// in house teleporter.
			if (ID == 0) FlxG.overlap(this, Reg.state.player, teleportInside);
			else if (FlxG.overlap(this, Reg.state.player))
			{
				FlxG.overlap(this, Reg.state.player, teleportOutside);
					
				Reg._keyOrButtonDown = true;
			}
		}
		
		// Hack to stop the double firing of a key press or button click.
		if (InputControls.down.justReleased && Reg._keyOrButtonDown == true && FlxG.overlap(this, Reg.state.player))
		{
			Reg._keyOrButtonDown = false;
		}
						
		super.update(elapsed);
	}
	
	public function teleportInside(t:FlxSprite, p:Player):Void
	{		
		Reg.state.openSubState(new TeleportSubState());				
	}
	
	public function teleportOutside(t:FlxSprite, p:Player):Void
	{		
		// If the next teleporter exists then teleport the player to that teleporter.
		if (Reg._teleporterStartX[t.ID + 1] != 0 && Reg._teleporterStartY[t.ID + 1] != 0)
		{
			Reg.state.player.x = Reg._teleporterStartX[t.ID + 1];
			Reg.state.player.y = Reg._teleporterStartY[t.ID + 1];
		}
		// If the next teleporter does not exist then teleport the player to the first teleporter of ID 1.
		else
		{
			Reg.state.player.x = Reg._teleporterStartX[1];
			Reg.state.player.y = Reg._teleporterStartY[1];
		}
	trace("id", t.ID);
		Reg._playersYLastOnTile = Reg.state.player.y;
	}
}
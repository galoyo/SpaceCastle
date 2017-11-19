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
		
		if (id == 7) visible = false;
		
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
			if (ID == 0) 
				FlxG.overlap(this, Reg.state.player, teleportInside);
			else if (FlxG.overlap(this, Reg.state.player))
			{
				// check overlap between player and teleporter but only if the teleporter is active.
				if (animation.finished == false && Reg._teleporterInUse[ID] == true) 
				{
					FlxG.overlap(this, Reg.state.player, teleportOutside);
				
					if (Reg._soundEnabled == true) FlxG.sound.play("teleport2", 1, false);	
				} else if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
				
				Reg._keyOrButtonDown = true;
			}
		}
		
		// Hack to stop the double firing of a key press or button click.
		if (InputControls.down.justReleased && Reg._keyOrButtonDown == true && FlxG.overlap(this, Reg.state.player))
		{
			Reg._keyOrButtonDown = false;
		}
		
		if (animation.finished == false && Reg._teleporterInUse[ID] == false) animation.reset();
		
								
		super.update(elapsed);
	}
	
	public function teleportInside(t:FlxSprite, p:Player):Void
	{		
		Reg.state.openSubState(new TeleportSubState());				
	}
	
	public function teleportOutside(t:FlxSprite, p:Player):Void
	{		
		for (i in 1...Reg._teleporterStartX.length) 
		{
			// If the next teleporter exists then teleport the player to that teleporter. If teletorter 8 is used then send player to teleporter 1.
			if (Reg._teleporterStartX[i] != 0 && Reg._teleporterStartY[i] != 0 && t.ID != 8 && i > t.ID)
			{
				// move the player to the next teleporter.
				Reg.state.player.x = Reg._teleporterStartX[i];
				Reg.state.player.y = Reg._teleporterStartY[i];
		
				// no player fall damage.
				Reg._playersYLastOnTile = Reg.state.player.y;
				
				Reg._teleporterInUse[i] = false; // disable the teleporter that the player teleports to.
				Reg._teleporterInUse[t.ID] = false;
				
				return;			
			}
		}
		
		// If the next teleporter does not exist then teleport the player to the first teleporter of ID 1.
		Reg.state.player.x = Reg._teleporterStartX[1];
		Reg.state.player.y = Reg._teleporterStartY[1];		
	
		Reg._teleporterInUse[t.ID] = false;
		Reg._teleporterInUse[1] = false;
		
		Reg._playersYLastOnTile = Reg.state.player.y;
	}
}
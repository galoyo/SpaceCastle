package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * @author galoyo
 */

class ObjectSign extends FlxSprite
{
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectSign.png", true, 32, 32);	
		
		ID = id;
		pixelPerfectPosition = false;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{			
			if (FlxG.keys.anyJustReleased(["DOWN"]) && overlapsAt(x, y, Reg.state.player) || FlxG.mouse.justReleased == true && Reg._mouseClickedButtonDown == true && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "objectSign.png";
				
				if(Reg.mapXcoords == 17 && Reg.mapYcoords == 20)	
				{
					if (ID == 1)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/sign-ID1-Map17-20.txt").split("#");
									
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}
				}
				
				if(Reg.mapXcoords == 16 && Reg.mapYcoords == 20)	
				{
					if (ID == 1)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/sign-ID1-Map16-20.txt").split("#");
						Reg.dialogCharacterTalk[0] = "";
						
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}
				}

				if(Reg.mapXcoords == 14 && Reg.mapYcoords == 18)	
				{
					if (ID == 1)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/sign-ID1-Map14-18.txt").split("#");
									
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}
				}
			}
			
			super.update(elapsed);
		}
	}
	
}
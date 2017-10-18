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
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/objectSign.png", true, 32, 32);			
		
		pixelPerfectPosition = false;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{			
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
		
			if (InputControls.down.justReleased && overlapsAt(x, y, Reg.state.player))
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
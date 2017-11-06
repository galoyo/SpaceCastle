package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class NpcMalaHealthy extends FlxSprite
{
	/**
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/**
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	private var ticks:Float = 0;
	private var ticksWalk:Float = 0; // used for the npc that walks back and forth.
	
	/**
	 * Make the Mala idle for a short random time.
	 */
	private var ticksIdle:Float = 0;
	
	/**
	 * The Mala will stop and be idle if this value is true.
	 */
	private	var _makeMalaIdle:Bool = false;
	
	private var _xLeftBoundry:Float = 0; // npc cannot walk path the x position of this var.
	private var _xRightBoundry:Float = 0;
	private var _isWalking:Bool = false;
	private var _shovelDiggingSpeed:Int;
	private var _usingShovel:Bool = false;
	private var _usingWateringCan:Bool = false;
	private var _walking:Bool = false;
	
	private var _tileX:Int; // the tile x coords not in pixels.
	private var _tileY:Int;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);

		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		_xLeftBoundry = x - 60;
		_xRightBoundry = x + 60;
		
		loadGraphic("assets/images/npcMalaHealthy.png", true, 28, 28);
		
		if (FlxG.random.int(0, 2) == 0) _isWalking = true;
			else _isWalking = false;
			
		_shovelDiggingSpeed = FlxG.random.int(20, 40);
		
		animation.add("idle", [1, 1, 1, 1, 1, 12], 10);
		animation.play("idle");
		
		animation.add("walk", [0, 1, 2, 1, 0, 1, 2, 1], 16);
		
		// a green mala appears at house only if first boss was defeated.
		if (ID == 3 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._boss1ADefeated == false) kill();
		if (ID == 2 && Reg.mapXcoords == 20 && Reg.mapYcoords == 20 && Reg._playerFeelsWeak == true) kill();
	}
	
	override public function update(elapsed:Float):Void 
	{				
		if (isOnScreen())
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
			
			var ra:Int = FlxG.random.int(0, 25);			
			var ticksRandom:Int = FlxG.random.int(15, 40);	// used to delay walking.		
			
			//###################### WALKING #######################
			if (_isWalking == true && _usingShovel == false)
			{
				if (Reg.mapXcoords == 24 && Reg.mapYcoords == 25) return;
				
				if (ticksWalk > 10 && ra == 1 || _makeMalaIdle == true)
				{					
					if (ticksIdle == 0) 
					{
						animation.play("idle");
						if (_usingWateringCan == true) animation.pause();						
					}
					
					// do nothing				
					ticksIdle = Reg.incrementTicks(ticksIdle, 60 / Reg._framerate);
					_makeMalaIdle = true;
					
					if (ticksIdle > ticksRandom) // pause walking for a short time.
					{
						ticksIdle = 0;
						_makeMalaIdle = false;
						
						animation.play("walk");
						if (_usingWateringCan == true) animation.play("watering");
					}
				} 
				else
				{				
					// convert pixels to tiles. used to find the next tile.
					if (facing == FlxObject.LEFT)
					{
						_tileX = Std.int((x + 3) / 32);		
						_tileY = Std.int(y / 32);
					}
					else 
					{
						_tileX = Std.int((x - 3) / 32);		
						_tileY = Std.int(y / 32);
					}
					
					if (ticksWalk == 0 && _usingWateringCan == false) animation.play("walk");
					
					if (ticksWalk >= 90) // 90... reset to 0.
					{
						// THIS IS THE SAME CODE AS BELOW.
						if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
						{
							ticksWalk = 0; 
							x = x - 2; 
							_walking = true; 
							
						} // at this line the overlapsAt checks for an empty space underneath the next tile that the mob is walking to.					
					}
					else if (ticksWalk >= 45) // 45 to 90... walk to the right
					{
						if ((x + 2) < _xRightBoundry && overlapsAt(x + 28, y + 28, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 98)
						{
							x = x + 2; 
							_walking = true;							
						}
						
					}
					else if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
					{
						x = x - 2; 
						_walking = true; 						
					} // 0 to 45, walk left.
					
					if (_walking == false) // stop npc animation if object is not moving;
					{
						animation.play("idle");
						if (_usingWateringCan == true) animation.pause();
					} else if (_usingWateringCan == true) animation.play("watering");
					
					ticksWalk = Reg.incrementTicks(ticksWalk, 60 / Reg._framerate);		
					_walking = false;
					
				}	
			}
			//################### END OF WALKING ##################
			
			ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
			
			
			//############### PLAYER CHATS WITH NPC ###############
			if (InputControls.down.justReleased && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "dialogNpcHealthy.png";
				
				if (Reg._playerFeelsWeak == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"D-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				else if (Reg._boss1BDefeated == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 2 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"C-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}
				else if (Reg._boss1ADefeated == true)
				{
					if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
					{
						if (ID == 1 || ID == 2 || ID == 3)
						{						
							Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"B-malaHealthy.txt").split("#");
											
							Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
							// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
							Reg.displayDialogYesNo = false;
							Reg.state.openSubState(new Dialog());
						}
					}
				}				
				 
				else if(Reg.mapXcoords == 20 && Reg.mapYcoords == 20)	
				{
					if (ID == 1 || ID == 2)
					{						
						Reg.dialogIconText = openfl.Assets.getText("assets/text/Map20-20-ID"+ID+"A-malaHealthy.txt").split("#");
										
						Reg.dialogCharacterTalk[0] = "talkMobHealthy.png";
							
						// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
						Reg.displayDialogYesNo = false;
						Reg.state.openSubState(new Dialog());
					}
				}
			}
			
			//###################### END CHAT #####################
			
			super.update(elapsed);
		}
	}
	
}
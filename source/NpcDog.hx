package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class NpcDog extends FlxSprite
{
	private var _startX:Float;
	private var _startY:Float;
	public var _player:Player;
	
	/**
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;
	
	/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 800;
	
	private var ticks:Int = 0;
	
	public function new(x:Float, y:Float, player:Player, id:Int) 
	{		
		super(x, y);

		_startX = x;
		_startY = y;
		_player = player;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;

		Reg._dogExistsAtMap[ID] = true;
		
		loadGraphic("assets/images/npcDog.png", true, Reg._tileSize, Reg._tileSize);

		animation.add("idle", [3, 3, 3, 4], 15);
		animation.add("run", [0, 2], 15);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		velocity.x = velocity.y = acceleration.x = acceleration.y = 0;
		animation.play("idle");
		
		if (Reg._dogStopMoving == true) 
		{
			Reg._dogIsVisible = false;
			visible = false;
		}
		
		if (Reg.mapXcoords == 16 && Reg.mapYcoords == 20 && ID == 2) 
		{
			animation.play("run");
		
			// mob starts moving in direction of the player.
			if (x <= Reg.state.player.x) 
			{
				velocity.x = maxXSpeed;
				facing = FlxObject.RIGHT;
				
			}
			else {
				velocity.x = -maxXSpeed;
				facing = FlxObject.LEFT;			
			}
		}
	}
	
	override public function update(elapsed:Float):Void 
	{				
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
		FlxG.collide(Reg.state._objectLadders, this);
		
		if (InputControls.down.justReleased && overlapsAt(x, y, _player) && Reg._dogCarried == false && Reg.state.npcDogLady == null)
		{
			animation.play("idle");
			
			Reg.dialogIconFilename = "";
			
			Reg.dialogIconText = openfl.Assets.getText("assets/text/talkDog.txt").split("#");
										
			Reg.dialogCharacterTalk[0] = "talkDog.png";			
						
			// see the top part of npcMalaUnhealthy.hx update to see how this yes/no question works when answered.
			Reg.displayDialogYesNo = false;
			Reg.state.openSubState(new Dialog());
		
			// pickup the dog.
			Reg._dogCarried = true;
			
			Reg._dogCarriedItsID = Reg._dogCarriedItsID + ID + ",";
			Reg._dogCurrentlyCarried = ID;
			
			// the dog vars are used to remember where the dog was picked up.
			Reg.dogXcoords = Reg.mapXcoords;
			Reg.dogYcoords = Reg.mapYcoords;
			Reg._dogInHouse = Reg._inHouse;
		}
				
		if (Reg._dogCarried == true && Reg._dogCurrentlyCarried == ID)
		{
			x = _player.x;
			y = _player.y - 32;	
			
			velocity.x = _player.velocity.x;
			velocity.y = _player.velocity.y;					
			
			setFacingFlip(FlxObject.LEFT, false, false);
			setFacingFlip(FlxObject.RIGHT, false, false);				

		}
		
		if (Reg.state.npcDogLady != null)
		{
			if (InputControls.down.justPressed && overlapsAt(x, y, Reg.state.npcDogLady))				
			{
				if (Reg._dogCarried == true)
				{
					Reg._dogCarried = false; 
					
					// used to place dog at lady.
					Reg._dogFoundAtMap = Reg._dogFoundAtMap + Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse + ",";
					Reg._dogNoLongerAtMap = Reg._dogNoLongerAtMap + Reg.dogXcoords + "-" + Reg.dogYcoords + Reg._dogInHouse + ",";
					
					x = Reg.state.npcDogLady.x + (32 * Reg._dogCurrentlyCarried);
					y = Reg.state.npcDogLady.y;
					Reg._dogCarried = false;
					
					velocity.x = velocity.y = acceleration.x = acceleration.y = 0;
				}
			}
		}

		//------------------ WALK BUT CAN FALL IN HOLE
		if (ID == 2 && !overlapsAt(x, y + 32, _player) && Reg._dogStopMoving == false) 
		{
			// ##################################################
			// WALKING THEN REVERSE DIRECTION WALL OR BLACK TILE.
			// ##################################################
			if (justTouched(FlxObject.LEFT) && facing == FlxObject.LEFT || isTouching(FlxObject.FLOOR) && facing == FlxObject.LEFT && !overlapsAt(x - 27, y + 28, Reg.state.tilemap))
			{
				facing = FlxObject.RIGHT;
				if(_mobInWater == false) {velocity.x = maxXSpeed; }
				else {velocity.x = maxXSpeed / Reg._swimmingDelay;} 
			}
						
			if (justTouched(FlxObject.RIGHT) && facing == FlxObject.RIGHT || isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT && !overlapsAt(x + 27, y + 28, Reg.state.tilemap))
			{
				facing = FlxObject.LEFT;
				if(_mobInWater == false) {velocity.x = -maxXSpeed;}
				else {velocity.x = -maxXSpeed / Reg._swimmingDelay;} 
			}
		}
		
		// hide dog if dog is carried when player is inside of a pipe.
		if (Reg._dogCarried == true && Reg._dogCurrentlyCarried == ID)
		{
			if (Reg._dogIsInPipe == true) visible = false;
			else visible = true;
		}
		
		super.update(elapsed);
	}
	
}
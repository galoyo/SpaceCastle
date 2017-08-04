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
	
	public var _mobIsSwimming:Bool = false;
	private var maxXSpeed:Int = 800;
	
	private var ticks:Int = 0;
	
	public function new(x:Float, y:Float, player:Player, id:Int) 
	{		
		super(x, y);

		_startX = x;
		_startY = y;
		_player = player;
		
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
		FlxG.collide(Reg.state._objectLadders, this);
		
		if (FlxG.keys.anyJustReleased(["DOWN"]) && overlapsAt(x, y, _player) && Reg._dogCarried == false && Reg.state.npcDogLady == null
		|| FlxG.mouse.justReleased == true && Reg._mouseClickedButtonDown == true && overlapsAt(x, y, _player) && Reg._dogCarried == false && Reg.state.npcDogLady == null)
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
			if (FlxG.keys.anyJustPressed(["DOWN"]) && overlapsAt(x, y, Reg.state.npcDogLady) || FlxG.mouse.justReleased == true && Reg._mouseClickedButtonDown == true && overlapsAt(x, y, Reg.state.npcDogLady))				
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
				if(_mobIsSwimming == false) {velocity.x = maxXSpeed; }
				else {velocity.x = maxXSpeed / Reg._swimmingDelay;} 
			}
						
			if (justTouched(FlxObject.RIGHT) && facing == FlxObject.RIGHT || isTouching(FlxObject.FLOOR) && facing == FlxObject.RIGHT && !overlapsAt(x + 27, y + 28, Reg.state.tilemap))
			{
				facing = FlxObject.LEFT;
				if(_mobIsSwimming == false) {velocity.x = -maxXSpeed;}
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
package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class NpcParent extends FlxSprite
{
	/*******************************************************************************************************
	 * When this class is first created this var will hold the X value of this class. If this class needs to be reset back to its start map location then X needs to equal this var. 
	 */
	private var _startX:Float = 0;
	
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	/*******************************************************************************************************
	 * Used when the npc walks back and forth.
	 */
	private var ticksWalk:Float = 0;
	
	/*******************************************************************************************************
	 * Make the Mala idle for a short random time.
	 */
	private var ticksIdle:Float = 0;
	
	/*******************************************************************************************************
	 * Used to load either the shovel or watering can image.
	 */
	private var ticks:Float = 0;
	
	/*******************************************************************************************************
	 * The Mala will stop and be idle if this value is true.
	 */
	private	var _makeMalaIdle:Bool = false;
	
	/*******************************************************************************************************
	 * NPC cannot walk past the x location of this var. Stop NPC from walking if NPC walks too far to the left side of the map. NPC stops at about 3 tiles away from start location.
	 */
	private var _xLeftBoundry:Float = 0;
	
	/*******************************************************************************************************
	 * NPC cannot walk past the x location of this var. Stop NPC from walking if NPC walks too far to the right side of the map. NPC stops at about 3 tiles away from start location.
	 */
	private var _xRightBoundry:Float = 0;
	
	/*******************************************************************************************************
	 * True if the Mala is walking.
	 */
	private var _isWalking:Bool = false;
	
	/*******************************************************************************************************
	 * If value is true then the Mala is using the shovel.
	 */
	private var _usingShovel:Bool = false;
	
	/*******************************************************************************************************
	 * This is how fast that the Mala digs in the dirt.
	 */
	private var _shovelDiggingSpeed:Int;
	
	/*******************************************************************************************************
	 * If true then the NPC will water tjhe weeds.
	 */
	private var _usingWateringCan:Bool = false;
	
	/*******************************************************************************************************
	 * If this is true then the Mala is walking.
	 */
	private var _walking:Bool = false;
	
	/*******************************************************************************************************
	 * This var is the X value in tiles. The X value of a mob refers to pixels. Since each tile on a map is 32 pixels in width and height, the X is divided by 32 pixels To gets the Tiled Map Editor ID value when used with Y. This var can then be used to check if the tile directly left of the mob had a ID of 6. 
	 * _tileX = Std.int(x / 32); 
	 * _tileY = Std.int(y / 32); 
	 * Reg.state.overlays.getTile(_tileX - 1, _tileY) == 6;
	 */
	private var _tileX:Int;
	
	/*******************************************************************************************************
	 * This var is the Y value in tiles. The Y value of a mob refers to pixels. Since each tile on a map is 32 pixels in width and height, the Y is divided by 32 pixels To gets the Tiled Map Editor ID value when used with X. This var can then be used to check if the tile directly left of the mob had a ID of 6. 
	 * _tileX = Std.int(x / 32); 
	 * _tileY = Std.int(y / 32); 
	 * Reg.state.overlays.getTile(_tileX - 1, _tileY) == 6;
	 */
	private var _tileY:Int;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);

		_startX = x;
		_startY = y;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
	}
	
	override public function update(elapsed:Float):Void 
	{				
		if (isOnScreen())
		{
			super.update(elapsed);
			
			ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
		}
	}
	
	private function shovel():Void
	{
		//###################### SHOVEL #######################
		// check if a shovel exists at the left or right side of player. if it does then move player closer to shovel. next: play the animation of the mala digging with the shovel but only once. set _usingShovel to true so that the npc will not walk with the shovel while digging.			
		
		if (overlapsAt(x + 32, y, Reg.state._npcShovel) && ticks == 0)
		{
			if(ticks == 0) loadGraphic("assets/images/npcShovel.png", true, 56, 28);
			x = x + 30;
			animation.add("shovel", [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 4, 4, 3, 2, 1], _shovelDiggingSpeed, true);
			animation.play("shovel");
			_usingShovel = true;
		}
		else if (overlapsAt(x - 32, y, Reg.state._npcShovel) && ticks == 0) 
		{
			if(ticks == 0) loadGraphic("assets/images/npcShovel.png", true, 56, 28);
			x = x - 52;
			animation.add("shovel2", [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 4, 4, 3, 2, 1], _shovelDiggingSpeed, true);
			flipX = true;
			animation.play("shovel2");
			_usingShovel = true;
		}			
		
		//################### END OF SHOVEL ####################
	
	}
	
	private function wateringCan():Void
	{
		//################### WATERING CAN #####################
		if (overlapsAt(x + 32, y, Reg.state._npcWateringCan) && ticks == 0)
		{
			if(ticks == 0) loadGraphic("assets/images/npcWateringCan.png", true, 56, 28);
			x = x + 30;
			
			_xLeftBoundry = x; _xRightBoundry = x;
			if (overlapsAt(x + 32, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 32;
			if (overlapsAt(x + 64, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 64;
			if (overlapsAt(x + 96, y, Reg.state._objectGrassWeed)) _xRightBoundry = x + 96;
			
			animation.add("watering", [0, 1, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4 ,3 ,2, 4, 3, 2, 1], _shovelDiggingSpeed, true);
			animation.play("watering");
			_usingWateringCan = true;
			_isWalking = true;
		}
		else if (overlapsAt(x - 32, y, Reg.state._npcWateringCan) && ticks == 0) 
		{								
			if(ticks == 0) loadGraphic("assets/images/npcWateringCan.png", true, 56, 28);
			x = x - 50;
				
			_xLeftBoundry = x; _xRightBoundry = x;
			if (overlapsAt(x - 38, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 38;
			if (overlapsAt(x - 80, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 80;
			if (overlapsAt(x - 102, y, Reg.state._objectGrassWeed)) _xLeftBoundry = x - 102;
			
			animation.add("watering", [0, 1, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4, 3, 2, 3, 4 ,3 ,2, 4, 3, 2, 1], _shovelDiggingSpeed, true);
			flipX = true;
			animation.play("watering");
			_usingWateringCan = true;
			_isWalking = true;
		}
		//################## END OF WATERING CAN ###############

	}
	private function walking():Void
	{
		//###################### WALKING #######################
		var ra:Int = FlxG.random.int(0, 25);			
		var ticksRandom:Int = FlxG.random.int(15, 40); // used to delay walking.	
			
		if (_isWalking == true && _usingShovel == false )
		{
			if (Reg.mapXcoords == 24 && Reg.mapYcoords == 25) return;
			
			if (ticksWalk > 10 && ra == 1 || _makeMalaIdle == true)
			{					
				if (ticksIdle == 0) 
				{
					if (_usingWateringCan == false) animation.play("idle");
					if (_usingWateringCan == true) animation.pause();						
				}
				
				// do nothing				
				ticksIdle = Reg.incrementTicks(ticksIdle, 60 / Reg._framerate);
				_makeMalaIdle = true;
				
				if (ticksIdle > ticksRandom) // pause walking for a short time.
				{
					ticksIdle = 0;
					_makeMalaIdle = false;
					
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
				
				if (ticksWalk >= 90) // 90... reset to 0.
				{
					// THIS IS THE SAME CODE AS BELOW.
					if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
					{
						ticksWalk = 0; 
						x = x - 2; 
						_walking = true;
						if (_usingShovel == false &&  _usingWateringCan == false) facing = FlxObject.LEFT;
						
					} // at this line the overlapsAt checks for an empty space underneath the next tile that the mob is walking to.					
				}
				else if (ticksWalk >= 45) // 45 to 90... walk to the right
				{
					if ((x + 2) < _xRightBoundry && overlapsAt(x + 28, y + 28, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state.tilemap) && !overlapsAt(x + 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 98)
					{
						x = x + 2; 
						_walking = true;		
						if (_usingShovel == false &&  _usingWateringCan == false) facing = FlxObject.RIGHT;
					}
					
				}
				else if ((x - 2) > _xLeftBoundry && overlapsAt(x - 28, y + 28, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state.tilemap) && !overlapsAt(x - 3, y, Reg.state._objectBlockOrRock) && Reg.state.tilemap.getTile(_tileX, _tileY) != 96) 
				{
					x = x - 2; 
					_walking = true; 						
				} // 0 to 45, walk left.
				
				if (_walking == false) // stop npc animation if object is not moving;
				{
					if (_usingWateringCan == false) animation.play("idle");
					if (_usingWateringCan == true) animation.pause();
					
				} else if (_usingWateringCan == true) animation.play("watering");
				else if (_usingWateringCan == false) animation.play("walk");
				
				ticksWalk = Reg.incrementTicks(ticksWalk, 60 / Reg._framerate);		
				_walking = false;
				
			}	
		}
		//################### END OF WALKING ##################
		
		set_width(28); // this will change the hitbox so that player cannot talk to this mala when player is overtop of a watering can or a shovel.
		updateHitbox();
	}
}
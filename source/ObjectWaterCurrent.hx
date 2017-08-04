package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectWaterCurrent extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public var velocityX:Int = 625;
	public var velocityY:Int = 625;
		
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		_starty = y;
		_startx = x;
		
		ID = id;
		
		loadGraphic("assets/images/objectWaterCurrent" + id + ".png", false, Reg._tileSize, Reg._tileSize);	
		
		immovable = true;		
		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		if (isOnScreen()) FlxG.overlap(this, Reg.state.player, wavePlayer);	
		
		super.update(elapsed);
	}	
	
	/***********************
	 * accelerate the player through the water tides.
	 */
	public function wavePlayer(w:FlxSprite, p:Player):Void 
	{	
		if (ID == 1) {Reg.state.player.velocity.y = -velocityY; Reg.state.player.acceleration.y = velocityY; }
		if (ID == 2) {Reg.state.player.velocity.x = velocityX; Reg.state.player.acceleration.x = velocityX; }
		if (ID == 3) {Reg.state.player.velocity.y = velocityY; Reg.state.player.acceleration.y = velocityY; }
		if (ID == 4) {Reg.state.player.velocity.x = -velocityX; Reg.state.player.acceleration.x = velocityX; }	
		
		Reg.state.player.drag.x = 2000;
	}
}
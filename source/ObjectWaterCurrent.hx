package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectWaterCurrent extends FlxSprite
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
	 * This is the player's velocity.x when traveling in the water current.
	 */
	public var velocityX:Int = 625;
	
	/*******************************************************************************************************
	 * This is the player's velocity.y when traveling in the water current.
	 */
	public var velocityY:Int = 625;
		
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);
		
		_startX = x;
		_startY = y;		
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
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
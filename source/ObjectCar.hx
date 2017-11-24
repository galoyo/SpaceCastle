package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class ObjectCar extends FlxSprite 
{
	/*******************************************************************************************************
	 * When this class is first created this var will hold the Y value of this class. If this class needs to be reset back to its start map location then Y needs to equal this var. 
	 */
	private var _startY:Float = 0;
	
	/*******************************************************************************************************
	 * Used to increase the speed of the car by moving the car past map's center.
	 */
	private var ticksCamera:Float = 0;
	
	/*******************************************************************************************************
	 * Used to decrease the spped of the car by moving the car from it's map's center.
	 */
	private var ticksMinus:Float = 11;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);			
		
		if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19)
		{
			if (x < 400 ) {x = x - 150; offset.set(150, 0); } else offset.set( -150, 0);  
			updateHitbox();
			
			if (Reg._playerFeelsWeak == false) loadGraphic("assets/images/objectCar2.png", true, 150, 65); // player in car.
			else loadGraphic("assets/images/objectCar3.png", true, 150, 65); // player in car.
		} else loadGraphic("assets/images/objectCar1.png", true, 150, 65); // player not in car.
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		if (Reg.mapXcoords == 27 && Reg.mapYcoords == 19) {facing = FlxObject.LEFT;}
		
		// hide car when walking at parallax scene. this stops the car from flickering. without this code the car appears for a millisecond when player walks.
		if (Reg.mapXcoords == 22 && Reg.mapYcoords == 19 || Reg.mapXcoords == 27 && Reg.mapYcoords == 19) {} else visible = false;
		
		animation.add("car", [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,4,5,6,7,0,1,2,3,0,1,2,3,4,5,6,7,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,4,5,6,7], 25, false);			
		
		_startY = y;
		allowCollisions = FlxObject.ANY;
		


	}
	
	override public function update(elapsed:Float):Void 
	{		
		
		if (isOnScreen() == true && Reg._update == true)
		{	
			if (Reg.state.player.health <= 0) return;
			
			// player is entering the car.
			if (Reg.mapXcoords == 22 && Reg.mapYcoords == 19 && InputControls.down.pressed && FlxG.overlap(this, Reg.state.player)
			 || Reg.mapXcoords == 27 && Reg.mapYcoords == 19 && InputControls.down.pressed && FlxG.overlap(this, Reg.state.player))
			{
				Reg.state.player.visible = false;
				if (Reg._playerFeelsWeak == false) loadGraphic("assets/images/objectCar2.png", true, 150, 65); // player in car.
				else loadGraphic("assets/images/objectCar3.png", true, 150, 65);
				
				animation.add("car", [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7], 25, false);	
						
				if (Reg.mapXcoords == 22 && Reg.mapYcoords == 19) velocity.x = 500;	
				else velocity.x = -500;
				
				Reg.state._healthBarPlayer.visible = false;
				animation.play("car");
				Reg._playerInsideCar = true;
			}
			
			// at parallax car scene, car is moving in the direction of east.
			if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19 && Reg.state.player.visible == true && Reg._playerInsideCar == true)
			{
				Reg.state.player.visible = false;
				Reg.state._healthBarPlayer.visible = false;		
				
				Reg.state.camera.followLerp = 0.1;
				Reg.state.camera.followLead.set(20,0);
				
				if (Reg._carMovingEast == true) {velocity.x = 500;}
				else {facing = FlxObject.LEFT; velocity.x = -500; }
			} 
			
			else 
			{
				if (Reg.mapXcoords == 22 && Reg.mapYcoords == 19 || Reg.mapXcoords == 27 && Reg.mapYcoords == 19 ) {}
				else if ( Reg._playerInsideCar == false) visible = false;	// if player is walking at parallax car scene. hide the car.
			}
			
			if (velocity.x != 0) 
			{
				visible = true;
				animation.play("car");
				
				Reg.state.player.x = x + 53; Reg.state.player.y = y - 10; Reg.state.player.velocity.y = Reg.state.player.acceleration.y = 0;
			}
			
			if (InputControls.left.justPressed || InputControls.right.justPressed) 
				{ ticksCamera = 0; }
			
			//################### CAR LERP / LEAD ###################
			// this will decrease and increase the position of the car as it is moving forward. dodge the falling rocks with the left and right arrow keys. 
			if (InputControls.right.pressed && ticksCamera == 1 && Reg._carMovingEast == true
			 || InputControls.left.pressed && ticksCamera == 1 && Reg._carMovingEast == false)
			{
				if (ticksCamera / 10 <= 1) Reg.state.camera.followLerp = ticksCamera / 10; 
				
				if (ticksCamera <= 39) Reg.state.camera.followLead.set(ticksCamera,0);
			}
			if (InputControls.left.pressed && ticksCamera == 1 && Reg._carMovingEast == true
			 || InputControls.right.pressed && ticksCamera == 1 && Reg._carMovingEast == false)
			{
				if (ticksMinus / 10 <= 1) Reg.state.camera.followLerp = ticksMinus / 10; 
				
				if (ticksMinus >= 0) Reg.state.camera.followLead.set(ticksMinus,0);
			}	
			//#######################################################	
			
			ticksCamera = Reg.incrementTicks(ticksCamera, 60 / Reg._framerate);
			ticksMinus = -40 + ticksCamera;
			ticksMinus = Math.abs(ticksMinus);			
			
			if (Reg.mapXcoords == 23 && Reg.mapYcoords == 19 && FlxSpriteUtil.isFlickering(this) == false && velocity.x == 0 && Reg._playerInsideCar == true)
			{
				if (Reg._carMovingEast == true) {velocity.x = 500;}
					else {facing = FlxObject.LEFT; velocity.x = -500; }
			}
			
			super.update(elapsed);
		}
	}	
	
}
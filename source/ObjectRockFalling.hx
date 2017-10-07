package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class ObjectRockFalling extends FlxSprite 
{
	public var ticksRock:Float = 0; // used to fade the rock and make the rock fall.
	private var ra:Int; // used to rock the rock fall to the ground when player is random distance Y coords from this rock.
	private var raFallAngle:Int = 0; // 0 = fall at 6 o'clock, 1 = fall at 8 o'clock and 2 = 4 o'clock
	
	private var minusTicks:Float = 0;
	private var ticksDelay:Float = 0; // used to delay the rock fading.
	private var _rockfallVelocity:Float = 700;
	private var _startY:Float;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);		
		
		loadRotatedGraphic("assets/images/objectRockFalling.png", 32, -1, true, true);
						
		animation.add("animated", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], 30, true);
		animation.play("animated");
		
		_startY = y;
		
		allowCollisions = FlxObject.ANY;
		ra = FlxG.random.int( 80, 350);
		raFallAngle = FlxG.random.int(0, 2);		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		
		if (isOnScreen() == true)
		{
			
			// make the rock fall if rock is within the x range of the player.
			if (ticksRock == 0 && Reg.state.player.x > x - ra && Reg.state.player.x < x + ra && y == _startY) 
			{				
				velocity.y = _rockfallVelocity + (ra * 1.5);
			
				// rock falling down in an angle.
				if (raFallAngle > 0)
				{
					if (raFallAngle == 1) velocity.x = -velocity.y / 5 * 1.5;
					else velocity.x = velocity.y / 5 * 1.5;
				}
			}
			
			//##################### CHANGE ROCK DIRECTION WHEN CAR CHANGES DIRECTION.
			if (Reg._playerInsideCar == true && velocity.y != 0)
			{
				// car is moving backwards, so car should move closer to 8 o'clock rocks. for this to work with parallax, the rock needs to more closer to the car.
				if (InputControls.left.pressed)
					velocity.x = velocity.y / 5 * 1.7;
				if (InputControls.right.pressed)
					velocity.x = -velocity.y / 5 * 1.7;
			}
			//#######################################################################
			
			// rock not yet falling to the ground.
			if (ticksRock == 0)
			{
				// player and enemy damage taken, if rock hits them.
				if (FlxG.overlap(Reg.state.player, this))
				{
					Reg.state.player.hurt(3);		
					
				}
				FlxG.overlap(Reg.state.enemies, this, rockFallingEnemy);
			}
		
			
			// stop the rock if collides with tilemap, then play the animation so that it appears that the rock enters a bit in to the tilemap.
			if (isTouching(FlxObject.FLOOR) || ticksDelay > 0)
			{
				velocity.y = 0;
				animation.stop();
				
				ticksDelay = Reg.incrementTicks(ticksDelay, 60 / Reg._framerate);
		trace("p", ticksDelay);
				if (ticksDelay > 1)
				{
					ticksDelay = 1;
				
					// fade the rock and then remove it from map.
					ticksRock = Reg.incrementTicks(ticksRock, 60 / Reg._framerate) + 1;
					minusTicks = -10 + ticksRock;
					minusTicks = Math.abs(minusTicks);
					alpha = minusTicks / 10;				
				
					if (ticksRock >= 10) kill();
				}
			}
						
			super.update(elapsed);
		}
	}	
	
	// enemy hurt damage if hit by this spike
	private function rockFallingEnemy(e:FlxSprite, s:FlxSprite):Void
	{
		if (FlxSpriteUtil.isFlickering(e) == false)
		{
			e.hurt(3);
		}
	}	
}
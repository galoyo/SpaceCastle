package ;
import flixel.FlxBasic.FlxType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectQuickSand extends FlxSprite
{
	/*******************************************************************************************************
	 * Delay the sinking in to sand.
	 */
	private var ticksDelay:Float = 1;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/objectQuickSand.png", false, 32, 32);	
		
		allowCollisions = FlxObject.ANY;
		immovable = true;		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{			
			ticksDelay = Reg.incrementTicks(ticksDelay, 60 / Reg._framerate);
			
			if (ticksDelay > 1)
			{
				if (overlapsAt(x, y-8, Reg.state.player))
				{
					// without these vars the player would fall through this sand block.
					Reg.state.player.maxVelocity.y = 12;
					Reg.state.player.velocity.y = 12;
					Reg.state.player._inAir = false;
				}
				
				FlxG.overlap(this, Reg.state.enemies, enemyInQuickSand);

				
				// delay the sinking in to sand.
				ticksDelay = 1;
			}
			
			super.update(elapsed);
		}
	}
	
	public static function enemyInQuickSand(t:FlxSprite, e:FlxSprite):Void
	{
		if (Std.is(e, MobApple))
		{
			var mob:MobApple = cast(e, MobApple);
			mob.velocity.y = 12;
			mob.velocity.x = mob.acceleration.x = 0;
			mob._gravity = 0;	
		}
		
		// mobBat should never be overtop of quicksand.
		// mobBullet should never be overtop of quicksand.
				
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob.velocity.y = 12;
			mob.velocity.x = mob.acceleration.x = 0;
			mob._gravity = 0;	
		}
		
		if (Std.is(e, MobExplode))
		{
			var mob:MobExplode = cast(e, MobExplode);
			mob.velocity.y = 12;
			mob.velocity.x = mob.acceleration.x = 0;
			mob._gravity = 0;			
		}
		
		// mobFish should never be overtop of quicksand.
		
		// mobGlob should never be overtop of quicksand.
		
		// mobSaw should never be overtop of quicksand.
		
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob.velocity.y = 12;
			mob.velocity.x = mob.acceleration.x = 0;
			mob._gravity = 0;	
		}
		
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob.velocity.y = 12;
			mob.velocity.x = mob.acceleration.x = 0;
			mob._gravity = 0;	
		}
		
		// mobTube should never be overtop of quicksand.
		
		// mobWorm should never be overtop of quicksand.
		

	}
	
}
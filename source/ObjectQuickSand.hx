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
					Reg.state.player.inAir = false;
				}
				
				FlxG.overlap(this, Reg.state.enemies, enemyInQuickSand);

				
				// delay the sinking in to to sand.
				ticksDelay = 1;
			}
			
			super.update(elapsed);
		}
	}
	
	public static function enemyInQuickSand(t:FlxSprite, e:FlxSprite):Void
	{
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
			mob._gravity = 0;
		}
		
		// get the mob that jumped into the water.
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
			mob._gravity = 0;
		}
		
		if (Std.is(e, MobBullet))
		{
			var mob:MobBullet = cast(e, MobBullet);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
		}
		
		if (Std.is(e, MobBat))
		{
			var mob:MobBat = cast(e, MobBat);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
		}
		
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
			mob._gravity = 0;
		}
		
		// fish do not need air so do not define it here.
		
		if (Std.is(e, MobGlob))
		{
			var mob:MobGlob = cast(e, MobGlob);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
		}
		
		if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
		}
		
		if (Std.is(e, MobExplode))
		{
			var mob:MobExplode = cast(e, MobExplode);
			mob.maxVelocity.y = 12;
			mob.velocity.y = 12;
			mob.acceleration.y = 12;
			mob._gravity = 0;
		}
	}
	
}
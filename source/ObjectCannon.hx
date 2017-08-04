package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * @author galoyo
 */

class ObjectCannon extends ObjectChildClass
{
	private var _bulletTimeForNextFiring:Float; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = 0; // 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of the clock.
	
	public function new(x:Float, y:Float, id:Int, bulletsObject:FlxTypedGroup<BulletObject>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, bulletsObject, emitterBulletHit, emitterBulletMiss);
		
		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/objectCannon.png", true, 46, 37);	

		animation.add("shoot", [0, 1, 2, 2, 1, 0], 20, false);		
		
		pixelPerfectPosition = false;
	
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		ID = id;

		if (ID == 2) facing = FlxObject.LEFT;
		 _bulletFormationNumber = 0;
		immovable = true;
		
		// one second.
		_bulletTimeForNextFiring = FlxG.random.float(0.40, 0.90);
		_cooldown = FlxG.random.float(0.10, 0.40);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{	
			// bullet
			_cooldown += elapsed;
			
			if (_cooldown >= _gunDelay)
			{
				animation.play("shoot");
				shoot();
			}
			
			super.update(elapsed);
		}
	}
	
}
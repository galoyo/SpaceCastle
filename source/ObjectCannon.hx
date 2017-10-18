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
	private var _bulletFormationNumber:Int = 0; // -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	
	public function new(x:Float, y:Float, id:Int, bulletsObject:FlxTypedGroup<BulletObject>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, bulletsObject, particleBulletHit, particleBulletMiss);
		
		_startX = x;
		_startY = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/objectCannon.png", true, 46, 37);	

		animation.add("shoot", [0, 1, 2, 2, 1, 0], 20, false);		
		
		pixelPerfectPosition = false;
	
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
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
				Reg._bulletSize = 0;
				shoot();
			}
			
			super.update(elapsed);
		}
	}
	
}
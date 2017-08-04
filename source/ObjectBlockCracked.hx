package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

/**
 * @author galoyo
 */

class ObjectBlockCracked extends FlxSprite
{
	private var _startX:Float;
	private var _startY:Float;
	
	private var _emitterBulletFlame:FlxEmitter;
	private var _emitterBulletHit:FlxEmitter;
	private var _emitterDeath:FlxEmitter;
	
	public function new(x:Float, y:Float, emitterBulletFlame:FlxEmitter, emitterDeath:FlxEmitter, emitterBulletHit:FlxEmitter) 
	{		
		super(x, y);

		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/objectBlockCracked.png", false, Reg._tileSize, Reg._tileSize);	

		_emitterBulletFlame = emitterBulletFlame;
		_emitterDeath = emitterDeath;
		_emitterBulletHit = emitterBulletHit;
		
		allowCollisions = FlxObject.UP + FlxObject.LEFT + FlxObject.RIGHT; // stop player and mobs from getting stuck in the seam of a rock over top of another rock.
		immovable = true;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxG.overlap(this, _emitterBulletFlame, bulletHitBlock);
		FlxG.overlap(this, Reg.state._bullets, bulletHitBlock);
		
		super.update(elapsed);
	}
	
	/******************************
	 * if bullet hits this block then do the following.
	 */
	private function bulletHitBlock(block:FlxSprite, bullet:FlxSprite):Void 
	{
		_emitterDeath.focusOn(this);
		_emitterDeath.start(true, 20, 1);		
			
		if (Reg._soundEnabled == true) FlxG.sound.play("hit", 1, false);
		
		bullet.kill();
		kill();
	}
}
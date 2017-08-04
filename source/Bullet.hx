package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

/**
 * @author galoyo
 */

class Bullet extends FlxSprite 
{	
	// used to store the distance away fron the gun that the emitterBulletHit will emit from.
	private var	_bulletStar:Float = 0;
	
	// distance the bulletStar animation is from the gun.
	private var	_bulletStarDistance:Int = 30;
	
	// emit the _bulletStar animation.
	private var _emitterBulletHit:FlxEmitter;
	private var _emitterBulletMiss:FlxEmitter;
	
	private var _holdingUpKey:Bool = false;
	
	public function loadNewBulletImage():Void
	{
		if(Reg._typeOfGunCurrentlyUsed == 2)
			loadGraphic("assets/images/bulletFreeze.png", false, 16, 16);
		else 
		{	
			if(Reg._gunPower == 1)
			loadGraphic("assets/images/bullet1.png", false, Reg._tileSize, 4);
			else if(Reg._gunPower == 2)
			loadGraphic("assets/images/bullet2.png", false, Reg._tileSize, 12);
			else if(Reg._gunPower == 3)
			loadGraphic("assets/images/bullet3.png", false, Reg._tileSize, 20);
		}
	}
	
	public function new(emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{		
		super();
		
		_emitterBulletHit = emitterBulletHit;	
		_emitterBulletMiss = emitterBulletMiss;
		
		// load a different graphic depending on the value of reg._gunPower.
		loadNewBulletImage();
			
		exists = false; // we don't want this to exist yet.				
	}
	
	override public function update(elapsed:Float):Void 
	{
		// if bullet exists.
		if (this != null)
		{
			// when the bullet is at the distance of the _bullterStar, emit the _emitterBulletHit so that the _bulletStar animation can be seen. Then destroy the animation.
			if (Reg._typeOfGunCurrentlyUsed == 0)
			{
				if (_holdingUpKey == true )
				{	if (Reg._antigravity == false && _bulletStar > y)
					{
						_emitterBulletHit.focusOn(this);
						_emitterBulletHit.start(true, 0.2, 1);
						kill();
					}
					if (Reg._antigravity == true && _bulletStar < y)
					{
						_emitterBulletHit.focusOn(this);
						_emitterBulletHit.start(true, 0.2, 1);
						kill();
					}
				}	
				else if (_holdingUpKey == false)
				{
					if((Reg.state.player.facing == FlxObject.RIGHT && x > _bulletStar) || (Reg.state.player.facing == FlxObject.LEFT && x < _bulletStar))
					{	
						_emitterBulletHit.focusOn(this);
						_emitterBulletHit.start(true, 0.2, 1);
						kill();
					}
				}
			}
			
			if (isTouching(FlxObject.FLOOR) || isTouching(FlxObject.WALL) || isTouching(FlxObject.CEILING))
			{
				_emitterBulletMiss.focusOn(this);
				_emitterBulletMiss.start(true, 0.2, 1);
				kill();
			}
		}
		
		if(isOnScreen() == false || touching != 0) 
		{
			kill();
		}	
		
		super.update(elapsed);
	}
	
	public function shoot(x:Int, y:Int, velocityX:Int, velocityY:Int, holdingUpKey:Bool, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter):Void
	{
		if (Reg._playerCanShootOrMove == false) return;
		
		_emitterBulletHit = emitterBulletHit;
		_emitterBulletMiss = emitterBulletMiss;
		_holdingUpKey = holdingUpKey;
	
		//#################### LOAD BULLET IMAGE AGAIN? ################
		// only load a bullet graphics if...
		if (FlxG.keys.anyPressed(["Z"]) && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Gun."
		|| FlxG.keys.anyPressed(["X"]) && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Gun."
		|| FlxG.keys.anyPressed(["C"]) && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Gun."
		|| Reg._mouseClickedButtonZ == true && Reg._inventoryIconZNumber[Reg._itemZSelectedFromInventory] == true && Reg._itemZSelectedFromInventoryName == "Normal Gun."
		|| Reg._mouseClickedButtonX == true && Reg._inventoryIconXNumber[Reg._itemXSelectedFromInventory] == true && Reg._itemXSelectedFromInventoryName == "Normal Gun."
		|| Reg._mouseClickedButtonC == true && Reg._inventoryIconCNumber[Reg._itemCSelectedFromInventory] == true && Reg._itemCSelectedFromInventoryName == "Normal Gun.")
		{
			if (FlxG.keys.anyPressed(["UP"]) && Reg._currentKeyPressed != "up" || Reg._mouseClickedButtonUp == true && Reg._currentKeyPressed != "up") 
			{Reg._gunPowerIncreasedOrDecreased = true; Reg._currentKeyPressed = "up";}
					
			else if (FlxG.keys.anyPressed(["RIGHT"]) && Reg._currentKeyPressed != "right" || Reg._mouseClickedButtonRight == true && Reg._currentKeyPressed != "right") 
			{Reg._gunPowerIncreasedOrDecreased = true; Reg._currentKeyPressed = "right";}
			
			else if (FlxG.keys.anyPressed(["DOWN"]) && Reg._currentKeyPressed != "down" || Reg._mouseClickedButtonDown == true && Reg._currentKeyPressed != "down") 
			{Reg._gunPowerIncreasedOrDecreased = true; Reg._currentKeyPressed = "down";}
			
			else if (FlxG.keys.anyPressed(["LEFT"]) && Reg._currentKeyPressed != "left" || Reg._mouseClickedButtonLeft == true && Reg._currentKeyPressed != "left") 
			{Reg._gunPowerIncreasedOrDecreased = true; Reg._currentKeyPressed = "left";}
		}
		
		if (Reg._gunPowerIncreasedOrDecreased == true)
		{
			loadNewBulletImage();	// load a different graphic depending on the value of reg._gunPower.
			Reg._gunPowerIncreasedOrDecreased = false;				
		} 	else if (Reg._currentKeyPressed != "") {loadNewBulletImage(); Reg._currentKeyPressed = "left";}
		//################ END LOAD BULLET IMAGE AGAIN #################		

		// if bullet exists and is moving to the left when set the distance the bullet can travel.
		if (_holdingUpKey == true)
		{
			if(Reg._antigravity == false)
			_bulletStar = y - (_bulletStarDistance) - ((Reg._gunPower + 1) * 50); 
			else _bulletStar = y + (_bulletStarDistance) + ((Reg._gunPower + 1) * 50);
		}
		else
		{
		if (Reg.state.player.x <= x) {_bulletStar = x + _bulletStarDistance + ((Reg._gunPower + 1) * 50); }
	if (Reg.state.player.x > x) {_bulletStar = x - _bulletStarDistance - ((Reg._gunPower + 1) * 50); }
		}
		
		// used to reset the bullet to its default position.
		super.reset(x, y);
		
		// they are not the same cade.
		velocity.x = velocityX;
		velocity.y = velocityY;
		
		if(Reg._typeOfGunCurrentlyUsed == 2)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreeze", 1, false);
		}
			
		else if (Reg._gunPower == 1)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet", 1, false);
		}
		
		else if(Reg._gunPower == 2)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet2", 1, false);
		}
			
		else if (Reg._gunPower == 3)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("bullet3", 1, false);
		}
	}
	
}
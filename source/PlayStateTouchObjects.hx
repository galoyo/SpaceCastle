package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateTouchObjects extends PlayStateMiscellaneous
{

	//#########################################################
	// COLLIDE - EMITTERS
	//#########################################################
	
	/**
	 * this function is called when the player picks up a that triangle that is bouncing on the map. Mob release triangle at death and triangles increase gun power.
	 */
	public function emitterTrianglePlayerOverlap(e:FlxParticle, p:Player):Void
	{
		// find the width of the triangle to determine if the triangle is the large one of the small one, then give the gun powerup depending on which triangle it is.
		if(Std.int(e.width) == 19) // if width of triangle is 19.
			Reg._gunHudBoxCollectedTriangles++;	// small triangle was dropped.	
		else Reg._gunHudBoxCollectedTriangles += 3; // large triangle.
		
		hud.increaseGunPowerCollected();
		if (Reg._soundEnabled == true) FlxG.sound.play("click2", 1, false);
		e.kill();
	}
	
	public function emitterDiamondPlayerOverlap(e:FlxParticle, p:Player):Void
	{
	}
	
	public function emitterPowerUpPlayerOverlap(e:FlxParticle, p:Player):Void
	{
		FlxSpriteUtil.flicker(p, 100, 0.04);
		Reg._powerUpStopFlicker = true;
		FlxG.sound.playMusic("powerUp2", 0.40, false);
		
		e.kill();
	}
	
	public function emitterNuggetPlayerOverlap(e:FlxParticle, p:Player):Void
	{
		Reg._nuggets++;
		
		if (Reg._soundEnabled == true) FlxG.sound.play("click2", 1, false);
		e.kill();
	}
	
	/**
	 * mobs release hearts at death and hearts increase the health of the player.
	 */
	public function emitterHeartPlayerOverlap(h:FlxParticle, p:Player):Void
	{
		// if health is not full then increase health by 1.
		if(p.health < Reg._healthMaximum)
			p.health++;
	
		if (Reg._soundEnabled == true) FlxG.sound.play("click2", 1, false);
		h.kill();
	}
	
	/**
	 * when player is in the water, a text will countdown how much air is left in the lungs. when player overlaps an air bubble then the player is able to breath even when in the water.
	 */
	public function airBubblePlayerOverlap(a:FlxSprite, p:Player):Void
	{
		Reg._playerAirLeftInLungs = 100;
		_playerAirRemainingTimer.start(0.05, null, 100); // set the text countdown of the air remaining.
		
		waterPlayer(p);
	}	
	
	//#########################################################
	// COLLIDE TWEENS
	//#########################################################		
	
	/**
	 * player collides with the block that the fireball rotates.
	 */
	private function fireballBlockPlayer(b:FlxSprite, p:Player):Void 
	{
		// play a thump sound when mob lands on the floor.
		if (p.justTouched(FlxObject.FLOOR)) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
		}	
	}
	
	
	/**
	 * collide check with the fireball that rotates a block. damage taken.
	 */
	public function fireballCollidePlayer(a:FlxSprite, p:Player):Void
	{
		if (FlxSpriteUtil.isFlickering(p) == false)
		{
			p.hurt(3);
		}
	}
	
	/**
	 * ememy touching the fireball that rotates the block. damage taken
	 */
	public function fireballCollideEnemy(a:FlxSprite, e:FlxSprite):Void
	{
		if (FlxSpriteUtil.isFlickering(e) == false)
		{
			e.hurt(3);
		}
	}	
		

	//############################################################
	// COLLIDE - OVERLAP MISC
	//############################################################
	
	/**
	 * prepare to go to the next map when this door is touched. must have the correct key color to exit this door.
	 * */
	private function touchDoor(door:FlxSprite, p:Player):Void 
	{
		if(Reg._itemGotKey[door.ID] == true)
		{
			// animate the player with a tween to look like he goes throught the door.
			// move player to center of door and fade him out
			var px = door.x;
			var py = door.y;
			
			if (!p.hasWon) {				
				/*p.velocity.x = 0;
				p.velocity.y = 0;
				p.acceleration.x = 0;
				p.acceleration.y = 0;
				*/
				p.hasWon = true;
				
			}	
			
			door.kill();
			
			// change to the next map when player is at the edge of the screen simular to how zelda does it.
			if (alive == true)
			{
				// door is now open, so move the player through the door so that the next screen can load after update at playstate.hx sees that the player is at the edge of the screen.
				if (p.x < 40) p.x = 1;				
				if (p.x > 730) p.x = 771;				
				if (p.y < 40) p.y = 1;		
				if (p.y > 410) p.y = 451;
			}
		}
	
	}
	
	/**
	 * mobs takes a bullet from the regular pea shooter of a gun.
	 */
	private function hitEnemy(bullet:FlxSprite, enemy:FlxSprite):Void 
	{
		// return from this function if enemy is not alive or health is less or equals zero.
		if (!enemy.alive || enemy.health <= 0) 
				return;
				
		enemy.hurt((Reg._gunPower));
		
		// emit the bullet star to anaimate where the mob is at.
		if (enemy.health > 0 )
		{
			_emitterBulletHit.focusOn(enemy);
			_emitterBulletHit.start(true, 0.2, 1);
		}
		
		// destroy the bullet.
		bullet.kill();
	}
	
	/**
	 * Player takes a hit from a bullet shot from a mob.
	 */
	private function hitPlayer(bullet:FlxSprite, player:Player):Void 
	{				
		player.hurt(1);
		
		// emit the bullet star to anaimate where the mob is at.
		if (player.health > 0 )
		{
			_emitterBulletHit.focusOn(player);
			_emitterBulletHit.start(true, 0.2, 1);
		}
		
		// destroy the bullet.
		bullet.kill();
	}

	/**
	 * hits for 2 times greater than the normal pea shooter gun and carries on through to the next mob. powerful weapon.
	 */
	private function hitEnemyWithFlame(flame:FlxEmitter, enemy:FlxSprite):Void 
	{
		// return from this function if enemy is not alive or health is less or equals zero.
		if (!enemy.alive || enemy.health <= 0) 
				return;
				
		//enemy health decreases by 1.
		enemy.hurt((Reg._gunPower * 2));
	}
	
	/**
	 * walk up/down ladder.
	 */
	function ladderPlayerOverlap(e:FlxSprite, p:Player):Void
	{
		if (FlxG.keys.anyPressed(["UP"]) || Reg._mouseClickedButtonUp == true) 
		{
			p.xForce--; p.xForce = FlxMath.bound(p.xForce, -1, 1);
			p.yForce = 0;
			p.velocity.y = -100;
			p.acceleration.y = -320;		
			p.y = p.y - 2;
			p.x = e.x - 10; // horizontal align the player to the ladder.

			if (Reg._antigravity == false) p.animation.play("walkOnLadder");
				else p.animation.play("walkOnLadder2");
				
			Reg._arrowKeyInUseTicks = 0;
		}
		else if (FlxG.keys.anyPressed(["DOWN"]) || Reg._mouseClickedButtonDown == true) 
		{
			p.xForce--; p.xForce = FlxMath.bound(p.xForce, -1, 1);
			p.yForce = 0;
			p.velocity.y = 100;
			p.acceleration.y = 320;
			p.y = p.y + 2;
			p.x = e.x - 10; // horizontal align the player to the ladder.
			
			if (Reg._antigravity == false) p.animation.play("walkOnLadder");
				else p.animation.play("walkOnLadder2");
				
			Reg._arrowKeyInUseTicks = 0;
		}
		else { p.velocity.y = 0; p.acceleration.y = 0; }
		
		_playerOnLadder = true;
		Reg._playersYLastOnTile = p.y;  // no fall damage;
	}	
	
	//############################################################
	// COLLIDE MOVING OBJECTS
	//############################################################
	
	/**
	 * collide and make the player stay on the moving platform.
	 */
	private function platformMovingPlayer(obj:FlxSprite, p:Player):Void 
	{
		// play a thump sound when mob lands on the floor.
		if (p.justTouched(FlxObject.FLOOR) || p.justTouched(FlxObject.CEILING)) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);	
		}
		
		if (!FlxG.keys.anyPressed(["LEFT"]) && Reg._mouseClickedButtonLeft == false && !FlxG.keys.anyPressed(["RIGHT"]) && Reg._mouseClickedButtonRight == false)
		{
			if (p.isTouching(FlxObject.CEILING))
			{
				// player is on the ceiling of a playform. keep player moving with the playform.
				p.animation.play("idle2");
				p.velocity.x = obj.velocity.x * 1.5;
			}
		}
		
		EnemyCastSpriteCollide.shoundThereBeFallDamage(p);
	}
	
	/**
	 * mobs on moving platform.
	 */
	private function platformMovingEnemy(obj:FlxSprite, e:FlxSprite):Void 
	{
		// play a thump sound when mob lands on the floor.
		if (e.justTouched(FlxObject.FLOOR)) {
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
			e.y = obj.y - 29;
		}	
	}
	
	/**
	 * If player has the correct special block number then player is able to walk passed the super blocks that hamper the path. this function determines if that path should be cleared.
	 */
	private function touchSuperBlock(obj:FlxSprite, p:Player):Void 
	{
		if(Reg._itemGotSuperBlock[obj.ID] == true)
		{	
			if (Reg._soundEnabled == true) FlxG.sound.play("tick", 1, false);
			obj.kill();
			
			_touchingSuperBlock = true;
		}
	}
	

	
	// ###############################################################
	// OVERLAYS - COLLIDE WATER
	// ###############################################################
	
	/**
	 * this is a collide check to determine if the player has just enetered or exited the water. if player is in the water then do emit the splash sound.
	 */
	public function waterPlayerParameter(w:FlxSprite, p:Player):Void
	{
		Reg._playerAirLeftInLungsCurrent = Reg._playerAirLeftInLungsMaximum;
		Reg._playerAirIsDecreasing = false; // player is at the parameter of water, so the player air is not decreasing.
		Reg._playersYLastOnTile = p.y; // no fall damage because player is in the water.
		
		// flying hat does not work in water.
		if(Reg._usingFlyingHat == true) Reg._usingFlyingHat = false;
		p.animation.play("idle");
		
		p.acceleration.x = p.acceleration.y = p._gravity;
		p.drag.x = p._drag;	
				
		_waterPlayer.cancel;
		_waterPlayer.start(0.05, onTimerWaterPlayer, 1);
		
		// reset the amount of air in the players lungs.
		airLeftInLungsText.visible = false;
		Reg._playerAirLeftInLungs = Reg._playerAirLeftInLungsMaximum;
			
		// play the sound only when the player is in the air.,
		if (p.inAir == true && _playWaterSound == true)
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("water", 1, false);
			_playWaterSound = false;
			
			_emitterWaterSplash.focusOn(p);
			_emitterWaterSplash.start(true, 0.2, 15);
		}
	}	
	
	/**
	 * this bool is needed so that the water splash sound is only played when the player is in the air.
	 */
	private function onTimerWaterPlayer(Timer:FlxTimer):Void
	{	
		_playWaterSound = true;
	}
	
	/**
	 * function for when the player is deep swimming or walking in the water.
	 */
	public function waterPlayer(p:Player):Void
	{
		if (Reg._playerAirIsDecreasing == false ) 
		{
			Reg._playerAirIsDecreasing = true;
			_playerAirRemainingTimer.start(0.05, null, Reg._playerAirLeftInLungsCurrent); // set the Time value to some big number
		}
			
			
		p._mobIsSwimming = true;									
		Reg._playerAirLeftInLungs = -_playerAirRemainingTimer.elapsedLoops + Reg._playerAirLeftInLungsCurrent;
		p.drag.x = p._drag;
		
		// count down from 100 in the water. when reaching 0 then mob will die.
		airLeftInLungsText.text = "Air: " + Reg._playerAirLeftInLungs;
		airLeftInLungsText.visible = true;
		
		if (Reg._playerAirLeftInLungs <= 0)
			p.kill();		
	}		
	
	/**
	 * player is no longer swimming.
	 */
	public function wavePlayer(w:FlxSprite, p:Player):Void
	{
		p._mobIsSwimming = false;
		p.acceleration.x = p.acceleration.y = p._gravity;
	}	
	
	/**
	 * laser beam that deceases or increases in y and starting from the floor or ceiling.
	 */
	function laserBeamPlayer(l:FlxSprite, p:Player):Void
	{
		if(FlxSpriteUtil.isFlickering(p) == false && l.visible == true)
			p.hurt(2);
	}	
	
	//#################################################################
	// TILEMAP COLLIDE - OVERLAP
	//#################################################################
		
	/**
	 * sound played when a partical such as a triangle touches the floor.
	 */
	function tilemapParticalCollide(t:FlxTilemap, e:FlxParticle):Void
	{
		// play sound when the triangles from the enemies touch the floor.
		if (e.isOnScreen())
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("tap", 0.12, false);
		}
	}
	
	/**
	 * function used to keep the player standing on the floor.
	 */
	function tilemapPlayerCollide(t:FlxTilemap, p:Player):Void
	{
		if (p.justTouched(FlxObject.FLOOR)) Reg._arrowKeyInUseTicks = 0; // do not show the players guidelines.
		
		if (Reg._antigravity == true && p.isTouching(FlxObject.FLOOR) && _touchingSuperBlock == false || Reg._antigravity == false && p.isTouching(FlxObject.CEILING) && _touchingSuperBlock == false)
		{
			_emitterCeilingHit.focusOn(p);
			
			if (!FlxG.overlap(_overlayPipe, p))
			{
				_ceilingHit.cancel;
				_ceilingHit.start(0, onTimerCeilingHit, 1);
			}
		} 
		else EnemyCastSpriteCollide.shoundThereBeFallDamage(p);

	}
	
	/**
	 * function that detects if player is touching a rock ro a block.
	 */
	function blockPlayerCollide(t:FlxSprite, p:Player):Void
	{
		EnemyCastSpriteCollide.shoundThereBeFallDamage(p);
	}
	
	/**
	 * used so only a few curcles appear above the head of the player when the player bangs head on the ceiling.
	 */
	private function onTimerCeilingHit(_ceilingHit:FlxTimer):Void
	{	
		// remove this line if you want this emitted when a mob hits the head of player.
		//if(_ceilingHitFromMob == false) // seems to work best without this line.
			_emitterCeilingHit.start(true, 0.2, 2);
	
		_ceilingHitFromMob = false;
	}
		
}
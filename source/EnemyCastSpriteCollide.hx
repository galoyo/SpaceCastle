package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class EnemyCastSpriteCollide {
    
	/**********************************
	 * In the water, this function is called if mob is at an air bubble. 
	 */	
	public static function airBubbleEnemyOverlap(a:FlxSprite, e:FlxSprite):Void
	{
		if (Std.is(e, MobApple))
		{
			var mob:MobApple = cast(e, MobApple);
			mob._airLeftInLungs = 80;
		}
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob._airLeftInLungs = 50;		
		}
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob._airLeftInLungs = 40;	
		}
		if (Std.is(e, MobBat))
		{
			var mob:MobBat = cast(e, MobBat);
			mob._airLeftInLungs = 130;		
		}
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob._airLeftInLungs = 130;		
		}
		
		// mobFish dont need air, so do not define it here.
		
		if (Std.is(e, MobGlob))
		{
			var mob:MobGlob = cast(e, MobGlob);
			mob._airLeftInLungs = 200;		
		}
		
		if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			mob._airLeftInLungs = 200;		
		}
	}
	
	public static function tilemapEnemyCollide(t:FlxTilemap, e:FlxSprite):Void
	{
		// die if sqeezed between the tile and moving platform.
		if(e.isTouching(FlxObject.LEFT) && e.overlapsAt(e.x-15, e.y, t) && e.overlapsAt(e.x+15, e.y, Reg.state._objectPlatformMoving) || e.isTouching(FlxObject.RIGHT) && e.overlapsAt(e.x+15, e.y, t) && e.overlapsAt(e.x-15, e.y, Reg.state._objectPlatformMoving))
		{
			if (Std.is(e, MobApple))
			{
				var mob:MobApple = cast(e, MobApple);
				mob.kill();	
			}
			if (Std.is(e, MobCutter))
			{
				var mob:MobCutter = cast(e, MobCutter);
				mob.kill();			
			}
			if (Std.is(e, MobSlime))
			{
				var mob:MobSlime = cast(e, MobSlime);
				mob.kill();		
			}
			if (Std.is(e, MobBat))
			{
				var mob:MobBat = cast(e, MobBat);
				mob.kill();			
			}
			if (Std.is(e, MobSqu))
			{
				var mob:MobSqu = cast(e, MobSqu);
				mob.kill();	
			}
			
			if (Std.is(e, MobFish))
			{
				var mob:MobFish = cast(e, MobFish);
				mob.kill();		
			}
			
			if (Std.is(e, MobGlob))
			{
				var mob:MobGlob = cast(e, MobGlob);
				mob.kill();		
			}
			
			if (Std.is(e, MobWorm))
			{
				var mob:MobWorm = cast(e, MobWorm);
				mob.kill();		
			}
		}
	}
	
	public static function blockEnemyCollide(t:FlxSprite, e:FlxSprite):Void
	{
		// die if sqeezed between the tile and moving platform.
		if(e.isTouching(FlxObject.LEFT) && e.overlapsAt(e.x-15, e.y, t) && e.overlapsAt(e.x+15, e.y, Reg.state._objectPlatformMoving) || e.isTouching(FlxObject.RIGHT) && e.overlapsAt(e.x+15, e.y, t) && e.overlapsAt(e.x-15, e.y, Reg.state._objectPlatformMoving))
		{
			if (Std.is(e, MobApple))
			{
				var mob:MobApple = cast(e, MobApple);
				mob.kill();	
			}
			if (Std.is(e, MobCutter))
			{
				var mob:MobCutter = cast(e, MobCutter);
				mob.kill();			
			}
			if (Std.is(e, MobSlime))
			{
				var mob:MobSlime = cast(e, MobSlime);
				mob.kill();		
			}
			if (Std.is(e, MobBat))
			{
				var mob:MobBat = cast(e, MobBat);
				mob.kill();			
			}
			if (Std.is(e, MobSqu))
			{
				var mob:MobSqu = cast(e, MobSqu);
				mob.kill();	
			}
			
			if (Std.is(e, MobFish))
			{
				var mob:MobFish = cast(e, MobFish);
				mob.kill();		
			}
			
			if (Std.is(e, MobGlob))
			{
				var mob:MobGlob = cast(e, MobGlob);
				mob.kill();		
			}
			
			if (Std.is(e, MobWorm))
			{
				var mob:MobWorm = cast(e, MobWorm);
				mob.kill();		
			}
		}
	}
	
	/**********************************
	 * this function is called when a mob and player collides. 
	 */	
	public static function enemyPlayerCollide(e:FlxSprite, p:Player):Void
	{
		var healthDamage:Float = 0; // Initialize player hurt value.
		Reg.state._ceilingHitFromMob = true;

		if (e.animation.paused == false)
		{
			Reg._gunHudBoxCollectedTriangles--;
			Reg.state.hud.decreaseGunPowerCollected();
			
			// different hurt values depending on which mob hit player.
			if (Std.is(e, MobSaw)) p.hurt(4);
			else if(e.alpha == 1) p.hurt(1);
				
			// knock player to the right.
			if (p.facing == FlxObject.LEFT) p.velocity.x = 600;
			else p.velocity.x = -600;
			
			return;
		
		} else
			{
				if (Std.is(p, Player))
				{
					var mob:Player = cast(p, Player);
					mob._newY = mob.y; // prepare to stand still above the head of the mob.		
				}
			}
		
	}
	
	private static function onTimerWaterEnemy(Timer:FlxTimer):Void
	{	
		Reg.state._playWaterSoundEnemy = true;
	}
	
	/**********************************
	 * Called when the mob enters or exits the water. 
	 */	
	public static function waterEnemyParameter(w:FlxSprite, e:FlxSprite):Void
	{
		Reg.state._waterEnemy.cancel;
		Reg.state._waterEnemy.start(0.05, onTimerWaterEnemy, 1);
		
		if (Std.is(e, MobApple))
		{
			var mob:MobApple = cast(e, MobApple);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			// play a sound when the mob is in the air and a delay to play the sound is complete.
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 1, false);
								
				// set the delay to play the water sound. next time this function is called, the timer function will be called, to set this var as true so that if the mob is in the air and touching the water parameter then the sound will be played.				
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
		
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 1, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);				
			} 	
		}
		
		// get the mob that jumped into the water.
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 1, false);

				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);				
			} 	
		}
		
		if (Std.is(e, MobBullet))
		{
			var mob:MobBullet = cast(e, MobBullet);
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 0.50, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
		
		if (Std.is(e, MobBat))
		{
			var mob:MobBat = cast(e, MobBat);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 0.50, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
		
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 0.50, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
		
		// fish do not need air so do not define it here.
		
		if (Std.is(e, MobGlob))
		{
			var mob:MobGlob = cast(e, MobGlob);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 0.50, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
		
		if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			mob._airLeftInLungs = mob._airLeftInLungsMaximum;
			mob.airTimerTicks = 0;
			
			if (mob.inAir == true && Reg.state._playWaterSoundEnemy == true)
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("water", 0.50, false);
				Reg.state._playWaterSoundEnemy = false;
				
				Reg.state._emitterWaterSplash.focusOn(mob);
				Reg.state._emitterWaterSplash.start(true, 0.2, 15);
			} 	
		}
	}
	
	public static function waterEnemy(e:FlxSprite):Void
	{
		if (Std.is(e, MobApple))
		{
			var mob:MobApple = cast(e, MobApple);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;	// increase timer. without this var the mob would die with no air in lungs as soon as the mob hit the water. this var makes a small delay in the air in lungs count down.
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--; 	// decrease the amount of air in mobs lungs.
				mob.airTimerTicks = 0;	// reset timer.
			}
								
			if (mob._airLeftInLungs <= 0)	// kill mob if no more air in lungs.
				mob.kill();	
		}
		
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
		
		// get the mob that jumped into the water.
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
		
		if (Std.is(e, MobBullet))
		{
			var mob:MobBullet = cast(e, MobBullet);
			mob._mobIsSwimming = true;
		}
		
		if (Std.is(e, MobBat))
		{
			var mob:MobBat = cast(e, MobBat);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
		
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
		
		// fish do not need air so do not define it here.
		
		if (Std.is(e, MobGlob))
		{
			var mob:MobGlob = cast(e, MobGlob);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
		
		if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			mob._mobIsSwimming = true;
			
			mob.airTimerTicks++;
					
			if (mob.airTimerTicks > 5)
			{
				mob._airLeftInLungs--;
				mob.airTimerTicks = 0;
			}
								
			if (mob._airLeftInLungs <= 0)
				mob.kill();	
		}
	}
	
	/**********************************
	 * called when mob is at the surface of the water. waving water image. 
	 */	
	public static function waveEnemy(w:FlxSprite, e:FlxSprite):Void
	{
		if (Std.is(e, MobApple))
		{
			var mob:MobApple = cast(e, MobApple);
			mob._mobIsSwimming = false;
			// TODO water currents do not work with mobs yet but if it does then this line is needed so that if the water current throws the mob out of the water then the gravity will pull the mob back down.
			mob.acceleration.x = mob.acceleration.y = mob._gravity;
		}
		
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			mob._mobIsSwimming = false;
			mob.acceleration.x = mob.acceleration.y = mob._gravity;
		}
		
		// get the mob that jumped into the water.
		if (Std.is(e, MobSlime))
		{
			var mob:MobSlime = cast(e, MobSlime);
			mob._mobIsSwimming = false;
			
			mob.acceleration.y = mob._mobAccelY;
		}
		
		if (Std.is(e, MobBullet))
		{
			var mob:MobBullet = cast(e, MobBullet);
			mob._mobIsSwimming = false;
		}

		if (Std.is(e, MobBat))
		{
			var mob:MobBat = cast(e, MobBat);
			mob._mobIsSwimming = false;
		}
		
		if (Std.is(e, MobSqu))
		{
			var mob:MobSqu = cast(e, MobSqu);
			mob._mobIsSwimming = false;
			mob.acceleration.x = mob.acceleration.y = mob._gravity;
		}
		
		// fish do not need air so do not define it here.
		
		if (Std.is(e, MobGlob))
		{
			var mob:MobGlob = cast(e, MobGlob);
			mob._mobIsSwimming = false;
		}

		if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			mob._mobIsSwimming = false;
		}
	}
	
	/**********************************
	 * freeze gun function to freeze the mob when hit.
	 */
	public static function hitEnemy(b:FlxSprite, e:FlxSprite):Void
	{
		
		// the following is needed for the freeze weapon to work. if a mob is not here then the freeze weapon used on the mob does nothing.
		
		if (Std.is(e, MobCutter))
		{
			var mob:MobCutter = cast(e, MobCutter);
			
			if (mob.animation.paused == false)
			{
				mob.setColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
							
				mob.acceleration.y = 0;
				mob.velocity.y = 0;
				mob._newX = mob.x;
				mob._newY = mob.y;
			
				if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreezeHit", 1, false);
				mob.animation.paused = true;	
			} else if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreezeMiss", 1, false);
		} 
		else if (Std.is(e, MobWorm))
		{
			var mob:MobWorm = cast(e, MobWorm);
			
			if (mob.animation.paused == false)
			{
				mob.setColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
							
				mob.acceleration.y = 0;
				mob.velocity.y = 0;
				mob._newX = mob.x;
				mob._newY = mob.y;
			
				if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreezeHit", 1, false);
				mob.animation.paused = true;	
			} else if (Reg._soundEnabled == true) FlxG.sound.play("bulletFreezeMiss", 1, false);
		} 
		else if (Reg._soundEnabled == true) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("buzz", 1, false);
		}
		
		// remove the freeze bullet.
		b.kill();
	}
	 
	/**********************************
	 * this function handles what to do when a mob hits the laser beam. 
	 */	
	public static function laserBeamEnemy(l:FlxSprite, e:FlxSprite):Void
	{
		if(FlxSpriteUtil.isFlickering(e) == false && l.visible == true)
		{
			if (Std.is(e, MobApple))
			{
				var mob:MobApple = cast(e, MobApple);
				mob.hurt(2);
			}
			if (Std.is(e, MobCutter))
			{
				var mob:MobCutter = cast(e, MobCutter);
				mob.hurt(2);	
			}
			if (Std.is(e, MobSlime))
			{
				var mob:MobSlime = cast(e, MobSlime);
				mob.hurt(2);	
			}
			if (Std.is(e, MobBullet))
			{
				var mob:MobBullet = cast(e, MobBullet);
				mob.hurt(2);		
			}
			if (Std.is(e, MobBat))
			{
				var mob:MobBat = cast(e, MobBat);
				mob.hurt(2);		
			}
			
			if (Std.is(e, MobSqu))
			{
				var mob:MobSqu = cast(e, MobSqu);
				mob.hurt(2);		
			}
			
			if (Std.is(e, MobFish))
			{
				var mob:MobFish = cast(e, MobFish);
				mob.hurt(2);		
			}
			
			if (Std.is(e, MobGlob))
			{
				var mob:MobGlob = cast(e, MobGlob);
				mob.health = mob.health - 2;
				
				if (mob.health <= 0) mob.kill();
			}

			if (Std.is(e, MobWorm))
			{
				var mob:MobWorm = cast(e, MobWorm);
				mob.hurt(2);		
			}
		}
	}
	
	public static function shoundThereBeFallDamage(p:Player):Void
	{
		if (Reg._playerFallDamage == false) return;
		
		if (p.inAir == true)
		{
			if (Reg.state.warningFallLine != null)
			{
				Reg.state.warningFallLine.visible = false;
				Reg.state.deathFallLine.visible = false;
				Reg.state.maximumJumpLine.visible = false;
			}
		}
		
		Reg.state._touchingSuperBlock = false;
		
		Reg._playerYNewFallTotal = p.y - Reg._playersYLastOnTile;
		
		// if the player lands on the ground from a steep distance above the ground then the player is hurt. determine the distance hurt or if the player dies.
		if (Reg._antigravity == false && p.isTouching(FlxObject.FLOOR) && p._mobIsSwimming == false)
		{
			if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels >= 128 || Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels > 0 && p.health <= 1.5) 
			{
				Reg._isFallDamage = true;
				p.hurt(p.health); 
				if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);
				
			}
			else if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels >= 96) 
			{
				Reg._isFallDamage = true;
				p.hurt((Reg._healthMaximum * 0.75)); 
				if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);
				
			} // 75 percent.
			else if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels >= 64) 
			{
				Reg._isFallDamage = true;
				p.hurt((Reg._healthMaximum * 0.50)); 
				if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);
				
			} // 50 percent.
			else if (Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels >= 32) 
			{
				Reg._isFallDamage = true;
				p.hurt((Reg._healthMaximum * 0.25)); 
				if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false); 
				
			} // 50 percent.
				
			Reg._playersYLastOnTile = p.y;
		}
		
		else if (Reg._antigravity == true && p.isTouching(FlxObject.CEILING) && p._mobIsSwimming == false)
		{
			if (Reg._playerYNewFallTotal + Reg._fallAllowedDistanceInPixels <= -128 || Reg._playerYNewFallTotal - Reg._fallAllowedDistanceInPixels > 0 && p.health <= 1.5) {p.hurt(p.health); if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);}
			else if (Reg._playerYNewFallTotal + Reg._fallAllowedDistanceInPixels <= -96) {p.hurt((p.health * 0.75)); if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);} // 75 percent.
			else if (Reg._playerYNewFallTotal + Reg._fallAllowedDistanceInPixels <= -64) {p.hurt((p.health * 0.50)); if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false);} // 50 percent.
			else if (Reg._playerYNewFallTotal + Reg._fallAllowedDistanceInPixels <= -32) {p.hurt((p.health * 0.25)); if (Reg._soundEnabled == true) FlxG.sound.play("fallDamage", 0.85, false); } // 50 percent.
				
			Reg._playersYLastOnTile = p.y;
		}
		
		if (Reg._antigravity == false)
		{
			// player falling one tile below this line will get small health damage.
			if (Reg.state.warningFallLine != null)
			{
				Reg.state.warningFallLine.x = p.x - 830;
				Reg.state.warningFallLine.y = p.y + Reg._fallAllowedDistanceInPixels + 28;
				
				// player falling to or passed this line is instant death.		
				Reg.state.deathFallLine.x = p.x - 830;
				Reg.state.deathFallLine.y = p.y + Reg._fallAllowedDistanceInPixels + 96 + 58;
				
				// player can jump to this line but not passed it.
				Reg.state.maximumJumpLine.x = p.x - 830;
				Reg.state.maximumJumpLine.y = p.y - Reg._fallAllowedDistanceInPixels + 28;
			}
		}
		else if (Reg._antigravity == true)
		{
			// player falling one tile below this line will get small health damage.		
			if (Reg.state.warningFallLine != null)
			{
					Reg.state.warningFallLine.x = p.x - 830;
					Reg.state.warningFallLine.y = p.y - Reg._fallAllowedDistanceInPixels;
				
				// player falling to or passed this line is instant death.		
				Reg.state.deathFallLine.x = p.x - 830;
				Reg.state.deathFallLine.y = p.y - Reg._fallAllowedDistanceInPixels - 96 - 30;
				
				// player can jump to this line but not passed it.
				Reg.state.maximumJumpLine.x = p.x - 830;
				Reg.state.maximumJumpLine.y = p.y + Reg._fallAllowedDistanceInPixels;
			}
		}
	}
}
package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxTrailEffect;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.ui.FlxUIState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxTimer;

/**
 * ...
 * @author galoyo
 */
class PlayStateAdd
{	
	// ############################################################
	//  ADD MOBS TO MAP
	// ############################################################
	
	public static function addPlayer(X:Int, Y:Int):Void
	{
		// when going to the Player constructor, the x and y values will be multiply by the
		// tile size. currently, these x and y value refers to how many blocks from the
		// left-right or up-down position of a csv file.
		var xNewCoords:Float = 0;
		var yNewCoords:Float = 0;
		var facingLeft:Bool = false;
		
		if (Reg._inHouse == "")
		{
			if (Reg.beginningOfGame == false && Reg.restoreGameState == false)
			{
				// west - to go east door.
				if (Reg.playerXcoords < 1) {xNewCoords = 23 ; yNewCoords = Reg.playerYcoords; facingLeft = true; } 
				
				// north - to go south door.
				else if (Reg.playerYcoords < 1) {yNewCoords = 13 ; xNewCoords = Reg.playerXcoords; } 
				
				// east - to go west door.
				else if (Reg.playerXcoords > 24) {xNewCoords = 1 ; yNewCoords = Reg.playerYcoords; facingLeft = false; } 
			
				// south - go to north door.
				else if (Reg.playerYcoords > 14) {yNewCoords = 1 ; xNewCoords = Reg.playerXcoords;} 		
				
			}
			else
			{
				xNewCoords = Reg.playerXcoords;
				yNewCoords = Reg.playerYcoords;
			}
		}
	
		// place the player on the map.
		if (Reg._inHouse == "")
		{
			if (Reg.playerXcoordsLast != 0)
				{Reg.state.player = new Player(Reg.playerXcoordsLast, Reg.playerYcoordsLast, Reg.state._bullets, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss, Reg.state._emitterBulletFlame); Reg.playerXcoordsLast = 0; Reg.playerYcoordsLast = 0; }
			else if (Reg.beginningOfGame == false && Reg.restoreGameState == false)
				Reg.state.player = new Player(xNewCoords * Reg._tileSize, yNewCoords * Reg._tileSize, Reg.state._bullets, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss, Reg.state._emitterBulletFlame);
			else if (Reg.beginningOfGame == false && Reg.restoreGameState == true)
				Reg.state.player = new Player(Reg.playerXcoords, Reg.playerYcoords, Reg.state._bullets, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss, Reg.state._emitterBulletFlame); 			
			else Reg.state.player = new Player(X, Y, Reg.state._bullets, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss, Reg.state._emitterBulletFlame);
		}
		else 
		{
			if (Reg._teleportedToHouse == true) 
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("teleport2", 1, false);
				X += (10 * Reg._tileSize);
			}
			Reg.state.player = new Player(X, Y, Reg.state._bullets, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss, Reg.state._emitterBulletFlame); 			
			
			Reg._teleportedToHouse = false;
		}
		
		Reg.restoreGameState = false;		
		Reg._playersYLastOnTile = Reg.state.player.y;
		
		if (facingLeft == true) Reg.state.player.facing = FlxObject.LEFT;
		
		Reg.state._healthBarPlayer = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.player, "health", 0, Reg.state.player.health, false);		
		Reg.state._healthBarPlayer.setRange(0, Reg._healthMaximum);
		Reg.state.add(Reg.state._healthBarPlayer);
	}
	
	
	/**
	 * walks back and forth on a platform. no bullet ability.
	 */
	public static function addMobApple(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		// when power is greater than 1, make it so that monsters at a higher level have a 66 percent chance of appearing.
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobApple = new MobApple(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobApple);

			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	Reg.state.mobApple, "health", 0, Reg.state.mobApple.health, false);		
			Reg.state._healthBars.add(_healthBar);
		}
	}

	/**
	 * moves back/forth by touching a wall. jumps over holes. no bullets.
	 */
	public static function addMobCutter(X:Float, Y:Float, id:Int):Void
	{
		// normal walking monster that walks in one direction.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobCutter = new MobCutter(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobCutter);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobCutter, "health", 0, Reg.state.mobCutter.health, false);	
			Reg.state._healthBars.add(_healthBar);
		}
	}
	
	/**
	 * higher id = faster movement. able to jump. bullets maybe.
	 */
	public static function addMobSlime(X:Float, Y:Float, id:Int):Void
	{
		// the mobs in this class can jump.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobSlime = new MobSlime(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobSlime);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobSlime, "health", 0, Reg.state.mobSlime.health, false);		
			Reg.state._healthBars.add(_healthBar);
		}
	}
	
	/**
	 * flies. warps to player when wall is a path obstacle. bullets.
	 */
	public static function addBoss2(X:Float, Y:Float):Void
	{
		if (Reg._boss2Defeated == false)
		{
			Reg.state.boss2 = new Boss2(X, Y, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.boss2);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.boss2, "health", 0, Reg.state.boss2.health, false);		
			Reg.state._healthBars.add(_healthBar);
		} else Reg._boss2IsMala = false;
	}
	
	/**
	 * only moves horizontally from one side of the screen to the other.
	 */
	public static function addMobBullet(X:Float, Y:Float):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		Reg.state.mobBullet = new MobBullet(X, Y, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		Reg.state.enemiesNoCollideWithTileMap.add(Reg.state.mobBullet);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobBullet, "health", 0, Reg.state.mobBullet.health, false);		
		Reg.state._healthBars.add(_healthBar);		
	}
	
	public static function addMobTube(X:Float, Y:Float):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		Reg.state.mobTube = new MobTube(X, Y, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		Reg.state.enemiesNoCollideWithTileMap.add(Reg.state.mobTube);
	
	}
	
	/**
	 * moves randomly in the air. no bullets ability.
	 */
	public static function addMobBat(X:Float, Y:Float, id:Int):Void
	{
		// x and y coords, p = player, _emitterMobsDamage is the effect seen when a mob is hit.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobBat = new MobBat(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobBat);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobBat, "health", 0, Reg.state.mobBat.health, false);		
			Reg.state._healthBars.add(_healthBar);
		}
	}
	
	/**
	 * jump happy mob: no bullets.
	 */
	public static function addMobSqu(X:Float, Y:Float, id:Int):Void
	{
		// x and y coords, _emitterMobsDamage is the effect seen when a mob is hit.
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobSqu = new MobSqu(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobSqu);
			
			// the health bar displayed underneath the players legs.
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobSqu, "health", 0, Reg.state.mobSqu.health, false);		
			Reg.state._healthBars.add(_healthBar);	
		}
	}
	
	/**
	 * NPC. looks like the player but yellow color. weak from the virus in the air.
	 */
	public static function addNpcMalaUnhealthy(X:Float, Y:Float, id:Int):Void
	{
		Reg.state.npcMalaUnhealthy = new NpcMalaUnhealthy(X, Y, id);			
		Reg.state.npcs.add(Reg.state.npcMalaUnhealthy);
	}
	
	/**
	 * moves back/forth by touching a wall. no bullets. different speeds.
	 */
	public static function addMobFish(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobFish = new MobFish(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobFish);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobFish, "health", 0, Reg.state.mobFish.health, false);		
			Reg.state._healthBars.add(_healthBar);		
		}
	}
	
	/**
	 * moves on ceiling, walls or floors. slow movement. no bullets.
	 */
	public static function addMobGlob(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobGlob = new MobGlob(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobGlob);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobGlob, "health", 0, Reg.state.mobGlob.health, false);	
			_healthBar.offset.set( -3, -6);
			Reg.state._healthBars.add(_healthBar);	
		}
	}
	
	/**
	 * flies back and forth on an invisible horizontal line.
	 */
	public static function addMobWorm(X:Float, Y:Float, id:Int):Void
	{
		var ra = FlxG.random.int(1, 3);
		
		if ( ra > 1 && Reg._gunPower >= id && Reg._gunPower > 1 ||  Reg._gunPower == id)
		{
			Reg.state.mobWorm = new MobWorm(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.mobWorm);
			
			var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobWorm, "health", 0, Reg.state.mobWorm.health, false);	
			_healthBar.offset.set( -3, -6);
			Reg.state._healthBars.add(_healthBar);
		}
	}

	/**
	 * mobExplode: This mob hangs from the ceiling shooting bullets in an angle. Fly towards player when they are near vertical. occupies two tiles.
	 */
	public static function addMobExplode(X:Float, Y:Float):Void
	{
		Reg.state.mobExplode = new MobExplode(X, Y, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		Reg.state.enemies.add(Reg.state.mobExplode);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.mobExplode, "health", 0, Reg.state.mobExplode.health, false);	
		_healthBar.offset.set( 0, -12);
		Reg.state._healthBars.add(_healthBar);
	}
	
	/**
	 * add a saw to the map. one touch means big health damage.
	 */
	public static function addMobSaw(X:Float, Y:Float, id:Int):Void
	{
		Reg.state.mobSaw = new MobSaw(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		Reg.state.enemies.add(Reg.state.mobSaw);
	}
	
	/**
	 * Runs and jumps randomly.
	 */
	public static function addBoss(X:Float, Y:Float, id:Int):Void
	{
		if (Reg._boss1ADefeated == false && id == 1)
		{
			Reg.state.boss1A = new Boss1(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.boss1A);
			
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.boss1A, "health", 0, Reg.state.boss1A.health, false);	
		_healthBar.offset.set( -3, -6);
		Reg.state._healthBars.add(_healthBar);
		}
		
		if (Reg._boss1BDefeated == false && id == 2)
		{
			Reg.state.boss1B = new Boss1(X, Y, id, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
			Reg.state.enemies.add(Reg.state.boss1B);
			
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.boss1B, "health", 0, Reg.state.boss1B.health, false);	
		_healthBar.offset.set( -3, -30); // minus values = move down;
		Reg.state._healthBars.add(_healthBar);
		}
	}
	
	/**
	 * NPC looks like the player. not sick from the bad air.
	 */
	public static function addNpcMalaHealthy(X:Float, Y:Float, id:Int):Void
	{
		Reg.state.npcMalaHealthy = new NpcMalaHealthy(X, Y, id);
		Reg.state.npcs.add(Reg.state.npcMalaHealthy);
	}
	
	/**
	 * Boss. ??? (doctors friend).
	 */
	public static function addMobBubble(X:Float, Y:Float):Void
	{
		if (Reg._boss1BDefeated == true && Reg.mapXcoords != 12 && Reg.mapYcoords != 19 || Reg._boss1BDefeated == false && Reg.mapXcoords == 12 && Reg.mapYcoords == 19)
		{
			Reg.state.mobBubble = new MobBubble(X, Y, Reg.state.player, Reg.state._emitterMobsDamage, Reg.state._emitterDeath, Reg.state._emitterItemTriangle, Reg.state._emitterItemDiamond, Reg.state._emitterItemPowerUp, Reg.state._emitterItemNugget, Reg.state._emitterItemHeart, Reg.state._emitterSmokeRight, Reg.state._emitterSmokeLeft, Reg.state._bulletsMob, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		
			Reg.state.enemies.add(Reg.state.mobBubble);		
			
			Reg.fireballRandom = FlxG.random.float( 0.90, 1.10);
			
			Reg.state._defenseMobFireball1 = new DefenseMobFireball(0,0);
			Reg.state.add(Reg.state._defenseMobFireball1);
			
			Reg.state._defenseMobFireball2 = new DefenseMobFireball(0,0);
			Reg.state.add(Reg.state._defenseMobFireball2);
			
			Reg.state._defenseMobFireball3 = new DefenseMobFireball(0,0);
			Reg.state.add(Reg.state._defenseMobFireball3);
			
			Reg.state._defenseMobFireball4 = new DefenseMobFireball(0,0);
			Reg.state.add(Reg.state._defenseMobFireball4);
			
			// this is needed so that player can take damage from these fireballs.
			Reg.state._objectFireballTween.add(Reg.state._defenseMobFireball1);
			Reg.state._objectFireballTween.add(Reg.state._defenseMobFireball2);
			Reg.state._objectFireballTween.add(Reg.state._defenseMobFireball3);
			Reg.state._objectFireballTween.add(Reg.state._defenseMobFireball4);
			
			Reg.state._bubbleHealthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, 	Reg.state.mobBubble, "health", 0, Reg.state.mobBubble.health, false);	
			Reg.state._bubbleHealthBar.offset.set( -3, 0);
			Reg.state._bubbleHealthBar.visible = false;
			Reg.state._healthBars.add(Reg.state._bubbleHealthBar);	
		}
	}
	
	/**
	 * ???
	 */
	public static function addNpcDoctor(X:Float, Y:Float):Void
	{
		Reg.state.npcDoctor = new NpcDoctor(X, Y);
		Reg.state.npcs.add(Reg.state.npcDoctor);
		
		var _healthBar = new HealthBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 28, 12, Reg.state.npcDoctor, "health", 0, Reg.state.npcDoctor.health, false);		
		Reg.state._healthBars.add(_healthBar);		
	}
	
	/**
	 * NPC. talks about the doctor, his friends and how the malas became sick. needs help finding her dogs.
	 */
	public static function addNpcDogLady(X:Float, Y:Float):Void
	{
		Reg.state.npcDogLady = new NpcDogLady(X, Y);
		Reg.state.npcs.add(Reg.state.npcDogLady);
	}
	
	/**
	 * NPC. player needs to collect 2 dogs to get a special block from the dog lady to advance in the game.
	 */
	public static function addNpcDog(X:Float, Y:Float, P:Player, id:Int):Void
	{
		if (Reg._itemGotDogFlute == false) return;
		
		var _dogCarriedItsID2 = Reg._dogCarriedItsID.split(",");
		var _dogFoundAtMap2 = Reg._dogFoundAtMap.split(",");
		Reg._dogOnMap = true;
			
		// if dog lady is not on map and the dog on map is not currently carried then create dog at its position.
		if ( Reg.state.npcDogLady == null)
		{			
			for (i in 0..._dogFoundAtMap2.length)
			{	
				// was the dog picked up at map
				if (_dogFoundAtMap2[i] == Reg.mapXcoords + "-" + Reg.mapYcoords + Reg._inHouse)
				{
					Reg._dogOnMap = false;
					break;
				}
			}		
			
			if (Reg._dogOnMap == true)
			{
				var idFound:Bool = false;
				
				for (i in 0..._dogCarriedItsID2.length)
				{						
					// is the dog currently carried?
					if (_dogCarriedItsID2[i] == Std.string(id))
					{
						idFound = true;
					}					
				}	
				
				// do this code block if the dog was not carried to the lady.
				if (idFound == false || Reg._dogCarried == true && Reg._dogCurrentlyCarried == id)
				{
					Reg.state.npcDog = new NpcDog(X, Y, P, id);
					Reg.state.npcs.add(Reg.state.npcDog);
				}
				else idFound = false;
			}
		}

			// loop through the _dogCarriedItsID2 array. if there is a match (id value of sprite and id value of _dogCarriedItsID2 var) then a dog was carried to the lady. she now has that dog. so display the dog beside her.
		if (Reg.state.npcDogLady != null)
		{
			for (i in 0..._dogCarriedItsID2.length)
			{	
				if (_dogCarriedItsID2[i] == Std.string(id))
				{
					if (_dogFoundAtMap2[i] != null)
					{
						Reg.state.npcDog = new NpcDog(X, Y, P, id);
						Reg.state.npcs.add(Reg.state.npcDog);	
						Reg._dogOnMap = true;
					}

				}
			}
		}
	}
	
		
	// ######################################################
	// ITEMS	
	// ######################################################
	
	/**
	 * add the diamonds to the map. collect all diamonds at the map for 1 health point increase.
	 */
	public static function addDiamond(X:Float, Y:Float):Void
	{
		var paragraph = Reg._diamondCoords.split(",");
		var diamondsFoundOnMap:Bool = false;
		
		// loop through the paragraph array. if there is a match then a heart was picked up at the current map the player is at.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				diamondsFoundOnMap = true;
		}
		
		if (diamondsFoundOnMap == false)
		{
			// diamonds that the player collects/
			Reg.state._itemsThatWerePickedUp.add(new ItemDiamond(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
			Reg.diamondsRemaining++;
		}		
		
	}
	
	/**
	 * add the door keys to the map. These key are different colored and open the same colored door.
	 */
	public static function addItemDoorKey(X:Float, Y:Float, id:Int):Void
	{
		if (Reg._itemGotKey[id] == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemDoorKey(X, Y, id));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the jump higher ability to the map.
	 */
	public static function addItemJump(X:Float, Y:Float, I:Int):Void
	{
		if (Reg._itemGotJump[I] == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemJump(X, Y, I));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flame gun to the map. 2 times more powerful than the normal gun. does not stop when hitting an object.
	 */
	public static function addItemGunFlame(X:Float, Y:Float):Void
	{
		if (Reg._itemGotGunFlame == false)
		{
			Reg.state._itemGunFlame.add(new ItemGunFlame(X, Y));
			Reg.state.add(Reg.state._itemGunFlame);
		}
	}
	
	/**
	 * add the guns rapid fire to the map. increase the bullet speed of the normal gun.
	 */
	public static function addItemGunRapidFire(X:Float, Y:Float):Void
	{
		if (Reg._itemGotGunRapidFire == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemGunRapidFire(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add a save point to the map.
	 */
	public static function addSavePoint(X:Float, Y:Float):Void
	{
		Reg.state.savePoint.add(new SavePoint(X, Y));
		Reg.state.add(Reg.state.savePoint);
	}
	
	/**
	 * add a heath container to the map. collect these to increase health maximum by 3.
	 */
	public static function addHeartContainer(X:Float, Y:Float):Void
	{
		var paragraph = Reg._healthContainerCoords.split(",");
		var heartContainerFound:Bool = false;
		
		// loop through the paragraph array. if there is a match then a heart was picked up at the current map the player is at.
		for (i in 0...paragraph.length)
		{	
			if (paragraph[i] == Reg.mapXcoords + "-" + Reg.mapYcoords)
				heartContainerFound = true;
		}
		// refilling or picking up health peices increases health but cannot go beyond the maximum health total number. heart container increases the maximum health total number by 3.
		if (heartContainerFound == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemHeartContainer(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flying hat to the map. able to fly but gravity will continue to pull the player down.
	 */
	public static function addFlyingHat(X:Float, Y:Float):Void
	{
		if (Reg._itemGotFlyingHat == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemFlyingHat(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add the flying hat platform to the map. can only fly using the hat when at this platform.
	 */
	public static function addFlyingHatPlatform(X:Float, Y:Float):Void
	{
		var flyingHatPlatform:ItemFlyingHatPlatform = new ItemFlyingHatPlatform(X, Y);
		Reg.state._itemFlyingHatPlatform.add(flyingHatPlatform);
	}

	/**
	 * add the normal gun to the map.
	 */
	public static function addItemGun(X:Float, Y:Float, id:Int = 1):Void
	{
		if (Reg._itemGotGun == false)
		{
			Reg.state._itemGun.add(new ItemGun(X, Y, id));
			Reg.state.add(Reg.state._itemGun);
		}
	}

	/**
	 * add a shovel to the map. must be placed beside the grass weed and at the other side of that shovel must be an unhealthy Mala.
	 */
	public static function addNpcShovel(X:Float, Y:Float):Void
	{
		Reg.state._npcShovel.add(new NpcShovel(X, Y));
			Reg.state.add(Reg.state._npcShovel);
	}
	
	/**
	 * add the grass weed to the map. the malas beleave that the doctor needs lots of flowers from the grass weeds to cure them.
	 */
	public static function addGrassWeed(X:Float, Y:Float, id:Int):Void
	{
		Reg.state._objectGrassWeed.add(new ObjectGrassWeed(X, Y, id));
			Reg.state.add(Reg.state._objectGrassWeed);
	}
	
	/**
	 * add the watering can to the map. place the watering can next to the weed and at the other side place an unhealthy mala.
	 */
	public static function addWateringCan(X:Float, Y:Float):Void
	{
		Reg.state._npcWateringCan.add(new NpcWateringCan(X, Y));
			Reg.state.add(Reg.state._npcWateringCan);
	}
	
	/**
	 * add a ladder to the map. that ladder will not be seen so place an overlay or underlay ladder to the map on top of that ladder sprite.
	 */
	public static function addLadder(X:Float, Y:Float, id:Int):Void
	{		
		var ladder:ObjectLadder = new ObjectLadder(X, Y, id);
		Reg.state._objectLadders.add(ladder);
	}
	
	/**
	 * add a door to a house. currently, the house is a place to warp from one level to the next.
	 */
	public static function addDoorHouse(X:Float, Y:Float):Void
	{		
		var door:ObjectDoorHouse = new ObjectDoorHouse(X, Y);
		Reg.state._objectDoorToHouse.add(door);
	}
	
	/**
	 * collect treasure chest to get a bonus in score.
	 */
	public static function addTreasureChest(X:Float, Y:Float):Void
	{		
		Reg.state._objectTreasureChest = new ObjectTreasureChest(X, Y);
		Reg.state._objectLayer3OverlapOnly.add(Reg.state._objectTreasureChest);
	}
	
	/**
	 * ???
	 */
	public static function addComputer(X:Float, Y:Float):Void
	{		
		Reg.state._objectComputer = new ObjectComputer(X, Y);
		Reg.state._objectLayer3OverlapOnly.add(Reg.state._objectComputer);
	}
	
	/**
	 * add a super block to the map. these special blocks are needed to bypass an obstacle block of this type.
	 */
	public static function addItemSuperBlock(X:Float, Y:Float, id:Int):Void
	{		
		if (Reg._itemGotSuperBlock[id] == false)
		{
			var superBlock:ItemSuperBlock = new ItemSuperBlock(X, Y, id);
			Reg.state._itemsThatWerePickedUp.add(superBlock);
		}
	}	
	
	/**
	 * add a swimming skill to the map. picking up this item will enable player to swim not walk in the water.
	 */
	public static function addItemSwimmingSkill(X:Float, Y:Float):Void
	{		
		if (Reg._itemGotSwimmingSkill == false)
		{
			var swimming:ItemSwimmingSkill = new ItemSwimmingSkill(X, Y);
			Reg.state._itemsThatWerePickedUp.add(swimming);
		}
	}	
	
	/**
	 * add this item to the map. mob hit by this bullet will be frozen for a short time. at that time, player can jump on the mob.
	 */
	public static function addItemGunFreeze(X:Float, Y:Float, id:Int = 2):Void
	{
		if (Reg._itemGotGunFreeze == false)
		{
			Reg.state._itemGunFreeze.add(new ItemGun(X, Y, id));
			Reg.state.add(Reg.state._itemGunFreeze);
		}
	}
	
	/**
	 * add this flute to the map. This flute will not be visible and is handing to the player by the dog lady. Plays a melody when at a map that has a dog and a buzz sound when not.
	 */
	public static function addDogFlute(X:Float, Y:Float):Void
	{
		if (Reg._itemGotDogFlute == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemDogFlute(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	/**
	 * add a swimming skill to the map. picking up this item will enable player to swim not walk in the water.
	 */
	public static function addItemAnitgravitySuit(X:Float, Y:Float):Void
	{		
		if (Reg._itemGotAntigravitySuit == false)
		{
			Reg.state._itemsThatWerePickedUp.add(new ItemAntigravitySuit(X, Y));
			Reg.state.add(Reg.state._itemsThatWerePickedUp);
		}
	}
	
	// ################################################################
	// ####### OBJECTS
	// ################################################################
	
	/**
	 * add a spike trap the the map. one touch means big health damage.
	 */
	public static function addSpikeTrap(X:Float, Y:Float, id:Int):Void
	{
		var spikeTrap:ObjectSpikeTrap = new ObjectSpikeTrap(X, Y, id);
		Reg.state._objectsThatDoNotMove.add(spikeTrap);
	}
	
	/**
	 * add this to the map to block the player from leaving an area.
	 */
	public static function addBarricade(X:Float, Y:Float):Void
	{
		var barricade:ObjectBarricade = new ObjectBarricade(X, Y);
		Reg.state._objectsThatDoNotMove.add(barricade);
	}
	
	/**
	 * add a colored door to the map. can only be opened by the same colored key.
	 */
	public static function addDoor(X:Float, Y:Float, id):Void
	{
		// east door.
		if (X > 13)
		{
			Reg.state._objectDoor.add(new ObjectDoor(X, Y, id));
		} 
		
		// north door.
		else if(Y < 7)
		{
			Reg.state._objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		// west door.
		else if(X < 11)
		{
			Reg.state._objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		// south door.
		else if(Y > 9)
		{
			Reg.state._objectDoor.add(new ObjectDoor(X, Y, id));
		}
		
		Reg.state.add(Reg.state._objectDoor);
	}
	
	/**
	 * add a moving platform to the map.
	 */
	public static function addPlatformMoving(X:Float, Y:Float, id:Int):Void
	{
		var platform:ObjectPlatformMoving = new ObjectPlatformMoving(X, Y, id);
		Reg.state._objectPlatformMoving.add(platform);
	}
		
	/**
	 * add a fireball block to the map. the fireball will rotate around the block. 
	 */
	public static function addObjectFireballBlock(X:Float, Y:Float):Void
	{
		Reg.state._objectFireballBlock.add(new ObjectFireballBlock(X, Y));
		Reg.state.add(Reg.state._objectFireballBlock);	
		
		Reg.fireballRandom = FlxG.random.float( 0.95, 1.15);
		Reg.state._fireballPositionInDegrees = 359;			
		
		// add the four different fireball sprites at the fireball block.
		Reg.state._objectFireball.add(new ObjectFireball1(X, Y));
			Reg.state.add(Reg.state._objectFireball);
			
		Reg.state._objectFireball.add(new ObjectFireball2(X, Y));
			Reg.state.add(Reg.state._objectFireball);
			
		Reg.state._objectFireball.add(new ObjectFireball3(X, Y));
			Reg.state.add(Reg.state._objectFireball);
			
		Reg.state._objectFireball.add(new ObjectFireball4(X, Y));
			Reg.state.add(Reg.state._objectFireball);			
	}	
	
	/**
	 * add the laser beam to the map. This laser will move vertically starting from the ground then will touch the ceiling and then start over again. 
	 */
	public static function addLaserBeam(X:Float, Y:Float):Void
	{
		Reg.state._objectBeamLaser.add(new ObjectLaserBeam(X, Y));
		Reg.state.add(Reg.state._objectBeamLaser);
	}
	
	/**
	 * add the disappearing block to the map. the player must time the jump to land on this block when it is visible. 
	 */
	public static function addBlockDisappearing(X:Float, Y:Float, id:Int):Void
	{
		Reg.state._objectBlockOrRock.add( new ObjectBlockDisappearing(X, Y, id));
		Reg.state.add(Reg.state._objectBlockOrRock);
	}
	
	/**
	 * add the super block to the map. the player can only remove this block that stands in players way when player has an item of that type.
	 */
	public static function addObjectSuperBlock(X:Float, Y:Float, id:Int):Void
	{		
		var superBlock:ObjectSuperBlock = new ObjectSuperBlock(X, Y, id);
		Reg.state._objectSuperBlock.add(superBlock);
	}
	
	/**
	 * add the water current to the map. player is forced to swim in the direction of the current.
	 */
	public static function addWaterCurrent(X:Float, Y:Float, id:Int):Void
	{		
		var waterCurrent:ObjectWaterCurrent = new ObjectWaterCurrent(X, Y, id);
		Reg.state._objectWaterCurrent.add(waterCurrent);
	}
	
	/**
	 * add the moving vine to the map.
	 */	
	public static function addVineMoving(X:Float, Y:Float, id:Int):Void
	{			
		// make a random var so that each vine moves at a different speed. to be used at the vine class.
		Reg._vineMovingSpeed = FlxG.random.float(Reg._vineMovingMinimumSpeed, Reg._vineMovingMaximumSpeed);
				
		// used to make every second vine move faster than the first so that is it possible to jump from vine to vine.
		if (Reg._vineToggleMovementSpeed == false) Reg._vineToggleMovementSpeed = true;
			else {Reg._vineToggleMovementSpeed = false; Reg._vineMovingSpeed = Reg._vineMovingSpeed * 1.2;}
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y, 1);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 10, 2);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 10, 3);
		Reg.state.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 4);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 5);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 6);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 7);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 8);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 9);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving = new ObjectVineMoving(X, Y = Y + 8, 10);
		Reg.state._objectVineMoving.add(vine);
		
		var vine:ObjectVineMoving2 = new ObjectVineMoving2(X, Y = Y + 7, 11);
		Reg.state._objectVineMoving.add(vine);
		
	}

	/**
	 * add the cannon that fires a cannon ball to the map.
	 */	
	public static function addCannon(X:Float, Y:Float, id:Int):Void
	{
		var cannon:ObjectCannon = new ObjectCannon(X, Y, id, Reg.state._bulletsObject, Reg.state._emitterBulletHit, Reg.state._emitterBulletMiss);
		Reg.state._objectsThatDoNotMove.add(cannon);
	}
	
	/**
	 * add the cracked block that can only be destroyed by the normal gun
	 */	
	public static function addBlockedCracked(X:Float, Y:Float):Void
	{
		var blockCracked:ObjectBlockCracked = new ObjectBlockCracked(X, Y, Reg.state._emitterBulletFlame, Reg.state._emitterDeath, Reg.state._emitterBulletHit);
		Reg.state._objectBlockOrRock.add(blockCracked);
	}

	/**
	 * add the sign to the map that has readable information.
	 */	
	public static function addSign(X:Float, Y:Float, id:Int):Void
	{
		var sign:ObjectSign = new ObjectSign(X, Y, id);
		Reg.state._objectSign.add(sign);
	}
	
	/**
	 * add the different rocks to the map.
	 */	
	public static function addRock(X:Float, Y:Float, id:Int):Void
	{
		Reg.state._objectBlockOrRock.add( new ObjectRock(X, Y, id));
		Reg.state.add(Reg.state._objectBlockOrRock);
	}
	
	/**
	 * add a teleporter to the map. used to teleport to a different level. needs a different key to activate a new level to teleport to.
	 */	
	public static function addTeleporter(X:Float, Y:Float):Void
	{
		Reg.state._objectTeleporter.add( new ObjectTeleporter(X, Y));
		Reg.state.add(Reg.state._objectTeleporter);
	}
	
	/**
	 * add a spike that hangs from the ceiling and falls when the player is vertically close to the spike.
	 */	
	public static function addSpikeFalling(X:Float, Y:Float):Void
	{
		Reg.state._objectsThatMove.add( new ObjectSpikeFalling(X, Y));
		Reg.state.add(Reg.state._objectsThatMove);
	}
	
	
	public static function addJumpingPad(X:Float, Y:Float, id:Int):Void
	{
		Reg.state._jumpingPad.add( new ObjectJumpingPad(X, Y, id));
		Reg.state.add(Reg.state._jumpingPad);
	}
	/**
	 * add a mala cage to the map. malas placed at the bottom of the cage will appear to be inside the cage with game is played.
	 */	
	public static function addCage(X:Float, Y:Float, id:Int):Void
	{
		var cage:ObjectCage = new ObjectCage(X, Y, id);
		Reg.state._objectCage.add(cage);
	}
	
	/**
	 * add a lava block to the map. every once in awhile damage will be given to the mob or player that touches this block.
	 */
	public static function addLavaBlock(X:Float, Y:Float):Void
	{
		Reg.state._objectLavaBlock.add( new ObjectLavaBlock(X, Y));
		Reg.state.add(Reg.state._objectLavaBlock);
	}

	/**
	 * add a quick sand block to the map. player slowly enters the sand player needs to jump.
	 */
	public static function addQuickSand(X:Float, Y:Float):Void
	{
		Reg.state._objectQuickSand.add( new ObjectQuickSand(X, Y));
		Reg.state.add(Reg.state._objectQuickSand);
	}
	
	/**
	 * add a tube to the map. a monster exits this tube then flies towards the player.
	 */
	public static function addTube(X:Float, Y:Float):Void
	{
		var tube:ObjectTube = new ObjectTube(X, Y);
		Reg.state._objectTube.add(tube); 
	}
	
	// ###############################################################
	// ADD OVERLAYS
	// ###############################################################
	
	/**
	 * add a water wave to the map. a water wave if tghe surface of the water.
	 */
	public static function addWave(X:Float, Y:Float):Void
	{
		var wave:OverlayWave = new OverlayWave(X, Y);
		Reg.state._overlayWave.add(wave);
	}
	
	/**
	 * add the body of the water to the map. this is water, deep water, ect.
	 */
	public static function addWater(X:Float, Y:Float):Void
	{
		var water:OverlayWater = new OverlayWater(X, Y);
		Reg.state._overlayWater.add(water);
	}
	
	/**
	 * add a water parameter to the map. must be place above the water wave so that game knowns when water is entered or exited.
	 */
	public static function addWaterParameter(X:Float, Y:Float):Void
	{
		var waterParameter:ObjectWaterParameter = new ObjectWaterParameter(X, Y);
		Reg.state._objectWaterParameter.add(waterParameter);
	}
	
	/**
	 * add the air bubble to the map. player is able to breath underwater at an air bubble location.
	 */
	public static function addAirBubble(X:Float, Y:Float):Void
	{
		var airBubble:OverlayAirBubble = new OverlayAirBubble(X, Y);
		Reg.state._overlayAirBubble.add(airBubble);
		
		Reg.state._emitterAirBubble.focusOn(airBubble);
		Reg.state._emitterAirBubble.start(false, 0.05, 0);
	}
	
	/**
	 * add a laser block to the map. ../readme dev/README FIRST.txt for more information.
	 */
	public static function addLaserBlock(X:Float, Y:Float, id:Int):Void
	{
		var laser:OverlayLaserBlocks = new OverlayLaserBlocks(X, Y, id);
		// the yellow overlay block used for the laser is in a different group than the orange laser block. the reason is that this stops a mob from waiting for the laser to not be in its current path when standing near the brown block. 
		if (id == 1) Reg.state._overlayLaserBeam.add(laser);
		else Reg.state._overlaysThatDoNotMove.add(laser);		
	}
	
	/**
	 * add a laser parameter to the map. ../readme dev/README FIRST.txt for more information.
	 */
	public static function addLaserParameter(X:Float, Y:Float):Void
	{
		var laserParameter:ObjectLaserParameter = new ObjectLaserParameter(X, Y);
		Reg.state._objectLaserParameter.add(laserParameter);
	}
	
	/**
	 * add a pipe1 segment to the map.
	 */
	public static function addPipe1(X:Float, Y:Float, id:Int):Void
	{
		var pipe:OverlayPipe1 = new OverlayPipe1(X, Y, id);
		Reg.state._overlayPipe.add(pipe);
	}
	
	/**
	 * add a pipe2 segment to the map.
	 */
	public static function addPipe2(X:Float, Y:Float, id:Int):Void
	{
		var pipe:OverlayPipe2 = new OverlayPipe2(X, Y, id);
		Reg.state._overlayPipe.add(pipe);
	}
	
	/**
	 * add a platform parameter to the map. a moving platform will change direction when touching a wall or this object.
	 */
	public static function addPlatformParameter(X:Float, Y:Float):Void
	{
		var platformParameter:ObjectPlatformParameter = new ObjectPlatformParameter(X, Y);
		Reg.state._objectPlatformParameter.add(platformParameter);
	}

}
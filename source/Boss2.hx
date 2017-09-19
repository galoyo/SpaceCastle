package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class Boss2 extends EnemyChildClass 
{	
	private var _bulletTimeForNextFiring:Float; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = 2; // -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.	
	public var defaultHealth1:Int = 18;
	private var _displayNextDialog:Bool = false;
	private var _dialogDisplayIt:Bool = false; // used to display a dialog only once. 
	// how fast the object can fall.
	var gravity:Int = 1800;
	private var _YjumpingDelay:Float = 100;
	
	// this value is needed to that a mob can walk up a high slope.
	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;	
	
	private var ticksRun:Float = 0; // used to give time to run from the mala before mala turns into a mob.
	private var ticksBoss:Float = 0; // used to delay changing to a different mob ability.
		
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 70; // total air in mob without air items.
	public var _airLeftInLungsMaximum:Int = 70; // this var is used to reset _airLeftInLungs when jumping out of the water.
	
	private var maxSpeed:Int = 330;
	private var ra:Int; // used to store a random value;
	
	private var _xRandomMinimumHorizontalHoverPosition:Float; // the random minimum and maximum horizontal x positions when hovering.
	private var _xRandomMaximumHorizontalHoverPosition:Float;

	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, emitterSmokeRight:FlxEmitter, emitterSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, emitterBulletHit:FlxEmitter, emitterBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, emitterSmokeRight, emitterSmokeLeft, bulletsMob, emitterBulletHit, emitterBulletMiss);
	
		loadGraphic("assets/images/boss2.png", true, 28, 28);
		animation.add("fly", [0, 1, 2, 3], 15);		
		animation.add("walking", [0, 1, 2, 1, 0, 1, 2, 1], 24);
		animation.add("jumping", [0, 2, 1]);
		animation.add("landing", [0, 1, 2, 1, 0, 1, 2, 1], 8, false);	
		animation.add("standing", [0, 1], 3);
		
		pixelPerfectPosition = false;		
		
		_xRandomMinimumHorizontalHoverPosition = _startX - 200;
		_xRandomMaximumHorizontalHoverPosition = _startX + 200;
		
		properties();
	}
	
	public function properties():Void 
	{				
		alive = true;
		angle = 0;
		_mobIsSwimming = false;
		visible = true;		
		
		// bullet.
		_bulletSpeed = 450;
		_bulletTimeForNextFiring = FlxG.random.float(0.32, 0.45);
		_cooldown = FlxG.random.float(0.40, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
		
		health = defaultHealth1 * Reg._differcuityLevel;
		Reg.displayDialogYesNo = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (alive == true)
		{
			//############### PLAYER CHATS WITH MOB ###############
			if(Reg.mapXcoords == 15 && Reg.mapYcoords == 15 && _displayNextDialog == true && Reg._playerHasTalkedToThisMob == true && Reg._dialogAnsweredYes == false && _dialogDisplayIt == false)	
			{
				Reg.dialogIconText = openfl.Assets.getText("assets/text/boss2-ID1-Map15-15B.txt").split("#");								
					
				Reg.dialogCharacterTalk[0] = "talkBoss2.png";
					
				Reg.displayDialogYesNo = true;
				Reg.state.openSubState(new Dialog());					
			}
			
			else if (InputControls.down.justReleased && Reg._playerHasTalkedToThisMob == false && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "";
				
				if (Reg.mapXcoords == 15 && Reg.mapYcoords == 15 && Reg.displayDialogYesNo == false && _displayNextDialog == false)	
				{
					
					_dialogDisplayIt = false;
					Reg.dialogIconText = openfl.Assets.getText("assets/text/boss2-ID1-Map15-15.txt").split("#");								
						
					Reg.dialogCharacterTalk[0] = "talkBoss2.png";								
					Reg.displayDialogYesNo = false;
					Reg.state.openSubState(new Dialog());
					Reg._playerHasTalkedToThisMob = true;
					Reg._boss2IsMala = true;
					_displayNextDialog = true;					
				} 				
			}		
			
			if (Reg.displayDialogYesNo == true && Reg._dialogYesNoWasAnswered == true && Reg._dialogAnsweredYes == false && _dialogDisplayIt == false && overlapsAt(x, y, Reg.state.player))
			{						
				Reg.dialogIconText = openfl.Assets.getText("assets/text/boss2-ID1-Map15-15No.txt").split("#");
					
				Reg.dialogCharacterTalk[0] = "talkBoss2.png";	
				Reg.state.openSubState(new Dialog());
				_dialogDisplayIt = true;
				Reg._dialogAnsweredYes = false;
				Reg.displayDialogYesNo = false;				
				Reg._dialogYesNoWasAnswered = true;				
				
				properties();
			}	
				
			if(Reg._playerHasTalkedToThisMob == true)
			{
				animation.play("fly");
				if(ticksBoss == 0)
				{
					playBossMusic();
					FlxSpriteUtil.stopFlickering(Reg.state.player);
				}
				
				if (inRange(_range))
				{							
					if (justTouched(FlxObject.FLOOR)) 
					{
						if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
						inAir = false;
					} 
					else if(!isTouching(FlxObject.FLOOR)) inAir = true;
					
					// follow player.
					if (ticksBoss > 0 && ticksBoss <= 80)
					{						
						seekPlayerAfterTouchingTile(Std.int(maxSpeed / 2), _mobIsSwimming);
					}
					else if (ticksBoss >= 80 && ticksBoss <= 130)
					{
						// bullet
						_bulletFireFormation = 0;
						_cooldown += elapsed;
						Reg._bulletSize = 0;
						shoot();
					} 
					else
					{
						// stand still and fire bullets at player.
						this.alpha = 1; // display boss in case this boss is invisible.
							
						// display the boss somewhere on the horizontal plane.
						if (ticksBoss == 150 || ticksBoss == 180 || ticksBoss == 210)
						{
							x = FlxG.random.float(_xRandomMinimumHorizontalHoverPosition, _xRandomMaximumHorizontalHoverPosition);
							y = _startY - 198;
						}
						
						// stand still.
						velocity.x = velocity.y = 0;
						
						// bullet
						_bulletFireFormation = 2;
						_cooldown += elapsed;
						Reg._bulletSize = 0;
						shoot();
					}
						
					ticksBoss = Reg.incrementTicks(ticksBoss, 60 / Reg._framerate);
					if (ticksBoss > 230) ticksBoss = 1;
					
					// after the conversation, delay the boss from attacking the player.
					if (ticksRun >= 30) {Reg._boss2IsMala = false; ticksRun = 30;}
					ticksRun = Reg.incrementTicks(ticksRun, 60 / Reg._framerate);
				} 
				
				if (inRange(_range))
				{
					// rotate mob when not alive.
					if (!alive) angle += Reg._angleDefault;									
				}
				
				if ( health <= 1 * Reg._gunPower)
				{						
					Reg._boss2Defeated = true; 
					Reg._boss2IsMala = true;
							
					// remove block barrier so that plater can get item.
					var newindex:Int = 193;
					for (j in 0...Reg.state.tilemap.heightInTiles)
					{
						for (i in 0...Reg.state.tilemap.widthInTiles - 1)
						{
							if (Reg.state.tilemap.getTile(i, j) == 177)
							{
								Reg.state.tilemap.setTile(i, j, newindex, true);
							}	
						}		
					}
							
					alive = false;
					Reg._dialogYesNoWasAnswered = false;
					Reg._playerHasTalkedToThisMob = false;
					PlayStateMiscellaneous.playMusic(); // back to the normal stage music because boss was defeated
					kill();
				}
			}
		}
		
		super.update(elapsed);
		
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
}
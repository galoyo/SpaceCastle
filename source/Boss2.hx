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

class Boss2 extends EnemyParentClass 
{	
	/*******************************************************************************************************
	 * Time it takes for this mob to fire another bullet.
	 */
	private var _bulletTimeForNextFiring:Float =  1;
	
	/*******************************************************************************************************
	 * -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	 */
	private var _bulletFormationNumber:Int = 2; 
	
	/*******************************************************************************************************
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth1:Int = 18;
	
	/*******************************************************************************************************
	 * Used to display the next dialog.
	 */
	private var _displayNextDialog:Bool = false;
	
	/*******************************************************************************************************
	 * Used to display a dialog only once. 
	 */
	private var _dialogDisplayIt:Bool = false;
	
	/*******************************************************************************************************
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/*******************************************************************************************************
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;	
	
	/*******************************************************************************************************
	 * This var is used to give the player some time to run away from the mala before mala turns into a mob.
	 */
	private var ticksRun:Float = 0;
	
	/*******************************************************************************************************
	 * Mob will do a different fighting tactic when this tick is a certain value.
	 */
	private var ticksBoss:Float = 0;
		
	/*******************************************************************************************************
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Int = 0; 
	
	/*******************************************************************************************************
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 70;
	
	/*******************************************************************************************************
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 70; 
	
	/*******************************************************************************************************
	 * The X and/or Y velocity of this mob. Must be in integers of 32.
	 */
	private var maxSpeed:Int = 320;
	
	/*******************************************************************************************************
	 * This mob will disappear from somewhere close to the player and then will reappear somewhere on an invisible horizontal line above the player and will shoot bullets at that time. This val refers to the minimum X position of the mob on that line. 
	 */
	private var _xRandomMinimumHorizontalHoverPosition:Float = 0;
	
	/*******************************************************************************************************
	 * The maximum X position of the mob. 
	 */
	private var _xRandomMaximumHorizontalHoverPosition:Float = 0;

	public function new(x:Float, y:Float, player:Player, emitterMobsDamage:FlxEmitter, emitterDeath:FlxEmitter, emitterItemTriangle:FlxEmitter, emitterItemDiamond:FlxEmitter, emitterItemPowerUp:FlxEmitter, emitterItemNugget:FlxEmitter, emitterItemHeart:FlxEmitter, particleSmokeRight:FlxEmitter, particleSmokeLeft:FlxEmitter, bulletsMob:FlxTypedGroup<BulletMob>, particleBulletHit:FlxEmitter, particleBulletMiss:FlxEmitter) 
	{
		super(x, y, player, emitterMobsDamage, emitterDeath, emitterItemTriangle, emitterItemDiamond, emitterItemPowerUp, emitterItemNugget, emitterItemHeart, particleSmokeRight, particleSmokeLeft, bulletsMob, particleBulletHit, particleBulletMiss);
	
		loadGraphic("assets/images/boss2.png", true, 28, 28);
		animation.add("fly", [0, 1, 0, 2], 27);		
		
		pixelPerfectPosition = false;		
		
		_xRandomMinimumHorizontalHoverPosition = _startX - 200;
		_xRandomMaximumHorizontalHoverPosition = _startX + 200;
		
		properties();
	}
	
	public function properties():Void 
	{				
		alive = true;
		angle = 0;
		_mobInWater = false;
		visible = true;		
		
		// bullet.
		_bulletSpeed = 450;
		_bulletTimeForNextFiring = FlxG.random.float(0.32, 0.45);
		_cooldown = FlxG.random.float(0.40, 0.60);		
		_gunDelay = _bulletTimeForNextFiring;	// Initialize the cooldown so that we can shoot right away.
		_bulletFireFormation = _bulletFormationNumber;	
		
		health = defaultHealth1 * Reg._difficultyLevel;
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
			
			else if (InputControls.down.justPressed && Reg._keyOrButtonDown == false && Reg._playerHasTalkedToThisMob == false && overlapsAt(x, y, Reg.state.player))
			{
				Reg._keyOrButtonDown = true;
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
			
			if (InputControls.down.justReleased && Reg._keyOrButtonDown == true)
			{
				Reg._keyOrButtonDown = false;
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
						_inAir = false;
					} 
					else if(!isTouching(FlxObject.FLOOR)) _inAir = true;
					
					// follow player.
					if (ticksBoss > 0 && ticksBoss <= 80)
					{						
						seekPlayerAfterTouchingTile(Std.int(maxSpeed / 2), _mobInWater);
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
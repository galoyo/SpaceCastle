package ;
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

class NpcDoctor extends FlxSprite
{
	/**
	 * Time it takes for this mob to fire another bullet.
	 */
	private var _bulletTimeForNextFiring:Float = 1;
	
	/**
	 * -1 disabled, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of a clock. 5 = 20 and 40 minutes of a clock.
	 */
	private var _bulletFormationNumber:Int = -1;
	
	/**
	 * This is the default health when mob is first displayed or reset on a map.
	 */
	public var defaultHealth1:Int = 1;

	/**
	 * The X velocity of this mob. 
	 */
	private var maxXSpeed:Int = 300;
	
	/**
	 * How fast the object can fall. 4000 is a medimum speed fall while 10000 is a fast fall.
	 */
	private var _gravity:Int = 4400;	

	/**
	 * If true then this mob is not touching a tile.
	 */
	public var _inAir:Bool = false;
	
	/**
	 * This mob may either be swimming or walking in the water. In elther case, if this value is true then this mob is in the water.
	 */
	public var _mobInWater:Bool = false;

	private var ticks:Int = 0;
	
	/**
	 * Used to delay the decreasing of the _airLeftInLungs value.
	 */
	public var airTimerTicks:Int = 0; 
	
	/**
	 * A value of zero will equal unlimited air. This value must be the same as the value of the _airLeftInLungsMaximum var. This var will decrease in value when mob is in water. This mob will stay alive only when this value is greater than zero.
	 */
	public var _airLeftInLungs:Int = 100;
	
	/**
	 * This var is used to set the _airLeftInLungs back to default value when mob jumps out of the water.
	 */
	public var _airLeftInLungsMaximum:Int = 100; 
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// set to false if sprite has no animation frames.
		loadGraphic("assets/images/doctor.png", true, Reg._tileSize, 60);
		
		animation.add("idle", [0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 1, 2, 3, 4], 12);
		animation.play("idle");	

		pixelPerfectPosition = false;
		
		Reg.displayDialogYesNo = false;
		Reg._dialogYesNoWasAnswered = false;
		Reg._dialogAnsweredYes = false;
		Reg._talkedToDoctorNearDogLady = false;
		
		properties(); // gravity, direction facing, is alive, ect and health vars.		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if(isOnScreen())
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
			InputControls.checkInput();
		
			if (justTouched(FlxObject.FLOOR)) 
			{
				if (Reg._soundEnabled == true) FlxG.sound.play("switch", 1, false);
				_inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) _inAir = true;			
				
			if( InputControls.down.justPressed && Reg.mapXcoords == 13 && Reg.mapYcoords == 15 && overlapsAt(x, y, Reg.state.player))
			{
				Reg.dialogIconFilename = "";
				Reg.dialogIconText = openfl.Assets.getText("assets/text/Map13-15-doctor.txt").split("#");
				
				Reg.dialogCharacterTalk[0] = "talkDoctor.png";
				Reg.displayDialogYesNo = false;
				Reg.state.openSubState(new Dialog());				
				
				ticks = 5;
			}
		
			if (Reg.displayDialogYesNo == true && Reg._dialogYesNoWasAnswered == true && Reg._dialogAnsweredYes == false && overlapsAt(x, y, Reg.state.player))
			{						
				ticks = 10;
				Reg._talkedToDoctorNearDogLady = true; // used to move the player to the waiting room.
			}
			
			if (ticks == 6  && overlapsAt(x, y, Reg.state.player))
			{						
				Reg.dialogIconText = openfl.Assets.getText("assets/text/Map13-15B-doctor.txt").split("#");
				
				Reg.dialogCharacterTalk[0] = "talkDoctor.png";	
				Reg.displayDialogYesNo = true;		
				Reg.state.openSubState(new Dialog());
			}
			if (ticks == 5 ) ticks = 6;


			if (Reg.displayDialogYesNo == true && Reg._dialogYesNoWasAnswered == true && Reg._dialogAnsweredYes == true && overlapsAt(x, y, Reg.state.player))
			{						
				Reg.dialogIconText = openfl.Assets.getText("assets/text/Map13-15-doctor.txt").split("#");
				
				Reg.dialogCharacterTalk[0] = "talkDoctor.png";	
				Reg.displayDialogYesNo = false;				
				Reg._dialogAnsweredYes = false;
				Reg._dialogYesNoWasAnswered = false;
				Reg.state.openSubState(new Dialog());
				ticks = 5;
			}	

		} 
		
		if (isOnScreen())
		{
			// rotate mob when not alive.
			if (!alive) angle += Reg._angleDefault;
		
			super.update(elapsed);
		}
		
		// delete the enemy when at the bottom of screen.
		if (y > Reg.state.tilemap.height) super.kill();
	}
	
	override public function reset(xx:Float, yy:Float):Void 
	{		
		super.reset(x, y);
		properties();
		
		FlxSpriteUtil.flicker(this, Reg._mobResetFlicker, 0.02, true);
	}	
	
	public function properties():Void 
	{
		alive = true;		
		angle = 0;
		health = defaultHealth1;
		visible = true;
		velocity.x = velocity.y = 0;
		acceleration.y = _gravity;	
	}
}
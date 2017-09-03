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
	private var _bulletTimeForNextFiring:Float = 1; // time it takes to display another bullet.
	private var _bulletFormationNumber:Int = -1; // -1 disable, 0 = fire left/right, 1 = up/down. 2 = up/down/left/right. 3 = all four angles. 4 = every 10 minutes of the clock.
	
	// used with jumping ability.
	private var _YjumpingDelay:Float = 100;
	
	public var defaultHealth1:Int = 1;
	private var maxXSpeed:Int = 300;
	private var maxSpeed:Int = 250;	
	
	// how fast the object can fall.
	var _gravity:Int = 4400;	

	public var inAir:Bool = false;
	public var _mobIsSwimming:Bool = false;

	private var ticks:Int = 0;
	
	// used to delay the decreasing of the _airLeftInLungs var.
	public var airTimerTicks:Int = 0; 
	public var _airLeftInLungs:Int = 100; // total air in mob without air items.
	// this value must be higher that the _areLeftInLungs var. this value can be any value. the higher the value the longer the mob can stay in the water. 100 = player. most mobs are around 40 - 70 but can have a value of about 200. 
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
		Reg._talkedToDoctorAtDogLady = false;
		
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
				inAir = false;
			} 
			else if (!isTouching(FlxObject.FLOOR)) inAir = true;			
				
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
				Reg._talkedToDoctorAtDogLady = true; // used to move the player to the waiting room.
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
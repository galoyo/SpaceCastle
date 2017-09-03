package;

#if FLX_NO_KEYBOARD
	import flixel.ui.FlxVirtualPad;
#else
	import flixel.input.keyboard.FlxKey;
#end

#if FLX_NO_KEYBOARD
public static var virtualPad:FlxVirtualPad;
#end

/**
 * @author galoyo
 */

override public function create():Void
{

	#if FLX_NO_KEYBOARD
		virtualPad = new FlxVirtualPad(); // MUST BE BEFORE PLAYER IS CREATED!!
	#end
	
	// other add code. you want the virtualPad last so it's on top
	
	#if FLX_NO_KEYBOARD
		add(virtualPad);
	#end
	
	super.create();
}

/////////////////////////////////////////////////
//Player.hx 

#if FLX_NO_KEYBOARD
import flixel.ui.FlxVirtualPad;
#else
import flixel.input.keyboard.FlxKey;
#end

private var _leftPressed:Bool = false;
private var _rightPressed:Bool = false;
private var _upPressed:Bool = false;
private var _downPressed:Bool = false;
private var _jumpPressed:Bool = false;
private var _jumpJustPressed:Bool = false;
private var _jumpJustReleased:Bool = false;
private var _shootPressed:Bool = false;
private var _shootJustPressed:Bool = false;
private var _shootJustReleased:Bool = false;

#if FLX_NO_KEYBOARD
private var _virtualPad:FlxVirtualPad;
#else
private var _leftKeys:Array<FlxKey>	 = [A, LEFT];
private var _rightKeys:Array<FlxKey> = [D, RIGHT];
private var _upKeys:Array<FlxKey> 	 = [W, UP];
private var _downKeys:Array<FlxKey>  = [S, DOWN];
private var _jumpKeys:Array<FlxKey>  = [C, K, SPACE];
private var _shootKeys:Array<FlxKey> = [J, X];
#end

public function new(x:Int, y:Int, bullets:FlxTypedGroup<Bullet>, star:FlxEmitter)
{
	super(x, y);
	
	_bullets = bullets;
	_star = star;

#if FLX_NO_KEYBOARD
	_virtualPad = PlayState.virtualPad;
#end
}
	
private function checkInput():Void
{
	_leftPressed		= false;
	_rightPressed		= false;
	_upPressed			= false;
	_downPressed		= false;
	_jumpPressed		= false;
	_jumpJustPressed	= false;
	_jumpJustReleased	= false;
	_shootPressed		= false;
	_shootJustPressed	= false;
	_shootJustReleased	= false;
	
#if !FLX_NO_KEYBOARD
	_leftPressed		= FlxG.keys.anyPressed(_leftKeys);
	_rightPressed		= FlxG.keys.anyPressed(_rightKeys);
	_upPressed			= FlxG.keys.anyPressed(_upKeys);
	_downPressed		= FlxG.keys.anyPressed(_downKeys);
	_jumpPressed		= FlxG.keys.anyPressed(_jumpKeys);
	_jumpJustPressed	= FlxG.keys.anyJustPressed(_jumpKeys);
	_jumpJustReleased	= FlxG.keys.anyJustReleased(_jumpKeys);
	_shootPressed		= FlxG.keys.anyPressed(_shootKeys);
	_shootJustPressed	= FlxG.keys.anyJustPressed(_shootKeys);
	_shootJustReleased	= FlxG.keys.anyJustReleased(_shootKeys);
#else	
	_jumpJustPressed  	= _jumpJustPressed	 || _virtualPad.buttonA.justPressed;
	_jumpJustReleased  	= _jumpJustReleased	 || _virtualPad.buttonA.justReleased;
	_shootJustPressed 	= _shootJustPressed	 || _virtualPad.buttonB.justPressed;
	_shootJustReleased 	= _shootJustReleased || _virtualPad.buttonB.justReleased;
	_leftPressed 	 	= (_leftPressed		 || _virtualPad.buttonLeft.pressed)  && (!_virtualPad.buttonLeft.justPressed  || !_virtualPad.buttonLeft.justReleased);
	_rightPressed		= (_rightPressed	 || _virtualPad.buttonRight.pressed) && (!_virtualPad.buttonRight.justPressed || !_virtualPad.buttonRight.justReleased);
	_jumpPressed  		= (_jumpPressed		 || _virtualPad.buttonA.pressed   	 && (!_jumpJustPressed  || !_jumpJustReleased));
	_shootPressed 		= (_shootPressed	 || _virtualPad.buttonB.pressed 	 && (!_shootJustPressed || !_shootJustReleased));
#end
}
	
public override function update(elapsed:Float):Void
{	
	// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
	InputControls.checkInput();
	
	// shoot key or vpad shoot button pressed
	if (_shootPressed)
		shoot();
	
	super.update(elapsed);
}

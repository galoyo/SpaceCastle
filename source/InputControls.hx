package;
import flixel.FlxG;

#if !FLX_NO_KEYBOARD 
	import flixel.input.keyboard.FlxKey;
#end

/**
 * ...
 * @author galoyo
 */
class InputControls
{
	public static var  left:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var right:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var    up:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var  down:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var     z:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var     x:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var 	  c:IState = { justPressed:false, pressed:false, justReleased:false };
	public static var 	  i:IState = { justPressed:false, pressed:false, justReleased:false };

#if !FLX_NO_KEYBOARD	
	public static var _leftKeys:Array<FlxKey>  = [A, LEFT];
	public static var _rightKeys:Array<FlxKey> = [D, RIGHT];
	public static var _upKeys:Array<FlxKey>    = [W, UP];
	public static var _downKeys:Array<FlxKey>  = [S, DOWN];
	public static var _zKeys:Array<FlxKey>     = [Z];
	public static var _xKeys:Array<FlxKey>     = [X];
	public static var _cKeys:Array<FlxKey>	   = [C];
	public static var _iKeys:Array<FlxKey>	   = [I];
#end

	public static function checkInput():Void
	{
		#if FLX_NO_KEYBOARD
			if (Reg.state._buttonsNavigation.buttonLeft.exists)
			{
				left.justPressed  = Reg.state._buttonsNavigation.buttonLeft.justPressed;
				left.pressed      = Reg.state._buttonsNavigation.buttonLeft.pressed;
				left.justReleased = Reg.state._buttonsNavigation.buttonLeft.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonRight.exists)
			{
				right.justPressed  = Reg.state._buttonsNavigation.buttonRight.justPressed;
				right.pressed      = Reg.state._buttonsNavigation.buttonRight.pressed;
				right.justReleased = Reg.state._buttonsNavigation.buttonRight.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonUp.exists)
			{
				up.justPressed  = Reg.state._buttonsNavigation.buttonUp.justPressed;
				up.pressed      = Reg.state._buttonsNavigation.buttonUp.pressed;
				up.justReleased = Reg.state._buttonsNavigation.buttonUp.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonDown.exists)
			{
				down.justPressed  = Reg.state._buttonsNavigation.buttonDown.justPressed;
				down.pressed      = Reg.state._buttonsNavigation.buttonDown.pressed;
				down.justReleased = Reg.state._buttonsNavigation.buttonDown.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonZ.exists)
			{
				z.justPressed  = Reg.state._buttonsNavigation.buttonZ.justPressed;
				z.pressed      = Reg.state._buttonsNavigation.buttonZ.pressed;
				z.justReleased = Reg.state._buttonsNavigation.buttonZ.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonX.exists)
			{
				x.justPressed  = Reg.state._buttonsNavigation.buttonX.justPressed;
				x.pressed      = Reg.state._buttonsNavigation.buttonX.pressed;
				x.justReleased = Reg.state._buttonsNavigation.buttonX.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonC.exists)
			{
				c.justPressed  = Reg.state._buttonsNavigation.buttonC.justPressed;
				c.pressed      = Reg.state._buttonsNavigation.buttonC.pressed;
				c.justReleased = Reg.state._buttonsNavigation.buttonC.justReleased;
			}
			
			if (Reg.state._buttonsNavigation.buttonI.exists)
			{
				i.justPressed  = Reg.state._buttonsNavigation.buttonI.justPressed;
				i.pressed      = Reg.state._buttonsNavigation.buttonI.pressed;
				i.justReleased = Reg.state._buttonsNavigation.buttonI.justReleased;
			}
			
		#else
			left.justPressed   = FlxG.keys.anyJustPressed(_leftKeys);
			left.pressed       = FlxG.keys.anyPressed(_leftKeys);
			left.justReleased  = FlxG.keys.anyJustReleased(_leftKeys);
			
			right.justPressed  = FlxG.keys.anyJustPressed(_rightKeys);
			right.pressed      = FlxG.keys.anyPressed(_rightKeys);
			right.justReleased = FlxG.keys.anyJustReleased(_rightKeys);
			
			down.justPressed   = FlxG.keys.anyJustPressed(_downKeys);
			down.pressed       = FlxG.keys.anyPressed(_downKeys);
			down.justReleased  = FlxG.keys.anyJustReleased(_downKeys);
			
			up.justPressed     = FlxG.keys.anyJustPressed(_upKeys);
			up.pressed         = FlxG.keys.anyPressed(_upKeys);
			up.justReleased    = FlxG.keys.anyJustReleased(_upKeys);
			
			z.justPressed      = FlxG.keys.anyJustPressed(_zKeys);
			z.pressed          = FlxG.keys.anyPressed(_zKeys);
			z.justReleased     = FlxG.keys.anyJustReleased(_zKeys);
			
			x.justPressed      = FlxG.keys.anyJustPressed(_xKeys);
			x.pressed          = FlxG.keys.anyPressed(_xKeys);
			x.justReleased     = FlxG.keys.anyJustReleased(_xKeys);
			
			c.justPressed   = FlxG.keys.anyJustPressed(_cKeys);
			c.pressed       = FlxG.keys.anyPressed(_cKeys);
			c.justReleased  = FlxG.keys.anyJustReleased(_cKeys);		
			
			i.justPressed   = FlxG.keys.anyJustPressed(_iKeys);
			i.pressed       = FlxG.keys.anyPressed(_iKeys);
			i.justReleased  = FlxG.keys.anyJustReleased(_iKeys);	

		#end
	}
}
	
typedef IState = { justPressed:Bool, pressed:Bool, justReleased:Bool }


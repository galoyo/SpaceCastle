package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class Instructions extends FlxSubState
{	
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var title:FlxText;
	
	/*******************************************************************************************************
	 * Clicking this button will send you to the main menu.
	 */
	private var OKbutton:Button;
	
	public function new():Void
	{
		super();
		
		var background = new FlxSprite(0, 0, "assets/images/backgroundSubState1.jpg");
		background.scrollFactor.set(0, 0);	
		add(background);
		
		title = new FlxText(0, 50, 0, "Instructions");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.BLUE);
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 1);
		title.scrollFactor.set();
		title.setPosition(0, 50);
		title.screenCenter(X);
		add(title);
		
		text(50, 125, "LEFT / RIGHT arrow keys moves player.");
		text(50, 150, "DOWN arrow key: interact with objects such as characters, doors and dialogs.");
		text(50, 175, "i: Access the inventory.");
		text(50, 200, "z, x, c: Action key for an item. Confirm.");
		text(50, 225, "m: Main menu.");
		text(50, 250, "F12: Toggles full screen mode.");
		
		OKbutton = new Button(180, 300, "z: Back.", 160, 35, null, 16, 0xFFCCFF33, 0, OKbuttonClicked);	
		OKbutton.screenCenter(X);
		OKbutton.label.font = Reg.defaultFont;
		add(OKbutton);
	}
	
	/**
	 * @param	_width	Width location of text on screen.
	 * @param	_height	Height location of text on screen.
	 * @param	_text	The text to place on screen.
	 */
	private function text(_width:Int, _height:Int, _text:String):Void
	{
		var _t:FlxText;
		_t = new FlxText(_width, _height, 0, _text);
		_t.setFormat(Reg.defaultFont, 14, FlxColor.BLACK);
		_t.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.LIME, 1);
		_t.scrollFactor.set();
		add(_t);
	}
	
	override public function update(elapsed:Float):Void 
	{				
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustReleased(["F12"])) 
			{
				Reg._stopDemoFromPlaying = true;
				FlxG.fullscreen = !FlxG.fullscreen; // toggles fullscreen mode.
			}
			
			if (FlxG.keys.anyJustPressed(["Z"]))
			{
				Reg._stopDemoFromPlaying = false;
				OKbuttonClicked();
			}
		#end
		
		super.update(elapsed);
	}	
	
	private function OKbuttonClicked():Void
	{
		Reg._stopDemoFromPlaying = false;
		Reg.playTwinkle();		
	
		new FlxTimer().start(0.15, delayChangeState,1);

	}
	
	private function delayChangeState(Timer:FlxTimer):Void
	{
		FlxG.switchState(new MenuState());
	}
}
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
	 * Used so that this subState does not start with a transparent background.
	 */
	private var screenBox:FlxSprite;
	
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
		
		screenBox = new FlxSprite(10, 10);
		screenBox.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);		
		screenBox.setPosition(0, 0); 
		screenBox.scrollFactor.set(0, 0);
		add(screenBox);
		
		title = new FlxText(0, 50, 0, "Instructions");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.GREEN);
		title.scrollFactor.set();
		title.setPosition(0, 50);
		title.screenCenter(X);
		add(title);
		
		var Instructions1 :FlxText;
		Instructions1 = new FlxText(50, 125, 0, "LEFT / RIGHT arrow keys moves player.");
		Instructions1.color = FlxColor.WHITE;
		Instructions1.size = 14;
		Instructions1.scrollFactor.set();
		add(Instructions1);
		
		var Instructions2 :FlxText;
		Instructions2 = new FlxText(50, 150, 0, "DOWN arrow key: interact with objects such as characters, doors and dialogs.");
		Instructions2.color = FlxColor.WHITE;
		Instructions2.size = 14;
		Instructions2.scrollFactor.set();
		add(Instructions2);
		
		var Instructions3 :FlxText;
		Instructions3 = new FlxText(50, 175, 0, "i: Select item, confirm.");
		Instructions3.color = FlxColor.WHITE;
		Instructions3.size = 14;
		Instructions3.scrollFactor.set();
		add(Instructions3);		
	
		var Instructions4 :FlxText;
		Instructions4 = new FlxText(50, 200, 0, "m: key is main menu.");
		Instructions4.color = FlxColor.WHITE;
		Instructions4.size = 14;
		Instructions4.scrollFactor.set();
		add(Instructions4);
		
		var Instructions5 :FlxText;
		Instructions5 = new FlxText(50, 225, 0, "F12: key toggles full screen mode.");
		Instructions5.color = FlxColor.WHITE;
		Instructions5.size = 14;
		Instructions5.scrollFactor.set();
		add(Instructions5);
		
		OKbutton = new Button(180, 300, "z: Back.", 160, 35, null, 16, 0xFFCCFF33, 0, OKbuttonClicked);	
		OKbutton.screenCenter(X);
		add(OKbutton);
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
				FlxG.switchState(new MenuState());
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
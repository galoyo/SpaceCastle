package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * @author galoyo
 */

class Instructions extends FlxSubState
{	
	private var screenBox:FlxSprite;
	private var title:FlxSprite;
	private var button1:MouseClickThisButton;
	
	public function new():Void
	{
		super();
		
		screenBox = new FlxSprite(10, 10);
		screenBox.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);		
		screenBox.setPosition(0, 0); 
		screenBox.scrollFactor.set(0, 0);
		add(screenBox);
		
		title = new FlxSprite();
		title.loadGraphic("assets/images/titleInstructionsImage.png", false);
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
		Instructions3 = new FlxText(50, 175, 0, "A: Select item, confirm.");
		Instructions3.color = FlxColor.WHITE;
		Instructions3.size = 14;
		Instructions3.scrollFactor.set();
		add(Instructions3);		
	
		var Instructions4 :FlxText;
		Instructions4 = new FlxText(50, 200, 0, "F1: key is quit game menu.");
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
		
		var Instructions6 :FlxText;
		Instructions6 = new FlxText(50, 250, 0, "Holding SHIFT key then press + / - to increase / decrease the volume.");
		Instructions6.color = FlxColor.WHITE;
		Instructions6.size = 14;
		Instructions6.scrollFactor.set();
		add(Instructions6);		
		
		button1 = new MouseClickThisButton(180, 300, "z: Back.", 160, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);	
		button1.screenCenter(X);
		add(button1);
	}
	
	override public function update(elapsed:Float):Void 
	{				
		#if !FLX_NO_KEYBOARD  
			if (FlxG.keys.anyJustPressed(["Z"]))
			{
				Reg._ignoreIfMusicPlaying = false;
				FlxG.switchState(new MenuState());
			}
		#end
		
		super.update(elapsed);
	}	
	
	private function button1Clicked():Void
	{
		Reg._ignoreIfMusicPlaying = false;
		FlxG.switchState(new MenuState());
	}
	
}
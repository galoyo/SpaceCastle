package ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class WinState extends FlxState
{
	override public function create():Void
	{
		super.create();
		bgColor = 0xFF000000;
		
					
		if (Reg._musicEnabled == true)
		{
			if (FlxG.sound.music.playing == true)
			FlxG.sound.music.stop();
		}
		
		// set the properties of the font and then add the font to the screen.
		var title = new FlxText();
		title.text = "YOU HAVE FINISHED THE GAME!";
		title.color = FlxColor.GREEN;
		title.size = 16;
		title.scrollFactor.set();
		title.alignment = FlxTextAlign.CENTER;
		title.screenCenter();
		add(title);
		
		// start from the beginning.
		Reg.beginningOfGame = true;
		Reg._inHouse = "";
		Reg._dogInHouse = "";
		Reg.playerXcoordsLast = 0;
		Reg.playerYcoordsLast = 0;
		
		var winText = new FlxTypeText(0, 0, FlxG.width - 160, "", 15, true);		
		winText.delay = 0.005;
		winText.eraseDelay = 0;
		winText.showCursor = true;
		winText.cursorBlinkSpeed = 0;
		winText.prefix = openfl.Assets.getText("assets/text/winState.txt");
		winText.autoErase = true;
		winText.waitTime = 2.0;
		winText.setTypingVariation(0.75, true);
		winText.color = 0xFFFFFFFF;
		winText.setPosition(90, 360); 
		winText.scrollFactor.set(0, 0);
		winText.cursorCharacter = "";
		add(winText);
		
		var button1:Button = new Button(0, 0, "Z: OK", 100, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		button1.setPosition(0, 500); 
		button1.screenCenter(X);
		add(button1);
		
		#if !FLX_NO_KEYBOARD
			if (FlxG.keys.anyJustPressed(["Z"])) 
			{
				Reg.resetRegVars(); 
			}
		#end
	}
	
	override public function update(elapsed:Float):Void 
	{
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
		// when a key is pressed, go to the function called closed.
		#if !FLX_NO_KEYBOARD
			if (FlxG.keys.anyJustPressed(["Z"])) 
			{
				Reg.resetRegVars(); 
				FlxG.resetGame();
			}
		#end
		
		super.update(elapsed);
	}
	
	private function button1Clicked():Void
	{
		Reg.resetRegVars(); FlxG.resetGame();
	}
}
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
		
		if (FlxG.keys.justPressed.ANY) Reg.resetRegVars();
	}
	
	override public function update(elapsed:Float):Void 
	{
		//FlxG.gamepads.lastActive.anyButton() || 
		
		// when a key is pressed, go to the function called closed.
		if (FlxG.keys.justPressed.ANY) {Reg.resetRegVars(); FlxG.resetGame();}
		super.update(elapsed);
	}	
}
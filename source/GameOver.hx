package ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class GameOver extends FlxState
{
	private var button1:MouseClickThisButton;

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF000000;
		
		// set the properties of the font and then add the font to the screen.
		var gameOverText = new FlxText();
		gameOverText.text = "Game Over.";
		gameOverText.color = FlxColor.GREEN;
		gameOverText.size = 16;
		gameOverText.scrollFactor.set();
		gameOverText.alignment = FlxTextAlign.CENTER;
		gameOverText.screenCenter();
		add(gameOverText);
		
		// start from the beginning.
		Reg.beginningOfGame = true;
		Reg._inHouse = "";
		Reg._dogInHouse = "";
		Reg.playerXcoordsLast = 0;
		Reg.playerYcoordsLast = 0;
		
		button1 = new MouseClickThisButton(0, 0, "Z: OK", 100, 35, null, 16, 0xFFCCFF33, 0, button1Clicked);
		button1.setPosition(0, 500); 
		button1.screenCenter(X);
		add(button1);
		
		if (Reg._musicEnabled == true) FlxG.sound.playMusic("gameOverNotCompleted", 1, false);
	}
	
	override public function update(elapsed:Float):Void 
	{
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
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
		
		if (Reg._musicEnabled == true) FlxG.sound.playMusic("gameOverNotCompleted", 1, false);
	}
	
	override public function update(elapsed:Float):Void 
	{
		//FlxG.gamepads.lastActive.anyButton() || 
		
		// when a key is pressed, go to the function called closed.
		if (FlxG.keys.justPressed.ANY) {Reg.resetRegVars(); FlxG.resetGame();}
		super.update(elapsed);
	}	
}
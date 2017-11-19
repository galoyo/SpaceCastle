package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class GameLoad extends GameSaveLoadParent
{	
	/*******************************************************************************************************
	 * This title text display near the top of the screen.
	 */
	private var title:FlxText;
	
	public function new():Void
	{
		super();
		
		title = new FlxText(0, 50, 0, "Load Game");
		title.setFormat("assets/fonts/trim.ttf", 36, FlxColor.GREEN);
		title.scrollFactor.set();
		title.screenCenter(X);
		add(title);	
		
		Reg._gameSaveOrLoad = 2;
	}
	
	override public function update(elapsed:Float):Void 
	{				
		super.update(elapsed);
	}
}
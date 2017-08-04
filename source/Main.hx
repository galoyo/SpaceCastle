// Std.int();

package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.Lib;
import openfl.display.Sprite;

/**
 * @author galoyo
 */

class Main extends Sprite 
{
	var gameWidth:Int = 800; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 600; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var zoom:Float = 1; // If -1, zoom is automatically calculated to fit the window dimensions.	
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	private var _gameOptions:FlxSave; // load the options, currently the "4" key at the MenuState.hx
	
	public function new() 
	{				
		_gameOptions = new FlxSave(); // initialize
		_gameOptions.bind("TSC-SAVED-OPTIONS"); // bind to the named save slot.
		
		if (_gameOptions.data._cheatModeEnabled != null)
		{
				loadOptions();
		}
		
		
		super();
	
		addChild(new FlxGame(gameWidth, gameHeight, MenuState, zoom, Reg._framerate, Reg._framerate, skipSplash, startFullscreen));
	}
	
		
	private function loadOptions():Void	
	{			
		// if you get a null error with one of these _gameOptions.data or things are not displaying correctly then you might have added a feature to options.hx. if that is the case, then there is already a saved data at hard drive so do the following.
		//comment out that conflicting code below then load the game and go to options then save options by exiting that screen then uncomment out the conflicting code 
		
		Reg._musicEnabled = _gameOptions.data._musicEnabled;
		Reg._soundEnabled = _gameOptions.data._soundEnabled;
		Reg._backgroundSounds = _gameOptions.data._backgroundSounds;
		Reg._playerRunningEnabled = _gameOptions.data._playerRunningEnabled;
		Reg._dialogFastTextEnabled = _gameOptions.data._dialogFastTextEnabled;
		Reg._cheatModeEnabled = _gameOptions.data._cheatModeEnabled;
		Reg._framerate = _gameOptions.data.framerate;
		Reg._playerFallDamage = _gameOptions.data._playerFallDamage;
		Reg._differcuityLevel = _gameOptions.data._differcuityLevel;
		
		_gameOptions.close;
	}

}
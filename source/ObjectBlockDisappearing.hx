package ;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * @author galoyo
 */

class ObjectBlockDisappearing extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	private var ticks:Float = 0;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);

		_startx = x;
		_starty = y;
		
		// At PlayStateCreateMap.hx - createLayer3Sprites() function, an ID is sometimes passed to the PlayStateAdd.hx function. When passed, it then always passes its ID var to a class. In this example, the ID of 1 can be the first appearence of the mob while a value of 2 is the same mob but using a different image or other property. An ID within an "if command" can be used to give a mob a faster running ability or a different dialog than the same mob with a different ID.
		ID = id;
		
		loadGraphic("assets/images/objectBlockDisappearing1-" + id + ".png", false, Reg._tileSize, Reg._tileSize);	

		immovable = true;	
		visible = false;

	}
	
	override public function update(elapsed:Float):Void 
	{
		ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
			
		if (ID == 1 && ticks > 40 && ticks < 70 + Reg._blockDisappearingDelay) {visible = true; solid = true; }
		if (ID == 1 && ticks < 40 || ticks > 70 + Reg._blockDisappearingDelay) {visible = false; solid = false; }
		if (ID == 1 && ticks == 35) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 0.50, false);
		}
			
		if (ID == 2 && ticks > 70 + Reg._blockDisappearingDelay && ticks < 100 + (Reg._blockDisappearingDelay * 2)) {visible = true; solid = true; }
		if (ID == 2 && ticks < 70 + Reg._blockDisappearingDelay || ticks > 100 + (Reg._blockDisappearingDelay * 2)) {visible = false; solid = false; }		
		if (ID == 2 && ticks == 65 + Reg._blockDisappearingDelay) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 0.50, false);
		}
			
		if (ID == 3 && ticks > 100 + (Reg._blockDisappearingDelay * 2) && ticks < 130 + (Reg._blockDisappearingDelay * 3)) {visible = true; solid = true; }
		if (ID == 3 && ticks < 100 + (Reg._blockDisappearingDelay * 2) || ticks > 130 + (Reg._blockDisappearingDelay * 3)) {visible = false; solid = false; }
		if (ID == 3 && ticks == 95 + (Reg._blockDisappearingDelay * 2)) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("switch", 0.50, false);
		}
			
		if (ticks > 130 + (Reg._blockDisappearingDelay * 3)) {ticks = 40; if (Reg._soundEnabled == true) FlxG.sound.play("switch", 0.25, false);}

		super.update(elapsed);
	}
	
}
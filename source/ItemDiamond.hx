package ;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import openfl.display.BlendMode;

/**
 * @author galoyo
 */

class ItemDiamond extends FlxSprite
{
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		loadGraphic("assets/images/itemDiamond.png", true, Reg._tileSize, Reg._tileSize);
		
		// every coin displayed on the map will be animated. this is the animation frames.  
		animation.add("play", [0, 1, 2], 16);
		animation.play("play");
		
	}
	
	override public function kill():Void 
	{
		super.kill();
		
		alive = false;
		blend = BlendMode.ADD;
		
		// gradually change the diamond x to 0. When 0 the update() function will delete it.
		FlxTween.tween(scale, { x:0, y:3 }, 0.1);
		
		velocity.y = -150;
	}
	
	override public function update(elapsed:Float):Void 
	{
		// delete coin when it has a width of 0.
		if (scale.x <= 0) super.kill();
		super.update(elapsed);
	}
	
}